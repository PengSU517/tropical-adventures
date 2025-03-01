local assets =
{
    Asset("ANIM", "anim/limestone.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    --    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.HEAVY, TUNING.WINDBLOWN_SCALE_MAX.HEAVY)

    inst.AnimState:SetBank("limestone")
    inst.AnimState:SetBuild("limestone")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("bait")
    inst:AddTag("molebait")

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = "stone"
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_CUTSTONE_HEALTH




    return inst
end

return Prefab("common/inventory/limestone", fn, assets)
