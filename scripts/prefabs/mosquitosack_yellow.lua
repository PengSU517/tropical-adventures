local assets =
{
    Asset("ANIM", "anim/bladder_yellow.zip"),
}

local function poisonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bladder")
    inst.AnimState:SetBuild("bladder_yellow")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.05)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    ---------------------       

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.VITAE
    inst.components.repairer.perishrepairpercent = 1

    inst:AddComponent("fillable")
    inst.components.fillable.filledprefab = "waterballoon"

    inst:AddComponent("healer")
    inst.components.healer:SetHealthAmount(TUNING.HEALING_MED)

    inst:AddComponent("fuel")
	inst.components.fuel.fueltype = FUELTYPE.BLOOD
	inst.components.fuel.fuelvalue = TUNING.TOTAL_DAY_TIME

    return inst
end

return Prefab("mosquitosack_yellow", poisonfn, assets)