local assets =
{
    Asset("ANIM", "anim/cutnettle.zip"),
    Asset("INV_IMAGE", "cutnettle"),
}

local WRATH_SMALL = -8

local function oneat(inst, eater)
    if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
        eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 4000
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("cutnettle")
    inst.AnimState:SetBuild("cutnettle")

    inst.AnimState:PlayAnimation("idle")


    inst:AddTag("cattoy")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible:SetOnEatenFn(oneat)

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    --    inst:AddComponent("appeasement")
    --    inst.components.appeasement.appeasementvalue = WRATH_SMALL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    --inst.components.burnable:MakeDragonflyBait(3)

    inst:AddComponent("inventoryitem")



    return inst
end

return Prefab("common/inventory/cutnettle", fn, assets)
