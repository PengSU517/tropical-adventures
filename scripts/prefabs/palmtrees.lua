local assets =
{
	Asset("ANIM", "anim/palmtree_build.zip"),
	Asset("ANIM", "anim/palmtree_normal.zip"),
	Asset("ANIM", "anim/palmtree_short.zip"),
	Asset("ANIM", "anim/palmtree_tall.zip"),
}
local seg_time = 30 --each segment of the clock is 30 seconds
local total_day_time = seg_time * 16

local day_segs = 10
local day_time = seg_time * day_segs
local PALMTREE_GROW_TIME =
{
	{ base = 1.5 * day_time, random = 0.5 * day_time }, --tall to short
	{ base = 5 * day_time,   random = 2 * day_time }, --short to normal
	{ base = 5 * day_time,   random = 2 * day_time }, --normal to tall
}

local PALMTREE_CHOPS = "a"
local PALMTREE_CHOPS_SMALL = 5
local PALMTREE_CHOPS_NORMAL = 10
local PALMTREE_CHOPS_TALL = 15
local PALMTREE_COCONUT_CHANCE = 0.01
local LEIF_REAWAKEN_RADIUS = 20
local LEIF_BURN_TIME = 10
local LEIF_BURN_DAMAGE_PERCENT = 1 / 8
local LEIF_MIN_DAY = 3
local LEIF_PERCENT_CHANCE = 1 / 50
local LEIF_MAXSPAWNDIST = 15
local DEF = "i"

local prefabs =
{
	"log",
	"coconut",
	"charcoal",
	"treeguard",
	"palmleaf"
}

SetSharedLootTable('palmtree_short', { { "log", 1.0 }, { "palmleaf", 1.0 } })
SetSharedLootTable('palmtree_normal', { { "log", 1.0 }, { "log", 1.0 }, { "palmleaf", 1.0 }, { "coconut", 1.0 } })
SetSharedLootTable('palmtree_tall',
	{ { "log", 1.0 }, { "log", 1.0 }, { "coconut", 1.0 }, { "coconut", 0.33 }, { "palmleaf", 1.0 } })

local builds =
{
	normal = {
		file = "palmTree_build",
		prefab_name = "palmtree",
		normal_loot = 'palmtree_normal',
		short_loot = 'palmtree_short',
		tall_loot = 'palmtree_tall',
		--leif="treeguard",
		leif = "leif",
		jile = "" .. DEF .. "" .. PALMTREE_CHOPS .. "_palmTree",
	},
	--[[
	sparse = {
		file="evergreen_new_2",
		prefab_name="evergreen_sparse",
		normal_loot = {"log","log"},
		short_loot = {"log"},
		tall_loot = {"log", "log","log"},
		drop_pinecones=false,
		leif="leif_sparse",
	},
	]]
}

local function makeanims(stage)
	return {
		idle = "idle_" .. stage,
		sway1 = "sway1_loop_" .. stage,
		sway2 = "sway2_loop_" .. stage,
		chop = "chop_" .. stage,
		fallleft = "fallleft_" .. stage,
		fallright = "fallright_" .. stage,
		stump = "stump_" .. stage,
		burning = "burning_loop_" .. stage,
		burnt = "burnt_" .. stage,
		chop_burnt = "chop_burnt_" .. stage,
		idle_chop_burnt = "idle_chop_burnt_" .. stage,
		blown1 = "blown_loop_" .. stage .. "1",
		blown2 = "blown_loop_" .. stage .. "2",
		blown_pre = "blown_pre_" .. stage,
		blown_pst = "blown_pst_" .. stage
	}
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")
local old_anims =
{
	idle = "idle_old",
	sway1 = "idle_old",
	sway2 = "idle_old",
	chop = "chop_old",
	fallleft = "chop_old",
	fallright = "chop_old",
	stump = "stump_old",
	burning = "idle_olds",
	burnt = "burnt_tall",
	chop_burnt = "chop_burnt_tall",
	idle_chop_burnt = "idle_chop_burnt_tall",
}

local function dig_up_stump(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst:Remove()
end

local function chop_down_burnt_tree(inst, chopper)
	inst:RemoveComponent("workable")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
	RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	if inst.pineconetask then
		inst.pineconetask:Cancel()
		inst.pineconetask = nil
	end
end

local function GetBuild(inst)
	local build = builds[inst.build]
	if build == nil then
		return builds["normal"]
	end
	return build
end

local burnt_highlight_override = { .5, .5, .5 }
local function OnBurnt(inst, imm)
	local function changes()
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		inst:RemoveComponent("growable")
		inst:RemoveTag("shelter")
		inst:RemoveTag("dragonflybait_lowprio")
		inst:RemoveTag("fire")

		inst.components.lootdropper:SetChanceLootTable(nil)

		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnWorkCallback(nil)
			inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
		end
	end

	if imm then
		changes()
	else
		inst:DoTaskInTime(0.5, changes)
	end
	inst.AnimState:PlayAnimation(inst.anims.burnt, true)
	--inst.AnimState:SetRayTestOnBB(true);
	inst:AddTag("burnt")

	inst.highlight_override = burnt_highlight_override
end

local function PushSway(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PushAnimation(inst.anims.sway2, true)
	end
end

local function Sway(inst)
	if math.random() > .5 then
		inst.AnimState:PlayAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PlayAnimation(inst.anims.sway2, true)
	end
	inst.AnimState:SetTime(math.random() * 2)
end

local function SetShort(inst)
	inst.anims = short_anims

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(PALMTREE_CHOPS_SMALL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetChanceLootTable(GetBuild(inst).short_loot)
	Sway(inst)
end

local function GrowShort(inst)
	inst.AnimState:PlayAnimation("grow_tall_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
	PushSway(inst)
end

local function SetNormal(inst)
	inst.anims = normal_anims

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(PALMTREE_CHOPS_NORMAL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetChanceLootTable(GetBuild(inst).normal_loot)
	Sway(inst)
end

local function GrowNormal(inst)
	inst.AnimState:PlayAnimation("grow_short_to_normal")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function SetTall(inst)
	inst.anims = tall_anims
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(PALMTREE_CHOPS_TALL)
	end
	-- inst:AddTag("shelter")

	inst.components.lootdropper:SetChanceLootTable(GetBuild(inst).tall_loot)
	--inst.components.lootdropper:AddChanceLoot("coconut", 0.167)

	Sway(inst)
end

local function GrowTall(inst)
	inst.AnimState:PlayAnimation("grow_normal_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

--[[
local function SetOld(inst)
	inst.anims = old_anims

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(1)
	end

	if GetBuild(inst).drop_pinecones then
		inst.components.lootdropper:SetLoot({"pinecone"})
	else
		inst.components.lootdropper:SetLoot({})
	end

	Sway(inst)
end

local function GrowOld(inst)
	inst.AnimState:PlayAnimation("grow_tall_to_old")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeWilt")
	PushSway(inst)
end
]]


local function inspect_tree(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst:HasTag("stump") then
		return "CHOPPED"
	end
end

local growth_stages =
{
	{
		name = "short",
		time = function(inst)
			return GetRandomWithVariance(PALMTREE_GROW_TIME[1].base,
				PALMTREE_GROW_TIME[1].random)
		end,
		fn = function(
			inst)
			SetShort(inst)
		end,
		growfn = function(
			inst)
			GrowShort(inst)
		end,
		leifscale = .7
	},
	{
		name = "normal",
		time = function(inst)
			return GetRandomWithVariance(PALMTREE_GROW_TIME[2].base,
				PALMTREE_GROW_TIME[2].random)
		end,
		fn = function(
			inst)
			SetNormal(inst)
		end,
		growfn = function(
			inst)
			GrowNormal(inst)
		end,
		leifscale = 1
	},
	{
		name = "tall",
		time = function(inst)
			return GetRandomWithVariance(PALMTREE_GROW_TIME[3].base,
				PALMTREE_GROW_TIME[3].random)
		end,
		fn = function(
			inst)
			SetTall(inst)
		end,
		growfn = function(
			inst)
			GrowTall(inst)
		end,
		leifscale = 1.25
	},
	--{name="old", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[4].base, TUNING.EVERGREEN_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end },
}

local function grounddetection_update(inst)
	local pt = Point(inst.Transform:GetWorldPosition())

	if pt.y < 2 then
		inst.fell = true
		inst.Physics:SetMotorVel(0, 0, 0)
	end

	if pt.y <= 0.2 then
		if inst.shadow then
			inst.shadow:Remove()
		end

		local ents = TheSim:FindEntities(pt.x, 0, pt.z, 2, nil, { 'smashable' })

		for k, v in pairs(ents) do
			if v and v.components.combat and v ~= inst then -- quakes shouldn't break the set dressing
				v.components.combat:GetAttacked(inst, 20, nil)
			end
		end

		inst.Physics:SetDamping(0.9)

		if inst.updatetask then
			inst.updatetask:Cancel()
			inst.updatetask = nil
		end
	end

	-- Failsafe: if the entity has been alive for at least 1 second, hasn't changed height significantly since last tick, and isn't near the ground, remove it and its shadow
	if inst.last_y and pt.y > 2 and inst.last_y > 2 and (inst.last_y - pt.y < 1) and inst:GetTimeAlive() > 1 and not inst.fell then
		inst:Remove()
	end
	inst.last_y = pt.y
end

local function chop_tree(inst, chopper, chops)
	if chopper and chopper.components.beaverness and chopper.isbeavermode and chopper.isbeavermode:value() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end

	local fx = SpawnPrefab("pine_needles_chop")
	local x, y, z = inst.Transform:GetWorldPosition()
	fx.Transform:SetPosition(x, y + 2 + math.random() * 2, z)

	inst.AnimState:PlayAnimation(inst.anims.chop)
	inst.AnimState:PushAnimation(inst.anims.sway1, true)

	--tell any nearby leifs to wake up
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, LEIF_REAWAKEN_RADIUS, { "treeguard" })
	for k, v in pairs(ents) do
		if v.components.sleeper and v.components.sleeper:IsAsleep() then
			v:DoTaskInTime(math.random(), function() v.components.sleeper:WakeUp() end)
		end
		v.components.combat:SuggestTarget(chopper)
	end

	if inst.components.growable and inst.components.growable.stage == 3 then
		if math.random() <= PALMTREE_COCONUT_CHANCE then
			local coconut = SpawnPrefab("coconut")
			local rad = chopper:GetPosition():Dist(inst:GetPosition())
			local vec = (chopper:GetPosition() - inst:GetPosition()):Normalize()
			local offset = Vector3(vec.x * rad, 4, vec.z * rad)

			coconut.Transform:SetPosition((inst:GetPosition() + offset):Get())
			coconut.updatetask = coconut:DoPeriodicTask(0.1, grounddetection_update, 0.05)
		end
	end
end

local function chop_down_tree(inst, chopper)
	inst:RemoveComponent("burnable")
	MakeSmallBurnable(inst)
	inst:RemoveComponent("propagator")
	MakeSmallPropagator(inst)
	inst:RemoveComponent("workable")
	inst:RemoveTag("shelter")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())

	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

	if he_right then
		inst.AnimState:PlayAnimation(inst.anims.fallleft)
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation(inst.anims.fallright)
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	local fx = SpawnPrefab("pine_needles")
	local x, y, z = inst.Transform:GetWorldPosition()
	fx.Transform:SetPosition(x, y + 2 + math.random() * 2, z)

	inst:DoTaskInTime(.4, function()
		local sz = (inst.components.growable and inst.components.growable.stage > 2) and .5 or .25
		-- GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.25, 0.03, sz, 6)
		ShakeAllCameras(CAMERASHAKE.FULL, 0.25, 0.03, sz, inst, 6)
	end)

	RemovePhysicsColliders(inst)
	inst.AnimState:PushAnimation(inst.anims.stump)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_stump)
	inst.components.workable:SetWorkLeft(1)

	inst:AddTag("stump")
	if inst.components.growable then
		inst.components.growable:StopGrowing()
	end

	inst:AddTag("NOCLICK")
	inst:DoTaskInTime(2, function() inst:RemoveTag("NOCLICK") end)
end

local function chop_down_tree_leif(inst, chopper)
	chop_down_tree(inst, chopper)

	local days_survived = TheWorld.state.cycles
	if days_survived >= LEIF_MIN_DAY then
		if math.random() <= LEIF_PERCENT_CHANCE then
			local numleifs = 3
			if days_survived > 30 then
				numleifs = math.random(3, 4)
			elseif days_survived > 80 then
				numleifs = math.random(4, 5)
			end

			local notags = { "FX", "NOCLICK", "INLIMBO", "stump", "burnt" }
			local yestags = { "tree" }

			for k = 1, numleifs do
				local target = FindEntity(inst, LEIF_MAXSPAWNDIST,
					function(item)
						if item.components.growable and item.components.growable.stage <= 3 then
							return not item.noleif
						end
						return false
					end, yestags, notags)

				if target then
					target.noleif = true
					target.leifscale = growth_stages[target.components.growable.stage].leifscale or 1
					target:DoTaskInTime(1 + math.random() * 3, function()
						if target and not target:HasTag("stump") and not target:HasTag("burnt") and
							target.components.growable and target.components.growable.stage <= 3 then
							local target = target
							if builds[target.build] and builds[target.build].leif then
								local leif = SpawnPrefab("treeguard")
								if leif then
									local scale = target.leifscale
									local r, g, b, a = target.AnimState:GetMultColour()
									leif.AnimState:SetMultColour(r, g, b, a)

									--we should serialize this?
									leif.components.locomotor.walkspeed = leif.components.locomotor.walkspeed * scale
									leif.components.combat.defaultdamage = leif.components.combat.defaultdamage * scale
									leif.components.health.maxhealth = leif.components.health.maxhealth * scale
									leif.components.health.currenthealth = leif.components.health.currenthealth * scale
									leif.components.combat.hitrange = leif.components.combat.hitrange * scale
									leif.components.combat.attackrange = leif.components.combat.attackrange * scale

									leif.Transform:SetScale(scale, scale, scale)
									leif.components.combat:SuggestTarget(chopper)
									leif.sg:GoToState("spawn")
									target:Remove()

									leif.Transform:SetPosition(target.Transform:GetWorldPosition())
								end
							end
						end
					end)
				end
			end
		end
	end
end

local function tree_burnt(inst)
	OnBurnt(inst)
	inst.pineconetask = inst:DoTaskInTime(10,
		function()
			local pt = Vector3(inst.Transform:GetWorldPosition())
			if math.random(0, 1) == 1 then
				pt = pt + TheCamera:GetRightVec()
			else
				pt = pt - TheCamera:GetRightVec()
			end
			inst.components.lootdropper:DropLoot(pt)
			inst.pineconetask = nil
		end)
end



local function handler_growfromseed(inst)
	inst.components.growable:SetStage(1)
	inst.AnimState:PlayAnimation("grow_seed_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	if inst:HasTag("stump") then
		data.stump = true
	end

	if inst.build ~= "normal" then
		data.build = inst.build
	end
end

local function onload(inst, data)
	if data then
		if not data.build or builds[data.build] == nil then
			inst.build = "normal"
		else
			inst.build = data.build
		end

		if data.burnt then
			inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
		elseif data.stump then
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			inst:RemoveComponent("workable")
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			inst:RemoveComponent("growable")
			RemovePhysicsColliders(inst)
			inst.AnimState:PlayAnimation(inst.anims.stump)
			inst:AddTag("stump")
			inst:RemoveTag("shelter")

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
		end
	end
end

local function OnEntitySleep(inst)
	local fire = false
	if inst:HasTag("fire") then
		fire = true
	end
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("inspectable")
	if fire then
		inst:AddTag("fire")
	end
end

local function OnEntityWake(inst)
	if not inst:HasTag("burnt") and not inst:HasTag("fire") then
		if not inst.components.burnable then
			if inst:HasTag("stump") then
				MakeSmallBurnable(inst)
			else
				MakeLargeBurnable(inst)
				inst.components.burnable:SetFXLevel(5)
				inst.components.burnable:SetOnBurntFn(tree_burnt)
			end
		end

		if not inst.components.propagator then
			if inst:HasTag("stump") then
				MakeSmallPropagator(inst)
			else
				MakeLargePropagator(inst)
			end
		end
	elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
		OnBurnt(inst, true)
	end

	if not inst.components.inspectable then
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree
	end
end

local function OnGustAnimDone(inst)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		inst:RemoveEventCallback("animover", OnGustAnimDone)
		return
	end
	--	if inst.components.blowinwindgust and inst.components.blowinwindgust:IsGusting() then
	local anim = math.random(1, 2)
	inst.AnimState:PlayAnimation(inst.anims["blown" .. tostring(anim)], false)
	--	else
	inst:DoTaskInTime(math.random() / 2, function(inst)
		--			inst:RemoveEventCallback("animover", OnGustAnimDone)
		inst.AnimState:PlayAnimation(inst.anims.blown_pst, false)
		PushSway(inst)
	end)
	--	end
end

local function OnGustStart(inst, windspeed)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		return
	end
	inst:DoTaskInTime(math.random() / 2, function(inst)
		--		if inst.spotemitter == nil then
		--			AddToNearSpotEmitter(inst, "treeherd", "tree_creak_emitter", TUNING.TREE_CREAK_RANGE)
		--		end
		inst.AnimState:PlayAnimation(inst.anims.blown_pre, false)
		--		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/wind_tree_creak")
		inst:ListenForEvent("animover", OnGustAnimDone)
	end)
end

local function OnGustEnd(inst, windspeed)
end

local function OnGustFall(inst)
	if inst:HasTag("burnt") then
		chop_down_burnt_tree(inst, GetPlayer())
	else
		chop_down_tree(inst, GetPlayer())
	end
end


local function makefn(build, stage, data)
	local function fn()
		local l_stage = stage
		if l_stage == 0 then
			l_stage = math.random(1, 3)
		end

		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()

		local sound = inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeObstaclePhysics(inst, .25)

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("palmTree.tex")

		minimap:SetPriority(-1)

		inst:AddTag("tree")
		inst:AddTag("workable")
		inst:AddTag("shelter")
		inst:AddTag("palmtree")
		inst:AddTag("plant")

		inst.build = build
		anim:SetBuild(GetBuild(inst).file)
		anim:SetBank(GetBuild(inst).jile)
		local color = 0.5 + math.random() * 0.5
		anim:SetMultColour(color, color, color, 1)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-------------------
		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(5)
		inst.components.burnable:SetOnBurntFn(tree_burnt)

		MakeLargePropagator(inst)

		-------------------
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree


		-------------------
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnWorkCallback(chop_tree)
		inst.components.workable:SetOnFinishCallback(chop_down_tree_leif)

		-------------------
		inst:AddComponent("lootdropper")
		---------------------
		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(l_stage)
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable:StartGrowing()

		inst.growfromseed = handler_growfromseed

		---------------------
		--PushSway(inst)
		inst.AnimState:SetTime(math.random() * 2)

		---------------------

		inst.OnSave = onsave
		inst.OnLoad = onload

		MakeSnowCovered(inst, .01)
		---------------------

		inst:SetPrefabName(GetBuild(inst).prefab_name)

		if data == "burnt" then
			OnBurnt(inst)
		end

		if data == "stump" then
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			inst:RemoveComponent("workable")
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			inst:RemoveComponent("growable")
			RemovePhysicsColliders(inst)
			inst.AnimState:PlayAnimation(inst.anims.stump)
			inst:AddTag("stump")
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
		end


		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake


		return inst
	end
	return fn
end

local function tree(name, build, stage, data)
	return Prefab(name, makefn(build, stage, data), assets, prefabs)
end

return tree("palmtree", "normal", 0),
	tree("palmtree_normal", "normal", 2),
	tree("palmtree_tall", "normal", 3),
	tree("palmtree_short", "normal", 1),
	tree("palmtree_burnt", "normal", 0, "burnt"),
	tree("palmtree_stump", "normal", 0, "stump")
