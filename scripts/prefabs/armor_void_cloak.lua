local DEBUG_MODE = BRANCH == "dev"

local assets =
{
    Asset("ANIM", "anim/armor_void_cloak.zip"),
    Asset("ANIM", "anim/cloak_fx.zip"), -- wait for modify
    Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

local equipslot = --[[ EQUIPSLOTS.BACK or ]] EQUIPSLOTS.BODY -- 四格中设定为背包

local function SetSoundParam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition, 0, 1)
    inst.SoundEmitter:SetParameter("vortex", "intensity", param)
end

local function SetDefenses(inst, isbroken)
    inst.components.armor:SetAbsorption(not isbroken and 1 or 0)
    local level = 0
    if not isbroken and inst.components.medal_immortal ~= nil then
        level = inst.components.medal_immortal:GetLevel() or 0
    end
    if inst.components.planardefense ~= nil then
        inst.components.planardefense:SetBaseDefense(isbroken and 0
            or TUNING.VOID_CLOAK.PLANAR_DEF + level * TUNING.VOID_CLOAK.IMMORTAL_PLANAR_DEF)
    end
    if inst.components.medal_chaosdefense ~= nil then
        inst.components.medal_chaosdefense:SetBaseDefense(level * TUNING.VOID_CLOAK.CHAOS_DEF)
    end
end

local function StartWispTask(inst)
    inst.wisptask = inst:DoPeriodicTask(0.1, function(this)
        if not (this.replica.equippable and this.replica.equippable:IsEquipped()) then return end
        local fx = SpawnPrefab("armorvortexcloak_fx_client")
        local x, y, z = this.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x + math.random() * 0.25 - 0.25 / 2, y, z + math.random() * 0.25 - 0.25 / 2)
        fx.AnimState:SetAddColour(math.random() * .5, 0, 0, 0)
    end)
end

local function UpdateBrokenState(inst, isbroken)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        if isbroken then
            owner:RemoveTag("not_hit_stunned")
        elseif inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            owner:AddTag("not_hit_stunned")
        end
    end
    SetDefenses(inst, isbroken)
    inst._isbroken = isbroken
end

local function OnArmorPercentChanged(inst)
    local armor = inst.components.armor
    if armor == nil then
        return
    end
    local isbroken = armor:GetPercent() <= 0
    if inst._isbroken ~= isbroken then
        UpdateBrokenState(inst, isbroken)
    end
end

local function OnBlocked(owner, data, inst)
    if not inst._ontakedmg then
        return
    end
    if inst.components.armor.condition and inst.components.armor.condition > 0 then
        owner:AddChild(SpawnPrefab("vortex_cloak_fx")) -- wait for modify
    end
    SetSoundParam(inst)
    inst._ontakedmg = nil
end

local function OnTakeDamage(inst, damage_amount)
    inst._ontakedmg = damage_amount and damage_amount > 0 or nil
    local sanity = inst.components.inventoryitem.owner and
        inst.components.inventoryitem.owner.components.sanity
    if not sanity then return end
    sanity:DoDelta(-damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY, false)
end

local function OnTroRepaired(inst, _fuel, _fuelvalue, doer)
    if doer then
        doer.components.sanity:DoDelta(-TUNING.SANITY_TINY)
        doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
    end
    SetSoundParam(inst)
end

local function MakeForgeRepairable(inst, material)
    if inst.components.armor ~= nil then
        assert(not (DEBUG_MODE and inst.components.armor.onfinished ~= nil))
        inst.components.armor:SetKeepOnFinished(true)
    elseif inst.components.finiteuses ~= nil then
        assert(not (DEBUG_MODE and inst.components.finiteuses.onfinished ~= nil))
    elseif inst.components.fueled ~= nil then
        assert(not (DEBUG_MODE and inst.components.fueled.depleted ~= nil))
    end
    inst:AddComponent("forgerepairable")
    inst.components.forgerepairable:SetRepairMaterial(material)
end

local function ImmortalFn(inst, level, isadd)
    local mult = TUNING.VOID_CLOAK.IMMORTAL_ARMOR_MULT + level * TUNING.VOID_CLOAK.IMMORTAL_ARMOR_BONUS
    if inst.components.armor ~= nil then
        inst.components.armor.maxcondition = TUNING.VOID_CLOAK.ARMOR / TUNING.VOID_CLOAK.IMMORTAL_ARMOR_MULT * mult
    end
    if isadd then
        if inst.components.armor ~= nil then
            inst.components.armor:SetPercent(1)
        end
    end
    SetDefenses(inst)
end

local function OnSave(inst, data)
    if inst.components.armor ~= nil then
        data.armor_percent = inst.components.armor:GetPercent()
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.armor_percent ~= nil and inst.components.armor ~= nil then
        inst.components.armor:SetPercent(data.armor_percent)
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_void_cloak", "swap_body")

    inst:ListenForEvent("blocked", inst.OnBlocked, owner)
    inst:ListenForEvent("attacked", inst.OnBlocked, owner)

    if not inst._isbroken then
        owner:AddTag("not_hit_stunned")
    end

    inst.components.container:Open(owner)

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/LP", "vortex")
    SetSoundParam(inst)
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_on")
    inst:RemoveEventCallback("blocked", inst.OnBlocked, owner)
    inst:RemoveEventCallback("attacked", inst.OnBlocked, owner)
    owner:RemoveTag("not_hit_stunned")
    inst.components.container:Close(owner)
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_void_cloak")
    inst.AnimState:SetBuild("armor_void_cloak")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:AddMiniMapEntity():SetIcon("armor_void_cloak.tex")

    MakeInventoryFloatable(inst)

    inst:AddTag("backpack")
    inst:AddTag("vortex_cloak")
    inst:AddTag("shadow_item")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    inst.medal_repair_immortal = {
        immortal_fruit = TUNING.VOID_CLOAK.IMMORTAL_FRUIT_REPAIR,
    }

    inst.tro_repair = TUNING.TROREPAIR.CLOAKCOMMON

    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
        StartWispTask(inst)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    inst:AddComponent("container"):WidgetSetup("armorvoidcloak")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(TUNING.VOID_CLOAK.ARMOR, TUNING.VOID_CLOAK.ARMOR_ABSORPTION)
    armor.ontakedamage = OnTakeDamage

    inst:AddComponent("planardefense")

    inst:AddComponent("damagetyperesist"):AddResist("shadow_aligned", inst, TUNING.VOID_CLOAK.SHADOW_RESIST) --虚空长袍的10%暗影阵营减伤

    inst:AddComponent("shadowlevel"):SetDefaultLevel(TUNING.VOID_CLOAK.SHADOW_LEVEL)

    local equippable = inst:AddComponent("equippable")
    equippable.equipslot = equipslot
    equippable:SetOnEquip(OnEquip)
    equippable:SetOnUnequip(OnUnequip)

    MakeForgeRepairable(inst, "voidcloth")

    pcall(inst.AddComponent, inst, "medal_chaosdefense")
    local ok, medal_immortal = pcall(inst.AddComponent, inst, "medal_immortal")
    if ok then
        medal_immortal:SetMaxLevel(TUNING.VOID_CLOAK.IMMORTAL_MAXLEVEL)
        medal_immortal:SetOnImmortal(ImmortalFn)
    end
    SetDefenses(inst)

    inst._isbroken = false
    inst:ListenForEvent("percentusedchange", OnArmorPercentChanged)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.OnBlocked = function(owner, data) OnBlocked(owner, data, inst) end

    inst.OnTroRepaired = OnTroRepaired

    return inst
end

return Prefab("common/inventory/armorvoidcloak", Fn, assets)
