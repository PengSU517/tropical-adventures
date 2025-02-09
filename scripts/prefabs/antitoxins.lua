local assets =
{
    Asset("ANIM", "anim/poison_antidote.zip"),
    Asset("ANIM", "anim/poison_salve.zip"),
    Asset("ANIM", "anim/venom_gland.zip"),
}

local MAX_VENOM_GLAND_DAMAGE = 80
local MIN_VENOM_GLAND_LEFTOVER = 5

local function oneat(inst, eater)
    if eater.components.poisonable then
        eater.components.poisonable:WearOff()
    end
end

local function oneat_gland(inst, eater)
    oneat(inst, eater)

    local health = eater.components.health
    if not health then return end

    health:DoDelta(health.currenthealth - MIN_VENOM_GLAND_LEFTOVER < MAX_VENOM_GLAND_DAMAGE and
                   MIN_VENOM_GLAND_LEFTOVER - health.currenthealth or -MAX_VENOM_GLAND_DAMAGE, nil, "venomgland")
end

local function MakeAntitoxin(name, build, oneatfn, tags)
    return Prefab(name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle")

        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        ---------------------

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")

        inst:AddComponent("stackable")
        inst:AddComponent("tradable")

        local edible = inst:AddComponent("edible")
        edible.healthvalue = 0
        edible.hungervalue = 0
        edible.foodtype = FOODTYPE.GOODIES
        edible.secondaryfoodtype = FOODTYPE.ROUGHAGE
        edible.sanityvalue = 0
        edible.temperaturedelta = 0
        edible.temperatureduration = 0
        edible:SetOnEatenFn(oneatfn)

        return inst
    end, assets)
    
end

return MakeAntitoxin("antivenom", "poison_antidote", oneat, {"aquatic", "preparedfood"}),
    MakeAntitoxin("poisonbalm", "poison_salve", oneat, {"aquatic", "preparedfood"}),
    MakeAntitoxin("venomgland", "venom_gland", oneat_gland, {"cattoy"})

