local assets = {Asset("ANIM", "anim/des_shard_sword_ground.zip"), Asset("ANIM", "anim/swap_des_shard_sword.zip"),
                Asset("ANIM", "anim/des_shard_beak_ground.zip"), Asset("ANIM", "anim/swap_des_shard_beak.zip"),
                Asset("ANIM", "anim/des_glass_shards.zip")}

local BEAK_DURABILITY = 100
local SWORD_DURABILITY = BEAK_DURABILITY / 2

local function shine(inst)
    inst.task = nil
    inst.AnimState:PlayAnimation("sparkle")
    inst.AnimState:PushAnimation("idle")
    inst.task = inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function swordequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_des_shard_sword", "swap_des_shard_sword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function beakequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_des_shard_beak", "swap_des_shard_beak")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

    return inst
end

local function swordfn()
    local inst = common()

    inst.AnimState:SetBank("des_shard_sword_ground")
    inst.AnimState:SetBuild("des_shard_sword_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    MakeInventoryFloatable(inst)

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SWP_SHARD_DMG.SWORD) 

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(SWORD_DURABILITY)
    inst.components.finiteuses:SetUses(SWORD_DURABILITY)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(swordequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function beakfn()
    local inst = common()

    inst.AnimState:SetBank("des_shard_beak_ground")
    inst.AnimState:SetBuild("des_shard_beak_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SWP_SHARD_DMG.BEAK) 

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(BEAK_DURABILITY)
    inst.components.finiteuses:SetUses(BEAK_DURABILITY)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(beakequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function fn()
    local inst = common()

    inst.entity:AddSoundEmitter()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("des_glass_shards")
    inst.AnimState:SetBuild("des_glass_shards")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")
    inst:AddTag("renewable")
    inst:AddTag("quakedebris")

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunchAndSmash(inst)

    inst:AddComponent("bait")
    local s = math.random() * .3 + .9
    local r = math.random() * .4 + .6
    local g = math.random() * .4 + .5
    local b = math.random() * .4 + .6
    local a = math.random() * .3 + .7

    inst.AnimState:SetScale(s, s, s, s)
    inst.AnimState:SetMultColour(r, g, b, 1)

    shine(inst)

    return inst
end

return Prefab("shard_sword", swordfn, assets), Prefab("shard_beak", beakfn, assets), Prefab("glass_shards", fn, assets)