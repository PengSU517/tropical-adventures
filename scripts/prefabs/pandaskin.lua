local assets =
{
    Asset("ANIM", "anim/panskin.zip"),
    Asset("ANIM", "anim/pigskin.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pigskin")
    inst.AnimState:SetBuild("panskin")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT


    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE

    return inst
end

return Prefab("pandaskin", fn, assets)
