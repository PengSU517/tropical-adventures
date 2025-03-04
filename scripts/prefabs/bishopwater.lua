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

SetSharedLootTable('bishopwater',
    {
        { 'gears',     1.0 },
        { 'gears',     1.0 },
        { 'purplegem', 1.0 },
    })

local function ShouldSleep(inst)
    return clockwork_common.ShouldSleep(inst)
end

local function ShouldWake(inst)
    return clockwork_common.ShouldWake(inst)
end

local function Retarget(inst)
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

local function OnTimerDone(inst, data)
    if data.name == "vaiembora" then
        local invader = GetClosestInstWithTag("player", inst, 25)
        if not invader then
            inst:Remove()
        else
            inst.components.timer:StartTimer("vaiembora", 10)
        end
    end
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

    inst.AnimState:SetBank("bishopboat")
    inst.AnimState:SetBuild("bishopboat_build")

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bishop")
    inst:AddTag("tropicalspawner")

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

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("vaiembora", 480 + math.random() * 240)

    return inst
end

local function bishop_fn()
    local inst = common_fn("bishopboat_build")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishopwater')
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"

    return inst
end


local function common_fn2(build, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bishopboat")
    inst.AnimState:SetBuild("bishopboat_build")

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bishop")
    inst:AddTag("tropicalspawner")

    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst:SetPrefabNameOverride("bishopwater")

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

local function bishop_fn2()
    local inst = common_fn2("bishopboat_build")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishopwater')
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"

    return inst
end


local function onruinsrespawn(inst, respawner)
    if not respawner:IsAsleep() then
        inst.sg:GoToState("ruinsrespawn")
    end
end

return Prefab("bishopwater", bishop_fn, assets, prefabs),
    Prefab("bishopwaterfixo", bishop_fn2, assets, prefabs)
