local assets =
{
    Asset("ANIM", "anim/blunderbuss.zip"),
    Asset("ANIM", "anim/swap_blunderbuss.zip"),
    Asset("ANIM", "anim/swap_blunderbuss_loaded.zip"),
    Asset("ANIM", "anim/blunderbuss_ammo.zip"),
}

local BLUNDERBUSS_ATTACK_RANGE = 9
local BLUNDERBUSS_HIT_RANGE = 11

local function onequip(inst, owner, force)
    owner.AnimState:OverrideSymbol("swap_object", inst.override_bank, "swap_blunderbuss")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function CanTakeAmmo(inst, ammo, giver)
    return ammo.prefab == "gunpowder"
end

local function OnTakeAmmo(inst, data)
    local ammo = data and data.item
    if not ammo then return end

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_load")

    inst.components.trader.enabled = false
    --Set up as projectile thrower instead of crummy bat
    inst:AddTag("projectile")
    inst.components.weapon:SetProjectile("gunpowder_projectile")
    inst:AddTag("blunderbuss")
    --Change ranges
    inst.components.weapon:SetRange(BLUNDERBUSS_ATTACK_RANGE, BLUNDERBUSS_HIT_RANGE)
    local damage = TUNING.GUNPOWDER_DAMAGE
    inst.components.weapon:SetDamage(damage)

    inst.override_bank = "swap_blunderbuss_loaded"

    --If equipped, change current equip overrides
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        owner.AnimState:OverrideSymbol("swap_object", inst.override_bank, "swap_blunderbuss")
    end

    --Change invo image.
    inst.components.inventoryitem:ChangeImageName("blunderbuss_loaded")
end

local function OnLoseAmmo(inst, data)
    inst.components.trader.enabled = true
    --Go back to crummy bat mode
    inst:RemoveTag("projectile")
    inst.components.weapon:SetProjectile(nil)
    inst:RemoveTag("blunderbuss")

    --Change ranges back to melee
    inst.components.weapon:SetRange(nil, nil)
    inst.components.weapon:SetDamage(TUNING.UNARMED_DAMAGE)

    --Change equip overrides
    inst.override_bank = "swap_blunderbuss"

    --If equipped, change current equip overrides
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        owner.AnimState:OverrideSymbol("swap_object", inst.override_bank, "swap_blunderbuss")
    end

    inst.components.inventoryitem:ChangeImageName("blunderbuss")
end

local function OnAttack(inst, attacker, target)
    local removed_item = inst.components.inventory:GetItemInSlot(1)
    if removed_item then
        removed_item:Remove()
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", 0.05, { 0.8, 0.4, 0.8 })

    inst.AnimState:SetBank("blunderbuss")
    inst.AnimState:SetBuild("blunderbuss")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("blunderbus")
    inst:AddTag("rangedweapon")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("weapon")
    inst.components.weapon.onattack = OnAttack

    inst:AddComponent("inventoryitem")



    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 1
    inst:ListenForEvent("itemlose", OnLoseAmmo)
    inst:ListenForEvent("itemget", OnTakeAmmo)

    inst:AddComponent("trader")
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader:SetAcceptTest(CanTakeAmmo)
    inst.components.trader.enabled = true
    inst.components.trader.acceptnontradable = true


    inst.override_bank = "swap_blunderbuss"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

local function OnHit(inst, attacker, target, weapon)
    local impactfx = SpawnPrefab("impact")
    if impactfx and attacker then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        impactfx:FacePoint(attacker.Transform:GetWorldPosition())
    end

    inst:Remove()
end

local function projectile_fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    anim:SetBank("amo01")
    anim:SetBuild("blunderbuss_ammo")
    anim:PlayAnimation("idle")

    inst:AddTag("projectile")
    --inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(OnHit)

    inst.persists = false

    return inst
end

return Prefab("common/blunderbuss", fn, assets),
    Prefab("common/gunpowder_projectile", projectile_fn, assets)
