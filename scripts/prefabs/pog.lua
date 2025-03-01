require("brains/pogbrain")
require "stategraphs/SGcatcoon"

local assets =
{
	Asset("ANIM", "anim/pog_basic.zip"),
	Asset("ANIM", "anim/pog_actions.zip"),
	Asset("ANIM", "anim/pog_feral_build.zip"),
	--Asset("SOUND", "sound/catcoon.fsb"),
}

local prefabs =
{

}

local POG_ATTACK_RANGE = 3
local POG_MELEE_RANGE = 2.5
local POG_TARGET_DIST = 25
local POG_WALK_SPEED = 2
local POG_RUN_SPEED = 4.5
local POG_DAMAGE = 25
local POG_HEALTH = 150
local POG_ATTACK_PERIOD = 2

local MIN_POGNAP_INTERVAL = 30
local MAX_POGNAP_INTERVAL = 120
local MIN_POGNAP_LENGTH = 20
local MAX_POGNAP_LENGTH = 40

local POG_LOYALTY_MAXTIME = 480
local POG_LOYALTY_PER_ITEM = 480 * .1
local POG_EAT_DELAY = 0.5
local POG_SEE_FOOD = 30

SetSharedLootTable('pog',
	{
		{ 'smallmeat', 1.00 },
	})

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function OnAttacked(inst, data)
	local attacker = data.attacker
	inst:ClearBufferedAction()

	if inst.components.combat and not inst.components.combat.target then
		--	inst.sg:GoToState("hiss")
	end
	if inst.components.combat then
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("pog") end,
			MAX_TARGET_SHARES)
	end
end

local function KeepTargetFn(inst, target)
	if target:HasTag("pog") then
		return (target
			and target.components.combat
			and target.components.health
			and not target.components.health:IsDead()
			and not (inst.components.follower and target.components.follower and inst.components.follower.leader ~= nil and inst.components.follower.leader == target.components.follower.leader)
			and not (inst.components.follower and inst.components.follower.leader == target))
	else
		return (target
			and target.components.combat
			and target.components.health
			and not target.components.health:IsDead()
			and not (inst.components.follower and inst.components.follower.leader == target))
	end
end

local function RetargetFn(inst)
	return FindEntity(inst, POG_TARGET_DIST,
		function(guy)
			return ((guy:HasTag("monster") or guy:HasTag("smallcreature")) and
					not guy:HasTag("pog") and
					guy.components.health and
					not guy.components.health:IsDead() and
					inst.components.combat:CanTarget(guy) and
					not (inst.components.follower and inst.components.follower.leader ~= nil and guy:HasTag("abigail"))) and
				not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and inst.components.follower.leader == guy.components.follower.leader) and
				not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and guy.components.follower.leader and guy.components.follower.leader.components.inventoryitem and guy.components.follower.leader.components.inventoryitem.owner and inst.components.follower.leader == guy.components.follower.leader.components.inventoryitem.owner)
		end)
end

local function SleepTest(inst)
	if inst.components.follower and inst.components.follower.leader then return end
	if inst.components.combat and inst.components.combat.target then return end
	if inst.components.playerprox:IsPlayerClose() then return end
	if not inst.sg:HasStateTag("busy") and (not inst.last_wake_time or GetTime() - inst.last_wake_time >= inst.nap_interval) then
		inst.nap_length = math.random(MIN_POGNAP_LENGTH, MAX_POGNAP_LENGTH)
		inst.last_sleep_time = GetTime()
		return true
	end
end

local function WakeTest(inst)
	if not inst.last_sleep_time or GetTime() - inst.last_sleep_time >= inst.nap_length then
		inst.nap_interval = math.random(MIN_POGNAP_INTERVAL, MAX_POGNAP_INTERVAL)
		inst.last_wake_time = GetTime()
		return true
	end
end


local function ShouldAcceptItem(inst, item)
	if inst.components.health and inst.components.health:IsDead() then return false end

	if item.components.edible and (
			item.components.edible.foodtype == "MEAT" or
			item.components.edible.foodtype == "VEGGIE" or
			item.components.edible.foodtype == "SEEDS" or
			item.components.edible.foodtype == "INSECT" or
			item.components.edible.foodtype == "GENERIC") then
		return true
	end

	return false
end

local function OnGetItemFromPlayer(inst, giver, item)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	else
		if inst.components.combat.target and inst.components.combat.target == giver then
			inst.components.combat:SetTarget(nil)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")
		elseif giver.components.leader then
			inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
			giver.components.leader:AddFollower(inst)
			inst.components.follower:AddLoyaltyTime(POG_LOYALTY_PER_ITEM)
		end
	end
end

local function OnRefuseItem(inst, giver, item)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	elseif not inst.sg:HasStateTag("busy") then
		inst:FacePoint(giver.Transform:GetWorldPosition())
		inst.sg:GoToState("refuse")
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(2, 0.75)
	trans:SetFourFaced()
	inst.entity:AddNetwork()

	MakeCharacterPhysics(inst, 1, 0.5)
	--	MakePoisonableCharacter(inst)

	anim:SetBank("pog")
	anim:SetBuild("pog_actions")
	anim:PlayAnimation("idle_loop")

	inst:AddTag("smallcreature")
	inst:AddTag("animal")
	inst:AddTag("pog")
	inst:AddTag("scarytoprey")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(POG_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(POG_DAMAGE)
	inst.components.combat:SetRange(POG_ATTACK_RANGE)
	inst.components.combat:SetAttackPeriod(POG_ATTACK_PERIOD)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat:SetRetargetFunction(3, RetargetFn)
	inst.components.combat:SetHurtSound("dontstarve_DLC003/creatures/pog/hit")
	inst:ListenForEvent("attacked", OnAttacked)
	inst.components.combat.battlecryinterval = 20

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('pog')

	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = POG_LOYALTY_MAXTIME

	inst:AddComponent("eater")
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater.strongstomach = true -- can eat monster meat!

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4, 6)
	inst.components.playerprox:SetOnPlayerNear(function(inst)
		inst:AddTag("can_beg")
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end)
	inst.components.playerprox:SetOnPlayerFar(function(inst)
		inst:RemoveTag("can_beg")
	end)

	inst:AddComponent("sleeper")
	--inst.components.sleeper:SetResistance(3)
	inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	inst.last_sleep_time = nil
	inst.last_wake_time = GetTime()
	inst.nap_interval = math.random(MIN_POGNAP_INTERVAL, MAX_POGNAP_INTERVAL)
	inst.nap_length = math.random(MIN_POGNAP_LENGTH, MAX_POGNAP_LENGTH)
	inst.components.sleeper:SetWakeTest(WakeTest)
	inst.components.sleeper:SetSleepTest(SleepTest)

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = POG_WALK_SPEED
	inst.components.locomotor.runspeed = POG_RUN_SPEED

	-- boat hopping setup
	inst.components.locomotor:SetAllowPlatformHopping(true)
	inst:AddComponent("embarker")

	inst:AddComponent("knownlocations")
	inst:AddComponent("herdmember")

	MakeSmallBurnableCharacter(inst, "pog_chest", Vector3(1, 0, 1))
	MakeSmallFreezableCharacter(inst)

	--[[
	inst.special_action = function (act)
        inst.sg:GoToState("desk_pre")
    end
]]


	inst:WatchWorldState("startaporkalypse", function() inst.AnimState:SetBuild("pog_feral_build") end, TheWorld)
	inst:WatchWorldState("stopaporkalypse", function() inst.AnimState:SetBuild("pog_basic") end, TheWorld)
	inst:DoTaskInTime(0.2,
		function(inst)
			if TheWorld.state.isaporkalypse then
				inst.AnimState:SetBuild("pog_feral_build")
			else
				inst.AnimState:SetBuild("pog_basic")
			end
		end)

	local brain = require("brains/pogbrain")
	inst:SetBrain(brain)
	inst:SetStateGraph("SGpog")

	return inst
end

return Prefab("creatures/pog", fn, assets, prefabs)
