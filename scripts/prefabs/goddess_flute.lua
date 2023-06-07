local assets =
{
    Asset("ANIM", "anim/goddess_flute.zip"),
	Asset("ANIM", "anim/greentornado.zip"),
}

local prefabs =
{
    "greentornado",
}

local function HearPanFlute(inst, musician, instrument)	
	if musician:HasTag("windy1") and musician:HasTag("windy2") then
		SpawnPrefab("greentornado").Transform:SetPosition(inst.Transform:GetWorldPosition())
	else
		SpawnPrefab("greentornado1").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local finiteuses =  inst.components.finiteuses:GetPercent()
	if giver:HasTag("windy1") and giver:HasTag("windy2") then
		inst.components.finiteuses:SetPercent(finiteuses + 0.40)
	else
		inst.components.finiteuses:SetPercent(finiteuses + 0.10)
	end
	if finiteuses >= 1 then
		inst.components.finiteuses:SetPercent(1)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst:AddTag("goddess_flute")

    inst.AnimState:SetBank("pan_flute")
    inst.AnimState:SetBuild("goddess_flute")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
    inst.components.instrument:SetOnHeardFn(HearPanFlute)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_flute.xml"

    MakeHauntableLaunch(inst)
    AddHauntableCustomReaction(inst, function(inst, haunter)
        if math.random() <= TUNING.HAUNT_CHANCE_HALF then
            if inst.components.finiteuses then
                inst.components.finiteuses:Use(1)
                inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
                return true
            end
        end
        return false
    end, true, false, true)

    return inst
end

local brain = require("brains/greentornadobrain")

local function ontornadolifetime(inst)
    inst.sg:GoToState("despawn")
end

local function tornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = 1.20
	inst.Transform:SetScale(s,s + 0.2,s)

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("greento")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(TUNING.TORNADO_LIFETIME * 4, ontornadolifetime)

    inst:AddComponent("knownlocations")
	
	inst:AddComponent("follower")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SGgreentornado")
    inst:SetBrain(brain)

	inst:DoPeriodicTask(0.15, function(inst)
        SpawnPrefab("green_leaves_chop").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
	
    inst.WINDSTAFF_CASTER = nil
    inst.persists = false

    return inst
end

local function tornado1_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("tornado")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(TUNING.TORNADO_LIFETIME, ontornadolifetime)

    inst:AddComponent("knownlocations")
	
	inst:AddComponent("follower")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SGtornado")
    inst:SetBrain(brain)
	
    inst.WINDSTAFF_CASTER = nil
    inst.persists = false

    return inst
end

local function onkillfx(inst, anim)

end

local function KillFX(inst)

end

local function TriggerFX(inst)

end

local function tornado2_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = 1.20
	inst.Transform:SetScale(s,s + 0.2,s)

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("greento")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("greentornado2")
	
    inst:DoTaskInTime(TUNING.TORNADO_LIFETIME * 4, ontornadolifetime)

    inst:AddComponent("knownlocations")
	
	inst:AddComponent("follower")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SGgreentornado1")
    inst:SetBrain(brain)

	inst:DoPeriodicTask(0.15, function(inst)
        SpawnPrefab("green_leaves_chop").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
	
    inst.WINDSTAFF_CASTER = nil
    inst.persists = false
	
	inst.KillFX = KillFX
    inst.OnKillFX = onkillfx
	inst.TriggerFX = TriggerFX


    return inst
end

return Prefab("goddess_flute", fn, assets, prefabs),
    Prefab("greentornado", tornado_fn, assets),
	Prefab("greentornado1", tornado1_fn, assets),
	Prefab("greentornado2", tornado2_fn, assets)