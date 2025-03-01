local assets = {
    Asset("ANIM", "anim/chiminea_fire.zip"),
}

local heats = { 70, 85, 100, 115 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 20
end

local firelevels =
{
    { anim = "level1", sound = "ia/common/chiminea_fire_lp", radius = 2, intensity = .8, falloff = .33, colour = { 255 / 255, 255 / 255, 192 / 255 }, soundintensity = .1 },
    { anim = "level2", sound = "ia/common/chiminea_fire_lp", radius = 3, intensity = .8, falloff = .33, colour = { 255 / 255, 255 / 255, 192 / 255 }, soundintensity = .3 },
    { anim = "level3", sound = "ia/common/chiminea_fire_lp", radius = 4, intensity = .8, falloff = .33, colour = { 255 / 255, 255 / 255, 192 / 255 }, soundintensity = .6 },
    { anim = "level4", sound = "ia/common/chiminea_fire_lp", radius = 5, intensity = .8, falloff = .33, colour = { 255 / 255, 255 / 255, 192 / 255 }, soundintensity = 1 },
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("chiminea_fire")
    inst.AnimState:SetBuild("chiminea_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(1)
    inst.components.firefx.usedayparamforsound = true

    return inst
end

return Prefab("chimineafire", fn, assets)
