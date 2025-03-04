require "prefabutil"
require "recipes"

local assets =
{
    Asset("ANIM", "anim/ant_house.zip"),
    Asset("SOUND", "sound/pig.fsb"),
    Asset("MINIMAP_IMAGE", "ant_house"),
}

local prefabs =
{
    "antman",
    "antlarva",
}

local ANTMAN_MIN = 3

local function LaunchProjectile(inst, targetpos)
    --if not inst.canFire then return end
    local projectile = SpawnPrefab("antlarva")
    projectile.owner = inst
    projectile.Transform:SetPosition(inst:GetPosition():Get())
    projectile.components.complexprojectile:Launch(targetpos)
    --inst.canFire = false
    --inst.components.timer:StartTimer("Reload", TUNING.FIRESUPPRESSOR_RELOAD_TIME)
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

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
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

local function maintainantpop(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, { "ant" })
    local invader = GetClosestInstWithTag("player", inst, 20)
    --		print (#ents)
    if #ents < ANTMAN_MIN and invader then
        local x, y, z = inst.Transform:GetWorldPosition()
        local projectile = SpawnPrefab("antlarva")
        projectile.Transform:SetPosition(x + 0.5, y, z + 0.5)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("ant_house.tex")
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(true)
    light:SetColour(185 / 255, 185 / 255, 20 / 255)
    inst.lightson = true

    MakeObstaclePhysics(inst, 1)

    anim:SetBank("ant_house")
    anim:SetBuild("ant_house")
    anim:PlayAnimation("idle", true)

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "honey", "honey", "honey", "honeycomb" })


    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    --[[
    inst:AddComponent( "childspawner" )
    inst.components.childspawner:SetRegenPeriod(60)
    inst.components.childspawner:SetSpawnPeriod(.1)
    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner.childname = "antman"
    inst.components.childspawner:StartSpawning()
]]
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

    inst.OnSave = onsave
    inst.OnLoad = onload

    --    inst:WatchWorldState("startaporkalypse", function() inst.Light:Enable(false) end, TheWorld)
    --    inst:WatchWorldState("stopaporkalypse", function() inst.Light:Enable(true) end, TheWorld)
    --    inst:ListenForEvent("exitlimbo", function(inst) inst.Light:Enable(not GetAporkalypse():IsActive()) end)
    --    inst.Light:Enable(not GetAporkalypse():IsActive())

    inst:WatchWorldState("stopday", maintainantpop)
    inst:WatchWorldState("startday", maintainantpop)

    return inst
end

return Prefab("common/objects/antcombhome", fn, assets, prefabs),
    MakePlacer("common/antcombhome_placer", "ant_house", "ant_house", "idle")
