require "prefabutil"
require "recipes"

local assets =
{
    Asset("ANIM", "anim/octo_house.zip"),
    Asset("ANIM", "anim/ballphin_house.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "octopus",
}

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
        inst.lightson = true
    end
end

local function LightsOff(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
        inst.lightson = false
    end
end

local function onfar(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOn(inst)
        end
    end
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onnear(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOff(inst)
        end
    end
end

local function onwere(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve/pig/werepig_in_hut", "pigsound")
    end
end

local function onnormal(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
    end
end

local function onoccupied(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.doortask = inst:DoTaskInTime(1,
            function() if not inst.components.playerprox:IsPlayerClose() then LightsOn(inst) end end)
        if child then
            inst:ListenForEvent("transformwere", onwere, child)
            inst:ListenForEvent("transformnormal", onnormal, child)
        end
    end
end

local function onvacate(inst, child)
    if not inst:HasTag("burnt") then
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        inst.SoundEmitter:KillSound("pigsound")

        if child then
            inst:RemoveEventCallback("transformwere", onwere, child)
            inst:RemoveEventCallback("transformnormal", onnormal, child)
            if child.components.werebeast then
                child.components.werebeast:ResetTriggers()
            end
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
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner then inst.components.spawner:ReleaseChild() end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function ongusthammerfn(inst)
    onhammered(inst, nil)
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function OnDay(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner:IsOccupied() then
            LightsOff(inst)
            if inst.doortask then
                inst.doortask:Cancel()
                inst.doortask = nil
            end
            inst.doortask = inst:DoTaskInTime(1 + math.random() * 2,
                function() inst.components.spawner:ReleaseChild() end)
        end
    end
end

local function onbuilt(inst)
    --	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("octohouse.tex")
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180 / 255, 195 / 255, 50 / 255)

    --    MakeObstaclePhysics(inst, 1)
    MakeWaterObstaclePhysics(inst, 1, 2, 1.25)

    anim:SetBank("ballphin_house")
    anim:SetBuild("octoplus_house")
    anim:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("ignorewalkableplatforms")

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
    WorldSettings_Spawner_SpawnDelay(inst, TUNING.TOTAL_DAY_TIME * 4, true)
    inst.components.spawner:Configure("octopus", TUNING.TOTAL_DAY_TIME * 4)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:SetWaterSpawning(true, false)
    inst:ListenForEvent("daytime", function() OnDay(inst) end, TheWorld)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst, .01)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
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

    --    inst:AddComponent("blowinwindgust")
    --    inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.PIGHOUSE_WINDBLOWN_SPEED)
    --    inst.components.blowinwindgust:SetDestroyChance(TUNING.PIGHOUSE_WINDBLOWN_FALL_CHANCE)
    --    inst.components.blowinwindgust:SetDestroyFn(ongusthammerfn)
    --    inst.components.blowinwindgust:Start()

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:DoTaskInTime(math.random(), function()
        --print(inst, "spawn check day")
        if TheWorld.state.isday then
            OnDay(inst)
        end
    end)

    return inst
end

return Prefab("common/objects/octohouse", fn, assets, prefabs),
    MakePlacer("common/octohouse_placer", "pig_house", "pig_house", "idle")
