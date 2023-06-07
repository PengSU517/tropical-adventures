local assets =
{
	Asset("IMAGE", "images/inventoryimages/goddess_butterflywings.tex"),
	Asset("ATLAS", "images/inventoryimages/goddess_butterflywings.xml"),
	Asset("ANIM", "anim/goddess_butterfly_wings.zip"),
}

local prefabs =
{
    "spoiled_food",
}

	local meat = {"goddess_butterflywings"}
	AddIngredientValues(meat, {meat=0.5}, true)

	local function IsCookingIngredient(goddess_butterflywings)
	local name = "goddess_butterflywings"
	if ingredients[name] then
		return true
	end

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBuild("goddess_butterfly_wings")
    inst.AnimState:SetBank("butterfly_wings")
    inst.AnimState:PlayAnimation("idle", false)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("goddess_butterflywings")
	inst:AddTag("cattoy")
	
    inst:AddComponent("edible")
    inst.components.edible.hungervalue = 10
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.healthvalue = 15

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_butterflywings.xml"
	
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("goddess_butterflywings", fn, assets, prefabs)