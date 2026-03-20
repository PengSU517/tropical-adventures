local Vacuum = Class(function(self, inst)
	self.inst = inst
	self.vacuumradius = 5
	self.vacuumspeed = 30
	self.consumeradius = 1
	self.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "STUMP", "BIRD", "NOVACUUM", "player" }
	self.ignoreplayer = true
	self.playervacuumdamage = 50
	self.playervacuumsanityhit = 0
	self.playervacuumradius = 25
	self.player_hold_distance = 3
	self.holdingplayertimer = 0
	self.holdplayertime = 2
	self.vacuuming_player = false
	self.spitplayer = false
end)


function Vacuum:TurnOn()
	self.inst:StartUpdatingComponent(self)
end

function Vacuum:TurnOff()
	self.inst:StopUpdatingComponent(self)
end

function Vacuum:SpitItem(item)
	if not item then
		local slot = math.random(1, self.inst.components.inventory:GetNumSlots())
		item = self.inst.components.inventory:DropItem()
	end

	if item and item.Physics then
		--		if item.components.inventoryitem then
		--			item.components.inventoryitem:OnStartFalling()
		--		end

		local x, y, z = self.inst:GetPosition():Get()
		y = 2
		item.Physics:Teleport(x, y, z)
		item:AddTag("NOVACUUM")
		item:DoTaskInTime(2, function() item:RemoveTag("NOVACUUM") end)

		local speed = 8 + (math.random() * 4)
		local angle = (math.random() * 360) * DEGREES
		item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
	end
end

function Vacuum:OnUpdate(dt)
	local pt = self.inst:GetPosition()

	-- 1. 防宕机吞噬物品逻辑
	local ents_consume = TheSim:FindEntities(pt.x, 0, pt.z, self.consumeradius, nil, self.noTags)
	for k, v in pairs(ents_consume) do
		if v and v.components.inventoryitem and not v.components.inventoryitem:IsHeld() then
			-- 限制最大吸入数量，多余的直接化为灰烬
			if self.inst.components.inventory:NumItems() < 20 then
				if not self.inst.components.inventory:GiveItem(v) then
					self:SpitItem(v)
				end
			else
				local ash = SpawnPrefab("ash")
				if ash then ash.Transform:SetPosition(v.Transform:GetWorldPosition()) end
				v:Remove()
			end
		end
	end

	-- 2. 限制单帧牵引物品逻辑（缓解服务器压力）
	local ents_pull = TheSim:FindEntities(pt.x, pt.y, pt.z, self.vacuumradius, { "_inventoryitem" }, self.noTags)
	local pull_count = 0
	for k, v in pairs(ents_pull) do
		if pull_count >= 20 then break end
		if v and v.Physics and v.components.inventoryitem and not v.components.inventoryitem:IsHeld() and not v:HasTag("boat") then
			local x, y, z = v:GetPosition():Get()
			v.Physics:Teleport(x, 0.1, z)
			local dir = pt - v:GetPosition()
			local angle = math.atan2(dir.z, dir.x)
			v.Physics:SetVel(math.cos(angle) * self.vacuumspeed, 0, math.sin(angle) * self.vacuumspeed)
			pull_count = pull_count + 1
		else
			v:AddTag("NOVACUUM")
			v:DoTaskInTime(1, function() v:RemoveTag("NOVACUUM") end)
		end
	end

	local jogadores = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, { "player" })

	for k, player in pairs(jogadores) do
		if player:HasTag("playerghost") or not self.inst.sg:HasStateTag("vacuo") then return end
		--	local player = GetClosestInstWithTag("player", self.inst, 40)
		--	if not player then return end
		if player and not self.ignoreplayer or self.vacuuming_player then
			player:RemoveTag("NOVACUUM")
			local playerpos = player:GetPosition()
			local displacement = playerpos - self.inst:GetPosition()
			local dist = displacement:Length()
			local angle = math.atan2(-displacement.z, -displacement.x)
			--  		local windProofness = player.components.inventory:GetWindproofness()
			--Allow the player to get closer if they're wearing something with windproofness
			local playerDistanceMultiplier = 1 -- - (windProofness * 0.25)
			if dist < self.player_hold_distance or self.spitplayer then
				--hold player inside
				self.holdingplayertimer = self.holdingplayertimer + dt

				if not self.spitplayer then
					player.Transform:SetRotation(0)
					player.Physics:SetMotorVelOverride(0, 0, 0)
					player:PushEvent("vacuum_held")
				else
					local mult = self.playervacuumdamage / self.inst.components.combat.defaultdamage
					self.inst.components.combat:DoAttack(player, nil, nil, nil, mult)
					player.components.sanity:DoDelta(self.playervacuumsanityhit)
					player:AddTag("NOVACUUM") --Shoot player out
					player:PushEvent("vacuum_out", { angle = angle, speed = -self.vacuumspeed })
					player.Transform:SetRotation(0)
					self.holdingplayertimer = 0
					self.vacuuming_player = false
				end
			elseif not player:HasTag("NOVACUUM") and (self.vacuuming_player or (dist < (self.playervacuumradius * playerDistanceMultiplier) and CheckLOSFromPoint(self.inst:GetPosition(), player:GetPosition()))) then --Pull player in
				--print("trying to vacuum in the player")


				player.Transform:SetRotation(0)
				player.Physics:SetMotorVelOverride(math.cos(angle) * self.vacuumspeed, 0,
					math.sin(angle) * self.vacuumspeed)
				player.components.locomotor:Clear()
				player:PushEvent("vacuum_in")
				self.holdingplayertimer = 0
				self.vacuuming_player = true
			end
		end
	end

	self.spitplayer = false
end

return Vacuum
