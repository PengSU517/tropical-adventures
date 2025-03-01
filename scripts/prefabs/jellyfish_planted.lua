local assets =
{
    Asset("ANIM", "anim/jellyfish.zip"),
}

local prefabs =
{
    "jellyfish_dead",
}
local JELLYFISH_DAMAGE = 5
local JELLYFISH_HEALTH = 50
local JELLYFISH_WALK_SPEED = 2

local function OnWorked(inst, worker)
    if worker.components.inventory then
        if not worker.components.inventory:IsFull() then
            local toGive = SpawnPrefab("jellyfish")
            worker.components.inventory:GiveItem(toGive, nil, inst:GetPosition())
            worker.SoundEmitter:PlaySound("dontstarve_DLC002/common/bugnet_inwater")
            inst:Remove()
        else
            local cai = worker.components.inventory.itemslots[1]
            if cai ~= nil then
                worker.components.inventory:DropItem(cai, true, true)
                local toGive = SpawnPrefab("jellyfish")
                worker.components.inventory:GiveItem(toGive, nil, inst:GetPosition())
                worker.SoundEmitter:PlaySound("dontstarve_DLC002/common/bugnet_inwater")
                inst:Remove()
            end
        end
    else
        local toGive = SpawnPrefab("jellyfish_dead")
        toGive.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end
end


local function onattacked(inst, data)
    local jogador = GetClosestInstWithTag("player", inst, 3)
    if data and data.attacker.components.health then
        if (data.weapon == nil or (not data.weapon:HasTag("projectile") and data.weapon.projectile == nil))
            and (data.attacker:HasTag("player") and not data.attacker.components.inventory:IsInsulated()) then
            if data.attacker:HasTag("player") and jogador then
                data.attacker.components.health:DoDelta(-JELLYFISH_DAMAGE)
                data.attacker.sg:GoToState("electrocute")
            end
        end
    end
end

local function ShouldSleep(inst)
    return false
end

local function OnTimerDone(inst, data)
    if data.name == "vaiembora" then
        local invader = GetClosestInstWithTag("player", inst, 25)
        if not invader then
            inst:Remove()
        else
            inst.components.timer:StartTimer("vaiembora", 10)
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local physics = inst.entity:AddPhysics()
    MakeCharacterPhysics(inst, 1, 0.5)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.AnimState:SetBank("jellyfish")
    inst.AnimState:SetBuild("jellyfish")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("aquatic")
    inst:AddTag("jellyfishrede")
    inst:AddTag("tropicalspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = JELLYFISH_WALK_SPEED

    --inst.AnimState:SetRayTestOnBB(true);
    --inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
    --inst.AnimState:SetLayer(LAYER_BELOW_GROUND)

    inst:AddComponent("combat")
    inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/jellyfish/hit")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(JELLYFISH_HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "jellyfish_dead" })

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    --inst:DoTaskInTime(0, ondropped)
    inst:SetStateGraph("SGjellyfish")
    local brain = require "brains/jellyfishbrain"
    inst:SetBrain(brain)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("vaiembora", 240 + math.random() * 240)

    inst:ListenForEvent("attacked", onattacked)

    MakeHauntablePanic(inst)
    MakeMediumFreezableCharacter(inst, "jelly")

    return inst
end

return Prefab("jellyfish_planted", fn, assets, prefabs)
