local DEBUG_MODE = BRANCH == "dev"

local assets = { Asset("ANIM", "anim/armor_vortex_cloak.zip"), Asset("ANIM", "anim/cloak_fx.zip") }

local equipslot = --[[ EQUIPSLOTS.BACK or ]] EQUIPSLOTS.BODY -- 四格中设定为背包

local function SetSoundParam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition, 0, 1)
    inst.SoundEmitter:SetParameter("vortex", "intensity", param)
end

local function StartWispTask(inst)
    inst.wisptask = inst:DoPeriodicTask(0.1, function(this)
        if not (this.replica.equippable and this.replica.equippable:IsEquipped()) then return end
        local fx = SpawnPrefab("armorvortexcloak_fx_client")
        local x, y, z = this.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x + math.random() * 0.25 - 0.25 / 2, y, z + math.random() * 0.25 - 0.25 / 2)
    end)
end

local function Close(inst)
    inst.components.container.canbeopened = false
end

local function OnDrop(inst, owner)
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.container.canbeopened = true
end

local function OnBlocked(owner, data, inst)
    if not inst._ontakedmg then
        return
    end
    if inst.components.armor.condition and inst.components.armor.condition > 0 then
        owner:AddChild(SpawnPrefab("vortex_cloak_fx"))
    end
    SetSoundParam(inst)
    inst._ontakedmg = nil
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_vortex_cloak", "swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_off")

    inst:ListenForEvent("blocked", inst.OnBlocked, owner)
    inst:ListenForEvent("attacked", inst.OnBlocked, owner)

    owner:AddTag("not_hit_stunned")
    inst.components.container.canbeopened = true
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
    if inst.components.container:IsEmpty() == true then
        Close(inst)
        inst.components.inventoryitem.cangoincontainer = true
    else
        inst.components.inventoryitem.cangoincontainer = false
    end
end

local function OnTroRepaired(inst, _fuel, _fuelvalue, doer)
    inst.components.armor:SetAbsorption(1)
    if doer then
        doer.components.sanity:DoDelta(-TUNING.SANITY_TINY)
        doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
    end
    SetSoundParam(inst)
end

local function OnTakeDamage(inst, damage_amount)
    inst._ontakedmg = damage_amount and damage_amount > 0 or nil
    local sanity = inst.components.inventoryitem.owner and
        inst.components.inventoryitem.owner.components.sanity
    if not sanity then return end
    sanity:DoDelta(-damage_amount * TUNING.VORTEX_CLOAK.SANITY_DMG_AS_SANITY, false)
end

local function PercentChanged(inst, data)
    if inst.components.armor and data.percent then
        inst.components.armor:SetAbsorption(data.percent > 0 and 1 or 0)
    end
end

local function Fn()
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

    inst.tro_repair = TUNING.TROREPAIR.CLOAKCOMMON

    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
        StartWispTask(inst)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    local inventoryitem = inst:AddComponent("inventoryitem")
    inventoryitem.cangoincontainer = true
    inventoryitem.canonlygoinpocket = true
    inventoryitem:SetOnPutInInventoryFn(Close)
    inventoryitem:SetOnDroppedFn(OnDrop)

    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    local container = inst:AddComponent("container")
    container:WidgetSetup("armorvortexcloak")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(TUNING.VORTEX_CLOAK.ARMOR, TUNING.VORTEX_CLOAK.ARMOR_ABSORPTION)
    armor:SetKeepOnFinished(true)
    armor:AddNonresistTags("shadow")
    inst.components.armor.ontakedamage = OnTakeDamage

    local shadowlevel = inst:AddComponent("shadowlevel")
    shadowlevel:SetDefaultLevel(TUNING.VORTEX_CLOAK.SHADOW_LEVEL) -- Runar: 影甲的老麦2级暗影之力

    local equippable = inst:AddComponent("equippable")
    equippable.equipslot = equipslot
    equippable:SetOnEquip(OnEquip)
    equippable:SetOnUnequip(OnUnequip)

    inst.OnBlocked = function(owner, data) OnBlocked(owner, data, inst) end

    inst:ListenForEvent("percentusedchange", PercentChanged)

    inst.OnTroRepaired = OnTroRepaired

    return inst
end

local function Fx()
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

return Prefab("common/inventory/armorvortexcloak", Fn, assets),
    Prefab("armorvortexcloak_fx_client", Fx, assets)
