local assets =
{
    Asset("ANIM", "anim/cutgreengrass.zip"),
	Asset("ATLAS", "images/inventoryimages/cutgreengrass.xml"),
	Asset("IMAGE", "images/inventoryimages/cutgreengrass.tex"),
	
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cutgrass")
    inst.AnimState:SetBuild("cutgreengrass")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")
    MakeDragonflyBait(inst, 3)
	MakeInventoryFloatable(inst)	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cutgreengrass.xml"
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ROUGHAGE
    inst.components.edible.woodiness = 1
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("cutgreengrass", fn, assets)
