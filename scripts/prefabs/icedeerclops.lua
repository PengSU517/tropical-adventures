local brain = require "brains/deerclopsbrain"

local assets =
{
    Asset("ANIM", "anim/deerclops_basic.zip"),
    Asset("ANIM", "anim/deerclops_actions.zip"),
    Asset("ANIM", "anim/deerclops_build.zip"),
    Asset("ANIM", "anim/deerclops_yule.zip"),
    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs =
{
    "meat",
    "deerclops_eyeball",
    "chesspiece_deerclops_sketch",
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4",
    "deerclops_laser",
    "deerclops_laserempty",
    "winter_ornament_light1",
}

local normal_sounds =
{
    step = "dontstarve/creatures/deerclops/step",
    taunt_grrr = "dontstarve/creatures/deerclops/taunt_grrr",
    taunt_howl = "dontstarve/creatures/deerclops/taunt_howl",
    hurt = "dontstarve/creatures/deerclops/hurt",
    death = "dontstarve/creatures/deerclops/death",
    attack = "dontstarve/creatures/deerclops/attack",
    swipe = "dontstarve/creatures/deerclops/swipe",
    charge = "dontstarve/creatures/deerclops/charge",
    walk = nil,
}

local TARGET_DIST = 16
local STRUCTURES_PER_HARASS = 5

local function IsSated(inst)
    return inst.structuresDestroyed >= STRUCTURES_PER_HARASS
end

local function CalcSanityAura(inst)
    return inst.components.combat.target ~= nil and -TUNING.SANITYAURA_HUGE or -TUNING.SANITYAURA_LARGE
end

local function FindBaseToAttack(inst, target)
    local structure = GetClosestInstWithTag("structure", target, 40)
    if structure ~= nil then
        inst.components.knownlocations:RememberLocation("targetbase", structure:GetPosition())
        inst.AnimState:ClearOverrideSymbol("deerclops_head")
    end
end

local function RetargetFn(inst)
    local range = inst:GetPhysicsRadius(0) + 8
    return FindEntity(
        inst,
        TARGET_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and (guy.components.combat:TargetIs(inst) or
                    guy:IsNear(inst, range)
                )
        end,
        { "_combat" },
        { "prey", "smallcreature", "INLIMBO" }
    )
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function AfterWorking(inst, data)
    if data.target then
        local recipe = AllRecipes[data.target.prefab]
        if recipe then
            inst.structuresDestroyed = inst.structuresDestroyed + 1
            if inst:IsSated() then
                inst.components.knownlocations:ForgetLocation("targetbase")
                inst.AnimState:OverrideSymbol("deerclops_head", "deerclops_yule", "deerclops_head_neutral")
            end
        end
    end
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function OnSave(inst, data)
    data.structuresDestroyed = inst.structuresDestroyed
end

local function OnLoad(inst, data)
    if data then
        inst.structuresDestroyed = data.structuresDestroyed or inst.structuresDestroyed
    end
end

local function OnRemove(inst)
    if inst.spikefire ~= nil then
        inst.spikefire:Remove()
        inst.spikefire = nil
    end
    if inst.sg.mem.circle ~= nil then
        inst.sg.mem.circle:KillFX()
        inst.sg.mem.circle = nil
    end
    if inst.icespike_pool ~= nil then
        for i, v in ipairs(inst.icespike_pool) do
            v:Remove()
        end
        inst.icespike_pool = nil
    end
    TheWorld:PushEvent("hasslerremoved", inst)
end

local function OnDead(inst)
    --V2C: make sure we're still burning by the time we actually reach death in stategraph
    if inst.components.burnable:IsBurning() then
        inst.components.burnable:SetBurnTime(nil)
        inst.components.burnable:ExtendBurning()
    end
    AwardRadialAchievement("deerclops_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
    TheWorld:PushEvent("hasslerkilled", inst)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    if data.attacker:HasTag("player") and inst.structuresDestroyed < STRUCTURES_PER_HARASS and inst.components.knownlocations:GetLocation("targetbase") == nil then
        FindBaseToAttack(inst, data.attacker)
    end
end

local function OnHitOther(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.freezable ~= nil then
                other.components.freezable:AddColdness(2)
            end
            if other.components.temperature ~= nil then
                local mintemp = math.max(other.components.temperature.mintemp, 0)
                local curtemp = other.components.temperature:GetCurrent()
                if mintemp < curtemp then
                    other.components.temperature:DoDelta(math.max(-5, mintemp - curtemp))
                end
            end
        end
        if other.components.freezable ~= nil then
            other.components.freezable:SpawnShatterFX()
        end
    end
end


local function oncollapse(inst, other)
    if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
    end
end

local function oncollide(inst, other)
    if other ~= nil and
        (other:HasTag("tree") or other:HasTag("boulder")) and --HasTag implies IsValid
        Vector3(inst.Physics:GetVelocity()):LengthSq() >= 1 then
        inst:DoTaskInTime(2 * FRAMES, oncollapse, other)
    end
end

local function OnNewTarget(inst, data)
    FindBaseToAttack(inst, data.target or inst)
    if inst.components.knownlocations:GetLocation("targetbase") and data.target:HasTag("player") then
        inst.structuresDestroyed = inst.structuresDestroyed - 1
        inst.components.knownlocations:ForgetLocation("home")
    end
end

local function OnNewState(inst, data)
    if not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("waking")) then
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
    end
end

local loot = { "meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "deerclops_eyeball",
    "chesspiece_deerclops_sketch" }

local function WantsToLeave(inst)
    return false
end

local function SwitchToEightFaced(inst)
    if not inst._temp8faced then
        inst._temp8faced = true
        inst.Transform:SetEightFaced()
    end
end

local function SwitchToFourFaced(inst)
    if inst._temp8faced then
        inst._temp8faced = false
        inst.Transform:SetFourFaced()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.sounds = normal_sounds

    MakeGiantCharacterPhysics(inst, 1000, .5)

    local s = 1.65
    inst.Transform:SetScale(s, s, s)
    inst.DynamicShadow:SetSize(6, 3.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    --    inst:AddTag("deerclops")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")

    inst.AnimState:SetBank("deerclops")

    inst.AnimState:SetBuild("deerclops_yule")

    inst.entity:AddLight()
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(8)
    inst.Light:SetFalloff(3)
    inst.Light:SetColour(1, 0, 0)

    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide)

    inst.structuresDestroyed = 0
    inst.icespike_pool = {}

    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 3

    ------------------------------------------
    inst:SetStateGraph("SGdeerclops")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    MakeLargeBurnableCharacter(inst, "deerclops_body")
    MakeHugeFreezableCharacter(inst, "deerclops_body")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEERCLOPS_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DEERCLOPS_DAMAGE)
    inst.components.combat.playerdamagepercent = TUNING.DEERCLOPS_DAMAGE_PLAYER_PERCENT
    inst.components.combat:SetRange(TUNING.DEERCLOPS_ATTACK_RANGE)
    inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE, TUNING.DEERCLOPS_AOE_SCALE)
    inst.components.combat.hiteffectsymbol = "deerclops_body"
    inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    ------------------------------------------
    inst:AddComponent("explosiveresist")

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
    ------------------------------------------
    inst:AddComponent("knownlocations")
    inst:SetBrain(brain)

    inst:ListenForEvent("working", AfterWorking)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDead)
    inst:ListenForEvent("onremove", OnRemove)
    inst:ListenForEvent("onhitother", OnHitOther)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.IsSated = IsSated
    inst.WantsToLeave = WantsToLeave
    inst.SwitchToEightFaced = SwitchToEightFaced
    inst.SwitchToFourFaced = SwitchToFourFaced

    inst:AddComponent("timer")
    inst:ListenForEvent("newstate", OnNewState)

    return inst
end

return Prefab("icedeerclops", fn, assets, prefabs)
