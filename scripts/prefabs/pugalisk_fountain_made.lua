require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/python_fountain_lunar.zip"),
}

local prefabs =
{

}


local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    inst:Remove()
end

local function TurnOn(inst)
    inst.AnimState:PlayAnimation("flow_pre")
    inst.AnimState:PushAnimation("flow_loop", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    inst.components.machine.ison = true
    inst.components.watersource.available = true
    inst.is_on = true
end

local function TurnOff(inst)
    inst.AnimState:PlayAnimation("flow_pst")
    inst.AnimState:PushAnimation("off", true)
    inst.SoundEmitter:KillSound("burble")
    inst.components.machine.ison = false
    inst.components.watersource.available = false
    inst.is_on = false
end

local function CanInteract(inst)
    if inst.components.machine.ison then
        return false
    end
    return true
end


local function onhit(inst, dist)
    if inst.components.machine and inst.components.machine.ison then
        inst.AnimState:PlayAnimation("flow_pst")
        inst.AnimState:PushAnimation("off", true)
        inst.SoundEmitter:KillSound("burble")
        inst.components.machine.ison = false
        inst.components.watersource.available = false
    end
end

local function CalcSanityAura(inst, observer)
    return TUNING.SANITYAURA_LARGE
end

SetSharedLootTable('pugalisk_fountain_made',
    {
        { 'waterdrop', 1.0 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
        { 'ice',       0.5 },
    })


local function OnFinished(inst)
    inst:AddTag("shadecanopy") --防止自然、过热和玻璃雨的标签
    inst:RemoveComponent("constructionsite")

    if inst.components.lootdropper then
        inst.components.lootdropper:SetChanceLootTable('pugalisk_fountain_made')
    end

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.caninteractfn = CanInteract
    inst.components.machine.cooldowntime = 0.5

    inst:AddComponent("watersource")
    inst.components.watersource.available = true

    inst.components.machine.ison = inst.is_on and true or false
    inst.components.watersource.available = inst.is_on and true or false

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    if inst.is_on then
        inst.AnimState:PlayAnimation("flow_pre")
        inst.AnimState:PushAnimation("flow_loop", true)
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    end
end

local function OnConstructed(inst, doer)
    local concluded = true
    for _, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
        if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
            concluded = false
            break
        end
    end

    if concluded then
        inst.has_constructed = true
        inst.is_on = true
        OnFinished(inst)
    end
end

local function OnSave(inst, data)
    data.has_constructed = inst.has_constructed or false
    data.is_on = inst.has_constructed and inst.is_on or false
end

local function OnLoad(inst, data)
    inst.has_constructed = data.has_constructed
    inst.is_on = data.is_on
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetScale(0.80, 0.80, 0.80)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pugalisk_fountain.tex")

    inst.AnimState:SetBank("fountain")
    inst.AnimState:SetBuild("python_fountain_lunar")
    inst.AnimState:PlayAnimation("off", true)



    MakeObstaclePhysics(inst, 0.5)

    inst:AddTag("structure")
    inst:AddTag("pugalisk_fountain")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddTag("constructionsite")
    local constructionsite = inst:AddComponent("constructionsite")
    constructionsite:SetConstructionPrefab("construction_container")
    constructionsite:SetOnConstructedFn(OnConstructed)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    inst.components.workable:SetWorkLeft(4)


    inst.has_constructed = false

    inst:DoTaskInTime(0, function(inst)
        if inst.has_constructed then
            OnFinished(inst)
        end
    end)


    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function fountainplacetestfn(inst)
    inst.AnimState:SetScale(0.80, 0.80, 0.80)
end

return Prefab("pugaliskfountain_made", fn, assets, prefabs),
    MakePlacer("pugaliskfountain_made_placer", "fountain", "python_fountain_lunar", "flow_loop", false, nil, nil, nil,
        nil, nil, fountainplacetestfn)
