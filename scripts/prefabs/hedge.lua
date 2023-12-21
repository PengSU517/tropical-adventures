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
}
local respawndays = math.random(1440, 2400) --tempo para renascer de 3 a 5 dias

local function setobstical(inst)
    local ground = TheWorld
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
    end
end

local function ondeploywall(inst, pt, deployer)
    --inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    local wall = SpawnPrefab("wall_" .. data.name, inst.linked_skinname, inst.skin_id)
    if wall ~= nil then
        local x = math.floor(pt.x) + .5
        local z = math.floor(pt.z) + .5
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(x, 0, z)
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        if data.name == "enforcedlimestone" then
            wall.AnimState:PlayAnimation("water_half", true)
        end

        if data.buildsound ~= nil then
            wall.SoundEmitter:PlaySound(data.buildsound)
        end
    end
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
        inst.AnimState:PlayAnimation("growth2to1")
        inst.AnimState:PushAnimation("growth1")
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    else
        inst.AnimState:PlayAnimation("growth2to3")
        inst.AnimState:PushAnimation("growth3")
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

local function fn()
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
    MakeObstaclePhysics(inst, .35)

    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("interactions")
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

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetEightFaced()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("hedge")
    inst.AnimState:SetBuild("hedge2_build")
    inst.AnimState:PlayAnimation("growth3", true)
    MakeObstaclePhysics(inst, .35)

    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("interactions")
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
    inst.AnimState:SetBuild("hedge3_build")
    inst.AnimState:PlayAnimation("growth3", true)
    MakeObstaclePhysics(inst, .35)

    inst:AddTag("machetecut")
    inst:AddTag("hedgetoshear")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("interactions")
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

return Prefab("hedge_block", fn, assets, prefabs),
    Prefab("hedge_cone", fn1, assets, prefabs),
    Prefab("hedge_layered", fn2, assets, prefabs),
    MakePlacer("hedge_block_placer", "hedge", "hedge1_build", "growth1", false, false, true),
    MakePlacer("hedge_cone_placer", "hedge", "hedge2_build", "growth1", false, false, true),
    MakePlacer("hedge_layered_placer", "hedge", "hedge3_build", "growth1", false, false, true)
