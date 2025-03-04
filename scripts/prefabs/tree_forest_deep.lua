local assets =
{
	Asset("ANIM", "anim/tree_forest_deep_build.zip"),
	Asset("ANIM", "anim/tree_jungle_normal.zip"),
	Asset("ANIM", "anim/tree_jungle_short.zip"),
	Asset("ANIM", "anim/tree_jungle_tall.zip"),
}

local LEIF_REAWAKEN_RADIUS = 20
local LEIF_BURN_TIME = 10
local LEIF_BURN_DAMAGE_PERCENT = 1 / 8
local LEIF_MIN_DAY = 3
local LEIF_PERCENT_CHANCE = 3 / 50
local LEIF_MAXSPAWNDIST = 15

local prefabs =
{

}

local builds =
{
	normal = {
		file = "tree_forest_deep_build",
		prefab_name = "tree_forest",
		normal_loot = { "log", "log", "tree_forest_deep_seed" },
		short_loot = { "log" },
		tall_loot = { "log", "log", "log", "tree_forest_deep_seed", "tree_forest_deep_seed" },

		leif = "treeguard",
	},
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
	blown = "blown_loop",
	blown_pre = "blown_pre",
	blown_pst = "blown_pst"
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

		inst.components.lootdropper:SetLoot({})

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
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetLoot({ "log" })

	if math.random() < 0.2 then
		for i = 1, 1 do
			if math.random() < 0.5 then --and GetClock():GetNumCycles() >= TUNING.SNAKE_POISON_START_DAY then
				inst.components.lootdropper:AddChanceLoot("snake_poison", 0.25)
			else
				inst.components.lootdropper:AddChanceLoot("snake", 0.5)
			end
		end
	end

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
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_NORMAL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetLoot({ "log", "log", "tree_forest_deep_seed" })

	if math.random() < 0.2 then
		for i = 1, 2 do
			if math.random() < 0.5 then -- and GetClock():GetNumCycles() >= TUNING.SNAKE_POISON_START_DAY then
				inst.components.lootdropper:AddChanceLoot("snake_poison", 0.25)
			else
				inst.components.lootdropper:AddChanceLoot("snake", 0.5)
			end
		end
	else
		inst.components.lootdropper:AddChanceLoot("bird_egg", 0.7)
	end

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
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_TALL)
	end
	-- inst:AddTag("shelter")
	inst.components.lootdropper:SetLoot({ "log", "log", "log", "tree_forest_deep_seed", "tree_forest_deep_seed" })

	if math.random() < 0.2 then
		for i = 1, 3 do
			if math.random() < 0.5 then -- and GetClock():GetNumCycles() >= TUNING.SNAKE_POISON_START_DAY then
				inst.components.lootdropper:AddChanceLoot("snake_poison", 0.25)
			else
				inst.components.lootdropper:AddChanceLoot("snake", 0.5)
			end
		end
	else
		if math.random() < 0.5 then
			inst.components.lootdropper:AddChanceLoot("bird_egg", 1.0)
		else
			inst.components.lootdropper:AddChanceLoot("cave_banana", 1.0)
		end
	end

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
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base,
				TUNING.EVERGREEN_GROW_TIME[1].random)
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
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base,
				TUNING.EVERGREEN_GROW_TIME[2].random)
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
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base,
				TUNING.EVERGREEN_GROW_TIME[3].random)
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


local function chop_tree(inst, chopper, chops)
	if chopper and chopper.components.beaverness and chopper.isbeavermode and chopper.isbeavermode:value() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end

	--	local fx = SpawnPrefab("green_leaves_chop")
	--    local x, y, z= inst.Transform:GetWorldPosition()
	--    fx.Transform:SetPosition(x,y + 4,z)

	inst.AnimState:PlayAnimation(inst.anims.chop)
	inst.AnimState:PushAnimation(inst.anims.sway1, true)

	--tell any nearby leifs to wake up
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.LEIF_REAWAKEN_RADIUS, { "jungletreeguard" })
	for k, v in pairs(ents) do
		if v.components.sleeper and v.components.sleeper:IsAsleep() then
			v:DoTaskInTime(math.random(), function() v.components.sleeper:WakeUp() end)
		end
		v.components.combat:SuggestTarget(chopper)
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

	-- local fx = SpawnPrefab("jungle_fall")
	-- local x, y, z= inst.Transform:GetWorldPosition()
	-- fx.Transform:SetPosition(x,y + 2 + math.random()*2,z)

	-- make snakes attack
	-- local x,y,z = inst.Transform:GetWorldPosition()
	-- local snakes = TheSim:FindEntities(x,y,z, 2, {"snake"})
	-- for k, v in pairs(snakes) do
	-- 	if v.components.combat then
	-- 		v.components.combat:SetTarget(chopper)
	-- 	end
	-- end

	inst:DoTaskInTime(.4, function()
		local sz = (inst.components.growable and inst.components.growable.stage > 2) and .5 or .25
		if chopper:HasTag("player") then
			ShakeAllCameras(CAMERASHAKE.FULL, 0.25, 0.03, sz, inst, 6)
		end
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
			local numleifs = 1
			if days_survived > 60 then
				numleifs = math.random(1, 3)
			elseif days_survived > 120 then
				numleifs = math.random(2, 4)
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
								local leif = SpawnPrefab("jungletreeguard")
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

local function makefn(build, stage, data)
	local function fn(Sim)
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
		minimap:SetIcon("jungleTree.tex")

		minimap:SetPriority(-1)

		inst:AddTag("tree")
		inst:AddTag("workable")
		inst:AddTag("shelter")
		inst:AddTag("gustable")
		inst:AddTag("palmtree")
		inst:AddTag("plant")

		inst.build = build
		anim:SetBuild("tree_forest_deep_build")
		anim:SetBank("jungletree")
		--		local color = 0.5 + math.random() * 0.5
		--		anim:SetMultColour(color, color, color, 1)

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

		--		inst:SetPrefabName( GetBuild(inst).prefab_name )

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

return tree("tree_forest_deep", "normal", 0),
	tree("tree_forest_deep_normal", "normal", 2),
	tree("tree_forest_deep_tall", "normal", 3),
	tree("tree_forest_deep_short", "normal", 1),
	tree("tree_forest_deep_burnt", "normal", 0, "burnt"),
	tree("tree_forest_deep_stump", "normal", 0, "stump")
