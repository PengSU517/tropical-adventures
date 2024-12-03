local assets = {Asset("ANIM", "anim/armor_obsidian.zip"), Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev")}

local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/obsidian")
    if data.attacker ~= nil and
        not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
        (data.weapon == nil or
            ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and
                data.weapon.components.projectile == nil)) and data.attacker.components.burnable ~= nil and
        not data.redirected and not data.attacker:HasTag("thorny") then
        data.attacker.components.burnable:Ignite(nil, nil, owner)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_obsidian", "swap_body")

    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - TUNING.ARMORDRAGONFLY_FIRE_RESIST)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    if owner.components.health ~= nil then owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst) end

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then owner:PushEvent("unequipskinneditem", inst:GetSkinName()) end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("torso_dragonfly")
    inst.AnimState:SetBuild("armor_obsidian")
    inst.AnimState:PlayAnimation("anim")

    local swap_data = {
        bank = "torso_dragonfly",
        sym_build = "armor_obsidian",
        anim = "anim",
    }
    MakeInventoryFloatable(inst, "small", .2, .80, nil, nil, swap_data)

    inst.foleysound = "dontstarve_DLC002/common/foley/obsidian_armour" -- What's this?

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOROBSIDIAN, TUNING.ARMORDRAGONFLY_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("armorobsidian", fn, assets)