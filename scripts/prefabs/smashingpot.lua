local assets =
{
    Asset("ANIM", "anim/pig_ruins_pot.zip"),
    Asset("MINIMAP_IMAGE", "pig_ruins_pot"),
}

local prefabs =
{
    "collapse_small",
}

local respawndays = 5

local function setbroken(inst)
    inst.AnimState:PlayAnimation("broken")
    inst.broken = true
    inst.Physics:SetActive(false)
    inst.Physics:SetSphere(0)
    inst.Physics:Stop()

    if inst.MiniMapEntity then
        inst.MiniMapEntity:SetIcon("")
    end

    if inst.components.lootdropper.randomloot then
        inst.components.lootdropper.randomloot = {}
        inst.components.lootdropper.totalrandomweight = 0
    end
    if inst.components.timer then
        inst.components.timer:StartTimer("spawndelay", 60 * 8 * respawndays)
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot_bigger")
    setbroken(inst)
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function OnSave(inst, data)
    if inst.broken then
        data.broken = true
    end
end

local function OnLoad(inst, data)
    if data and data.broken then
        setbroken(inst)
    end
end

local function getstatus(inst)

end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function OnTimerDone(inst, data)
    if data.name == "spawndelay" then
        local pote = SpawnPrefab("smashingpot")
        pote.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pig_ruins_pot.tex")

    inst.entity:AddPhysics()
    MakeObstaclePhysics(inst, .25)

    inst.entity:AddSoundEmitter()
    --inst:AddTag("structure")
    inst.hammersound = "Hamlet/common/harvested/claypot/hit"


    anim:SetBank("pig_ruins_pot")
    anim:SetBuild("pig_ruins_pot")

    anim:PlayAnimation("idle", true)


    local rarity = {
        extreeme = 1,
        veryhigh = 4,
        high = 8,
        med = 16,
        low = 32,
        verylow = 64,
    }

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("twigs", rarity.verylow)
    inst.components.lootdropper:AddRandomLoot("cutgrass", rarity.verylow)
    inst.components.lootdropper:AddRandomLoot("redgem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("goldnugget", rarity.high)
    inst.components.lootdropper:AddRandomLoot("nightmarefuel", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("pigskin", rarity.low)
    inst.components.lootdropper:AddRandomLoot("thulecite", rarity.extreeme)
    inst.components.lootdropper:AddRandomLoot("meat_dried", rarity.med)
    inst.components.lootdropper:AddRandomLoot("spoiled_food", rarity.low)
    inst.components.lootdropper:AddRandomLoot("livinglog", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("boneshard", rarity.med)
    inst.components.lootdropper:AddRandomLoot("houndstooth", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("log", rarity.low)
    inst.components.lootdropper:AddRandomLoot("silk", rarity.high)
    inst.components.lootdropper:AddRandomLoot("scorpion", rarity.high)
    inst.components.lootdropper:AddRandomLoot("rabid_beetle", rarity.high)
    inst.components.lootdropper:AddRandomLoot("rope", rarity.high)
    inst.components.lootdropper:AddRandomLoot("seeds", rarity.med)
    inst.components.lootdropper:AddRandomLoot("purplegem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("bluegem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("orangegem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("yellowgem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("greengem", rarity.veryhigh)
    inst.components.lootdropper:AddRandomLoot("cutreeds", rarity.low)
    inst.components.lootdropper:AddRandomLoot("feather_crow", rarity.med)
    inst.components.lootdropper:AddRandomLoot("feather_robin", rarity.med)
    inst.components.lootdropper:AddRandomLoot("feather_robin_winter", rarity.med)



    inst.components.lootdropper.numrandomloot = 1
    if math.random() < 0.2 then
        if inst.components.lootdropper.randomloot then
            inst.components.lootdropper.randomloot = {}
            inst.components.lootdropper.totalrandomweight = 0
        end
    elseif math.random() < 0.3 then
        inst.components.lootdropper.numrandomloot = 2
    else
    end

    --inst.components.lootdropper.numrandomloot = math.random(2)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    return inst
end


return Prefab("smashingpot", fn, assets, prefabs)
