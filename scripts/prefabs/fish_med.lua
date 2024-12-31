local dogfish_assets =
{
	Asset("ANIM", "anim/fish_dogfish.zip"),
}

local swordfish_assets =
{
	Asset("ANIM", "anim/fish_swordfish.zip"),
}

local spoiledfish_large_assets =
{
	Asset("ANIM", "anim/spoiled_fish_large.zip")
}

local lobster_assets =
{
	Asset("ANIM", "anim/lobster_build_color.zip"),
	Asset("ANIM", "anim/lobster.zip"),
}

local quagmire_crabmeat_assets =
{
	Asset("ANIM", "anim/quagmire_crabmeat.zip"),
}

local prefabs =
{
	"fishmeat_cooked",
	"spoiled_fish",
	"spoiled_fish_large",
}

local spoiled_fish_large_prefabs =
{
	"boneshard",
	"spoiled_food",
}

SetSharedLootTable('spoiled_fish_large_loot', {
    { 'boneshard', 1.0 },
    { 'boneshard', 1.0 },
    { 'spoiled_food', 0.5 },
})

local function stopkicking(inst)
	inst.AnimState:PlayAnimation("dead")
  end

local function makefish_med(bank, build)
	local function commonfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		inst.entity:AddAnimState()

		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation("dead")
		inst.build = build --This is used within SGwilson, sent from an event in fishingrod.lua

		MakeInventoryPhysics(inst)
	    MakeInventoryFloatable(inst)

		inst:AddTag("catfood")
	    inst:AddTag("fishmeat")
		inst:AddTag("meat")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("edible")
		inst.components.edible.ismeat = true
		inst.components.edible.foodtype = FOODTYPE.MEAT

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_fish_large"

		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
		--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
		inst.data = {}

		inst:AddComponent("cookable")
		inst.components.cookable.product = "fishmeat_cooked"

		inst:AddComponent("dryable")
		inst.components.dryable:SetProduct("meat_dried")
		inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	return commonfn
end

local function quagmire_crabmeat_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("quagmire_crabmeat")
	inst.AnimState:SetBuild("quagmire_crabmeat")
	inst.AnimState:PlayAnimation("idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst:AddTag("catfood")
	inst:AddTag("packimfood")
	inst:AddTag("meat")

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("edible")
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
	inst.data = {}

	inst:AddComponent("cookable")
	inst.components.cookable.product = "quagmire_crabmeat_cooked"

	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("smallmeat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

	inst:AddComponent("bait")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function quagmire_crabmeat_cooked_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("quagmire_crabmeat")
	inst.AnimState:SetBuild("quagmire_crabmeat")
	inst.AnimState:PlayAnimation("cooked", true)

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst:AddTag("meat")
	inst:AddTag("catfood")
	inst:AddTag("packimfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("edible")
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.foodstate = "COOKED"
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
	inst.data = {}

	inst:AddComponent("bait")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function lobster_dead_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lobster")
	inst.AnimState:SetBuild("lobster_build_color")
	inst.AnimState:PlayAnimation("idle_dead")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst:AddTag("meat")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("packimfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("edible")
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "lobster_dead_cooked"

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function lobster_dead_cooked_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lobster")
	inst.AnimState:SetBuild("lobster_build_color")
	inst.AnimState:PlayAnimation("idle_cooked")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst:AddTag("meat")
    inst:AddTag("fishmeat")
    inst:AddTag("catfood")
    inst:AddTag("packimfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("edible")
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.foodstate = "COOKED"
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local function large_fish_onhit(inst, worker, workleft, workdone)
	local num_loots = math.floor(math.clamp(workdone / TUNING.SPOILED_FISH_WORK_REQUIRED, 1, TUNING.SPOILED_FISH_LOOT.WORK_MAX_SPAWNS))
	num_loots = math.min(num_loots, inst.components.stackable:StackSize())

	if inst.components.stackable:StackSize() > num_loots then
		--inst.AnimState:PlayAnimation("hit")
		--inst.AnimState:PushAnimation("idle", false)

		if num_loots == TUNING.SPOILED_FISH_LOOT.WORK_MAX_SPAWNS then
			LaunchAt(inst, inst, worker, TUNING.SPOILED_FISH_LOOT.LAUNCH_SPEED, TUNING.SPOILED_FISH_LOOT.LAUNCH_HEIGHT, nil, TUNING.SPOILED_FISH_LOOT.LAUNCH_ANGLE)
		end
	end

	for _ = 1, num_loots do
		inst.components.lootdropper:DropLoot()
	end

	local top_stack_item = inst.components.stackable:Get(num_loots)
	top_stack_item.Transform:SetPosition(inst:GetPosition():Get())
    SpawnPrefab("collapse_small").Transform:SetPosition(top_stack_item.Transform:GetWorldPosition())
    top_stack_item.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	top_stack_item:Remove()
end

local function fish_stack_size_changed(inst, data)
    if data ~= nil and data.stacksize ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(data.stacksize * TUNING.SPOILED_FISH_WORK_REQUIRED)
    end
end

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function spoiledfn(common_init, mastersim_init, nutrients)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("spoiled")
    inst.AnimState:SetBuild("spoiled_food")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", .04, 0.73)
    MakeDeployableFertilizerPristine(inst)

    inst:AddTag("icebox_valid")
	inst:AddTag("saltbox_valid")
    inst:AddTag("show_spoiled")
    inst:AddTag("fertilizerresearchable")

	if common_init ~= nil then
		common_init(inst)
	end

    inst.GetFertilizerKey = GetFertilizerKey

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.SPOILEDFOOD_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(nutrients)

    inst:AddComponent("smotherer")

    inst:AddComponent("fertilizerresearchable")
    inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

    inst:AddComponent("selfstacker")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.SPOILED_HEALTH
    inst.components.edible.hungervalue = TUNING.SPOILED_HUNGER

    inst:AddComponent("tradable")

	if mastersim_init ~= nil then
		mastersim_init(inst)
	end

    MakeDeployableFertilizer(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function fish_large_init(inst)
    inst.AnimState:SetBank("spoiled_fish_large")
    inst.AnimState:SetBuild("spoiled_fish_large")
    inst:AddTag("spoiled_fish")

    inst.components.floater:SetScale(0.6)

    inst.Transform:SetScale(1.3, 1.3, 1.3)
end

local function fish_large_mastersim_init(inst)
	inst.components.inspectable.nameoverride = "spoiled_fish"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("spoiled_fish_large_loot")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(inst.components.stackable.stacksize * TUNING.SPOILED_FISH_WORK_REQUIRED)
    inst.components.workable:SetOnWorkCallback(large_fish_onhit)

	inst:ListenForEvent("stacksizechange", fish_stack_size_changed)
end

local rawdogfish = makefish_med("dogfish", "fish_dogfish")
local rawswordfish = makefish_med("swordfish", "fish_swordfish")

return Prefab("dogfish_dead", rawdogfish, dogfish_assets, prefabs),
	Prefab("swordfish_dead", rawswordfish, swordfish_assets, prefabs),
	Prefab("spoiled_fish_large", function() return spoiledfn(fish_large_init, fish_large_mastersim_init, FERTILIZER_DEFS.spoiled_fish_large.nutrients) end, spoiledfish_large_assets, spoiled_fish_large_prefabs),
	--Prefab("quagmire_crabmeat", quagmire_crabmeat_fn, quagmire_crabmeat_assets),
	--Prefab("quagmire_crabmeat_cooked", quagmire_crabmeat_cooked_fn, quagmire_crabmeat_assets),
	Prefab("lobster_dead", lobster_dead_fn, lobster_assets),
	Prefab("lobster_dead_cooked", lobster_dead_cooked_fn, lobster_assets)
