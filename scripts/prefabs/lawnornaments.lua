local prefabs =
{
    "ash",
    "collapse_small",
}

local function onhammered(inst, worker)
    local pt = inst:GetPosition()
    local tiletype = TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get()))
    if tiletype == GROUND.SUBURB or tiletype == GROUND.FOUNDATION or tiletype == GROUND.COBBLEROAD or tiletype == GROUND.FIELDS or tiletype == GROUND.LAWN then
        if worker and worker:HasTag("player") and not worker:HasTag("sneaky") then
            local x, y, z = inst.Transform:GetWorldPosition()
            local tiletype = TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get()))
            local eles = TheSim:FindEntities(x, y, z, 40, { "guard" })
            for k, guardas in pairs(eles) do
                if guardas.components.combat and guardas.components.combat.target == nil then guardas.components.combat
                        :SetTarget(worker) end
            end
        end
    end
    --	inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)

    local isLawnornament7 = inst.prefab == "lawnornament_7"
    if not isLawnornament7 then
        local fx = SpawnPrefab("robot_leaf_fx")
        local x, y, z = inst.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x, y + math.random() * 0.5, z)
    end

    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/lawnornaments/repair")
end


local function MakeLawnornament(n)
    local assets = {
        Asset("ANIM", "anim/topiary0"..n..".zip"),
        Asset("MINIMAP_IMAGE", "lawnornaments_"..n),
    }
    local function fn(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.entity:AddPhysics()
        MakeObstaclePhysics(inst, .5)

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("lawnornament_" .. n .. ".tex")

        inst.entity:AddSoundEmitter()
        inst:AddTag("structure")

        inst.AnimState:SetBank("topiary0".. n)
        inst.AnimState:SetBuild("topiary0".. n)

        inst.AnimState:PlayAnimation("idle")

        --		inst.AnimState:Hide("snow")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        --        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("inspectable")
        --inst.components.inspectable.getstatus = getstatus

        MakeSnowCovered(inst)
        inst:ListenForEvent( "onbuilt", onbuilt)

        --inst:SetPrefabNameOverride("lawnornament")

        inst:AddComponent("fixable")
        inst.components.fixable:AddRecinstructionStageData("burnt", "topiary0".. n, "topiary0".. n)
        --inst.components.fixable:SetPrefabName("lawnornament")

        MakeSmallBurnable(inst, nil, nil, true)
        MakeSmallPropagator(inst)

        inst:AddComponent("gridnudger")

        inst:ListenForEvent("burntup", inst.Remove)

        MakeHauntableWork(inst)
        return inst
    end

    return Prefab("lawnornament_"..n, fn, assets, prefabs)
end

local function MakeLawnornamentPlacer(n)
    return MakePlacer("lawnornament_"..n.."_placer", "topiary0"..n, "topiary0"..n, "idle")
end

local ret = {}

for i=1, 7 do
    table.insert(ret, MakeLawnornament(i))
    table.insert(ret, MakeLawnornamentPlacer(i))
end

return unpack(ret)
