require "prefabutil"
require "recipes"

local assets =
{
    Asset("ANIM", "anim/elderdrake_house.zip"),
    Asset("MINIMAP_IMAGE", "elderdrake_house"),
}

local prefabs =
{
    "mandrakeman",
}


local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        end
    end
end

local function onoccupied(inst, child)
    --inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
    --inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
end

local function onvacate(inst, child)
    --inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    --inst.SoundEmitter:KillSound("pigsound")
    if not inst:HasTag("burnt") then
        if child then
            if child.components.health then
                child.components.health:SetPercent(1)
            end
        end
    end
end


local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.components.spawner then inst.components.spawner:ReleaseChild() end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end


local function Empty(inst)
    --print(inst, "OnDay")
    if not inst:HasTag("burnt") then
        if inst.components.spawner:IsOccupied() then
            if inst.doortask then
                inst.doortask:Cancel()
                inst.doortask = nil
            end
            inst.doortask = inst:DoTaskInTime(1 + math.random() * 2,
                function() inst.components.spawner:ReleaseChild() end)
        end
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/rabbit_hutch")
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("elderdrake_house.tex")
    --{anim="level1", sound="dontstarve/common/campfire", radius=2, intensity=.75, falloff=.33, colour = {197/255,197/255,170/255}},
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180 / 255, 195 / 255, 50 / 255)

    MakeObstaclePhysics(inst, 1)

    anim:SetBank("elderdrake_house")
    anim:SetBuild("elderdrake_house")
    anim:PlayAnimation("idle", true)

    inst:AddTag("structure")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("spawner")
    WorldSettings_Spawner_SpawnDelay(inst, TUNING.TOTAL_DAY_TIME * 3, true)
    inst.components.spawner:Configure("mandrakeman", TUNING.TOTAL_DAY_TIME)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst:WatchWorldState("isdusk", Empty)
    inst:WatchWorldState("isnight", Empty)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst, .01)

    inst:ListenForEvent("burntup", function(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
    end)
    inst:ListenForEvent("onignite", function(inst)
        if inst.components.spawner then
            inst.components.spawner:ReleaseChild()
        end
    end)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:DoTaskInTime(math.random(), function()
        --print(inst, "spawn check day")
        if not TheWorld.state.isday then
            Empty(inst)
        end
    end)

    return inst
end

return Prefab("common/objects/mandrakehouse", fn, assets, prefabs)
--MakePlacer("common/rabbithouse_placer", "rabbithouse", "rabbit_house", "idle")
