local assets =
{
    Asset("ANIM", "anim/marshberry.zip"),
    --Asset("MINIMAP_IMAGE", "thorns_marsh"),
}

local erode_assets =
{
    Asset("ANIM", "anim/ash.zip"),
}

local prefabs =
{
    "berries",
    "dug_marshberry",
}

local burnt_prefabs =
{
    "ash",
    "burnt_marsh_bush_erode",
}

local regrewSegs = 1440

local function ontransplantfn(inst)
    inst.components.pickable:MakeEmpty()
end

local function dig_up(inst, chopper)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        inst.components.lootdropper:SpawnLootPrefab("berries")
		inst.components.lootdropper:SpawnLootPrefab("berries")
    end
    inst.components.lootdropper:SpawnLootPrefab("dug_marshberry")
    inst:Remove()
end

local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked", true)
    if picker.components.combat ~= nil then
        picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE)
        picker:PushEvent("thorns")
    end
    inst.rain = regrewSegs + math.random(3) - 1
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("regen")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked")
    inst.AnimState:PushAnimation("picked", true)
end

local function DropAsh(inst, pos)
    if inst.components.lootdropper == nil then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SpawnLootPrefab("ash", pos)
end

local function OnActivateBurnt(inst)
    local pos = inst:GetPosition()
    inst:DoTaskInTime(.25 + math.random() * .05, DropAsh, pos)
    inst:AddTag("NOCLICK")
    inst.persists = false
    ErodeAway(inst)
    SpawnPrefab("burnt_marsh_bush_erode").Transform:SetPosition(pos:Get())
end

local function CheckRegrow(inst)
    if inst.components.pickable ~= nil and not inst.components.pickable:CanBePicked() and TheWorld.state.israining then
        inst.rain = inst.rain - 1
        if inst.rain <= 0 then
            inst.components.pickable:Regen()
        end
    end        
end

local function GetVerb()
    return STRINGS.ACTIONS.ACTIVATE.TOUCH
end


local function OnSave(inst, data)
    data.rain = inst.rain
end

local function OnLoad(inst, data)
    if data and data.rain then
        inst.rain = data.rain
    end
end

local function DebugString(inst)
    return(string.format("rain segs before regrow: %i", inst.rain))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("marshberry")
    inst.AnimState:SetBank("marshberry")

    if regrewSegs then
        inst.AnimState:PlayAnimation("idle", true)
    else
        inst.AnimState:PlayAnimation("picked", true)
    end

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("marshberry_mini.tex")
    inst.MiniMapEntity:SetPriority(-1)

    inst:AddTag("thorny")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random()*2)

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    if regrewSegs then
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
        inst.components.pickable:SetUp("berries", nil, 2)
        inst.components.pickable.onregenfn = onregenfn
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.ontransplantfn = ontransplantfn
        inst:DoPeriodicTask(TUNING.SEG_TIME, CheckRegrow)
        inst.rain = 0
    end
    
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("inspectable")

    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)
    MakeHauntableIgnite(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.debugstringfn = DebugString

    return inst
end

local function burnt_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("marshberry")
    inst.AnimState:SetBank("marshberry")
    inst.AnimState:PlayAnimation("burnt")

    inst:AddTag("thorny")
    inst:AddTag("burnt")

    inst.GetActivateVerb = GetVerb

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateBurnt

    return inst
end

local function PlayErodeAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("ashes")
    inst.AnimState:SetBuild("ash")
    inst.AnimState:PlayAnimation("disappear")
    inst.AnimState:SetMultColour(.4, .4, .4, 1)
    inst.AnimState:SetTime(13 * FRAMES)

    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble", nil, .2)

    inst:ListenForEvent("animover", inst.Remove)
end

local function burnt_erode_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

    inst:AddTag("FX")

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayErodeAnim)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Transform:SetRotation(math.random(360))

    inst.persists = false
    inst:DoTaskInTime(.5, inst.Remove)

    return inst
end

return Prefab("marshberry", fn, assets, prefabs),
    Prefab("burnt_marshberry", burnt_fn, assets, burnt_prefabs),
    Prefab("burnt_marshberry_erode", burnt_erode_fn, erode_assets)
