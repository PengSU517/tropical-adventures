local assets =
{
    Asset("ANIM", "anim/hedge.zip"),
    Asset("ANIM", "anim/hedge1_build.zip"),
    Asset("ANIM", "anim/hedge2_build.zip"),
    Asset("ANIM", "anim/hedge3_build.zip"),
}

local prefabs =
{
    "clippings",
    "collapse_small",
}

local respawndays = math.random(4800, 9600) --tempo para renascer de 3 a 5 dias

local function setobstical(inst)
    local ground = TheWorld
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
    end
end

local function ondeploywall1(inst, pt, deployer)
    local wall = SpawnPrefab("hedge_block")
    if wall ~= nil then
        local x = math.floor(pt.x) + .5
        local z = math.floor(pt.z) + .5
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(x, 0, z)
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
end

local function ondeploywall2(inst, pt, deployer)
    local wall = SpawnPrefab("hedge_cone")
    if wall ~= nil then
        local x = math.floor(pt.x) + .5
        local z = math.floor(pt.z) + .5
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(x, 0, z)
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
end

local function ondeploywall3(inst, pt, deployer)
    local wall = SpawnPrefab("hedge_layered")
    if wall ~= nil then
        local x = math.floor(pt.x) + .5
        local z = math.floor(pt.z) + .5
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(x, 0, z)
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
end

local function itemfn1(Sim)

    local inst = CreateEntity()
    inst:AddTag("wallbuilder")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge1_build")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    --inst:AddComponent("appeasement")
    --inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall1
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

    MakeHauntableLaunch(inst)

    return inst
end

local function itemfn2(Sim)

    local inst = CreateEntity()
    inst:AddTag("wallbuilder")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge2_build")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    --inst:AddComponent("appeasement")
    --inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall2
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

    MakeHauntableLaunch(inst)

    return inst
end

local function itemfn3(Sim)

    local inst = CreateEntity()
    inst:AddTag("wallbuilder")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge3_build")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    --inst:AddComponent("appeasement")
    --inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall3
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

    MakeHauntableLaunch(inst)

    return inst
end

local function OnTimerDone(inst, data)
    if data.name == "spawndelay" then
        inst.AnimState:PlayAnimation("growth1to2")
        inst.AnimState:PushAnimation("growth2to3")
        inst.AnimState:PushAnimation("growth3", true)
        inst:AddTag("machetecut")
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetWorkAction(ACTIONS.HACK)
    end
end

local function cut_up(inst, worker)
    if inst:HasTag("machetecut") then
        inst:RemoveTag("machetecut")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.lootdropper:SpawnLootPrefab("clippings")
        inst.components.timer:StartTimer("spawndelay", respawndays)

        return
    end

    if not inst:HasTag("machetecut") then
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("clippings")

        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SpawnLootPrefab("nitre")
            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
        end
        inst:Remove()
    end
end

local function onhackedfn(inst, hacker, hacksleft)
    if not inst:HasTag("machetecut") then return end
    local fx = SpawnPrefab("green_leaves_chop")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y, z)

    if (hacksleft <= 0) then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("growth1")
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("growth2")
    end

    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
end


local function OnSave(inst, data)
    if not inst:HasTag("machetecut") then
        data.tag = 1
    end
end

local function OnLoad(inst, data)
    if data and data.tag == 1 then
        inst.AnimState:PlayAnimation("growth1")
        inst:RemoveTag("machetecut")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
    end
end

local function onbuilt(inst)
    if inst:HasTag("machetecut") then
        inst:RemoveTag("machetecut")
    end
    if inst.components.workable then
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.timer:StartTimer("spawndelay", respawndays)
    end
    inst.AnimState:PlayAnimation("growth1")
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetEightFaced()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge1_build")
    inst.AnimState:PlayAnimation("growth3", true)
    MakeObstaclePhysics(inst, .5)

    inst:AddTag("wall")
    inst:AddTag("grass")
    inst:AddTag("hedge")
    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    inst.components.workable:SetOnFinishCallback(cut_up)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable.onwork = onhackedfn

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst:ListenForEvent("onbuilt", onbuilt)

    inst.setobstical = setobstical  -----加上墙的寻路特性
    inst:AddComponent("gridnudger") ------------加上这个就只能放在墙点,这两个必须同时使用

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetEightFaced()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge2_build")
    inst.AnimState:PlayAnimation("growth2", true)
    MakeObstaclePhysics(inst, .5)

    inst:AddTag("wall")
    inst:AddTag("grass")
    inst:AddTag("hedge")
    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    inst.components.workable:SetOnFinishCallback(cut_up)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable.onwork = onhackedfn

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst:ListenForEvent("onbuilt", onbuilt)

    inst.setobstical = setobstical  -----加上墙的寻路特性
    inst:AddComponent("gridnudger") ------------加上这个就只能放在墙点,这两个必须同时使用

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetEightFaced()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge3_build")
    inst.AnimState:PlayAnimation("growth2", true)
    MakeObstaclePhysics(inst, .5)

    inst:AddTag("wall")
    inst:AddTag("grass")
    inst:AddTag("hedge")
    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    inst.components.workable:SetOnFinishCallback(cut_up)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable.onwork = onhackedfn

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst:ListenForEvent("onbuilt", onbuilt)

    inst.setobstical = setobstical  -----加上墙的寻路特性
    inst:AddComponent("gridnudger") ------------加上这个就只能放在墙点,这两个必须同时使用

    return inst
end

return Prefab("hedge_block_item", itemfn1, assets, {"hedge_block_item_placer", "collapse_small"}),
    Prefab("hedge_cone_item", itemfn2, assets, {"hedge_cone_item_placer", "collapse_small"}),
    Prefab("hedge_layered_item", itemfn3, assets, {"hedge_layered_item_placer", "collapse_small"}),

    Prefab("hedge_block", fn1, assets, prefabs),
    Prefab("hedge_cone", fn2, assets, prefabs),
    Prefab("hedge_layered", fn3, assets, prefabs),

    MakePlacer("hedge_block_item_placer", "hedge", "hedge1_build", "growth3", false, false, true, nil, nil, "eight"),
    MakePlacer("hedge_cone_item_placer", "hedge", "hedge2_build", "growth2", false, false, true, nil, nil, "eight"),
    MakePlacer("hedge_layered_item_placer", "hedge", "hedge3_build", "growth2", false, false, true, nil, nil, "eight")
