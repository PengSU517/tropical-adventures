local Badge = require "widgets/badge"

local IRON_LORD_DAMAGE = 68
-- local IRON_LORD_TIME = 180
local IRON_LORD_SPEED_MULT = 1.35

local assets = {Asset("ANIM", "anim/living_artifact.zip"), Asset("ANIM", "anim/living_suit_build.zip"),
                Asset("ANIM", "anim/player_living_suit_morph.zip"), Asset("ANIM", "anim/player_living_suit_punch.zip"),
                Asset("ANIM", "anim/player_living_suit_shoot.zip"),
                Asset("ANIM", "anim/player_living_suit_destruct.zip")}

--[[
local function BecomeIronLord(inst, instant)
    player.components.worker:SetAction(ACTIONS.CHOP, 4)
    player.components.worker:SetAction(ACTIONS.MINE, 3)
    player.components.worker:SetAction(ACTIONS.HAMMER, 3)
    player.components.worker:SetAction(ACTIONS.HACK, 2)
end

local function Revert(inst)
    --    player:DoTaskInTime(0,function()player.sg:GoToState("bucked_post") end)
end
]]
local function SetNetVar(var, inst, val)
    local netvar = var == "fuel" and inst.player_classified.artifactfuel or var == "explode" and
                       inst.player_classified.artifactexplode or var == "control" and
                       inst.player_classified.artifactcontrol or nil

    if netvar then
        netvar:set_local(val) -- Force dirty
        netvar:set(val)
    end
end

local function ToggleSkin(inst, hide) -- Prevent skin problems (e.g. eyeglasses)
    if hide then
        inst.artifact.skins = inst.artifact.skins or inst.components.skinner:GetClothing()
        inst.components.skinner:SetSkinName("", nil, true)
        inst.components.skinner:ClearAllClothing()
    else
        local skins = inst.artifact.skins
        if skins then
            inst.components.skinner:SetSkinName(skins.base, true)
            for _, skin in pairs(skins) do
                inst.components.skinner:SetClothing(skin)
            end
        end
    end
end

local function ToggleBuild(inst, isartifact)
    if isartifact then
        inst.artifact.build = inst.artifact.build or inst.AnimState:GetBuild()
        inst.AnimState:Hide("beard")
        inst.AnimState:SetBuild("living_suit_build")
        inst.AnimState:AddOverrideBuild("living_suit_build") -- This double makes sure everything is overriden (e.g. Wanda's torso problem)
    else
        inst.AnimState:ClearOverrideBuild("living_suit_build")
        inst.AnimState:SetBuild(inst.artifact.build)
        inst.AnimState:Show("beard")
    end
end

local function ToggleLight(inst, on)
    if on then
        inst.nightlight = SpawnPrefab("living_artifact_light")
        inst:AddChild(inst.nightlight)
    else
        inst:RemoveChild(inst.nightlight)
        inst.nightlight:Remove()
    end
end

local function ToggleVisual(inst, on)
    if on then
        inst:AddTag("ironlordvision")
        ToggleSkin(inst, on) -- "skin" and "build" order matters
        ToggleBuild(inst, on)
    else
        inst:RemoveTag("ironlordvision")
        ToggleBuild(inst, on) -- "skin" and "build" order matters
        ToggleSkin(inst, on)
        ToggleLight(inst, on)
    end
    inst.components.playervision:ForceGoggleVision(on)
end

local IRON_LORD_TAGS = {"ironlord", "fireimmune", "laser_immune", "insomniac", "toughworker", "poisonimmune"} -- 可能导致标签溢出
local ARTIFACT_TAGS = {"nosteal"}

local function ToggleTags(inst, on)
    if on then
        for _, tag in ipairs(IRON_LORD_TAGS) do
            inst:AddTag(tag)
        end
        for _, tag in ipairs(ARTIFACT_TAGS) do
            inst.artifact:AddTag(tag)
        end
    else
        for _, tag in ipairs(IRON_LORD_TAGS) do
            inst:RemoveTag(tag)
        end
        for _, tag in ipairs(ARTIFACT_TAGS) do
            inst.artifact:RemoveTag(tag)
        end
    end
end

local function SaveData(inst, label, new_data)
    local old_data = inst.artifact.data[label]
    inst.artifact.data[label] = new_data
    return old_data
end

local function ToggleComponents(inst, on)
    ToggleTags(inst, on)
    if on then
        if inst.components.poisonable then
            inst.components.poisonable:WearOff()
        end

        -- inst.components.inventory:DropEverything(true, false)

        inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_SUITUP"))

        inst:AddComponent("worker")
        inst.components.worker:SetAction(ACTIONS.DIG, 1)
        inst.components.worker:SetAction(ACTIONS.CHOP, 4)
        inst.components.worker:SetAction(ACTIONS.MINE, 3)
        inst.components.worker:SetAction(ACTIONS.HAMMER, 3)
        inst.components.worker:SetAction(ACTIONS.HACK, 2)

        if inst.prefab ~= "wanda" then
            inst.components.health:SetPercent(1)
        end -- health:SetPercent(1) will change age (to 20?)
        SaveData(inst, "healthredirect", inst.components.health.redirect)
        inst.components.health.redirect = function() return true end -- Avoid SetInvincible(), it removes all the "hit" reactions...
        inst.components.health.disable_penalty = true -- Pause but not reset

        inst.components.sanity:SetPercent(1)
        inst.components.sanity.ignore = true

        inst.components.hunger:SetPercent(1)
        inst.components.hunger:Pause()

        SaveData(inst, "caneat", inst.components.eater.caneat)
        inst.components.eater.caneat = {} -- No eating

        inst.components.temperature:SetTemp(TUNING.STARTING_TEMP) -- Pause with fixed value

        inst.components.moisture:ForceDry(true)

        SaveData(inst, "defaultdmg", inst.components.combat.defaultdamage)
        inst.components.combat:SetDefaultDamage(IRON_LORD_DAMAGE)
        SaveData(inst, "customdmg", inst.components.combat.customdamagemultfn)
        inst.components.combat.customdamagemultfn = nil

        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ironlord_speed", IRON_LORD_SPEED_MULT)

        inst.components.inventory.isexternallyinsulated:SetModifier(inst, true)

        inst.components.cursable:RemoveMonkeyCurse(true)
        inst:RemoveComponent("cursable")

        -- inst.components.grogginess:ResetGrogginess()

        if inst.components.mightiness then -- Wolfgang
            inst.components.mightiness:Pause()
        end

        if inst.components.thirst then -- Compatible with "Don't Starve: Dehydrated"
            inst.components.thirst:SetPercent(1)
            inst.components.thirst:Pause()
        end
    else
        inst:RemoveComponent("worker")

        inst.components.health.redirect = SaveData(inst, "healthredirect")
        inst.components.health.disable_penalty = false

        inst.components.sanity.ignore = false

        inst.components.hunger:Resume()

        inst.components.eater.caneat = SaveData(inst, "caneat")

        inst.components.temperature:SetTemp() -- Unpause

        inst.components.moisture:ForceDry(false)

        inst.components.combat:SetDefaultDamage(SaveData(inst, "defaultdmg"))
        inst.components.combat.customdamagemultfn = SaveData(inst, "customdmg")

        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ironlord_speed")

        inst.components.inventory.isexternallyinsulated:RemoveModifier(inst)

        inst:AddComponent("cursable")

        if inst.components.mightiness then
            inst.components.mightiness:Resume()
        end

        if inst.components.thirst then
            inst.components.thirst:Resume()
        end
    end
end

local function ToggleBGM(inst, on) SendModRPCToClient(GetClientModRPC("Living Artifact", "ToggleBGM"), inst.userid, on) end
--[[
local function onequip(inst, owner)
    inst.owner = inst.components.inventoryitem:GetGrandOwner()
    inst.owner.artifact = inst

    inst.SetNetVar("fuel", inst.owner, inst.components.fueled.currentfuel)
    inst.ToggleComponents(inst.owner, true)

    if inst.components.ironmachine:IsOn() then
         -- IsOn when enter, skip morph
         inst.ToggleVisual(inst.owner, true)
         inst.SetNetVar("control", inst.owner, true)
         inst.ToggleBGM(inst.owner, true)
         inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)
    if owner:HasTag("aquatic") then

    else
        --owner.sg:GoToState("explode")
        inst.SetNetVar("explode", inst.owner, true)
        --inst.nightlight:Remove()
        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end
    --owner.components.health:SetInvincible(false)
end
]]

local function onturnon(inst)
    inst.owner = inst.components.inventoryitem:GetGrandOwner()
    inst.owner.artifact = inst

    inst.SetNetVar("fuel", inst.owner, inst.components.fueled.currentfuel)
    inst.ToggleComponents(inst.owner, true)

    if inst.components.ironmachine:IsOn() then
        -- IsOn when enter, skip morph
        inst.ToggleVisual(inst.owner, true)
        inst.SetNetVar("control", inst.owner, true)
        inst.ToggleBGM(inst.owner, true)
        inst.components.fueled:StartConsuming()
    end
end

local function onturnoff(inst)
    inst.components.fueled:StopConsuming()
    inst.SetNetVar("explode", inst.owner, true)
end

local function ondepleted(inst)
    if inst.components.ironmachine:IsOn() then
        inst.components.ironmachine:TurnOff()
    end
    inst:Remove()
end

local function onsave(inst, data)
    data.skins = inst.skins
    data.build = inst.build
    data.ison = inst.components.ironmachine:IsOn()
end

local function onload(inst, data)
    if data then
        if data.skins then
            inst.skins = data.skins
        end
        if data.build then
            inst.build = data.build
        end
        if data.ison then
            inst:AddTag("ironmachineon")
            inst:DoTaskInTime(0, function() inst.components.ironmachine:TurnOn() end)
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("living_artifact")
    inst.AnimState:SetBuild("living_artifact")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    --[[
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    --    inst.components.equippable.walkspeedmult = ARMORMETAL_SLOW
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
]]
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.LIVINGARTIFACT
    inst.components.fueled:InitializeFuelLevel(TUNING.IRON_LORD_TIME)
    -- inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetDepletedFn(ondepleted)
    --    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled.accepting = true

    inst:AddComponent("ironmachine")
    inst.components.ironmachine.turnonfn = onturnon
    inst.components.ironmachine.turnofffn = onturnoff

    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.data = {}

    inst.ToggleLight = ToggleLight
    inst.ToggleVisual = ToggleVisual
    inst.ToggleComponents = ToggleComponents
    inst.SetNetVar = SetNetVar
    inst.ToggleBGM = ToggleBGM

    inst:ListenForEvent("percentusedchange", function(inst, data)
        if inst.owner then
            inst.SetNetVar("fuel", inst.owner, inst.components.fueled.currentfuel)
        end
    end)

    MakeHauntableLaunch(inst)

    return inst
end

local function displaynamefn(inst) return "" end

local function lightfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.displaynamefn = displaynamefn

    inst.Light:Enable(true)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.6)
    inst.Light:SetColour(245 / 255, 150 / 255, 0 / 255)

    inst:AddTag("NOCLICK")

    inst:DoTaskInTime(0, function()
        if inst:HasTag("lightsource") then
            inst:RemoveTag("lightsource")
        end
    end)
    return inst
end

return Prefab("living_artifact", fn, assets), Prefab("living_artifact_light", lightfn, assets)
