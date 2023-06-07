local assets =
{
    Asset("ANIM", "anim/goddess_sword.zip"),
	Asset("ANIM", "anim/swap_goddess_sword.zip"),
	Asset("IMAGE", "images/inventoryimages/goddess_sword.tex"),
	Asset("ATLAS", "images/inventoryimages/goddess_sword.xml"),
}

local WAKE_TO_FOLLOW_DISTANCE = 10
local SLEEP_NEAR_LEADER_DISTANCE = 5

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_goddess_sword", "swap_goddess_sword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	
	if owner:HasTag("windy2") and owner:HasTag("windy1") then
		owner.components.leader:AddFollower(inst) 
	end
end

local function onunequip(inst, owner)
	inst.components.equippable.walkspeedmult = 0.5
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) and not TheWorld.state.isfullmoon
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local finiteuses =  inst.components.finiteuses:GetPercent()
	if giver:HasTag("windy1") and giver:HasTag("windy2") then
		inst.components.finiteuses:SetPercent(1)
	else
		inst.components.finiteuses:SetPercent(finiteuses + 0.10)
	end
	if finiteuses >= 1 then
		inst.components.finiteuses:SetPercent(1)
	end
end

local function sleep (inst)
	inst.sg:GoToState("sleep")
end

local function wake (inst)
	inst.sg:GoToState("wake")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()

	MakeCharacterPhysics(inst, 1, .5)
	
	local s = 2.3
	inst.Transform:SetScale(s,s + 0.5,s)

	inst.AnimState:SetBuild("goddess_sword")
	inst.AnimState:SetBank("goddess_sword")
	inst.AnimState:PlayAnimation("idle", true)

	inst.DynamicShadow:Enable(true)

	inst.DynamicShadow:SetSize(.8, .5)

	inst.entity:SetPristine()
	
	inst:AddTag("goddess_item")

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = 2
	
	inst:AddComponent("follower")
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(100)
	inst.components.finiteuses:SetUses(100)
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
	inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(100)
	inst.components.combat:SetRange(3, 4)
	inst.components.combat:SetAttackPeriod(2, 3)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
	inst:AddComponent("sleeper")
	inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	
	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.CHOP, 4)
	inst.components.tool:SetAction(ACTIONS.MINE, 4)
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_sword.xml"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 0.5
	
	--inst:WatchWorldState("isnight", sleep)
	--inst:WatchWorldState("isday", wake)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(100)		
	inst.components.weapon:SetRange(2.5,2.5)

	inst:SetStateGraph("SGsword")
	local brain = require("brains/swordbrain")
	inst:SetBrain(brain)

	return inst
end

return Prefab("goddess_sword", fn, assets)