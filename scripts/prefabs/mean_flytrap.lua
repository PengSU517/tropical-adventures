require "brains/flytrapbrain"
require "stategraphs/SGflytrap"

local trace = function() end

local FLYTRAP_CHILD_HEALTH = 250
local FLYTRAP_CHILD_DAMAGE = 15
local FLYTRAP_CHILD_SPEED = 4

local FLYTRAP_TEEN_HEALTH = 300
local FLYTRAP_TEEN_DAMAGE = 20
local FLYTRAP_TEEN_SPEED = 3.5

local FLYTRAP_HEALTH = 350
local FLYTRAP_DAMAGE = 25
local FLYTRAP_SPEED = 3

local FLYTRAP_TARGET_DIST = 8
local FLYTRAP_KEEP_TARGET_DIST = 15
local FLYTRAP_ATTACK_PERIOD = 3
local SPIDER_WARRIOR_WAKE_RADIUS = 6
local SPRING_COMBAT_MOD = 1.33

local assets =
{
	Asset("ANIM", "anim/venus_flytrap_sm_build.zip"),
	Asset("ANIM", "anim/venus_flytrap_lg_build.zip"),
	Asset("ANIM", "anim/venus_flytrap_build.zip"),
	Asset("ANIM", "anim/venus_flytrap.zip"),
	--Asset("ANIM", "anim/snapdragon.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
	"plantmeat",
	"vine",
	"nectar_pod",
}


SetSharedLootTable('mean_flytrap',
	{
		{ 'plantmeat',  1.0 },
		{ 'vine',       0.5 },
		{ 'nectar_pod', 0.3 },
	})

local WAKE_TO_FOLLOW_DISTANCE = 8
local SHARE_TARGET_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function ShouldWakeUp(inst)
	return TheWorld.state.isnight
		or (inst.components.combat and inst.components.combat.target)
		or (inst.components.burnable and inst.components.burnable:IsBurning())
		or (inst.components.follower and inst.components.follower.leader)
end

local function ShouldSleep(inst)
	return TheWorld.state.isday
		and not (inst.components.combat and inst.components.combat.target)
		and not (inst.components.burnable and inst.components.burnable:IsBurning())
		and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end


local function retargetfn(inst)
	local dist = FLYTRAP_TARGET_DIST
	local notags = { "FX", "NOCLICK", "INLIMBO", "wall", "flytrap", "structure", "aquatic", "plantkin" }
	return FindEntity(inst, dist, function(guy)
		return inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and
	inst:GetDistanceSqToInst(target) <= (FLYTRAP_KEEP_TARGET_DIST * FLYTRAP_KEEP_TARGET_DIST) and
	not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
		function(dude) return dude:HasTag("snake") and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
		function(dude) return dude:HasTag("snake") and not dude.components.health:IsDead() end, 5)
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

local function TransformChild(inst, instant)
	if instant then
		local scale = 1.2
		inst.Transform:SetScale(scale, scale, scale)
		inst.AnimState:SetBuild("venus_flytrap_build")
	else
		inst.new_build = "venus_flytrap_build"
		inst.start_scale = 1

		inst.inc_scale = (1.20 - 1) / 5
		inst.sg:GoToState("grow")
	end

	inst:RemoveTag("usefastrun")

	inst.components.combat:SetDefaultDamage(FLYTRAP_TEEN_DAMAGE)
	inst.components.health:SetMaxHealth(FLYTRAP_TEEN_HEALTH)
	inst.components.locomotor.runspeed = FLYTRAP_TEEN_SPEED

	inst.components.health:DoDelta(50)
end

local function TransformTeen(inst, instant)
	if instant then
		local scale = 1.4
		inst.Transform:SetScale(scale, scale, scale)
		inst.AnimState:SetBuild("venus_flytrap_lg_build")
	else
		inst.new_build = "venus_flytrap_lg_build"
		inst.start_scale = 1.20

		inst.inc_scale = (1.40 - 1.20) / 5
		inst.sg:GoToState("grow")
	end

	inst:RemoveTag("usefastrun")

	inst.components.combat:SetDefaultDamage(FLYTRAP_DAMAGE)
	inst.components.health:SetMaxHealth(FLYTRAP_HEALTH)
	inst.components.locomotor.runspeed = FLYTRAP_SPEED
	inst.components.health:DoDelta(50)
end

local function TransformAdult(inst)
	local adult = SpawnPrefab("adult_flytrap")
	adult.Transform:SetPosition(inst.Transform:GetWorldPosition())
	adult.onSpawn(adult)
	inst:Remove()
end

local function OnEat(inst, food)
	--If we're not an adult
	if inst.currentTransform < 4 then
		inst.growtask = inst:DoTaskInTime(0.5,
			function()
				inst:DoTransform()
				inst.growtask:Cancel()
				inst.growtask = nil
			end)
	end
end

local function DoTransform(inst, instant)
	if inst.currentTransform < 4 then
		inst.currentTransform = inst.currentTransform + 1
	end
	if inst.currentTransform == 2 then
		inst:TransformChild(instant)
	elseif inst.currentTransform == 3 then
		inst:TransformTeen(instant)
	elseif inst.currentTransform == 4 then
		inst:TransformAdult(instant)
	end
end

local function OnSave(inst, data)
	if inst.currentTransform then
		data.currentTransform = inst.currentTransform
	end
end

local function OnLoad(inst, data)
	if data and data.currentTransform then
		inst.currentTransform = data.currentTransform - 1
		DoTransform(inst, true)
	end
end

local function SanityAura(inst, observer)
	return -TUNING.SANITYAURA_SMALL
end

local function ShouldSleep(inst)
	return TheWorld.state.isday
		and not (inst.components.combat and inst.components.combat.target)
		and not (inst.components.homeseeker and inst.components.homeseeker:HasHome())
		and not (inst.components.burnable and inst.components.burnable:IsBurning())
		and not (inst.components.follower and inst.components.follower.leader)
end

local function ShouldWake(inst)
	local wakeRadius = SPIDER_WARRIOR_WAKE_RADIUS
	if TheWorld.state.isspring then
		wakeRadius = wakeRadius * SPRING_COMBAT_MOD
	end
	return TheWorld.state.isnight
		or (inst.components.combat and inst.components.combat.target)
		or (inst.components.homeseeker and inst.components.homeseeker:HasHome())
		or (inst.components.burnable and inst.components.burnable:IsBurning())
		or (inst.components.follower and inst.components.follower.leader)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(2.5, 1.5)
	inst.Transform:SetFourFaced()
	inst.entity:AddNetwork()

	inst.AnimState:Hide("dirt")

	inst:AddTag("character")
	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("flytrap")
	inst:AddTag("hostile")
	inst:AddTag("animal")
	inst:AddTag("usefastrun")

	MakeCharacterPhysics(inst, 10, .5)

	anim:SetBank("venus_flytrap")
	anim:SetBuild("venus_flytrap_sm_build")
	anim:PlayAnimation("idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("knownlocations")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = FLYTRAP_CHILD_SPEED

	inst:SetStateGraph("SGflytrap")

	local brain = require "brains/flytrapbrain"
	inst:SetBrain(brain)

	inst:AddComponent("follower")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater.strongstomach = true -- can eat monster meat!
	inst.components.eater.oneatfn = OnEat

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(FLYTRAP_CHILD_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(FLYTRAP_CHILD_DAMAGE)
	inst.components.combat:SetAttackPeriod(FLYTRAP_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetRange(2, 3)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('mean_flytrap')


	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWake)

	inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst.OnEntitySleep = OnEntitySleep

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst.TransformChild = TransformChild
	inst.TransformTeen = TransformTeen
	inst.TransformAdult = TransformAdult
	inst.DoTransform = DoTransform
	inst.currentTransform = 1

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	MakeMediumFreezableCharacter(inst, "hound_body")
	MakeMediumBurnableCharacter(inst, "stem")

	return inst
end

return Prefab("monsters/mean_flytrap", fn, assets, prefabs)
-- Prefab("monsters/deadsnake", fndefault, assets, prefabs),
