local assets =
{
	Asset("ANIM", "anim/blubber.zip"),
}

local APPEASEMENT_SMALL = 8


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.AnimState:SetBank("blubber")
	inst.AnimState:SetBuild("blubber")
	inst.AnimState:PlayAnimation("idle")

	MakeInventoryPhysics(inst)
	--	MakeInventoryFloatable(inst, "idle_water", "idle")
	--    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

	MakeInventoryFloatable(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	inst:AddComponent("inspectable")

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	inst:AddComponent("waterproofer")
	inst.components.waterproofer.effectiveness = 0
	inst:AddComponent("inventoryitem")

	inst:AddComponent("tradable")
	--    inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"




	return inst
end

return Prefab("common/inventory/blubber", fn, assets)
