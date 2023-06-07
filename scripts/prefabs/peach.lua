local assets =
{
	Asset("IMAGE", "images/inventoryimages/peach.tex"),
	Asset("ATLAS", "images/inventoryimages/peach.xml"),
	Asset("ANIM", "anim/peach.zip"),
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

    inst.AnimState:SetBuild("peach")
    inst.AnimState:SetBank("peach")
    inst.AnimState:PlayAnimation("idle", false)

	local s = 0.70
	inst.Transform:SetScale(s,s,s)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.hungervalue = 12.5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 1

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "grilled_peach"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "peach_pit"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach.xml"
	
	inst:AddComponent("bait")
	
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("peach", fn, assets, prefabs)