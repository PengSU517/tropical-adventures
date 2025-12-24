local DEBUG_MODE = BRANCH == "dev"

local assets = { Asset("ANIM", "anim/armor_vortex_cloak.zip"), Asset("ANIM", "anim/cloak_fx.zip") }

local equipslot = --[[ EQUIPSLOTS.BACK or ]] EQUIPSLOTS.BODY -- 四格中设定为背包

local function setsoundparam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition, 0, 1)
    inst.SoundEmitter:SetParameter("vortex", "intensity", param)
end

local function spawnwisp_client(inst)
    if inst.equipped:value() then
        inst.wisptask = inst:DoPeriodicTask(0.1, function(this)
            local fx = SpawnPrefab("armorvortexcloak_fx_client")
            local x, y, z = this.Transform:GetWorldPosition()
            fx.Transform:SetPosition(x + math.random() * 0.25 - 0.25 / 2, y, z + math.random() * 0.25 - 0.25 / 2)
        end)
    elseif inst.wisptask ~= nil then
        inst.wisptask:Cancel()
        inst.wisptask = nil
    end
end

local function OnBlocked(owner, data, inst)
    if not inst._ontakedmg then
        return
    end
    if inst.components.armor.condition and inst.components.armor.condition > 0 then
        owner:AddChild(SpawnPrefab("vortex_cloak_fx"))
    end
    setsoundparam(inst)
    inst._ontakedmg = nil
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_vortex_cloak", "swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_off")

    inst:ListenForEvent("blocked", inst.OnBlocked, owner)
    inst:ListenForEvent("attacked", inst.OnBlocked, owner)

    owner:AddTag("not_hit_stunned")
    inst.components.container.canbeopened = true
    inst.components.container:Open(owner)
    inst.equipped:set(true)

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/LP", "vortex")
    setsoundparam(inst)
end

local function close(inst)
    inst.components.container.canbeopened = false
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_on")
    inst:RemoveEventCallback("blocked", inst.OnBlocked, owner)
    inst:RemoveEventCallback("attacked", inst.OnBlocked, owner)
    owner:RemoveTag("not_hit_stunned")
    inst.components.container:Close(owner)
    inst.equipped:set(false)
    if inst.components.container:IsEmpty() == true then
        close(inst)
        inst.components.inventoryitem.cangoincontainer = true
    else
        inst.components.inventoryitem.cangoincontainer = false
    end
end

local function ondrop(inst, owner)
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.container.canbeopened = true
end

local function ontakefuelitem(inst, _fuel, _fuelvalue, doer)
    inst.components.armor:SetPercent(inst.components.fueled:GetPercent())
    inst.components.armor:SetAbsorption(1)
    if doer then
        doer.components.sanity:DoDelta(-TUNING.SANITY_TINY)
        doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
    end
    setsoundparam(inst)
end

local function OnTakeDamage(inst, damage_amount)
    inst._ontakedmg = damage_amount and damage_amount > 0 or nil
    local sanity = inst.components.inventoryitem.owner and
        inst.components.inventoryitem.owner.components.sanity
    if not sanity then return end
    sanity:DoDelta(-damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY * 3, false)
    local armorleft = inst.components.armor:GetPercent()
    inst.components.fueled:SetPercent(armorleft)
    if armorleft <= 0 then
        inst.components.armor:SetAbsorption(0)
    end
end

local function fn()
    ---@class vortex_cloak: ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_vortex_cloak")
    inst.AnimState:SetBuild("armor_vortex_cloak")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst)

    inst:AddTag("backpack") -- 六格
    inst:AddTag("vortex_cloak")
    inst:AddTag("shadow_item")

    -- shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("armor_vortex_cloak.tex")

    inst.equipped = net_bool(inst.GUID, "cloak.equipped", "cloak.equippeddirty")
    inst.equipped:set(false)

    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("cloak.equippeddirty", spawnwisp_client)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    local inventoryitem = inst:AddComponent("inventoryitem")
    inventoryitem.cangoincontainer = true
    inventoryitem.canonlygoinpocket = true
    inventoryitem:SetOnPutInInventoryFn(close)
    inventoryitem:SetOnDroppedFn(ondrop)

    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    local container = inst:AddComponent("container")
    container:WidgetSetup("armorvortexcloak")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(TUNING.ARMORVORTEX, TUNING.ARMORVORTEX_ABSORPTION)
    armor:SetKeepOnFinished(true)
    armor:SetImmuneTags({ "shadow" })
    inst.components.armor.ontakedamage = OnTakeDamage

    local fueled = inst:AddComponent("fueled")
    fueled:InitializeFuelLevel(TUNING.ARMORVORTEXFUEL)
    fueled.fueltype = FUELTYPE.NIGHTMARE
    fueled.secondaryfueltype = FUELTYPE.ANCIENT_REMNANT
    fueled.ontakefuelitemfn = ontakefuelitem
    fueled.accepting = true

    local shadowlevel = inst:AddComponent("shadowlevel")
    shadowlevel:SetDefaultLevel(TUNING.ARMOR_SANITY_SHADOW_LEVEL) -- Runar: 影甲的老麦2级暗影之力

    local equippable = inst:AddComponent("equippable")
    equippable.equipslot = equipslot
    equippable:SetOnEquip(onequip)
    equippable:SetOnUnequip(onunequip)

    inst.OnBlocked = function(owner, data) OnBlocked(owner, data, inst) end


    return inst
end

local function fx()
    ---@class armorvortexcloak_fx_client: ent
    local inst = CreateEntity()
    inst.entity:AddTransform()

    if not TheNet:IsDedicated() then
        inst.entity:AddAnimState()
        inst.AnimState:SetBank("cloakfx")
        inst.AnimState:SetBuild("cloak_fx")
        inst.AnimState:PlayAnimation("idle")
        for i = 1, 14 do
            inst.AnimState:Hide("fx" .. i)
        end
        inst.AnimState:Show("fx" .. math.random(1, 14))
        inst:ListenForEvent("animover", inst.Remove)
    else
        inst:DoTaskInTime(0, inst.Remove)
    end

    inst:AddTag("FX")

    inst.persists = false

    return inst
end

return Prefab("common/inventory/armorvortexcloak", fn, assets),
    Prefab("armorvortexcloak_fx_client", fx, assets)
