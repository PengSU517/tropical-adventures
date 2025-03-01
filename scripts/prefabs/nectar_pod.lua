local assets = { Asset("ANIM", "anim/nectar_pod.zip") }

local prefabs = { "spoiled_food" }

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBuild("nectar_pod")
    inst.AnimState:SetBank("nectar_pod")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nectar")
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"


    inst:AddComponent("inventoryitem")


    return inst
end

return Prefab("common/inventory/nectar_pod", fn, assets, prefabs)
