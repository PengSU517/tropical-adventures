local assets = {
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("ANIM", "anim/ds_pig_boat_jump.zip"),
    Asset("ANIM", "anim/wildbeaverguard_build.zip"),
    Asset("ANIM", "anim/werebeaver_dance.zip"),
    Asset("ANIM", "anim/werepig_basic.zip"),
    Asset("ANIM", "anim/werebeaver_groggy.zip"),
    Asset("ANIM", "anim/werepig_actions.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs = {
    "log",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30
local CHOP_WAIT_DURATION = 20
local TREESDUE_THRESHOLD = 3

local SEED_TYPES = {
    "jungletreeseed",
    "pinecone",
    "acorn",
    "twiggy_nut",
    "cottontree_cone",
    "coconut",
    "tree_forestseed",
}

local function IsTreeSeed(item)
    for i, seedtype in ipairs(SEED_TYPES) do
        if (type(item) == "table" and seedtype == item.prefab) or
            (type(item) ~= "table" and seedtype == item) then
            return true
        end
    end
    return false
end

local function CalcSanityAura(inst, observer)
    return (inst.components.follower ~= nil and inst.components.follower.leader == observer and TUNING.SANITYAURA_SMALL)
        or 0
end

local function ShouldAcceptItem(inst, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    end
    if item.components.edible ~= nil then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.WOOD then
            return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= 0.9
        end
    end
    return false
end

local function WantsToChop(inst)
    if TheWorld.state.timeinphase < 0.1 and TheWorld.state.isday then
        return true
    end

    if TheWorld.state.timeinphase > 0.40 and TheWorld.state.timeinphase < 0.50 and TheWorld.state.isday then
        return true
    end

    if TheWorld.state.timeinphase > 0.80 and TheWorld.state.timeinphase < 0.9 and TheWorld.state.isday then
        return true
    end
    return false
end

local function ontalk(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
end

local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible ~= nil then
        --meat makes us friends (unless I'm a guard)
        if item.components.edible.foodtype == FOODTYPE.WOOD then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader ~= nil then
                giver:PushEvent("makefriend")
                giver.components.leader:AddFollower(inst)
                inst.components.follower:AddLoyaltyTime(TUNING.CALORIES_SMALL * TUNING.PIG_LOYALTY_PER_HUNGER)
                inst.components.follower.maxfollowtime =
                    giver:HasTag("polite")
                    and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                    or TUNING.PIG_LOYALTY_MAXTIME
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    --I wear hats
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local WALL_WOOD_COST = 20

local function CraftWall(inst)
    if inst.woodmeter >= WALL_WOOD_COST then
        local item = SpawnPrefab("wall_wood_item")
        inst.components.inventory:GiveItem(item)
        inst.woodmeter = inst.woodmeter - WALL_WOOD_COST
    end
end

local function OnDeployItem(inst, data)
    local prefab = data.prefab
    if IsTreeSeed(prefab) then
        inst.treesdue = inst.treesdue - 1
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food.components.edible.foodtype == FOODTYPE.WOOD then
            --inst.treesdue = inst.treesdue + 1
            inst.woodmeter = inst.woodmeter + food.components.edible.woodiness
            --CraftWall(inst)
        end
        if food.components.edible.foodtype == FOODTYPE.VEGGIE then
            SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
end

local function OnAttackedByDecidRoot(inst, attacker)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SpringCombatMod(SHARE_TARGET_DIST) * .5,
        { "_combat", "_health", "wildbeaver" }, { "INLIMBO" })
    local num_helpers = 0
    for i, v in ipairs(ents) do
        if v ~= inst and not v.components.health:IsDead() then
            v:PushEvent("suggest_tree_target", { tree = attacker })
            num_helpers = num_helpers + 1
            if num_helpers >= MAX_TARGET_SHARES then
                break
            end
        end
    end
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    if attacker ~= nil then
        inst:ClearBufferedAction()
        if attacker.prefab == "deciduous_root" and attacker.owner ~= nil then
            OnAttackedByDecidRoot(inst, attacker.owner)
        else
            inst.components.combat:SetTarget(attacker)
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(x) x:HasTag("wildbeaver") end,
                MAX_TARGET_SHARES)
        end
    end
end

local function OnNewTarget(inst, data)
    return
end

local function NormalRetargetFn(inst)
    return FindEntity(
        inst,
        TUNING.PIG_TARGET_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat", "monster" }, -- see entityreplica.lua
        inst.components.follower.leader ~= nil and
        { "playerghost", "INLIMBO", "abigail" } or
        { "playerghost", "INLIMBO" }
    )
end

local function NormalKeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function NormalShouldSleep(inst)
    return DefaultSleepTest(inst)
end

local function GetStatus(inst)
    return (inst.components.follower.leader ~= nil and "FOLLOWER")
        or nil
end

local function SuggestTreeTarget(inst, data)
    if data ~= nil and data.tree ~= nil and inst:GetBufferedAction() ~= ACTIONS.CHOP then
        inst.tree_target = data.tree
    end
end

local function Reset(inst)
    inst.treesdue = 10
    inst.chop = 1
end


local brain = require "brains/wildbeaverbrain"

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst:AddTag("character")
    --inst:AddTag("beaver") >> Apparently this has unintended side-effects
    inst:AddTag("wildbeaver")
    inst:AddTag("wildbeaverguard")
    inst:AddTag("scarytoprey")
    inst:AddTag("walrus")
    inst:AddTag("houndfriend")

    inst.AnimState:SetBuild("wildbeaver_guard")
    inst.AnimState:SetBank("werebeaver")
    inst.AnimState:PlayAnimation("idle_loop")
    --inst.AnimState:Hide("hat")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph

    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    -- boat hopping setup
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")

    inst:SetBrain(brain)
    inst:SetStateGraph("SGwildbeaver")

    -- inst:AddComponent("sleeper")
    -- inst.components.sleeper:SetResistance(2)

    inst:AddComponent("bloomer")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.WOOD }, { FOODGROUP.WOOD })
    -- inst.components.eater:SetCanEatHorrible()
    -- inst.components.eater:SetCanEatRaw()
    -- inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)

    MakeMediumBurnableCharacter(inst, "torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.WILDBEAVER_NAMES
    inst.components.named:PickNewName()

    MakeHauntablePanic(inst)

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

    inst.components.talker.ontalk = ontalk

    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat", 3)
    inst.components.lootdropper:AddRandomLoot("beaverskin", 1)
    inst.components.lootdropper.numrandomloot = 1
    --    inst.components.lootdropper:AddChanceLoot("wildbeaver_house_blueprint", 0.1)

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.acceptnontradable = true
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader:Enable()

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(NormalShouldSleep)
    inst.components.sleeper:SetWakeTest(DefaultWakeTest)

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    ------------------------------------------
    inst.WantsToChop = WantsToChop
    inst.IsTreeSeed = IsTreeSeed
    inst.treesdue = 0
    inst.woodmeter = 0
    inst.chop = 1

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)
    inst:ListenForEvent("deployitem", OnDeployItem)
    inst:WatchWorldState("startday", Reset)
    return inst
end

return Prefab("wildbeaver", fn, assets, prefabs)
