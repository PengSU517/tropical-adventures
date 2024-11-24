local assets = {Asset("ANIM", "anim/lotus.zip"), Asset("SOUND", "sound/common.fsb")}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    inst.entity:AddNetwork()

    anim:SetBank("lotus")
    anim:SetBuild("lotus")

    inst:AddTag("cattoy")
    inst:AddTag("billfood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.foodtype = "VEGGIE"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("bait")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("tradable")

    return inst
end

local function raw()
    local inst = fn()
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then return inst end

    inst.components.edible.sanityvalue = TUNING.SANITY_TINY or 0
    inst.components.edible.foodstate = "RAW"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "lotus_flower_cooked"

    return inst
end

local function cooked()
    local inst = fn()
    inst.AnimState:PlayAnimation("cooked")

    if not TheWorld.ismastersim then return inst end

    inst.components.edible.sanityvalue = TUNING.SANITY_MED or 0
    inst.components.edible.foodstate = "COOKED"

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("common/inventory/lotus_flower", raw, assets),
       Prefab("common/inventory/lotus_flower_cooked", cooked, assets)
