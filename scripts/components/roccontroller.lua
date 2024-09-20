-- local easing = require("easing")
--遗留问题：roc动画不会转向？ 确实不会
--roc的碰撞体积问题
--传送时间可能太早了
--脚还是会踩水
--onsave onload修改
--FindClosestPlayerToInst统一距离？
--死亡瞬间还是能吊起来
--finding_object时期的tile检测还是不对
--飞走的时候逐渐缩小
--GetDistanceSqToInst需要isvalid判断，真恶心。何必呢
--还是需要判定landed

--注意事项：鸟巢的生成不能离海太近，附近不要有敌对生物

local SCREEN_DIST = 50
local HEAD_ATTACK_DIST = 1.5
local HEAD_EAT_DIST = 0.5
local SCALERATE = 1 / (30 * 2) -- 2 seconds to go from 0 to 1

local HEADDIST = 17
local HEADDIST_TARGET = 15
local BODY_DIST_TOLLERANCE = 2

local TAILDIST = 13

local ROC_LEGDSIT = 6 --TUNING.ROC_LEGDSIT
local LEGDIST = ROC_LEGDSIT
local LEG_WALKDIST = 4
local LEG_WALKDIST_BIG = 6
local LAND_PROX = 15                         --7
local DISTANCE_FROM_WATER_OR_IMPASSABLE = 16 -- 8
local ROC_SPEED = 20


local _stages = {
	initializing = 0,
	navigating = 1,
	landing = 2,
	finding_object = 3,
	grabbing_player = 4,
	taking_off = 5,
	flying_away = 6
	-- flying_to_nest = 6,
	-- arriving_nest = 6,
	-- landing_again = 7,
	-- disgrabbing_player = 8,
	-- taking_off_away = 9,
	-- flying_away = 10
}




local RocController = Class(function(self, inst)
	self.inst = inst
	self.speed = 10
	self.scale_stages = 3
	self.startscale = 0.35

	self.head_vel = 0
	self.head_acc = 3
	self.head_vel_max = 6
	self.body_vel = { x = 0, z = 0 }
	self.body_acc = 0.3
	self.body_dec = 1
	self.body_vel_max = 10 --6

	self.tail_vel = { x = 0, z = 0 }
	self.tail_acc = 3
	self.tail_dec = 6
	self.tail_vel_max = self.speed

	self.turn_threshold = 20

	self.dungtime = 3

	self.angular_body_acc = 5

	self.inst.sounddistance = 0

	self.stage = _stages.initializing
	self._stages = _stages --方便其他文件引用
end)



-- local help functions
-- local function IsHamTile(tile)
-- 	return PL_LAND_TILES[tile] or false --有没有定义好的函数
-- end

-- local function IsCityTile(tile)
-- 	return tile == GROUND.FOUNDATION or tile == GROUND.COBBLEROAD or tile == GROUND.LAWN or tile == GROUND.FIELDS
-- end

local function IsValidTile(tile)
	return --[[IsHamTile(tile) and not IsCityTile(tile) -- and]] IsLandTile(tile) and not (tile == GROUND.FOUNDATION or
		tile == GROUND.COBBLEROAD or tile == GROUND.LAWN or tile == GROUND.DEEPRAINFOREST or tile == GROUND.GASJUNGLE)
end

local function IsValidTileAtPoint(x, y, z)
	local map = TheWorld.Map
	local tile = map:GetTileAtPoint(x, y, z)
	if IsValidTile(tile) then
		return true
	end
	return false
end

local function IsValidDungTileAtPoint(x, y, z)
	local map = TheWorld.Map
	local tile = map:GetTileAtPoint(x, y, z)
	if (tile == GROUND.RAINFOREST or tile == GROUND.PLAINS) then
		return true
	end
	return false
end

local function IsCloseToValidTileAtPoint(x, y, z, radius)
	local map = TheWorld.Map
	local step = (radius and radius >= 4) and 4 or 2

	for i = -radius, radius, step do
		for j = -radius, radius, step do
			if IsValidTile(map:GetTileAtPoint(x + i, y, z + j)) then
				return true
			end
		end
	end
	return false
end

local function IsCloseToInvalidTileAtPoint(x, y, z, radius)
	local map = TheWorld.Map
	local step = (radius and radius >= 4) and 4 or 2

	for i = -radius, radius, step do
		for j = -radius, radius, step do
			if not IsLandTile(map:GetTileAtPoint(x + i, y, z + j)) then
				return true
			end
		end
	end
	return false
end

local function GetCLosestValidInstWithTag(inst, radius, musttag, canottag)
	local pos = Vector3(inst.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius, musttag, canottag)
	for i = #ents, 1, -1 do
		if not ents[i].components.workable then
			table.remove(ents, i)
		end
	end

	local sorted = {}
	local target = nil

	if #ents > 0 then
		for i, ent in ipairs(ents) do
			if ent then
				local x, y, z = ent.Transform:GetWorldPosition()
				local tilevalid = IsValidTileAtPoint(x, y, z)

				if tilevalid and ent:IsValid() then
					table.insert(sorted, { ent, ent:GetDistanceSqToInst(inst) })
				end
			end
		end
		if #sorted > 0 then
			table.sort(sorted, function(a, b) return a[2] > b[2] end)
			target = sorted[#sorted][1]
		end
	end

	return target
end


local function getanglepointtopoint(x1, z1, x2, z2)
	local dz = z1 - z2
	local dx = x2 - x1
	local angle = math.atan2(dz, dx) / DEGREES
	return angle
end

local function IsValidPlayer(player) --是否需要添加其他状态监测
	if player and player:IsValid() and
		player:HasTag("player") and
		player.components.health and
		not player.components.health:IsDead() and
		not player:HasTag("playerghost") then
		return true
	end
	return false
end

local function FindClosestValidPlayerToInst(inst, range, isalive)
	local x, y, z = inst.Transform:GetWorldPosition()
	local rangesq = range * range
	local closestPlayer = nil
	for i, v in ipairs(AllPlayers) do
		if (isalive == nil or isalive ~= IsEntityDeadOrGhost(v)) and v.entity:IsVisible() and IsValidPlayer(v) then
			local pos = Vector3(inst.Transform:GetWorldPosition())
			local distsq = v:GetDistanceSqToPoint(x, y, z)
			if distsq < rangesq and IsValidTileAtPoint(pos.x, pos.y, pos.z) then
				rangesq = distsq
				closestPlayer = v
			end
		end
	end
	return closestPlayer
end

function RocController:Setup(speed, scale, scale_stages)
	if speed then
		self.speed = speed
	end
	if scale then
		self.startscale = scale
	end
	if scale_stages then
		self.scale_stages = scale_stages
	end

	self:setscale(self.startscale)
	self.inst:DoPeriodicTask(1, function() self:CheckScale() end)
end

function RocController:Start()
	self.inst:StartUpdatingComponent(self)
end

function RocController:Stop()
	self.inst:StopUpdatingComponent(self)
end

function RocController:CheckScale()
	if self.inst.Transform:GetScale() ~= 1 then
		local delta = (1 - self.startscale) / self.scale_stages

		self.scaleup = {
			targetscale = math.min(self.inst.Transform:GetScale() + delta, 1)
		}
	end
end

function RocController:setscale(scale)
	self.inst.Transform:SetScale(scale, scale, scale)
	if self.scalefn then
		self.scalefn(self.inst, scale)
	end
	self.inst.sounddistance = Remap(scale, self.startscale, 1, 0, 1)
end

function RocController:doliftoff()
	if self.inst.bodyparts and #self.inst.bodyparts > 0 then
		for i, part in ipairs(self.inst.bodyparts) do
			part:PushEvent("exit")
		end
		self.inst.bodyparts = nil
		self.head = nil
		self.tail = nil
		self.leg1 = nil
		self.leg2 = nil
		self.currentleg = nil

		self.inst:PushEvent("takeoff")
	end
end

function RocController:Spawnbodyparts()
	if not self.inst.bodyparts then
		self.inst.bodyparts = {}
	end


	--print("spawnbodypart!!!!!!")
	local angle = self.inst.Transform:GetRotation() * DEGREES
	if self.nest_dir then
		angle = self.nest_dir
	end

	local pos = Vector3(self.inst.Transform:GetWorldPosition())
	--------------leg1-----------------
	if not self.leg1 then
		local leg1 = SpawnPrefab("roc_leg")
		table.insert(self.inst.bodyparts, leg1)
		self.leg1 = leg1
		leg1.controller = self
		self.currentleg = self.leg1
	end

	local leg1 = self.leg1
	local offset = Vector3(LEGDIST * math.cos(angle + (PI / 2)), 0, -LEGDIST * math.sin(angle + (PI / 2)))
	leg1.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
	leg1.Transform:SetRotation(self.inst.Transform:GetRotation())
	leg1.sg:GoToState("enter")
	leg1.body = self.inst
	leg1.legoffsetdir = PI / 2


	----------------leg2----------------------
	if not self.leg2 then
		local leg2 = SpawnPrefab("roc_leg")
		table.insert(self.inst.bodyparts, leg2)
		self.leg2 = leg2
		leg2.controller = self
	end

	local leg2 = self.leg2
	local offset = Vector3(LEGDIST * math.cos(angle - (PI / 2)), 0, -LEGDIST * math.sin(angle - (PI / 2)))
	leg2.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
	leg2.Transform:SetRotation(self.inst.Transform:GetRotation())
	leg2.sg:GoToState("enter")
	leg2.body = self.inst
	leg2.legoffsetdir = -PI / 2

	------------------tail--------------------------
	if not self.tail then
		local tail = SpawnPrefab("roc_tail")
		self.tail = tail
		tail.controller = self
		table.insert(self.inst.bodyparts, tail)
	end

	local tail = self.tail
	local offset = Vector3(TAILDIST * math.cos(angle - PI), 0, -TAILDIST * math.sin(angle - PI))
	tail.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
	tail.Transform:SetRotation(self.inst.Transform:GetRotation())
	tail.sg:GoToState("enter")

	----------------head-----------------------
	self.inst:DoTaskInTime(0.5, function()
		if not self.head then
			local head = SpawnPrefab("roc_head")
			table.insert(self.inst.bodyparts, head)
			self.head = head
			head.controller = self
		end

		local head = self.head
		local offset = Vector3(HEADDIST * math.cos(angle), 0, -HEADDIST * math.sin(angle))
		head.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
		head.Transform:SetRotation(self.inst.Transform:GetRotation())
		head.sg:GoToState("enter")
		head.body = self.inst

		if self.stage == _stages.landing or self.stage == _stages.landing_again then
			self.stage = self.stage + 1
		end
	end)
end

function RocController:GetTarget() ------------更新
	local bird = self.head or self.inst


	if not self.target or not self.target:IsValid() or self.target:HasTag("player") then
		local target = GetCLosestValidInstWithTag(bird, 20, { "structure" })
		if target and target:IsValid() then
			self.target = target
		end
	end

	if self.target and self.target:IsValid() and (bird:GetDistanceSqToInst(self.target) <= 32 ^ 2) then
		return self.target
	end

	local target = FindClosestValidPlayerToInst(bird, 24, true)
	if target and target:IsValid() then
		self.target = target
		return self.target
	end
end

function RocController:Movebodyparts(dt)
	if not self.head or self.head.sg:HasStateTag("busy") or not self.leg1 or not self.leg2 or not self.tail then
		return
	end

	local target = self:GetTarget() --[[or self.inst]]

	if not target then
		self.inst:PushEvent("liftoff")
		self.stage = _stages.taking_off
		return
	end

	local targetpos = Vector3(target.Transform:GetWorldPosition())
	local headdistsq = self.head:GetDistanceSqToInst(target)

	if self.target:HasTag("structure") then
		if headdistsq > HEAD_ATTACK_DIST * HEAD_ATTACK_DIST then
			self.head_vel = math.min(self.head_vel + (self.head_acc * dt), self.head_vel_max)
		else
			self.head:PushEvent("bash")
			self.head_vel = math.max(self.head_vel - (self.head_acc * dt), 0)
		end
	else
		if headdistsq > HEAD_EAT_DIST * HEAD_EAT_DIST then
			self.head_vel = math.min(self.head_vel + (self.head_acc * dt), self.head_vel_max)
		else
			if self.target:HasTag("player") then
				self.target:PushEvent("cower")
				self.head:PushEvent("gobble")
			else
				if self.target ~= self.inst then
					self.head:PushEvent("eat") --吃食物的设定
				end
			end
			self.head_vel = math.max(self.head_vel - (self.head_acc * dt), 0)
		end
	end

	local HEAD_VEL = self.head_vel * dt

	local angle = self.head:GetAngleToPoint(targetpos) * DEGREES
	local offset = Vector3(HEAD_VEL * math.cos(angle), 0, -HEAD_VEL * math.sin(angle))
	local pos = Vector3(self.head.Transform:GetWorldPosition())
	self.head.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)


	-- BODY
	local pos = Vector3(self.inst.Transform:GetWorldPosition())

	local BOD_VEL_MAX = self.speed
	local BOD_ACC_MAX = 0.5 --5
	local targetpos = Vector3(self.head.Transform:GetWorldPosition())
	local angle = self.head:GetAngleToPoint(pos) * DEGREES
	local offset = Vector3(1 * math.cos(angle), 0, -1 * math.sin(angle))
	offset.x = offset.x * HEADDIST_TARGET
	offset.z = offset.z * HEADDIST_TARGET
	targetpos = targetpos + Vector3(offset.x, 0, offset.z)

	local bodistsq = self.inst:GetDistanceSqToPoint(targetpos)

	if bodistsq > BODY_DIST_TOLLERANCE * BODY_DIST_TOLLERANCE then
		local cpbv = pos + Vector3(self.body_vel.x, 0, self.body_vel.z)
		local angle = getanglepointtopoint(cpbv.x, cpbv.z, targetpos.x, targetpos.z) * DEGREES
		local offset = Vector3(BOD_ACC_MAX * math.cos(angle), 0, -BOD_ACC_MAX * math.sin(angle))
		local cpbvtv = cpbv + Vector3(offset.x, 0, offset.z)
		local finalangle = self.inst:GetAngleToPoint(cpbvtv) * DEGREES
		local finalvel = math.min(BOD_VEL_MAX, math.sqrt(self.inst:GetDistanceSqToPoint(cpbvtv)))
		self.body_vel = Vector3(finalvel * math.cos(finalangle), 0, -finalvel * math.sin(finalangle))
	else
		local angle = self.inst:GetAngleToPoint(targetpos) * DEGREES
		local vel = math.max(
			math.sqrt((self.body_vel.x * self.body_vel.x) + (self.body_vel.z * self.body_vel.z)) -
			(BOD_ACC_MAX * dt), 0)
		self.body_vel = Vector3(vel * math.cos(angle), 0, -vel * math.sin(angle))
	end
	self.inst.Transform:SetPosition(pos.x + (self.body_vel.x * dt), 0, pos.z + (self.body_vel.z * dt))

	--TAIL
	local angle = (self.inst.Transform:GetRotation() * DEGREES) + PI
	local tailtarget = Vector3(TAILDIST * math.cos(angle), 0, -TAILDIST * math.sin(angle))
	tailtarget = Vector3(self.inst.Transform:GetWorldPosition()) + tailtarget
	local taildistsq = self.tail:GetDistanceSqToPoint(tailtarget)
	local pos = Vector3(self.tail.Transform:GetWorldPosition())
	local TAIL_VEL_MAX = self.speed
	local TAIL_ACC_MAX = 0.3 --5

	if taildistsq > 1 * 1 then
		local cpbv = pos + Vector3(self.tail_vel.x, 0, self.tail_vel.z)
		local angle = getanglepointtopoint(cpbv.x, cpbv.z, tailtarget.x, tailtarget.z) * DEGREES
		local offset = Vector3(TAIL_ACC_MAX * math.cos(angle), 0, -TAIL_ACC_MAX * math.sin(angle))
		local cpbvtv = cpbv + Vector3(offset.x, 0, offset.z)
		local finalangle = self.tail:GetAngleToPoint(cpbvtv) * DEGREES
		local finalvel = math.min(TAIL_VEL_MAX, math.sqrt(self.tail:GetDistanceSqToPoint(cpbvtv)))
		self.tail_vel = Vector3(finalvel * math.cos(finalangle), 0, -finalvel * math.sin(finalangle))
	else
		local angle = self.tail:GetAngleToPoint(tailtarget) * DEGREES
		local vel = math.max(
			math.sqrt((self.tail_vel.x * self.tail_vel.x) + (self.tail_vel.z * self.tail_vel.z)) -
			(TAIL_ACC_MAX * dt), 0)
		self.tail_vel = Vector3(vel * math.cos(angle), 0, -vel * math.sin(angle))
	end
	self.tail.Transform:SetPosition(pos.x + (self.tail_vel.x * dt), 0, pos.z + (self.tail_vel.z * dt))

	-- set rotations
	local headpos = Vector3(self.head.Transform:GetWorldPosition())

	-- body rotation has velocity.
	local body_angular_vel_max = 36 / 3
	if not self.body_angle_vel then
		self.body_angle_vel = 0
	end

	local targetAngle = self.inst:GetAngleToPoint(headpos)
	local currentAngle = self.inst.Transform:GetRotation()

	if math.abs(anglediff(currentAngle, targetAngle)) < 20 then
		if self.body_angle_vel > 0 then
			self.body_angle_vel = math.max(0, self.body_angle_vel - (self.angular_body_acc * dt))
		elseif self.body_angle_vel < 0 then
			self.body_angle_vel = math.min(0, self.body_angle_vel + (self.angular_body_acc * dt))
		end
	else
		if targetAngle > currentAngle then
			if targetAngle - currentAngle < 180 then
				self.body_angle_vel = math.min(body_angular_vel_max,
					self.body_angle_vel + (self.angular_body_acc * dt))
			else
				self.body_angle_vel = math.max(-body_angular_vel_max,
					self.body_angle_vel - (self.angular_body_acc * dt))
			end
		else
			if currentAngle - targetAngle < 180 then
				self.body_angle_vel = math.max(-body_angular_vel_max,
					self.body_angle_vel - (self.angular_body_acc * dt))
			else
				self.body_angle_vel = math.min(body_angular_vel_max,
					self.body_angle_vel + (self.angular_body_acc * dt))
			end
		end
	end

	currentAngle = currentAngle + (self.body_angle_vel * dt)
	self.inst.Transform:SetRotation(currentAngle)

	if not self.head.sg:HasStateTag("busy") then
		if self.head then
			local targetpos = Vector3(self.head.Transform:GetWorldPosition())
			local angle = self.head:GetAngleToPoint(targetpos.x, targetpos.y, targetpos.z)
			self.head.Transform:SetRotation(angle)
		end
	end

	self.tail.Transform:SetRotation(self.inst.Transform:GetRotation())

	-- LEGS
	if not self.leg1.sg:HasStateTag("walking") and not self.leg2.sg:HasStateTag("walking") then
		local legdir = PI / 2
		if self.currentleg == 2 then
			legdir = legdir * -1
		end

		local angle = self.inst.Transform:GetRotation() * DEGREES

		local currentlegtargetpos = Vector3(self.inst.Transform:GetWorldPosition()) +
			Vector3(LEGDIST * math.cos(angle + legdir), 0, -LEGDIST * math.sin(angle + legdir))
		local legdistsq = self.currentleg:GetDistanceSqToPoint(currentlegtargetpos)
		local anglediff = anglediff(self.currentleg.Transform:GetRotation(),
			self.inst.Transform:GetRotation())
		if legdistsq > LEG_WALKDIST * LEG_WALKDIST or anglediff > self.turn_threshold then
			if legdistsq < LEG_WALKDIST_BIG * LEG_WALKDIST_BIG or (anglediff > self.turn_threshold and legdistsq <= LEG_WALKDIST_BIG * LEG_WALKDIST_BIG) then
				self.currentleg:PushEvent("walkfast")
			else
				self.currentleg:PushEvent("walk")
			end

			if self.currentleg == self.leg1 then
				self.currentleg = self.leg2
			else
				self.currentleg = self.leg1
			end
		end
	end
end

function RocController:OnEntityWake()
	self:Start()
end

function RocController:DoGrab_food()
	local food = self.target
	food:Remove()
end

local function disgrab_player(player)
	if not player or not IsValidPlayer(player) then
		return
	end
	player:PushEvent("disgrabbed")
end

local function FadeInFinished(player)
	if not player or not IsValidPlayer(player) then
		return
	end
	---添加相机相关操作
	player:SnapCamera()
	player:ScreenFade(true, 1)
	player:DoTaskInTime(2, function() disgrab_player(player) end)
end

local function teleport(player)
	if not player or not IsValidPlayer(player) then
		return
	end
	local nest = TheSim:FindFirstEntityWithTag("roc_nest")
	local nest_pos = nest and Vector3(nest.Transform:GetWorldPosition()) or { 0, 0, 0 }
	player.Transform:SetPosition(nest_pos:Get())
	player:DoTaskInTime(0, function() FadeInFinished(player) end)
end

local function FadeOut(player)
	-----添加相机相关操作

	if not player or not IsValidPlayer(player) then
		return
	end
	-- player:SnapCamera()
	-- player:ScreenFade(true, 2)
	player:ScreenFade(false, 2)

	player:DoTaskInTime(5, function() teleport(player) end)
end

local function grab_player(player)
	if not player or not IsValidPlayer(player) then
		return
	end

	player:PushEvent("grabbed")
	player:DoTaskInTime(2, function() FadeOut(player) end)
end

function RocController:DoGrab_player()
	local player = self.target
	if player and IsValidPlayer(player) then
		local headdistsq = self.head:GetDistanceSqToInst(player)
		if headdistsq < HEAD_EAT_DIST * HEAD_EAT_DIST then
			self.stage = _stages.grabbing_player

			player.Transform:SetRotation(self.head.Transform:GetRotation())
			grab_player(player)

			self.inst:DoTaskInTime(0.5, function()
				self.inst:PushEvent("liftoff")
				self.stage = _stages.taking_off
			end)
		end
	end
end

function RocController:OnUpdate(dt)
	--print("stage!!!!!!!!!!!", self.stage)

	local cx, cy, cz = self.inst.Transform:GetWorldPosition()
	-- self.inst.Transform:SetPosition(cx, 0, cz)




	if self.stage == _stages.initializing then
		self.inst:PushEvent("fly")
		self.stage = _stages.navigating
		return
	end

	if self.stage == _stages.navigating then
		local player = FindClosestValidPlayerToInst(self.inst, 80, true) --[[or self.inst]]
		if not player or TheWorld.state.isnight then
			self.stage = _stages.flying_away
			return
		end
		local px, py, pz = player.Transform:GetWorldPosition()

		-- local onvalidtiles = IsCloseToValidTileAtPoint(px, py, pz, 8)

		local disttoplayer = self.inst:GetDistanceSqToInst(player)
		if disttoplayer > SCREEN_DIST * SCREEN_DIST then
			self.inst.Transform:SetRotation(self.inst:GetAngleToPoint(px, py, pz))
		end

		if self.scaleup then
			local currentscale = self.inst.Transform:GetScale()
			if currentscale ~= self.scaleup.targetscale then
				local scale = math.min(currentscale + (SCALERATE * dt), self.scaleup.targetscale)
				self:setscale(scale)
			else
				self.scaleup = nil
			end
		end

		local dungok = true --添加自定义选项
		local onvaliddungtiles = IsValidDungTileAtPoint(cx, cy, cz)
		if onvaliddungtiles and dungok then
			if self.dungtime > 0 then
				self.dungtime = math.max(self.dungtime - dt, 0)
			else
				local ents = TheSim:FindEntities(cx, cy, cz, 50, { "dungpile" })
				if #ents < 2 then
					self.inst:DoTaskInTime(1 + Remap(self.inst.Transform:GetScale(), 0.35, 1, 2, 0), function()
						local crap = SpawnPrefab("dungpile")
						crap.Transform:SetPosition(cx, cy, cz)
						crap.fall(crap) --大写的Fall
					end)
				end
				self.dungtime = math.random() * 10 + 2
			end
		end

		if self.inst.Transform:GetScale() >= 1 then
			local roc_onvalidtiles = not IsCloseToInvalidTileAtPoint(cx, cy, cz, DISTANCE_FROM_WATER_OR_IMPASSABLE)
			if disttoplayer < LAND_PROX * LAND_PROX and roc_onvalidtiles then
				self.stage = _stages.landing
				self.inst:PushEvent("land")
			end
		end

		return
	end

	if self.stage == _stages.landing then --等待spawnbodypart完毕
		return
	end

	if self.stage == _stages.finding_object then
		local player = FindClosestValidPlayerToInst(self.inst, 60, true)

		if player then
			local px, py, pz = player.Transform:GetWorldPosition()
			local onvalidtiles = IsCloseToValidTileAtPoint(px, py, pz, 8)

			if onvalidtiles and not TheWorld.state.isnight then
				self:Movebodyparts(dt)
				return
			end
		end

		self.inst:PushEvent("liftoff")
		self.stage = _stages.taking_off
	end

	if self.stage == _stages.grabbing_player then
		return
	end

	if self.stage == _stages.taking_off then
		return
	end

	if self.stage == _stages.flying_away then
		local speed = self.inst.components.locomotor.runspeed
		self.inst.components.locomotor.runspeed = math.min(speed + 1, ROC_SPEED)

		local scale = self.inst.Transform:GetScale()
		if scale > 0.1 then scale = scale - 0.001 end
		self.inst.Transform:SetScale(scale, scale, scale)


		local player = FindClosestPlayerToInst(self.inst, SCREEN_DIST * 1.5, true)
		if not player then
			self.inst:Remove()
		end
		return
	end
end

function RocController:OnSave()
	local refs = {}
	local data = {}

	data.head_vel = self.head_vel
	data.body_vel_x = self.body_vel.x
	data.body_vel_z = self.body_vel.z
	data.tail_vel_x = self.tail_vel.x
	data.tail_vel_z = self.tail_vel.z


	data.dungtime = self.dungtime
	data.currentleg = self.currentleg and self.currentleg.GUID or nil
	-- data.scaleup = self.scaleup and self.scaleup.targetscale and self.scaleup or nil
	data.stage = self.stage or nil
	data.scale = self.inst.Transform:GetScale() or 1

	-- data.nest_pos = self.nest_pos or nil
	-- data.takeoff_pos = self.takeoff_pos or nil
	-- data.nest_dir = self.nest_dir or nil
	-- data.head_offset = self.head_offset or nil
	-- data.player_offset = self.player_offset or nil
	-- data.aim_pos = self.aim_pos or nil
	-- data.dist = self.dist or nil
	-- data.offset_diff = self.offset_diff or nil


	-- if self.currentleg then
	-- 	data.currentleg = self.currentleg.GUID
	-- end
	if self.scaleup then
		data.scaleup = self.scaleup.targetscale
	end
	-- if self.landed then
	-- 	data.landed = self.landed
	-- end
	-- if self.liftoff then
	-- 	data.liftoff = self.liftoff
	-- end




	if self.head then
		data.head = self.head.GUID
		table.insert(refs, self.head.GUID)
	end
	if self.tail then
		data.tail = self.tail.GUID
		table.insert(refs, self.tail.GUID)
	end
	if self.leg1 then
		data.leg1 = self.leg1.GUID
		table.insert(refs, self.leg1.GUID)
	end
	if self.leg2 then
		data.leg2 = self.leg2.GUID
		table.insert(refs, self.leg2.GUID)
	end

	return data, refs
end

function RocController:OnLoad(data)
	data.body_vel_x = self.body_vel.x
	data.body_vel_z = self.body_vel.z
	data.tail_vel_x = self.tail_vel.x
	data.tail_vel_z = self.tail_vel.z

	self.head_vel = data.head_vel
	self.body_vel = { x = data.body_vel_x, z = data.body_vel_z }
	self.tail_vel = { x = data.tail_vel_x, z = data.tail_vel_z }
	self.dungtime = data.dungtime

	self.currentleg = data.currentleg or nil
	self.stage = data.stage or nil
	self:setscale(data.scale or 1)

	-- self.nest_pos = data.nest_pos or nil
	-- self.takeoff_pos = data.takeoff_pos or nil
	-- self.nest_dir = data.nest_dir or nil
	-- self.head_offset = data.head_offset or nil
	-- self.player_offset = data.player_offset or nil
	-- self.aim_pos = data.aim_pos or nil
	-- self.dist = data.dist or nil
	-- self.offset_diff = data.offset_diff or nil

	-- if data.currentleg then
	-- 	self.currentleg = data.currentleg
	-- end
	if data.scaleup then
		self.scaleup = { targetscale = data.scaleup }
	end
	-- if data.landed then
	-- 	self.landed = data.landed
	-- end
	-- if data.liftoff then
	-- 	self.liftoff = data.liftoff
	-- end

	-- if data.stage then
	-- 	self.stage = data.stage
	-- end
end

function RocController:LoadPostPass(ents, data)
	self.inst.bodyparts = {}
	if data.currentleg then
		self.currentleg = ents[data.currentleg].entity
	end
	if data.head then
		self.head = ents[data.head].entity
		self.head.body = self.inst
		self.head.controller = self
		table.insert(self.inst.bodyparts, self.head)
	end
	if data.tail then
		self.tail = ents[data.tail].entity
		self.tail.body = self.inst
		table.insert(self.inst.bodyparts, self.tail)
	end
	if data.leg1 then
		self.leg1 = ents[data.leg1].entity
		self.leg1.body = self.inst
		self.leg1.legoffsetdir = PI / 2
		table.insert(self.inst.bodyparts, self.leg1)
	end
	if data.leg2 then
		self.leg2 = ents[data.leg2].entity
		self.leg2.body = self.inst
		self.leg2.legoffsetdir = -PI / 2
		table.insert(self.inst.bodyparts, self.leg2)
	end
end

return RocController
