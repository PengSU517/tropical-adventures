local assets =
{
    Asset("ANIM", "anim/walkingstick.zip"),
    Asset("ANIM", "anim/swap_walkingstick.zip"),
    --Asset("INV_IMAGE", "cane"),
}

local function onfinished(inst)
    inst:Remove()
end

local function OnEquipToModel(inst, owner, from_ground)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_walkingstick", "swap_walkingstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    OnEquipToModel(inst)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function onwornout(inst)
    inst:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.05, { 1.2, 0.75, 1.2 })
    anim:SetBank("walkingstick")
    anim:SetBuild("walkingstick")
    anim:PlayAnimation("idle")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -5, { sym_build = "swap_walkingstick" })

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20.4)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"


    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
    inst.components.equippable.walkspeedmult = 1.3

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(480 * 3)
    inst.components.fueled:SetDepletedFn(onwornout)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end


return Prefab("common/inventory/walkingstick", fn, assets)
