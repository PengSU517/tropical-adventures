local assets =
{
    Asset("ANIM", "anim/coconut.zip"),
}

local prefabs = {}

local function plant(inst, growtime)
    local sampling = SpawnPrefab("coconut_sapling")
    sampling:StartGrowing()
    sampling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sampling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst:Remove()
end

local function ondeploy(inst, pt)
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get())
    local timeToGrow = GetRandomWithVariance(TUNING.ACORN_GROWTIME.base, TUNING.ACORN_GROWTIME.random)
    plant(inst, timeToGrow)
end

local function common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("coconut")
    inst.AnimState:SetBuild("coconut")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"


    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.RAW

    return inst
end

local function onhacked(inst)
    local nut = inst
    if inst.components.inventoryitem then
        local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then
            nut = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end
        inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
        inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
    end

    nut:Remove()
end

local function raw()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("coconut")
    inst.AnimState:SetBuild("coconut")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")
    inst:AddTag("deployedplant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.getstatus = describe

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.RAW
    --inst:AddComponent("bait")
    inst:AddTag("show_spoilage")
    inst:AddTag("machetecut")
    inst:AddTag("aquatic")

    inst:AddComponent("interactions")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhacked)

    inst:AddComponent("lootdropper")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2

    inst:AddComponent("inventoryitem")

    return inst
end

local function cooked()
    local inst = common()

    inst.AnimState:PlayAnimation("cook")
    -- MakeInventoryFloatable(inst, "cooked_water", "cook")
    inst:AddTag("aquatic")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    return inst
end

local function halved()
    local inst = common()

    inst.AnimState:PlayAnimation("chopped")

    inst:AddTag("cookable")
    inst:AddTag("aquatic")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "coconut_cooked"

    inst:AddComponent("inventoryitem")

    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    return inst
end

return Prefab("coconut", raw, assets, prefabs),
    Prefab("coconut_cooked", cooked, assets, prefabs),
    Prefab("coconut_halved", halved, assets, prefabs),
    MakePlacer("coconut_placer", "coconut", "coconut", "planted")
