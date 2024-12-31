local assets =
{
    Asset("ANIM", "anim/seaweed.zip"),
}

local prefabs =
{
    "seaweed_planted",
    "seaweed_cooked",
    "seaweed_dried",
}

local perish_warp = 1 --/200
local calories_per_day = 75
local HEALING_TINY = 1
local HEALING_SMALL = 3
local STACK_SIZE_SMALLITEM = 40
local CALORIES_TINY = calories_per_day / 8
local CALORIES_SMALL = calories_per_day / 6
local SANITY_SMALL = 10
local PERISH_FAST = 6 * 480 * perish_warp
local PERISH_MED = 10 * 480 * perish_warp
local PERISH_PRESERVED = 20 * 480 * perish_warp
local DRY_FAST = 480
local POOP_FERTILIZE = 300
local POOP_SOILCYCLES = 10
local POOP_WITHEREDCYCLES = 1

local function commonfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("seaweed")
    inst.AnimState:SetBuild("seaweed")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("bait")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"

    inst:AddComponent("perishable")
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function defaultfn(sim)
    local inst = commonfn()
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = HEALING_TINY
    inst.components.edible.hungervalue = CALORIES_TINY
    inst.components.edible.sanityvalue = -SANITY_SMALL

    inst.components.perishable:SetPerishTime(PERISH_FAST)

    inst:AddComponent("cookable")
    inst.components.cookable.product = "seaweed_cooked"

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("seaweed_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_SUPERFAST)

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = POOP_FERTILIZE
    inst.components.fertilizer.soil_cycles = POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = POOP_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(TUNING.FERTILIZER_NUTRIENTS, 1, 5)

    return inst
end

local function cookedfn(sim)
    local inst = commonfn()
    inst.AnimState:PlayAnimation("cooked", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = HEALING_SMALL
    inst.components.edible.hungervalue = CALORIES_TINY
    inst.components.edible.sanityvalue = 0 --TUNING.SANITY_SMALL

    inst.components.perishable:SetPerishTime(PERISH_MED)

    return inst
end

local function driedfn(sim)
    local inst = commonfn()

    inst.AnimState:SetBank("meat_rack_food")
    inst.AnimState:SetBuild("meat_rack_food_tro")
    inst.AnimState:PlayAnimation("idle_dried_seaweed", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.foodstate = "DRIED"
    inst.components.edible.healthvalue = HEALING_SMALL
    inst.components.edible.hungervalue = CALORIES_SMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_SMALL

    inst.components.perishable:SetPerishTime(PERISH_PRESERVED)

    return inst
end

return Prefab("seaweed", defaultfn, assets, prefabs),
    Prefab("seaweed_cooked", cookedfn, assets),
    Prefab("seaweed_dried", driedfn, assets)