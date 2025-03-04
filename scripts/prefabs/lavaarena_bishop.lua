local clockwork_common = require "prefabs/clockwork_common"
local RuinsRespawner = require "prefabs/ruinsrespawner"

local assets =
{
    Asset("ANIM", "anim/bishop.zip"),
    Asset("ANIM", "anim/bishop_build.zip"),
    Asset("ANIM", "anim/bishop_nightmare.zip"),
    Asset("SOUND", "sound/chess.fsb"),
    Asset("SCRIPT", "scripts/prefabs/clockwork_common.lua"),
    Asset("SCRIPT", "scripts/prefabs/ruinsrespawner.lua"),

    Asset("ANIM", "anim/bishopboat.zip"),
    Asset("ANIM", "anim/bishopboat_build.zip"),
    Asset("ANIM", "anim/bishopboat_death.zip"),
}

local prefabs =
{
    "gears",
    "bishop_charge",
    "purplegem",
}

local prefabs_nightmare =
{
    "gears",
    "bishop_charge",
    "purplegem",
    "nightmarefuel",
    "thulecite_pieces",
    "bishop_nightmare_ruinsrespawner_inst",
}

local brain = require "brains/bishopbrain"

SetSharedLootTable('bishop',
    {
        { 'gears',     1.0 },
        { 'gears',     1.0 },
        { 'purplegem', 1.0 },
    })

SetSharedLootTable('bishop_nightmare',
    {
        { 'purplegem',        1.0 },
        { 'nightmarefuel',    0.6 },
        { 'thulecite_pieces', 0.5 },
    })

SetSharedLootTable('bishopb',
    {

    })

local function ShouldSleep(inst)
    if inst:HasTag("Arena") then return false end
    return clockwork_common.ShouldSleep(inst)
end

local function ShouldWake(inst)
    return clockwork_common.ShouldWake(inst)
end

local function Retarget(inst)
    local player = GetClosestInstWithTag("player", inst, 70)
    if player and inst:HasTag("Arena") then return inst.components.combat:SetTarget(player) end
    return clockwork_common.Retarget(inst, TUNING.BISHOP_TARGET_DIST)
end

local function KeepTarget(inst, target)
    return clockwork_common.KeepTarget(inst, target)
end

local function OnAttacked(inst, data)
    clockwork_common.OnAttacked(inst, data)
end

local function EquipWeapon(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        --[[Non-networked entity]]
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(inst.components.combat.defaultdamage)
        weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange + 4)
        weapon.components.weapon:SetProjectile("bishop_charge")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        weapon:AddComponent("equippable")

        inst.components.inventory:Equip(weapon)
    end
end

local function RememberKnownLocation(inst)
    inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function common_fn(build, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bishop")
    inst.AnimState:SetBuild(build)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bishop")

    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BISHOP_WALK_SPEED

    inst:SetStateGraph("SGbishop")
    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "waist"
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BISHOP_ATTACK_DIST)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BISHOP_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BISHOP_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    inst:DoTaskInTime(0, RememberKnownLocation)

    inst:AddComponent("follower")

    MakeMediumBurnableCharacter(inst, "waist")
    MakeMediumFreezableCharacter(inst, "waist")

    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)

    EquipWeapon(inst)

    return inst
end

local function OnWaterChange(inst, onwater)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/crocodog/emerge")

    if onwater then
        if inst.DynamicShadow then
            inst.DynamicShadow:Enable(false)
        end

        inst.AnimState:SetBank("bishopboat")
        inst.AnimState:SetBuild("bishopboat_build")
    else
        if inst.DynamicShadow then
            inst.DynamicShadow:Enable(true)
        end

        inst.AnimState:SetBank("bishop")
        inst.AnimState:SetBuild("bishop_build")
    end

    --   local splash = SpawnPrefab("splash_water")
    local splash = SpawnPrefab("frogsplash")

    local ent_pos = Vector3(inst.Transform:GetWorldPosition())
    splash.Transform:SetPosition(ent_pos.x, ent_pos.y, ent_pos.z)

    if inst.sg then
        inst.sg:GoToState("idle")
    end
end

local function OnEntityWake(inst)
    inst.components.tiletracker:Start()
end

local function OnEntitySleep(inst)
    inst.components.tiletracker:Stop()
end

local function bishop_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bishop")
    inst.AnimState:SetBuild("bishop_build")

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bishop")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('bishop')

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BISHOP_WALK_SPEED

    inst:SetStateGraph("SGbishop")
    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "waist"
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BISHOP_ATTACK_DIST)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BISHOP_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BISHOP_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    inst:DoTaskInTime(0, RememberKnownLocation)

    inst:AddComponent("follower")

    MakeMediumBurnableCharacter(inst, "waist")
    MakeMediumFreezableCharacter(inst, "waist")

    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)

    EquipWeapon(inst)
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"

    inst:AddComponent("tiletracker")
    inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep

    return inst
end

local function bishop_nightmare_fn()
    local inst = common_fn("bishop_nightmare", "cavedweller")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishop_nightmare')
    inst.kind = "_nightmare"
    inst.soundpath = "dontstarve/creatures/bishop_nightmare/"
    inst.effortsound = "dontstarve/creatures/bishop_nightmare/rattle"

    return inst
end

local function bishop_fnb()
    local inst = common_fn("bishop_build")
    inst:AddTag("Arena")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishopb')
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"

    return inst
end

local function bishop_nightmare_fnb()
    local inst = common_fn("bishop_nightmare", "cavedweller")
    inst:AddTag("Arena")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishopb')
    inst.kind = "_nightmare"
    inst.soundpath = "dontstarve/creatures/bishop_nightmare/"
    inst.effortsound = "dontstarve/creatures/bishop_nightmare/rattle"

    return inst
end

local function onruinsrespawn(inst, respawner)
    if not respawner:IsAsleep() then
        inst.sg:GoToState("ruinsrespawn")
    end
end

return Prefab("bishop", bishop_fn, assets, prefabs),
    Prefab("bishop_nightmare", bishop_nightmare_fn, assets, prefabs_nightmare),
    Prefab("bishopb", bishop_fnb, assets, prefabs),
    Prefab("bishop_nightmareb", bishop_nightmare_fnb, assets, prefabs_nightmare),
    RuinsRespawner.Inst("bishop_nightmare", onruinsrespawn), RuinsRespawner.WorldGen("bishop_nightmare", onruinsrespawn)
