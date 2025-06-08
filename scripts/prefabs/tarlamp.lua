local assets =
{
    Asset("ANIM", "anim/tarlamp.zip"),
    Asset("ANIM", "anim/swap_tarlamp.zip"),
    Asset("ANIM", "anim/swap_tarlamp_boat.zip"),
}

local prefabs =
{
    "tarlampfire",
}

local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    (owner ~= nil and owner:IsValid() and owner.SoundEmitter or inst.SoundEmitter):PlaySound("dontstarve/wilson/lantern_off")
end

local function PlayTurnOffSound(inst)
    if inst._soundtask == nil and inst:GetTimeAlive() > 0 then
        inst._soundtask = inst:DoTaskInTime(0, DoTurnOffSound, inst.components.inventoryitem.owner)
    end
end

local function PlayTurnOnSound(inst)
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
        inst._soundtask = nil
    elseif not POPULATING then
        inst._light.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    end
end

local function fuelupdate(inst)
    if inst._light ~= nil then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(.4, .6, fuelpercent))
        inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
        inst._light.Light:SetFalloff(.9)
    end
end

local function onremovelight(light)
    light._lantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem.owner

        if inst._light == nil then
            inst._light = SpawnPrefab("tarlampfire")
            inst._light._lantern = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
            fuelupdate(inst)
            PlayTurnOnSound(inst)
        end
        inst._light.entity:SetParent((owner or inst).entity)

        --[[local map = TheWorld.Map
        local x, y, z = inst.Transform:GetWorldPosition()
        local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

        local WALKABLE_PLATFORM_TAGS = { "walkableplatform" }
        local plataforma = false
        local pos_x, pos_y, pos_z = inst.Transform:GetWorldPosition()
        local entities = TheSim:FindEntities(x, 0, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, WALKABLE_PLATFORM_TAGS)
        for i, v in ipairs(entities) do
            local walkable_platform = v.components.walkableplatform
            if walkable_platform and walkable_platform.radius == nil then walkable_platform.radius = 4 end
            if walkable_platform ~= nil then
                local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
                local distance_sq = VecUtil_LengthSq(x - platform_x, z - platform_z)
                if distance_sq <= walkable_platform.radius * walkable_platform.radius then plataforma = true end
            end
        end

        if not plataforma and
            TileGroupManager:IsOceanTile(ground) then
            inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
            inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
            inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")
            if not inst.replica.inventoryitem:IsHeld() then inst.components.inventoryitem:AddMoisture(80) end
            inst.AnimState:PlayAnimation("idle_on_water", true)
        else
            inst.AnimState:SetLayer(LAYER_WORLD)
            inst.AnimState:ClearOverrideSymbol("water_ripple", "ripple_build", "water_ripple")
            inst.AnimState:ClearOverrideSymbol("water_shadow", "ripple_build", "water_shadow")
        end]]
        inst.AnimState:PlayAnimation("idle_on")

        if owner ~= nil and inst.components.equippable:IsEquipped() then
            owner.AnimState:Show("LANTERN_OVERLAY")
        end

        inst.components.machine.ison = true
        inst:PushEvent("lantern_on")
    end
end

local function turnoff(inst)
    stoptrackingowner(inst)

    inst.components.fueled:StopConsuming()

    if inst._light ~= nil then
        inst._light:Remove()
        PlayTurnOffSound(inst)
    end

    --[[local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

    local WALKABLE_PLATFORM_TAGS = { "walkableplatform" }
    local plataforma = false
    local pos_x, pos_y, pos_z = inst.Transform:GetWorldPosition()
    local entities = TheSim:FindEntities(x, 0, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, WALKABLE_PLATFORM_TAGS)
    for i, v in ipairs(entities) do
        local walkable_platform = v.components.walkableplatform
        if walkable_platform and walkable_platform.radius == nil then walkable_platform.radius = 4 end
        if walkable_platform ~= nil then
            local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
            local distance_sq = VecUtil_LengthSq(x - platform_x, z - platform_z)
            if distance_sq <= walkable_platform.radius * walkable_platform.radius then plataforma = true end
        end
    end



    if not plataforma and
        TileGroupManager:IsOceanTile(ground) then
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
        inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")
        if not inst.replica.inventoryitem:IsHeld() then inst.components.inventoryitem:AddMoisture(80) end
        inst.AnimState:PlayAnimation("idle_off_water", true)
    else
        inst.AnimState:SetLayer(LAYER_WORLD)
        inst.AnimState:ClearOverrideSymbol("water_ripple", "ripple_build", "water_ripple")
        inst.AnimState:ClearOverrideSymbol("water_shadow", "ripple_build", "water_shadow")
    end]]
    inst.AnimState:PlayAnimation("idle_off")

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end

    inst.components.machine.ison = false
    inst:PushEvent("lantern_off")
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tarlamp", "swap_lantern")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled:IsEmpty() then
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:Show("LANTERN_OVERLAY")
        turnon(inst)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")

    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end
end

local function onequiptomodel(inst, owner, from_ground)
    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end

    turnoff(inst)
end

local function nofuel(inst)
    turnoff(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
        owner:PushEvent("torchranout", {prefab = inst.prefab, equipslot = inst.components.inventoryitem.equipslot})
    end
    local rem = SpawnAt("seashell", inst)
    inst:Remove()
    if owner and owner.components.inventory then
        owner.components.inventory:GiveItem(rem)
    end
end

local function ontakefuel(inst)
    if inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end


local function tarlampfirefn(inst)
    inst.Light:SetColour(255 / 255, 180 / 255, 0 / 255)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tarlamp")
    inst.AnimState:SetBuild("tarlamp")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddTag("light")
    inst:AddTag("tarlamp")
    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    local inventoryitem = inst:AddComponent("inventoryitem")
    inventoryitem:SetOnDroppedFn(ondropped)
    inventoryitem:SetOnPutInInventoryFn(turnoff)

    inst:AddComponent("heater")
    inst.components.heater.equippedheat = 5

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.LIGHTER_DAMAGE)
    inst.components.weapon:SetAttackCallback(
        function(attacker, target)
            if target.components.burnable then
                if math.random() < TUNING.LIGHTER_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
                    target.components.burnable:Ignite()
                end
            end
        end
    )

    inst:AddComponent("equippable")

    local fueled = inst:AddComponent("fueled")

    local machine = inst:AddComponent("machine")
    machine.turnonfn = turnon
    machine.turnofffn = turnoff
    machine.cooldowntime = 0

    fueled:InitializeFuelLevel(TUNING.TORCH_FUEL)
    fueled:SetDepletedFn(nofuel)
    fueled:SetUpdateFn(fuelupdate)
    fueled:SetTakeFuelFn(ontakefuel)
    fueled.accepting = true

    inst._light = nil

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst.OnRemoveEntity = OnRemove

    inst._onownerequip = function(owner, data)
        if data.item ~= inst and
            (   data.eslot == EQUIPSLOTS.HANDS or
                (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
            ) then
            turnoff(inst)
        end
    end

    return inst
end

return Prefab("tarlamp", fn, assets, prefabs),
    Derive("lanternlight", "tarlampfire", tarlampfirefn)
