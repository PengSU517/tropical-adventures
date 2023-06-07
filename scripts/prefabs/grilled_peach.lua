local assets =
{
	Asset("IMAGE", "images/inventoryimages/grilled_peach.tex"),
	Asset("ATLAS", "images/inventoryimages/grilled_peach.xml"),
	Asset("ANIM", "anim/grilled_peach.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBuild("grilled_peach")
    inst.AnimState:SetBank("grilled_peach")
    inst.AnimState:PlayAnimation("idle", false)

	local s = 1.3
	inst.Transform:SetScale(s,s,s)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.hungervalue = 18.5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 3

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/grilled_peach.xml"
	
    MakeHauntableLaunchAndPerish(inst)


    return inst
end

return Prefab("grilled_peach", fn, assets, prefabs)