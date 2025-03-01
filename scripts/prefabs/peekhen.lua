require("brains/peekhenbrain")
require "stategraphs/SGpeekhen"

local assets =
{
    Asset("ANIM", "anim/buzzard_build.zip"),
    --Asset("ANIM", "anim/buzzard_shadow.zip"),
    Asset("ANIM", "anim/buzzard_basic.zip"),
    Asset("ANIM", "anim/peekhen_build.zip"),
    --Asset("SOUND", "sound/buzzard.fsb"),
}

local prefabs =
{

}

SetSharedLootTable('buzzard',
    {
        { 'drumstick',      1.00 },
        { 'smallmeat',      1.00 },
        { 'smallmeat',      0.33 },
        { 'peagawkfeather', 0.33 },
    })

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target) and
        inst:GetDistanceSqToInst(target) <= (7.5 * 7.5)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function OnHitOther(inst, data)

end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function canbeattacked(inst, attacked)
    return not inst.sg:HasStateTag("flying")
end


local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    shadow:SetSize(1.25, .75)
    inst.Transform:SetFourFaced()
    MakeCharacterPhysics(inst, 15, .25)
    --   MakePoisonableCharacter(inst)

    anim:SetBank("buzzard")
    anim:SetBuild("peekhen_build")
    anim:PlayAnimation("idle", true)

    ------------------------------------------

    inst:AddTag("buzzard")
    inst:AddTag("peekhen")
    inst:AddTag("animal")
    inst:AddTag("scarytoprey")

    ------------------------------------------

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BUZZARD_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BUZZARD_DAMAGE)
    inst.components.combat:SetRange(TUNING.BUZZARD_ATTACK_RANGE)
    inst.components.combat.hiteffectsymbol = "buzzard_body"
    inst.components.combat:SetAttackPeriod(TUNING.BUZZARD_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/buzzard/hurt")
    inst.components.combat.canbeattackedfn = canbeattacked
    ------------------------------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('buzzard')

    ------------------------------------------

    inst:AddComponent("inspectable")

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother", OnHitOther)

    ------------------------------------------

    MakeMediumBurnableCharacter(inst, "buzzard_body")
    MakeMediumFreezableCharacter(inst, "buzzard_body")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BUZZARD_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.BUZZARD_RUN_SPEED

    inst:SetStateGraph("SGpeekhen")
    local brain = require("brains/peekhenbrain")
    inst:SetBrain(brain)

    return inst
end

return Prefab("common/monsters/peekhen", fn, assets, prefabs)
