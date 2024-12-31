local assets =
{
    Asset("ANIM", "anim/shark_tooth.zip"),
}

local function on_float(inst)
    inst.AnimState:PlayAnimation("idle_water")
end

local function on_not_float(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.15, 0.8)

    inst.Transform:SetScale(0.8,0.8,0.8)

    inst.AnimState:SetBank("sharktooth")
    inst.AnimState:SetBuild("shark_tooth")
    inst.AnimState:PlayAnimation("idle")

    inst.pickupsound = "rock"

    --selfstacker (from selfstacker component) added to pristine state for optimization
    inst:AddTag("selfstacker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("selfstacker")

    inst:ListenForEvent("floater_startfloating", on_float)
    inst:ListenForEvent("floater_stopfloating", on_not_float)

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("shark_tooth", fn, assets)