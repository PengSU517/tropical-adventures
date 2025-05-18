require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/chicken_house.zip"),
}

local prefabs =
{
    "chicken",
    "bird_egg",
}

local levels =
{
    { amount = 3, idle = "egg3", hit = "hit_egg3" },
    { amount = 2, idle = "egg2", hit = "hit_egg2" },
    { amount = 1, idle = "egg1", hit = "hit_egg1" },
    { amount = 0, idle = "idle", hit = "hit" },
}

local function Stop(inst)
    if inst.components.harvestable ~= nil and inst.components.harvestable.growtime ~= nil then
        inst.components.harvestable:PauseGrowing()
    end
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function Start(inst)
    if not inst:HasTag("burnt") then
        if inst.components.harvestable ~= nil then
            inst.components.harvestable:StartGrowing()
        end
        if not TheWorld.state.iswinter and inst.components.childspawner ~= nil then
            inst.components.childspawner:StartSpawning()
        end
    end
end

local function OnBuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.components.harvestable ~= nil then
        inst.components.harvestable:Harvest()
    end
    -- inst:RemoveComponent("childspawner")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnAt("collapse_big", inst)
    fx:SetMaterial("wood")
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker)
        end
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle, false)
    end
end

local function OnIgnite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function OnBurnt(inst)
    inst.AnimState:PlayAnimation("burnt")
end

local function OnIsDay(inst, isday)
    if isday and not inst:HasTag("burnt") then
        Start(inst)
    else
        Stop(inst)
    end
end

local function UpdateLevel(inst)
    if not inst:HasTag("burnt") then
        local produce = inst.components.harvestable.produce
        for k, v in ipairs(levels) do
            if produce >= v.amount then
                inst.anims = { idle = v.idle, hit = v.hit }
                break
            end
        end
        inst.AnimState:PlayAnimation(inst.anims.idle)
    end
end

local function OnHarvest(inst, picker)
    if not inst:HasTag("burnt") and inst.components.harvestable then
        inst.components.harvestable:SetGrowTime(nil)
        inst.components.harvestable.pausetime = nil
        inst.components.harvestable:StopGrowing()
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
        UpdateLevel(inst)
    end
end

local function onchildgoinghome(inst, data)
    if not inst:HasTag("burnt") and
        data.child ~= nil and
        data.child.hadeaten ~= nil and
        data.child.hadeaten >= 2 and
        inst.components.harvestable ~= nil then
        data.child.hadeaten = data.child.hadeaten - 2
        inst.components.harvestable:Grow()
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    else
        UpdateLevel(inst)
    end
end

local function OnPreLoad(inst, data)
    WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.BEEBOX_RELEASE_TIME, TUNING.BEEBOX_REGEN_TIME)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(1.73, 1.73, 1.73)
    inst.AnimState:SetScale(1.73, 1.73, 1.73)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("chickenhouse.png")

    anim:SetBank("chicken_house")
    anim:SetBuild("chicken_house")
    anim:PlayAnimation("idle", true)

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "chicken"
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME)
    inst.components.childspawner:SetSpawnPeriod(40)
    inst.components.childspawner:SetMaxChildren(3)
    WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.BEEBOX_RELEASE_TIME, true)
    WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.BEEBOX_REGEN_TIME, true)

    if TheWorld.state.isday and not TheWorld.state.iswinter then
        inst.components.childspawner:StartSpawning()
    end

    inst:AddComponent("harvestable")
    inst.components.harvestable:SetUp("bird_egg", 3, nil, OnHarvest, UpdateLevel)
    inst.components.harvestable.produce = 0
    inst:ListenForEvent("childgoinghome", onchildgoinghome)

    inst:AddComponent("inspectable")

    inst:WatchWorldState("isday", OnIsDay)

    UpdateLevel(inst)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)

    inst:ListenForEvent("onignite", OnIgnite)
    inst:ListenForEvent("burntup", OnBurnt)
    inst:ListenForEvent("onbuilt", OnBuilt)

    MakeSnowCovered(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnPreLoad = OnPreLoad

    return inst
end

return Prefab("chickenhouse", fn, assets, prefabs),
    MakePlacer("chickenhouse_placer", "chicken_house", "chicken_house", "idle", nil, nil, nil, 3)
