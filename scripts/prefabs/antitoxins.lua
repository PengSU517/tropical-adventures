require("derives")

local assets =
{
    Asset("ANIM", "anim/poison_antidote.zip"),
    Asset("ANIM", "anim/poison_salve.zip"),
    Asset("ANIM", "anim/venom_gland.zip"),
}

local MAX_VENOM_GLAND_DAMAGE = 80
local MIN_VENOM_GLAND_LEFTOVER = 5

local function oneat(inst, eater)
    if not eater.components.poisonable then return end
    eater.components.poisonable:WearOff(TUNING.TOTAL_DAY_TIME / 2)
    return true
end

local function oneat_anti(inst, eater)
    if not oneat(inst, eater) or not eater:HasTag("player") then return end
    eater.AnimState:PlayAnimation("research")
end

local function oneat_gland(inst, eater)
    if not oneat(inst, eater) then return end
    local health = eater.components.health
    if not health then return end
    health:DoDelta(health.currenthealth - MIN_VENOM_GLAND_LEFTOVER < MAX_VENOM_GLAND_DAMAGE and
                   MIN_VENOM_GLAND_LEFTOVER - health.currenthealth or -MAX_VENOM_GLAND_DAMAGE, nil, "venomgland")
end

local function syrumpost(inst)
    inst.AnimState:SetBank("poison_antidote")
    inst.AnimState:SetBuild("poison_antidote")
    inst:AddTag("aquatic")
    inst:AddTag("preparedfood")

    if not TheWorld.ismastersim then return inst end

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_anti)

    return inst
end

local function balmpost(inst)
    inst.AnimState:SetBank("poison_salve")
    inst.AnimState:SetBuild("poison_salve")
    inst:AddTag("aquatic")
    inst:AddTag("preparedfood")

    if not TheWorld.ismastersim then return inst end

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_anti)

    return inst
end

local function glandpost(inst)
    inst.AnimState:SetBank("venom_gland")
    inst.AnimState:SetBuild("venom_gland")

    if not TheWorld.ismastersim then return inst end

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_gland)

    return inst
end

return Derive("bandage", "antivenom", syrumpost, assets),
    Derive("bandage", "poisonbalm", balmpost, assets),
    Derive("spidergland", "venomgland", glandpost, assets)