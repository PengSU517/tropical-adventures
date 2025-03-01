require "brains/snakebrain"
require "stategraphs/SGsnake2"

local trace = function() end

local SNAKE_SPEED = 3
local SNAKE_TARGET_DIST = 8
local SNAKE_KEEP_TARGET_DIST = 15
local SNAKE_HEALTH = 100
local SNAKE_DAMAGE = 10
local SNAKE_ATTACK_PERIOD = 3
local SNAKE_POISON_CHANCE = 0.25
local SNAKE_POISON_START_DAY = 3 -- the day that poison snakes have a chance to show up
local SNAKEDEN_REGEN_TIME = 3 * 30
local SNAKEDEN_RELEASE_TIME = 5
local SNAKE_JUNGLETREE_CHANCE = 0.5         -- chance of a normal snake
local SNAKE_JUNGLETREE_POISON_CHANCE = 0.25 -- chance of a poison snake
local SNAKE_JUNGLETREE_AMOUNT_TALL = 2      -- num of times to try and spawn a snake from a tall tree
local SNAKE_JUNGLETREE_AMOUNT_MED = 1       -- num of times to try and spawn a snake from a normal tree
local SNAKE_JUNGLETREE_AMOUNT_SMALL = 1     -- num of times to try and spawn a snake from a small tree
local SNAKEDEN_MAX_SNAKES = 3
local SNAKEDEN_CHECK_DIST = 20
local SNAKEDEN_TRAP_DIST = 2

local assets =
{
	Asset("ANIM", "anim/snake_build.zip"),
	Asset("ANIM", "anim/snake_yellow_build.zip"),
	Asset("ANIM", "anim/snake_basic.zip"),
	Asset("ANIM", "anim/snake_water.zip"),
	Asset("ANIM", "anim/snake_scaly_build.zip"),
	Asset("ANIM", "anim/dragonfly_fx.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
	"monstermeat",
	"snakeskin",
	"venomgland",
	--	"obsidian",
	"ash",
	"charcoal",
	--"vomitfire_fx",
	"firesplash_fx",
	"firering_fx",
	--	"dragonfly_fx",
	--	"lavaspit",
	--	"snakeoil",
}

local sounds = {
	default = {
		idle = "dontstarve_DLC002/creatures/snake/idle",
		pre_attack = "dontstarve_DLC002/creatures/snake/pre-attack",
		attack = "dontstarve_DLC002/creatures/snake/attack",
		hurt = "dontstarve_DLC002/creatures/snake/hurt",
		taunt = "dontstarve_DLC002/creatures/snake/taunt",
		death = "dontstarve_DLC002/creatures/snake/death",
		sleep = "dontstarve_DLC002/creatures/snake/sleep",
		move = "dontstarve_DLC002/creatures/snake/move",
	},
	amphibious = {
		idle = "dontstarve_DLC003/creatures/snake_amphibious/idle",
		pre_attack = "dontstarve_DLC002/creatures/snake/pre-attack",
		attack = "dontstarve_DLC003/creatures/snake_amphibious/attack",
		hurt = "dontstarve_DLC002/creatures/snake/hurt",
		taunt = "dontstarve_DLC002/creatures/snake/taunt",
		death = "dontstarve_DLC003/creatures/snake_amphibious/death",
		sleep = "dontstarve_DLC002/creatures/snake/sleep",
		move = "dontstarve_DLC002/creatures/snake/move",
	},
}


local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function ShouldWakeUp(inst)
	return TheWorld.state.isnight
		or (inst.components.combat and inst.components.combat.target)
		or (inst.components.homeseeker and inst.components.homeseeker:HasHome())
		or (inst.components.burnable and inst.components.burnable:IsBurning())
		or (inst.components.follower and inst.components.follower.leader)
end

local function ShouldSleep(inst)
	return TheWorld.state.isday
		and not (inst.components.combat and inst.components.combat.target)
		and not (inst.components.homeseeker and inst.components.homeseeker:HasHome())
		and not (inst.components.burnable and inst.components.burnable:IsBurning())
		and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end


local function retargetfn(inst)
	local dist = SNAKE_TARGET_DIST
	local notags = { "FX", "NOCLICK", "INLIMBO", "wall", "snake", "structure", "ox", "hippopotamoose" }
	return FindEntity(inst, dist, function(guy)
		return inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and
	inst:GetDistanceSqToInst(target) <= (SNAKE_KEEP_TARGET_DIST * SNAKE_KEEP_TARGET_DIST) and
	not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
		function(dude) return dude:HasTag("snake") and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
		function(dude) return (dude:HasTag("snake")) and not dude.components.health:IsDead() end, 5)
end

local function DoReturn(inst)
	--print("DoReturn", inst)
	if inst.components.homeseeker then
		inst.components.homeseeker:ForceGoHome()
	end
end

local function OnDay(inst)
	--print("OnNight", inst)
	if inst:IsAsleep() then
		DoReturn(inst)
	end
end


local function OnEntitySleep(inst)
	--print("OnEntitySleep", inst)
	if TheWorld.state.isday then
		DoReturn(inst)
	end
end

local function OnSave(inst, data)
end

local function OnLoad(inst, data)
end

local function SanityAura(inst, observer)
	if observer.prefab == "webber" then
		return 0
	end

	return -TUNING.SANITYAURA_SMALL
end

local function OnWaterChange2(inst)
	local map = TheWorld.Map
	local x, y, z = inst.Transform:GetWorldPosition()
	local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
	if ground ~= GROUND.OCEAN_SWELL and
		ground ~= GROUND.OCEAN_BRINEPOOL and
		ground ~= GROUND.OCEAN_BRINEPOOL_SHORE and
		ground ~= GROUND.OCEAN_HAZARDOUS and
		ground ~= GROUND.OCEAN_ROUGH and
		ground ~= GROUND.OCEAN_COASTAL_SHORE and
		ground ~= GROUND.OCEAN_WATERLOG and
		ground ~= GROUND.OCEAN_COASTAL then
		local invader = GetClosestInstWithTag("alagamento", inst, 5)
		if invader then
			if not inst.onwater then
				inst.onwater = true
				inst.sg:GoToState("submerge")
				inst.DynamicShadow:Enable(false)
			end
		else
			if inst.onwater then
				inst.sg:GoToState("emerge")
				inst.onwater = false
				inst.DynamicShadow:Enable(true)
			end
		end
	end
end


local function OnWaterChange(inst, onwater)
	if onwater then
		inst.onwater = true
		inst.sg:GoToState("submerge")
		inst.DynamicShadow:Enable(false)
		--        inst.components.locomotor.walkspeed = 3
	else
		if inst.onwater then
			inst.sg:GoToState("emerge")
		end
		inst.onwater = false
		inst.DynamicShadow:Enable(true)
		--        inst.components.locomotor.walkspeed = 4
	end
end

local function OnEntityWake(inst)
	if inst.components.tiletracker then
		inst.components.tiletracker:Start()
	end
end

local function OnEntitySleep(inst)
	if inst.components.tiletracker then
		inst.components.tiletracker:Stop()
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetFourFaced()
	inst.entity:AddNetwork()

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("snake")
	inst:AddTag("animal")
	inst:AddTag("canbetrapped")

	MakeCharacterPhysics(inst, 10, .5)

	anim:SetBank("snake")
	anim:SetBuild("snake_build")
	anim:PlayAnimation("idle")
	inst.AnimState:SetRayTestOnBB(true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("knownlocations")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = SNAKE_SPEED

	inst:AddComponent("follower")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
	inst.components.eater:SetCanEatHorrible()

	inst.components.eater.strongstomach = true -- can eat monster meat!

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(SNAKE_HEALTH)
	--	inst.components.health.poison_damage_scale = 0 -- immune to poison


	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(SNAKE_DAMAGE)
	inst.components.combat:SetAttackPeriod(SNAKE_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve_DLC003/creatures/snake/hurt")
	inst.components.combat:SetRange(2, 3)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstermeat", 1.00)
	inst.components.lootdropper:AddRandomLoot("snakeskin", 0.50)
	--	inst.components.lootdropper:AddRandomLoot("snakeoil", 0.01)
	inst.components.lootdropper.numrandomloot = math.random(0, 1)

	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)
	--inst.components.sleeper:SetResistance(1)
	-- inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	-- inst.components.sleeper:SetSleepTest(ShouldSleep)
	-- inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst.OnEntitySleep = OnEntitySleep

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad


	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	MakeMediumFreezableCharacter(inst, "hound_body")

	inst:SetStateGraph("SGsnake2")

	local brain = require "brains/snakebrain"
	inst:SetBrain(brain)

	inst:DoPeriodicTask(1, OnWaterChange2)
	return inst
end

local function commonfn(Sim)
	local inst = fn(Sim)

	MakePoisonableCharacter(inst)
	MakeMediumBurnableCharacter(inst, "hound_body")
	inst.sounds = sounds.default
	return inst
end

local function poisonfn(Sim)
	local inst = fn(Sim)

	inst.AnimState:SetBuild("snake_yellow_build")

	inst:AddTag("poisonous")
	inst.components.combat.poisonous = true
	inst.components.lootdropper:AddRandomLoot("venomgland", 1.00)
	inst.sounds = sounds.default
	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

local function firefn(Sim)
	local inst = fn(Sim)

	inst.AnimState:SetBuild("snake_yellow_build")

	inst.last_spit_time = nil
	inst.last_target_spit_time = nil
	inst.spit_interval = math.random(20, 30)
	inst.num_targets_vomited = 0

	inst:AddTag("lavaspitter")
	inst.components.health.fire_damage_scale = 0

	--inst:AddTag("poisonous")
	inst.components.lootdropper.numrandomloot = 3
	--	inst.components.lootdropper:AddRandomLoot("obsidian", .25)
	inst.components.lootdropper:AddRandomLoot("ash", .25)
	inst.components.lootdropper:AddRandomLoot("charcoal", .25)

	MakeLargePropagator(inst)
	inst.components.propagator.decayrate = 0

	return inst
end

local function amphibiousfn(Sim)
	local inst = fn(Sim)

	local shadow = inst.entity:AddDynamicShadow()
	inst:AddTag("amphibious_snake")
	MakeCharacterPhysics(inst, 1, .5)
	inst.Physics:ClearCollidesWith(COLLISION.BOAT_LIMITS)
	inst.AnimState:SetBuild("snake_scaly_build")

	inst:AddComponent("tiletracker")
	inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)

	inst.sounds = sounds.amphibious

	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

return --Prefab("monsters/snake", commonfn, assets, prefabs),
--	   Prefab("monsters/snake_poison", poisonfn, assets, prefabs),
--	   Prefab("monsters/snake_fire", firefn, assets, prefabs),
	Prefab("monsters/snake_amphibious", amphibiousfn, assets, prefabs)
-- Prefab("monsters/deadsnake", fndefault, assets, prefabs),
