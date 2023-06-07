local assets =
{
    Asset("ANIM", "anim/lizardman_cave.zip"),
}

local prefabs = {"lizardman"}

local function TryReleaseChild(inst, phase)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst:DoTaskInTime(math.random(1, 10), function() inst.components.spawner:ReleaseChild() end)
    end
end

local function SpawnCheckCaveDay(inst)
    inst.inittask = nil
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        --if not TheWorld.state.iscaveday then
            inst.components.spawner:ReleaseChild()
        --end
    end
end

local function OnInit(inst)
    inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckCaveDay)
    if inst.components.spawner ~= nil and
        inst.components.spawner.child == nil and
        inst.components.spawner.childname ~= nil and
        not inst.components.spawner:IsSpawnPending() then
        local child = SpawnPrefab(inst.components.spawner.childname)
        if child ~= nil then
            inst.components.spawner:TakeOwnership(child)
            inst.components.spawner:GoHome(child)
        end
    end
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("dragoon_den.png")

    MakeObstaclePhysics(inst, 1.0)
 
    inst.AnimState:SetBank("dragoon_den")
    inst.AnimState:SetBuild("lizardman_c")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.0, 1.0, 1.0)

    inst:AddTag("lizardman_cave")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("spawner")
    inst.components.spawner:Configure("lizardman", TUNING.TOTAL_DAY_TIME)
    inst.components.spawner:CancelSpawning()
    inst:WatchWorldState("phase", TryReleaseChild)
    inst:DoTaskInTime(0, OnInit)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("dragoon_den.png")

    MakeObstaclePhysics(inst, 1.0)
 
    inst.AnimState:SetBank("dragoon_den")
    inst.AnimState:SetBuild("lizardman_c")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.0, 1.0, 1.0)

    inst:AddTag("lizardman_cave")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("spawner")
    inst.components.spawner:Configure("gw_yellow_lizardman", TUNING.TOTAL_DAY_TIME)
    inst.components.spawner:CancelSpawning()
    inst:WatchWorldState("phase", TryReleaseChild)
    inst:DoTaskInTime(0, OnInit)

    return inst
end

return  Prefab("lizardman_cave", fn, assets, prefabs),
		Prefab("lizardman_cave2", fn2, assets, prefabs)