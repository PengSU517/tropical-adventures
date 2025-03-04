local assets =
{
	Asset("ANIM", "anim/seacucumber.zip"),
}

local prefabs =
{
	"seacucumber",
}


local function onpickedfn(inst)
	inst.AnimState:PlayAnimation("picking")
	inst.AnimState:PushAnimation("picked", true)
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle_plant", true)
	--inst.entity:Show()
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("picking")
	inst.AnimState:PushAnimation("picked", true)
	--inst.entity:Hide()
end

local function makebarrenfn(inst)
	inst.AnimState:PlayAnimation("picking")
	inst.AnimState:PushAnimation("picked", true)
	--inst.entity:Hide()
end

local function makefullfn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle_plant", true)
	--inst.entity:Show()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddNetwork()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("plant")

	inst.AnimState:SetLayer(LAYER_BACKGROUND)

	inst.AnimState:SetBank("seacucumber")
	inst.AnimState:SetBuild("seacucumber")
	inst.AnimState:PlayAnimation("idle_plant", true)
	inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
	inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")
	--	inst.AnimState:PlayAnimation("idle_plant", true)
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
	inst.components.pickable:SetUp("seacucumber", TUNING.SAPLING_REGROW_TIME)
	inst.components.pickable:SetOnPickedFn(onpickedfn)
	inst.components.pickable:SetOnRegenFn(onregenfn)
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.quickpick = false


	return inst
end

local function fn1(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeSmallPropagator(inst)
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seacucumber")
	inst.AnimState:SetBuild("seacucumber")
	inst.AnimState:PlayAnimation("idle")

	if not TheWorld.ismastersim then
		return inst
	end

	inst.entity:SetPristine()

	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")



	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "seacucumber_cooked"

	inst:AddComponent("tradable")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn2(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeSmallPropagator(inst)
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("seacucumber")
	inst.AnimState:SetBuild("seacucumber")
	inst.AnimState:PlayAnimation("cooked")
	MakeInventoryFloatable(inst)

	if not TheWorld.ismastersim then
		return inst
	end

	inst.entity:SetPristine()

	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")



	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("tradable")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end
return Prefab("common/inventory/seacucumber_planted", fn, assets),
	Prefab("seacucumber_cooked", fn2, assets),
	Prefab("seacucumber", fn1, assets, prefabs)
