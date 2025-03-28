local assets = { Asset("ANIM", "anim/des_shard_sword_ground.zip"), Asset("ANIM", "anim/swap_des_shard_sword.zip"),
    Asset("ANIM", "anim/des_shard_beak_ground.zip"), Asset("ANIM", "anim/swap_des_shard_beak.zip"),
    Asset("ANIM", "anim/des_glass_shards.zip") }

local BEAK_DURABILITY = 100
local SWORD_DURABILITY = BEAK_DURABILITY / 2

local function shine(inst)
    inst.task = nil
    inst.AnimState:PlayAnimation("sparkle")
    inst.AnimState:PushAnimation("idle")
    inst.task = inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function onequip(weapon)
    return function(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_des_shard_" .. weapon, "swap_des_shard_" .. weapon)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local NO_TAGS_PVP = { "INLIMBO", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "decoy" }
local NO_TAGS = shallowcopy(NO_TAGS_PVP)
table.insert(NO_TAGS, "player")

-- 从镰刀AOE拿来的
local function HasFriendlyLeader(target, attacker)
    local target_leader = (target.components.follower ~= nil) and target.components.follower.leader or nil

    if target_leader ~= nil then

        if target_leader.components.inventoryitem then
            target_leader = target_leader.components.inventoryitem:GetGrandOwner()
        end

        local PVP_enabled = TheNet:GetPVPEnabled()
        return (target_leader ~= nil 
                and (target_leader:HasTag("player") 
                and not PVP_enabled)) or
                (target.components.domesticatable and target.components.domesticatable:IsDomesticated() 
                and not PVP_enabled) or
                (target.components.saltlicker and target.components.saltlicker.salted
                and not PVP_enabled)
    end

    return false
end

local function BeakAoEValidFn(target, attacker)
    if target:HasTag("playerghost") then
        return false
    end

    if target:HasTag("monster") and not TheNet:GetPVPEnabled() and 
        ((target.components.follower and target.components.follower.leader ~= nil and 
            target.components.follower.leader:HasTag("player")) or target.bedazzled) then
        return false
    end

    if HasFriendlyLeader(target, attacker) then
        return false
    end

    return true
end

local function DoBeakAoE(inst, attacker, target)
    if attacker.components.combat then
        local range = TUNING.SKILLS.WORTOX.VOIDCLOTHSCYTHE_AOE_RANGE
        local weapon = inst
        local excludetags = TheNet:GetPVPEnabled() and NO_TAGS_PVP or NO_TAGS
        local hitcount = attacker.components.combat:DoAreaAttack(target, range, weapon, BeakAoEValidFn, nil, excludetags)
        if hitcount == 0 and target:IsValid() then
            attacker.components.combat:DoAreaAttack(target, range, weapon, BeakAoEValidFn, nil, excludetags, true)
        end
    end
end

local function BeakOnAttack(inst, attacker, target)
    if attacker._beakSweepTrigger == true then
        DoBeakAoE(inst, attacker, target)
        attacker._beakSweepTrigger = nil
    end
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
    inst.components.equippable:SetOnEquip(onequip("sword"))
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
    inst.components.weapon:SetOnAttack(BeakOnAttack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(BEAK_DURABILITY)
    inst.components.finiteuses:SetUses(BEAK_DURABILITY)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip("beak"))
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
