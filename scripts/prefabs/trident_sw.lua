local assets =
{
    Asset("ANIM", "anim/trident_sw.zip"),
    Asset("ANIM", "anim/swap_trident_sw.zip"),
    --Asset("INV_IMAGE", "trident_sw"),
}

local prefabs =
{
    --"crab_king_waterspout",
}

local TRIDENT_SW_DAMAGE = TUNING.SPEAR_DAMAGE
local TRIDENT_SW_OCEAN_DAMAGE = TUNING.SPEAR_DAMAGE * 3

local function trident_damage_calculation(inst, attacker, target)
    local is_over_ground = TheWorld.Map:IsVisualGroundAtPoint(attacker:GetPosition():Get())
    return (is_over_ground and TRIDENT_SW_DAMAGE) or TRIDENT_SW_OCEAN_DAMAGE
end

local function on_uses_finished(inst)
    if inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
    end

    inst:Remove()
end

local function onfinished(inst)
    inst:Remove()
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_trident_sw", "swap_trident_sw")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local FLOATER_SWAP_DATA = { sym_build = "swap_trident_sw" }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("pointy")
    inst:AddTag("sharp")
    inst:AddTag("weapon")

    inst.AnimState:SetBank("trident_sw")
    inst.AnimState:SetBuild("trident_sw")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, { 1.1, 0.5, 1.1 }, true, -9, FLOATER_SWAP_DATA)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --inst.scrapbook_weapondamage = { TRIDENT_SW.DAMAGE, TRIDENT_SW.OCEAN_DAMAGE }

    -------

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(trident_damage_calculation)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(on_uses_finished)

    -------

    inst:AddComponent("inspectable")

    -- -------

    inst:AddComponent("inventoryitem")
    -- -------

    inst:AddComponent("tradable")

    -------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    -------

    -- inst.DoWaterExplosionEffect = trident.DoWaterExplosionEffect

    -- inst:AddComponent("spellcaster")
    -- inst.components.spellcaster:SetSpellFn(trident.components.spellcaster.spell)
    -- inst.components.spellcaster.canuseonpoint_water = true

    -------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("trident_sw", fn, assets)
