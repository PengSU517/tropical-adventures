local assets =
{
    Asset("ANIM", "anim/walkingstick.zip"),
    Asset("ANIM", "anim/swap_walkingstick.zip"),
    --Asset("INV_IMAGE", "cane"),
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_walkingstick", "swap_walkingstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function OnEquipToModel(inst, owner)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    OnEquipToModel(inst, owner)
end

--local floatable_swap_data = {sym_build = "walkingstick", sym_name = "swap_walkingstick"}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", .05, { 1.2, .75, 1.2 })

    inst.AnimState:SetBuild("walkingstick")
    inst.AnimState:SetBankAndPlayAnimation("walkingstick", "idle")

    --MakeInventoryFloatable(inst, "med", .05, {0.95, .40, .95}, true, 1, floatable_swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -5, { sym_build = "swap_walkingstick" })

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20.4)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
    inst.components.equippable.walkspeedmult = 1.3

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.DAY_TIME_DEFAULT * 3)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/walkingstick", fn, assets)
