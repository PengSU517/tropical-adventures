require "prefabutil"
local easing = require("easing")

local assets =
{

    Asset("ANIM", "anim/loot_pump.zip"),
    Asset("IMAGE", "minimap/loot_pump.tex"),
    Asset("ATLAS", "minimap/loot_pump.xml"),
}


local prefabs =
{
    "collapse_small",
}


local LOOT_PUMP_SCALE = 1
local LOOT_PUMP_SPEED = 3
local LOOT_PUMP_SOUND = true
local LOOT_PUMP_TWOZN = false
local LOOT_PUMP_EQUIP = true

local OUTER_RANGE = 15 * LOOT_PUMP_SCALE
local INNER_SCALE = 0.5 -- If you change this value, the animation will not fit the effect radius
local UPDATE_INTERVAL = 0.3
local FIRING_DURATION = 0.2
local LOOT_SPEED = 10 * LOOT_PUMP_SPEED
--local PLACER_SCALE = 2.1
--local OUTER_RANGE=10
local PLACER_SCALE = 0.47 * math.sqrt(OUTER_RANGE)
local ABS_TIME = 0.15
local ABS_FRAMES = 5
local Y_OFFSET = 2.25

local ITEM_BLACKLIST = {
    ["lantern"] = true,
    ["chester_eyebone"] = true,
    ["hutch_fishbowl"] = true,
    ["heatrock"] = true,
    ["tallbirdegg"] = true,
    ["trap"] = true,
    ["birdtrap"] = true,
    ["glommerflower"] = true,
    ["redlantern"] = true,
    ["trap_teeth"] = true,
    ["beemine"] = true,
    ["trap_bramble"] = true,
    ["moonrockseed"] = true,
    ["amulet"] = true,
    ["pumpkin_lantern"] = true,
}

local CONTAINER_BLACKLIST = {
    ["backpack"] = true,
    ["bundle"] = true,
    ["candybag"] = true,
    ["chester"] = true,
    ["cookpot"] = true,
    ["hutch"] = true,
    ["icepack"] = true,
    ["krampus_sack"] = true,
    ["livingtree_halloween"] = true,
    ["mushroom_light"] = true,
    ["mushroom_light2"] = true,
    ["oceanfishingrod"] = true,
    ["piggyback"] = true,
    ["portablecookpot"] = true,
    ["portablespicer"] = true,
    ["sacred_chest"] = true,
    ["slingshot"] = true,
    ["spicepack"] = true,
    ["tacklecontainer"] = true,
    ["teleportato_base"] = true,
    ["winter_tree"] = true,
    ["winter_twiggytree"] = true,
    ["winter_deciduoustree"] = true,
    ["wobybig"] = true,
    ["wobysmall"] = true,
}

local TAG_BLACKLIST = {
    "birds",
    "trap",
    "canbetrapped",
    "smallcreature",
    "irreplaceable",
    "nonpotatable",
    "prototyper",
}



local PLACER_ANIM

if LOOT_PUMP_TWOZN == true then
    PLACER_ANIM = "placer"
else
    PLACER_ANIM = "placer_single"
end
--local PLACER_SCALE = 1.5

local function onturnon(inst)
    if not inst:HasTag("burnt") then
        inst.components.machine.ison = true
        inst.AnimState:PushAnimation("idle_on")
    end
end

local function onturnoff(inst)
    if not inst:HasTag("burnt") then
        inst.components.machine.ison = false

        inst.AnimState:PushAnimation("idle_off")

        local pos = inst:GetPosition()
        local ent = TheSim:FindEntities(pos.x, pos.y, pos.z, OUTER_RANGE, { "lootpump_oncatch" })

        for k, v in ipairs(ent) do
            if v.components.projectile then -- Extra check, just to be sure
                v.components.projectile:Miss(inst)
            end
        end
    end
end



local function OnBurnt(inst)
    inst.components.machine:TurnOff()
    DefaultBurntStructureFn(inst)
    inst:RemoveComponent("machine")
end

----------------------

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        if inst.components.machine.ison == true then
            inst.AnimState:PushAnimation("idle_on")
        else
            inst.AnimState:PushAnimation("idle_off")
        end
    end
end


local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end


local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_on", true)
end


--------------------------------------------------------------------------

local function CheckValidContainer(cnt, item)
    return (cnt.components.container:CanTakeItemInSlot(item)
        and not cnt.components.stewer
        and not cnt.components.inventoryitem
        and not CONTAINER_BLACKLIST[cnt.prefab]
    )
end

local function LookForContainers(inst, item, inner_range, outer_range)
    if item ~= nil and item:IsValid() then
        local pos = inst:GetPosition()
        local ent = TheSim:FindEntities(pos.x, pos.y, pos.z, outer_range, {}, { "fx", "decor", "inlimbo" })

        local cnt = {}

        for k, v in ipairs(ent) do
            if v.components and v.components.container then
                if inst:GetDistanceSqToInst(v) > inner_range * inner_range then
                    if CheckValidContainer(v, item) then
                        table.insert(cnt, v)
                    end
                end
            end
        end

        for k, v in ipairs(cnt) do -- First check if there is any container with the item
            if v.components.container:Has(item.prefab, 1) then
                for ii = 1, v.components.container.numslots do
                    local slot_item = v.components.container.slots[ii]
                    if not slot_item or
                        (slot_item.components.stackable ~= nil
                            and v.components.container.acceptsstacks
                            and slot_item.prefab == item.prefab
                            and slot_item.skinname == item.skinname
                            and not slot_item.components.stackable:IsFull()
                        ) then
                        return v
                    end
                end
            end
        end


        if item.components.perishable then
            local perish_rate = 1
            local best_preserver
            local aux
            for k, v in ipairs(cnt) do -- Then check for non-full containers that will reduce the item perish time
                if not v.components.container:IsFull() and item.prefab ~= "spoiled_food"
                    and item.prefab ~= "rottenegg" and item.prefab ~= "spoiled_fish" then
                    aux = 10
                    if v.components.preserver then
                        aux = v.components.preserver:GetPerishRateMultiplier(item)
                    end
                    if v:HasTag("fridge") then
                        aux = TUNING.PERISH_FRIDGE_MULT
                    end
                    if aux < perish_rate then
                        perish_rate = aux
                        best_preserver = v
                    end
                end
            end
            if best_preserver ~= nil then
                return best_preserver
            end
        end

        for k, v in ipairs(cnt) do -- Then check for non-full containers
            if not v.components.container:IsFull() then
                return v
            end
        end

        if #cnt > 0 then -- At last throw at a random container
            return cnt[math.random(#cnt)]
        end
    else
        return nil
    end
end

local function CheckTags(item)
    for k, v in pairs(TAG_BLACKLIST) do
        if item:HasTag(v) then
            return true
        end
    end
    return false
end

local function LookForItems(inst, inner_range)
    local pos = inst:GetPosition()
    local ent = TheSim:FindEntities(pos.x, pos.y, pos.z, inner_range, {},
        { "fx", "decor", "inlimbo", "lootpump_onflight" })

    -- based on: https://forums.kleientertainment.com/forums/topic/52389-mod-treeslacoil/
    -- and https://forums.kleientertainment.com/forums/topic/53314-finding-items-on-the-ground-in-a-radius/

    for k, v in ipairs(ent) do
        if v.components.inventoryitem and v.components.inventoryitem.canbepickedup and v.components.inventoryitem.cangoincontainer
            and (LOOT_PUMP_EQUIP or v.components.equippable == nil) then
            if v:GetPosition().y < 0.00005 and not ITEM_BLACKLIST[v.prefab] and not CheckTags(v) then -- Only catch itens that are close to the ground
                return v
            end
        end
    end
end

local function CheckContainerReplica(inst)
    return inst and inst.replica
        and inst.replica.container and inst.replica.container.classified
        and inst.components and inst.components.container
end

local function ContainerHit(inst)
    inst:RemoveTag("noclick")
    -- OK, this look very dumb, but I had to make several checks to avoid crashs when I break the container that will receive the item
    if CheckContainerReplica(inst.target_container) then
        if LOOT_PUMP_SOUND == true then
            inst.target_container.components.container:Open(inst.target_container)
        end
        if inst.AnimState then
            for i = 0, ABS_FRAMES - 1 do
                inst:DoTaskInTime(i * (ABS_TIME / ABS_FRAMES), function()
                    inst.AnimState:SetScale((1 - i / ABS_FRAMES), (1 - i / ABS_FRAMES))
                end)
            end
        end
        inst.target_container:DoTaskInTime(ABS_TIME, function()
            if CheckContainerReplica(inst.target_container) then -- Double check to avoid crash in specific conditions
                -- Note: I rly hate to make these kind of double checks, but I crashed the server while aspirating on-fire gunpowders
                -- I don't know how common this situation is, but ok, lets avoid these crashs
                if inst:IsValid() then
                    inst.target_container.components.container:Close()
                    inst.target_container.components.container:GiveItem(inst)
                end
            end
            inst.AnimState:SetScale(1, 1)
            inst:RemoveTag("lootpump_onflight")
        end)
    end
    inst:RemoveComponent("complexprojectile")
    inst:DoTaskInTime(ABS_TIME, function() -- Yeah, apply this again to avoid weird errors
        inst.AnimState:SetScale(1, 1)
        inst:RemoveTag("lootpump_onflight")
    end)

    --inst:DoTaskInTime(0.1, function() inst:RemoveTag("lootpump_onflight") end)
end

local function ItemFlingToContainer(inst, container, maxrange)
    local pos = inst:GetPosition()
    local targetpos = container:GetPosition()

    local dx = targetpos.x - pos.x
    local dy = targetpos.y - pos.y
    local dz = targetpos.z - pos.z
    local rangesq = dx * dx + dy * dy + dz * dz

    if inst.AnimState then
        for i = 0, ABS_FRAMES do
            inst:DoTaskInTime(i * (ABS_TIME / ABS_FRAMES), function()
                inst.AnimState:SetScale((i / ABS_FRAMES), (i / ABS_FRAMES))
            end)
        end
    end

    if rangesq < 1.21 * maxrange * maxrange then
        inst.target_container = container


        if not inst.components.complexprojectile then
            inst:AddComponent("complexprojectile")
        end


        local speed = easing.linear(rangesq, maxrange, 3, maxrange * maxrange)
        inst:AddTag("lootpump_onflight") -- Add the tag again, just to be sure
        inst.components.complexprojectile:SetHorizontalSpeed(speed)
        inst.components.complexprojectile:SetGravity(-25)
        inst.components.complexprojectile:SetOnHit(ContainerHit)
        inst.components.complexprojectile:Launch(targetpos, inst, inst)
    else
        inst:RemoveTag("noclick")
        inst:RemoveTag("lootpump_onflight")
    end
    if inst.loot_pump_oldphysics ~= nil then
        inst.Physics:SetCollisionMask(inst.loot_pump_oldphysics)
    end
end

local function ItemMiss(inst)
    if inst.Physics then
        inst.Physics:Stop()
    end
    inst.components.projectile:Stop()
    inst:RemoveComponent("projectile")
    inst:RemoveTag("noclick")
    inst:RemoveTag("lootpump_oncatch")
    if inst.loot_pump_oldphysics ~= nil then
        inst.Physics:SetCollisionMask(inst.loot_pump_oldphysics)
    end
end

local function ItemHit(inst, attacker, target)
    local pos = target:GetPosition()

    if inst.Physics then
        inst.Physics:Stop()
    end
    inst.components.projectile:Stop()
    inst:RemoveComponent("projectile")
    inst:RemoveTag("lootpump_oncatch") -- Remove the "oncatch" tag

    if target and not target:HasTag("burnt") and attacker and not attacker:HasTag("burnt") then
        inst:AddTag("lootpump_onflight") -- Add the catch "onflight" before the flight just to avoid "recatch"
        if inst.AnimState then
            for i = 0, ABS_FRAMES - 1 do
                inst:DoTaskInTime(i * (ABS_TIME / ABS_FRAMES), function()
                    inst.AnimState:SetScale((1 - i / ABS_FRAMES), (1 - i / ABS_FRAMES))
                end)
            end
        end

        if LOOT_PUMP_SOUND == true then
            target.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/beeguard/puff")
        end
        target.AnimState:PlayAnimation("firing", false)
        target.isfiring = true
        if target.components.machine and target.components.machine.ison == true then
            target.AnimState:PushAnimation("idle_on")
        else
            target.AnimState:PushAnimation("idle_off")
        end
        target:DoTaskInTime(FIRING_DURATION, function() target.isfiring = false end)

        inst:DoTaskInTime(ABS_TIME, function()
            inst.Transform:SetPosition(pos.x, pos.y + Y_OFFSET, pos.z)
            ItemFlingToContainer(inst, attacker, OUTER_RANGE)
        end)
    end

    if inst.loot_pump_oldphysics ~= nil then
        inst.Physics:SetCollisionMask(inst.loot_pump_oldphysics)
    end
end

local function DoUpdate(inst)
    if inst:HasTag("burnt") then
        return
    end

    if inst.components.machine.ison == true then
        local item
        if LOOT_PUMP_TWOZN then
            item = LookForItems(inst, INNER_SCALE * OUTER_RANGE)
        else
            item = LookForItems(inst, OUTER_RANGE)
        end
        if item ~= nil then
            local container
            if LOOT_PUMP_TWOZN then
                container = LookForContainers(inst, item, INNER_SCALE * OUTER_RANGE, OUTER_RANGE)
            else
                container = LookForContainers(inst, item, 0, OUTER_RANGE)
            end
            if container ~= nil then
                if item.components.stackable then
                    if item.components.stackable:IsStack() then
                        local pos = item:GetPosition()
                        item = item.components.stackable:Get(1)
                        item.Transform:SetPosition(pos.x, pos.y, pos.z)
                    end
                end

                item:AddTag("noclick")
                item:AddTag("lootpump_oncatch")
                item.loot_pump_oldphysics = item.Physics:GetCollisionMask()
                if inst.loot_through_walls then
                    item.Physics:ClearCollisionMask()
                    item.Physics:CollidesWith(COLLISION.WORLD)
                    item.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                end
                if not item.components.projectile then
                    item:AddComponent("projectile")
                end
                item.components.projectile:SetSpeed(LOOT_SPEED)
                item.components.projectile:SetOnMissFn(ItemMiss)
                item.components.projectile:SetOnHitFn(ItemHit)
                item.components.projectile:SetHitDist(0.2)
                item.components.projectile:Throw(container, inst, item)
                if inst.isfiring == false then
                    inst.AnimState:PlayAnimation("aspiration")
                end
            end
        end
    end
end


--------------------------------------------------------------------------



local function OnUpdatePlacerHelper(helperinst)
    if not helperinst.placerinst:IsValid() then
        helperinst.components.updatelooper:RemoveOnUpdateFn(OnUpdatePlacerHelper)
        helperinst.AnimState:SetAddColour(0, 0, 0, 0)
    elseif helperinst:IsNear(helperinst.placerinst, OUTER_RANGE) then
        local hp = helperinst:GetPosition()
        local p1 = TheWorld.Map:GetPlatformAtPoint(hp.x, hp.z)

        local pp = helperinst.placerinst:GetPosition()
        local p2 = TheWorld.Map:GetPlatformAtPoint(pp.x, pp.z)

        if p1 == p2 then
            if not helperinst:IsNear(helperinst.placerinst, INNER_SCALE * OUTER_RANGE) or LOOT_PUMP_TWOZN == false then
                helperinst.AnimState:SetAddColour(helperinst.placerinst.AnimState:GetAddColour())
            else
                helperinst.AnimState:SetAddColour(1, 0, 0, 0)
            end
        else
            helperinst.AnimState:SetAddColour(0, 0, 0, 0)
        end
    else
        helperinst.AnimState:SetAddColour(0, 0, 0, 0)
    end
end

local function OnEnableHelper(inst, enabled, recipename, placerinst)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("loot_pump")
            inst.helper.AnimState:SetBuild("loot_pump")
            inst.helper.AnimState:PlayAnimation(PLACER_ANIM)
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)

            inst.helper.entity:SetParent(inst.entity)

            if placerinst ~= nil then
                inst.helper:AddComponent("updatelooper")
                inst.helper.components.updatelooper:AddOnUpdateFn(OnUpdatePlacerHelper)
                inst.helper.placerinst = placerinst
                OnUpdatePlacerHelper(inst.helper)
            end
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("loot_pump.tex")

    --    MakeObstaclePhysics(inst, 1.0)

    inst.AnimState:SetBank("loot_pump")
    inst.AnimState:SetBuild("loot_pump")
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("structure")


    --Dedicated server does not need deployhelper
    if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.isfiring = false


    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("inspectable")
    --  inst.components.inspectable.getstatus = getstatus


    inst:AddComponent("machine")
    inst.components.machine.turnonfn = onturnon
    inst.components.machine.turnofffn = onturnoff
    inst.components.machine.cooldowntime = 0.5
    inst.components.machine.ison = true


    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

    inst._isupdating = inst:DoPeriodicTask(UPDATE_INTERVAL, DoUpdate, 1)

    inst.loot_through_walls = true


    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.components.machine:TurnOn()

    MakeHauntableWork(inst)

    return inst
end

local function placer_postinit_fn(inst)
    --Show the flingo placer on top of the flingo range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("loot_pump")
    placer2.AnimState:SetBuild("loot_pump")
    placer2.AnimState:PlayAnimation("idle", false)
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return Prefab("loot_pump", fn, assets, prefabs),
    MakePlacer("loot_pump_placer", "loot_pump", "loot_pump", PLACER_ANIM, true, nil, nil, PLACER_SCALE, nil, nil,
        placer_postinit_fn)
