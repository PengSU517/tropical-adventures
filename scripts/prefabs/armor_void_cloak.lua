local DEBUG_MODE = BRANCH == "dev"

local assets =
{
    Asset("ANIM", "anim/armor_void_cloak.zip"),
    Asset("ANIM", "anim/cloak_fx.zip"), -- wait for modify
    Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

local equipslot = --[[ EQUIPSLOTS.BACK or ]] EQUIPSLOTS.BODY -- 四格中设定为背包

local function setsoundparam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition, 0, 1)
    inst.SoundEmitter:SetParameter("vortex", "intensity", param)
end

local function spawnwisp(owner)
    if owner then
        local wisp = SpawnPrefab("armorvortexcloak_fx")
        local x, y, z = owner.Transform:GetWorldPosition()
        if x ~= nil and y ~= nil and z ~= nil then
            wisp.Transform:SetPosition(x + math.random() * 0.25 - 0.25 / 2, y, z + math.random() * 0.25 - 0.25 / 2)
        end
    end
end

local function OnBlocked(owner, data, inst)
    if inst.components.armor.condition and inst.components.armor.condition > 0 then
        owner:AddChild(SpawnPrefab("vortex_cloak_fx")) -- wait for modify
    end
    setsoundparam(inst)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_void_cloak", "swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/void_armour/equip_off")


    inst:ListenForEvent("blocked", inst.OnBlocked, owner)
    inst:ListenForEvent("attacked", inst.OnBlocked, owner)

    owner:AddTag("not_hit_stunned")
    --    owner.components.inventory:SetOverflow(inst)

    inst.components.container:Open(owner)
    inst.wisptask = inst:DoPeriodicTask(0.1, function() spawnwisp(owner, inst) end)

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/LP", "vortex")
    setsoundparam(inst)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_on")
    inst:RemoveEventCallback("blocked", inst.OnBlocked, owner)
    inst:RemoveEventCallback("attacked", inst.OnBlocked, owner)
    owner:RemoveTag("not_hit_stunned")
    --    owner.components.inventory:SetOverflow(nil)
    inst.components.container:Close(owner)
    if inst.wisptask then
        inst.wisptask:Cancel()
        inst.wisptask = nil
    end
    --    inst.SoundEmitter:KillSound("vortex")
end

local function ontakefuelitem(inst, _fuel, _fuelvalue, doer)
    inst.components.armor:SetPercent(inst.components.fueled:GetPercent()) -- Runar: 修复时耐久同步燃料
    inst.components.armor:SetAbsorption(1)
    if doer then
        doer.components.sanity:DoDelta(-TUNING.SANITY_TINY)
        doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
    end
    setsoundparam(inst)
end

local function OnBroken(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:HasTag("not_hit_stunned") ~= nil then
        owner:RemoveTag("not_hit_stunned")
    end
end

local function OnRepaired(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:HasTag("not_hit_stunned") == nil then
        owner:AddTag("not_hit_stunned")
    end
end

local function _MakeForgeRepairable(inst, material, _onbroken, onrepaired)
    local function __onbroken(inst)
        if _onbroken ~= nil then
            _onbroken(inst)
        end
    end
    if inst.components.armor ~= nil then
        assert(not (DEBUG_MODE and inst.components.armor.onfinished ~= nil))
        inst.components.armor:SetKeepOnFinished(true)
        inst.components.armor:SetOnFinished(__onbroken)
    elseif inst.components.finiteuses ~= nil then
        assert(not (DEBUG_MODE and inst.components.finiteuses.onfinished ~= nil))
        inst.components.finiteuses:SetOnFinished(__onbroken)
    elseif inst.components.fueled ~= nil then
        assert(not (DEBUG_MODE and inst.components.fueled.depleted ~= nil))
        inst.components.fueled:SetDepletedFn(__onbroken)
    end
    inst:AddComponent("forgerepairable")
    inst.components.forgerepairable:SetRepairMaterial(material)
    inst.components.forgerepairable:SetOnRepaired(onrepaired)
end

local function OnTakeDamage(inst, damage_amount)
    local sanity = inst.components.inventoryitem.owner and
                   inst.components.inventoryitem.owner.components.sanity
    if not sanity then return end
    sanity:DoDelta(-damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY, false)
    local armorleft = inst.components.armor:GetPercent()
    inst.components.fueled:SetPercent(armorleft)
    if armorleft <= 0 then
        inst.components.armor:SetAbsorption(0)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_void_cloak")
    inst.AnimState:SetBuild("armor_void_cloak")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst)

    inst:AddTag("backpack")
    inst:AddTag("void_cloak")
    inst:AddTag("shadow_item")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    inst.entity:SetPristine()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("armor_void_cloak.tex")

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("piggyback") end
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.cangoincontainer = false
    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    local container = inst:AddComponent("container")
    container:WidgetSetup("piggyback")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(TUNING.ARMORVOID, TUNING.ARMORVOID_ABSORPTION)
    inst.components.armor.ontakedamage = OnTakeDamage

    local fueled = inst:AddComponent("fueled")
    fueled:InitializeFuelLevel(TUNING.ARMORVOIDFUEL)
    fueled.fueltype = FUELTYPE.NIGHTMARE -- 燃料是噩梦燃料
    fueled.secondaryfueltype = FUELTYPE.ANCIENT_REMNANT
    fueled.ontakefuelitemfn = ontakefuelitem
    fueled.accepting = true

    local planardefense = inst:AddComponent("planardefense")
    planardefense:SetBaseDefense(TUNING.ARMOR_VOIDCLOTH_PLANAR_DEF) --虚空长袍的位面防御

    local damagetyperesist = inst:AddComponent("damagetyperesist")
    damagetyperesist:AddResist("shadow_aligned", inst, TUNING.ARMOR_VOIDCLOTH_SHADOW_RESIST) --虚空长袍的10%暗影阵营减伤

    local shadowlevel = inst:AddComponent("shadowlevel")
    shadowlevel:SetDefaultLevel(TUNING.ARMOR_VOIDCLOTH_SHADOW_LEVEL) --虚空长袍的老麦3级暗影之力

    local equippable = inst:AddComponent("equippable")
    equippable.equipslot = equipslot
    equippable:SetOnEquip(onequip)
    equippable:SetOnUnequip(onunequip)

    --采用修改后的联机版中的虚空长袍的机制
    _MakeForgeRepairable(inst, "voidcloth", OnBroken, OnRepaired)

    inst.OnBlocked = function(owner, data) OnBlocked(owner, data, inst) end

    return inst
end

return Prefab("common/inventory/armorvoidcloak", fn, assets)
