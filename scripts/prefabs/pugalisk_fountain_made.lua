require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/python_fountain.zip"),
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
end

local function TurnOff(inst)
    inst.AnimState:PlayAnimation("flow_pst")
    inst.AnimState:PushAnimation("off", true)
    inst.SoundEmitter:KillSound("burble")
    inst.components.machine.ison = false
    inst.components.watersource.available = false
end

local function CanInteract(inst)
    if inst.components.machine.ison then
        return false
    end
    return true
end


local function onhit(inst, dist)
    -- inst.sg:GoToState("hit")
    if inst.components.machine.ison then
        inst.AnimState:PlayAnimation("flow_pst")
        inst.AnimState:PushAnimation("off", true)
        inst.SoundEmitter:KillSound("burble")
        inst.components.machine.ison = false
        inst.components.watersource.available = false
    end
end

local function OnBuilt(inst)
    -- inst.sg:GoToState("place")
    inst.AnimState:PlayAnimation("flow_pre")
    inst.AnimState:PushAnimation("flow_loop", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    inst.components.machine.ison = true
    inst.components.watersource.available = true
end

local function OnSave(inst, data)
    local refs = {}
    return refs
end

local function OnLoad(inst, data)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetScale(0.90, 0.90, 0.90)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pig_ruins_well.png") ----------"kyno_pigruins_well.tex"

    inst.AnimState:SetBank("fountain")
    inst.AnimState:SetBuild("python_fountain")
    inst.AnimState:PlayAnimation("off", true)

    inst.on = true

    MakeObstaclePhysics(inst, 0.5)

    inst:AddTag("structure")
    inst:AddTag("pugalisk_fountain")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    -----------------还是没有制作台词
    -- inst.components.inspectable.nameoverride = "pugalisk_fountain"
    -- inst.name = STRINGS.NAMES.PUGALISK_FOUNTAIN ----------套用别的prefab的名字
    inst:AddComponent("lootdropper")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.caninteractfn = CanInteract
    inst.components.machine.cooldowntime = 0.5

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("watersource")
    -- inst:RemoveComponent("watersource")
    inst.components.watersource.available = true

    -- inst:SetStateGraph("SGfountain")

    inst:ListenForEvent("onbuilt", OnBuilt)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function fountainplacetestfn(inst)
    inst.AnimState:SetScale(0.90, 0.90, 0.90)
end

return Prefab("pugaliskfountain_made", fn, assets, prefabs),
    MakePlacer("pugaliskfountain_made_placer", "fountain", "python_fountain", "flow_loop", false, nil, nil, nil, nil, nil,
        fountainplacetestfn)
