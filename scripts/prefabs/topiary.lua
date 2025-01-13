local prefabs =
{
    "ash",
    "collapse_small",
}

local function onhammered(inst, worker)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(3, 4) do
        local fx = SpawnPrefab("robot_leaf_fx")
        fx.Transform:SetPosition(x + (math.random() * 2), y + math.random() * 0.5, z + (math.random() * 2))
        if math.random() < 0.5 then
            fx.Transform:SetScale(-1, 1, -1)
        end
    end
    inst:Remove()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)

    local fx = SpawnPrefab("robot_leaf_fx")
    local x, y, z= inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random()*0.5, z)

    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/lawnornaments/repair")
end

local function MakeTopiary(name, build, n)
    local assets = {
        Asset("ANIM", "anim/"..build..".zip"),
        Asset("MINIMAP_IMAGE", "topiary_"..n),
    }
    local function fn(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.entity:AddPhysics()
        MakeObstaclePhysics(inst, .25)

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("topiary_" .. n .. ".tex")

        inst.entity:AddSoundEmitter()
        inst:AddTag("structure")

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle", true)

        --inst:AddComponent("lootdropper")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("inspectable")
        --inst.components.inspectable.getstatus = getstatus

        MakeSnowCovered(inst)
        inst:ListenForEvent( "onbuilt", onbuilt)

        if n == "3" or n == "4" then
            MakeLargeBurnable(inst, nil, nil, true)
            MakeLargePropagator(inst)
        else
            MakeMediumBurnable(inst, nil, nil, true)
            MakeMediumPropagator(inst)
        end

        inst:ListenForEvent("burntup", inst.Remove)

        inst:AddComponent("fixable")
        inst.components.fixable:AddRecinstructionStageData("burnt", build, build)
        --inst.components.fixable:SetPrefabName("topiary")

        inst:AddComponent("gridnudger")

        --inst:SetPrefabNameOverride("topiary")

        MakeHauntableWork(inst)
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeTopiary("topiary_1", "topiary_pigman", "1"),
    MakeTopiary("topiary_2", "topiary_werepig", "2"),
    MakeTopiary("topiary_3", "topiary_beefalo", "3"),
    MakeTopiary("topiary_4", "topiary_pigking", "4"),
    MakePlacer("topiary_1_placer", "topiary_pigman", "topiary_pigman", "idle"),
    MakePlacer("topiary_2_placer", "topiary_werepig", "topiary_werepig", "idle"),
    MakePlacer("topiary_3_placer", "topiary_beefalo", "topiary_beefalo", "idle"),
    MakePlacer("topiary_4_placer", "topiary_pigking", "topiary_pigking", "idle")
