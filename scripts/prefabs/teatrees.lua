local assets = {Asset("ANIM", "anim/tree_leaf_short.zip"), Asset("ANIM", "anim/tree_leaf_normal.zip"),
                Asset("ANIM", "anim/tree_leaf_tall.zip"), Asset("ANIM", "anim/teatree_trunk_build.zip"), -- trunk build (winter leaves build)
                Asset("ANIM", "anim/teatree_build.zip"), Asset("ANIM", "anim/dust_fx.zip"),
                Asset("SOUND", "sound/forest.fsb")}

local day_time = 300
local DECIDUOUS_GROW_TIME = {{
    base = 1.5 * day_time,
    random = 0.5 * day_time,
}, -- short
{
    base = 5 * day_time,
    random = 2 * day_time,
}, -- normal
{
    base = 5 * day_time,
    random = 2 * day_time,
}, -- tall
{
    base = 1 * day_time,
    random = 0.5 * day_time,
} -- old
}

local DECIDUOUS_CHOPS_SMALL = 5
local DECIDUOUS_CHOPS_NORMAL = 10
local DECIDUOUS_CHOPS_TALL = 15

local prefabs = {"log", "twigs", "teatree_nut", "charcoal", "green_leaves", "green_leaves_chop", "spoiled_food"}

local builds = {
    normal = { -- Green
        leavesbuild = "teatree_build",
        prefab_name = "teatree",
        normal_loot = {"log", "twigs", "teatree_nut"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "twigs", "teatree_nut", "teatree_nut"},
        drop_nut = true,
        fx = "green_leaves",
        chopfx = "green_leaves_chop",
        shelter = true,
    },
}

local function makeanims(stage)
    return {
        idle = "idle_" .. stage,
        sway1 = "sway1_loop_" .. stage,
        sway2 = "sway2_loop_" .. stage,
        swayaggropre = "sway_agro_pre",
        swayaggro = "sway_loop_agro",
        swayaggropst = "sway_agro_pst",
        swayaggroloop = "idle_loop_agro",
        swayfx = "swayfx_" .. stage,
        chop = "chop_" .. stage,
        fallleft = "fallleft_" .. stage,
        fallright = "fallright_" .. stage,
        stump = "stump_" .. stage,
        burning = "burning_loop_" .. stage,
        burnt = "burnt_" .. stage,
        chop_burnt = "chop_burnt_" .. stage,
        idle_chop_burnt = "idle_chop_burnt_" .. stage,
        dropleaves = "drop_leaves_" .. stage,
        growleaves = "grow_leaves_" .. stage,
        blown1 = "blown_loop_" .. stage .. "1",
        blown2 = "blown_loop_" .. stage .. "2",
        blown_pre = "blown_pre_" .. stage,
        blown_pst = "blown_pst_" .. stage,
    }
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")

local function GetBuild(inst) return inst.build and builds[inst.build] or builds["normal"] end

local function GetItemschild(criteriaFn, child)
    local items = {}
    if criteriaFn and child and child.components.inventory and child.components.inventory.itemslots then
        for k, v in pairs(child.components.inventory.itemslots) do
            if criteriaFn(k, v) then table.insert(items, v) end
        end
    end

    return items
end

local function PushSway(inst, ...)
    inst.AnimState:PushAnimation(math.random() > .5 and inst.anims.sway1 or inst.anims.sway2, true)
end

local function Sway(inst, ...)
    if inst.sg:HasStateTag("burning") or inst:HasTag("stump") then return end
    PushSway(inst, ...)
end

local function ChangeSizeFn(inst)
    inst:RemoveEventCallback("animover", ChangeSizeFn)
    if inst.components.growable then
        inst.anims = ({short_anims, normal_anims, tall_anims})[inst.components.growable.stage]
    end
end

local function SetShort(inst)
    inst.anims = short_anims
    if inst.components.workable then inst.components.workable:SetWorkLeft(DECIDUOUS_CHOPS_SMALL) end
    inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
end

local function GrowShort(inst)
    inst.AnimState:PlayAnimation("grow_tall_to_short")
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local function SetNormal(inst)
    inst.anims = normal_anims
    if inst.components.workable then inst.components.workable:SetWorkLeft(DECIDUOUS_CHOPS_NORMAL) end
    inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
end

local function GrowNormal(inst)
    inst.AnimState:PlayAnimation("grow_short_to_normal")
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local function SetTall(inst)
    inst.anims = tall_anims
    if inst.components.workable then inst.components.workable:SetWorkLeft(DECIDUOUS_CHOPS_TALL) end
    inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
end

local function GrowTall(inst)
    inst.AnimState:PlayAnimation("grow_normal_to_tall")
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local growth_stages = {{
    name = "short",
    time = function(inst) return GetRandomWithVariance(DECIDUOUS_GROW_TIME[1].base, DECIDUOUS_GROW_TIME[1].random) end,
    fn = function(inst) SetShort(inst) end,
    growfn = function(inst) GrowShort(inst) end,
}, {
    name = "normal",
    time = function(inst) return GetRandomWithVariance(DECIDUOUS_GROW_TIME[2].base, DECIDUOUS_GROW_TIME[2].random) end,
    fn = function(inst) SetNormal(inst) end,
    growfn = function(inst) GrowNormal(inst) end,
}, {
    name = "tall",
    time = function(inst) return GetRandomWithVariance(DECIDUOUS_GROW_TIME[3].base, DECIDUOUS_GROW_TIME[3].random) end,
    fn = function(inst) SetTall(inst) end,
    growfn = function(inst) GrowTall(inst) end,
}}

local function chop_tree(inst, chopper, chops)
    if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
        inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
    else
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.AnimState:PlayAnimation(inst.anims.chop)
    inst.AnimState:PushAnimation(inst.anims.sway1, true)

    inst.AnimState:PlayAnimation(inst.anims.chop)

    PushSway(inst)
end

local function dig_up_stump(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("log")
    if inst.components.mystery and inst.components.mystery.investigated then
        inst.components.lootdropper:SpawnLootPrefab(inst.components.mystery.reward)
    end
    inst:Remove()
end

local function chop_down_tree(inst, chopper)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
    while inst:HasTag("cattoyairborne") do inst:RemoveTag("cattoyairborne") end
    inst:AddTag("stump")

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation(inst.anims.fallleft)
        if inst.components.growable and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("teatree_nut", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation(inst.anims.fallright)
        if inst.components.growable and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("teatree_nut", pt + TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    inst.components.inventory:DropEverything(false, false)

    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
        inst.components.childspawner:StopSpawning()
        inst:RemoveComponent("childspawner")
    end

    RemovePhysicsColliders(inst)
    inst.AnimState:PushAnimation(inst.anims.stump)
    inst.MiniMapEntity:SetIcon("teatree_stump.tex")

    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)

    if inst.components.growable then inst.components.growable:StopGrowing() end
end

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
    RemovePhysicsColliders(inst)
    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    inst:ListenForEvent("entitysleep", inst.Remove)
    inst.components.inventory:DropEverything(false, false)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
    if inst.acorntask then
        inst.acorntask:Cancel()
        inst.acorntask = nil
    end
end

local function BurnInventoryItems(inst)
    if inst.components.inventory then
        local burnableItems = inst.components.inventory:FindItems(function(item) return item.components.burnable end)
        for index, burnableItem in ipairs(burnableItems) do burnableItem.components.burnable:Ignite(true) end
    end
end

local function onburntchanges(inst)
    inst:RemoveComponent("growable")
    if inst:HasTag("shelter") then inst:RemoveTag("shelter") end
    if inst:HasTag("cattoyairborne") then inst:RemoveTag("cattoyairborne") end
    inst:RemoveTag("fire")

    inst.components.lootdropper:SetLoot({})
    if GetBuild(inst).drop_nut then inst.components.lootdropper:AddChanceLoot("teatree_nut", .1) end

    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
    end

    inst:RemoveComponent("childspawner")

    inst.AnimState:PlayAnimation(inst.anims.burnt, true)
    inst.MiniMapEntity:SetIcon("teatree_burnt.tex")
    inst:DoTaskInTime(3 * FRAMES, function(inst)
        if inst.components.burnable and inst.components.propagator then
            inst.components.burnable:Extinguish()
            inst.components.propagator:StopSpreading()
            inst:RemoveComponent("burnable")
            inst:RemoveComponent("propagator")
        end
    end)
end

local function OnBurnt(inst, imm)
    inst:AddTag("burnt")
    if imm then
        onburntchanges(inst)
    else
        inst:DoTaskInTime(0.5, function(inst) onburntchanges(inst) end)
    end
    inst.AnimState:SetRayTestOnBB(true);
end

local function tree_burnt(inst)
    OnBurnt(inst)
    inst.acorntask = inst:DoTaskInTime(10, function()
        local pt = inst:GetPosition() + (math.random(0, 1) == 1 and TheCamera:GetRightVec() or -TheCamera:GetRightVec())
        inst.components.lootdropper:DropLoot(pt)
        inst.acorntask = nil
    end)
    if inst.leaveschangetask then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end
end

local function handler_growfromseed(inst)
    inst.components.growable:SetStage(1)

    inst.AnimState:PlayAnimation("grow_seed_to_short")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    inst.anims = short_anims

    PushSway(inst)
end

local function inspect_tree(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst:HasTag("stump") then
        return "CHOPPED"
    end
end

local function OnIgnite(inst)
    BurnInventoryItems(inst)

    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
        inst.components.childspawner:StopSpawning()
    end
end

local function OnEntitySleep(inst)
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("inspectable")
end

local function OnEntityWake(inst)
    if not inst:HasTag("burnt") and not inst:HasTag("fire") then
        if not inst.components.burnable then
            if inst:HasTag("stump") then
                MakeSmallBurnable(inst)
            else
                MakeLargeBurnable(inst)
                inst.components.burnable:SetFXLevel(5)
                inst.components.burnable:SetOnBurntFn(tree_burnt)
                inst.components.burnable.extinguishimmediately = false
                inst.components.burnable:SetOnIgniteFn(OnIgnite)
                inst.components.burnable.onextinguish = function(inst)
                end
            end
        end
        if not inst.components.propagator then MakeLargePropagator(inst) end
    end

    if not inst:HasTag("burnt") and inst:HasTag("fire") then
        inst.sg:GoToState("empty")
        inst.AnimState:SetBank("tree_leaf")
        OnBurnt(inst, true)
    end

    if not inst.components.inspectable then
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree
    end
end

local function OnSpawned(inst, child) child.sg:GoToState("descendtree") end

local function testSpawning(inst)
    if TheWorld.state.isday or (TheWorld.state.moonphase == "new" and TheWorld.state.isnight) then
        inst.components.childspawner:StartSpawning()
    else
        inst.components.childspawner:StopSpawning()
    end
end

local function onoccupied(inst, child)
    if child.components.inventory:NumItems() > 0 then
        for i, item in ipairs(GetItemschild(function() return true end), child) do
            child.components.inventory:DropItem(item)
            inst.components.inventory:GiveItem(item)
        end
    end
end

local function setupspawner(inst)
    local childspawner = inst:AddComponent("childspawner")
    childspawner.childname = "piko"
    childspawner:SetRareChild("piko_orange", .25)
    childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4) -- 4 days regen
    childspawner:SetSpawnPeriod(8) -- 8 seconds spawn
    childspawner:SetMaxChildren(1)
    testSpawning(inst)
    inst:AddTag("dumpchildrenonignite")
    inst:ListenForEvent("enterlight", testSpawning)
    inst:ListenForEvent("enterdark", testSpawning)
end

local function onsave(inst, data)
    if inst.components.childspawner then data.pikonest = true end

    if inst:HasTag("burnt") or inst:HasTag("fire") then data.burnt = true end

    if inst:HasTag("stump") then data.stump = true end

    if inst.build ~= "normal" then data.build = inst.build end
end

local function onload(inst, data)
    if data then
        if data.pikonest then inst:AddTag("piko_nest") end

        if data.burnt then inst:AddTag("burnt") end

        if data.stump then inst:AddTag("stump") end

        if data and data.pikonest then setupspawner(inst) end

        inst.build = data.build and builds[data.build] and data.build or "normal"

        if inst.components.growable then
            inst.anims = ({short_anims, normal_anims, tall_anims})[inst.components.growable.stage]
        end

        if data.burnt then
            inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
            inst.MiniMapEntity:SetIcon("teatree_burnt.tex")
        elseif data.stump then
            while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
            while inst:HasTag("cattoyairborne") do inst:RemoveTag("cattoyairborne") end
            inst:RemoveComponent("burnable")
            if not inst:HasTag("stump") then inst:AddTag("stump") end
            if data.monster then
                inst.AnimState:SetBank("tree_leaf_monster")
                if GetBuild(inst).leavesbuild then
                    inst.AnimState:OverrideSymbol("legs", GetBuild(inst).leavesbuild, "legs")
                    inst.AnimState:OverrideSymbol("legs_mouseover", GetBuild(inst).leavesbuild, "legs_mouseover")
                else
                    inst.AnimState:ClearOverrideSymbol("legs")
                    inst.AnimState:ClearOverrideSymbol("legs_mouseover")
                end
            end
            inst.AnimState:PlayAnimation(inst.anims.stump)
            inst.MiniMapEntity:SetIcon("teatree_stump.tex")

            MakeSmallBurnable(inst)
            inst:RemoveComponent("workable")
            inst:RemoveComponent("propagator")
            inst:RemoveComponent("growable")
            --            inst:RemoveComponent("blowinwindgust")
            RemovePhysicsColliders(inst)

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetOnFinishCallback(dig_up_stump)
            inst.components.workable:SetWorkLeft(1)
        end
    end

    if not data or (not data.burnt and not data.stump) then
        if inst.build ~= "normal" or inst.leaf_state ~= inst.target_leaf_state then
        else
            if inst.build == "barren" then
                while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
                inst.AnimState:Hide("mouseover")
            else
                inst.AnimState:Show("mouseover")
            end
        end
    end
end

local function oninit(inst)
    if inst:HasTag("piko_nest") and not inst:HasTag("stump") and not inst:HasTag("burnt") then
        local piko_nest = SpawnAt("teatree_piko_nest", inst)
        inst:Remove()
    end
end

local function setupAsPikoNest(inst)
    if TheWorld.meta.pikofixed or inst.components.childspawner then return end

    local x, y, z = inst.Transform:GetWorldPosition()
    for t, node in ipairs(TheWorld.topology.nodes) do
        if node.type == "piko_land" and TheSim:WorldPointInPoly(x, z, node.poly) then
            setupspawner(inst)
            break
        end
    end
end

local function makefn(build, stage, data)
    local function fn()
        if stage == 0 then stage = math.random(1, 3) end

        local inst = CreateEntity()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        local anim = inst.entity:AddAnimState()

        MakeObstaclePhysics(inst, .25)

        inst.MiniMapEntity:SetIcon("teatree.tex")
        inst.MiniMapEntity:SetPriority(-1)

        inst:AddTag("plant")
        inst:AddTag("tree")
        inst:AddTag("teatree")
        inst:AddTag("shelter")
        inst:AddTag("workable")
        inst:AddTag("cattoyairborne")
        inst:AddTag("twiggytreesw")

        anim:SetBank("tree_leaf")
        inst.build = build
        anim:SetBuild("teatree_trunk_build")

        if GetBuild(inst).leavesbuild then
            anim:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
        end
        inst.color = 0.7 + math.random() * 0.3
        anim:SetMultColour(inst.color, inst.color, inst.color, 1)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then return inst end

        MakeLargeBurnable(inst)
        inst.components.burnable:SetFXLevel(5)
        inst.components.burnable:SetOnBurntFn(tree_burnt)
        inst.components.burnable.extinguishimmediately = false
        inst.components.burnable:SetOnIgniteFn(OnIgnite)

        MakeLargePropagator(inst)

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(chop_tree)
        inst.components.workable:SetOnFinishCallback(chop_down_tree)

        inst:AddComponent("lootdropper")
        inst:AddComponent("inventory")
        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(stage)
        inst.components.growable.loopstages = true
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()

        inst.growfromseed = handler_growfromseed
        inst.leaf_state = "normal"

        inst.AnimState:SetTime(math.random() * 2)

        inst.OnSave = onsave
        inst.OnLoad = onload

        MakeSnowCovered(inst, .01)

        inst:SetPrefabName(GetBuild(inst).prefab_name)

        if data == "burnt" then
            OnBurnt(inst)
        elseif data == "stump" then
            inst:RemoveTag("shelter")
            inst:RemoveComponent("burnable")
            MakeSmallBurnable(inst)
            inst:RemoveComponent("workable")
            inst:RemoveComponent("propagator")
            inst:RemoveComponent("growable")
            RemovePhysicsColliders(inst)
            inst.AnimState:PlayAnimation(inst.anims.stump)
            inst.MiniMapEntity:SetIcon("teatree_stump.tex")
            inst:AddTag("stump")
            inst:RemoveTag("teatree")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetOnFinishCallback(dig_up_stump)
            inst.components.workable:SetWorkLeft(1)
        elseif data == "piko_nest" then
            inst:AddTag("spyable")
            setupspawner(inst)
        end
        inst:DoTaskInTime(0, function() setupAsPikoNest(inst) end)

        inst:DoTaskInTime(0.5, oninit)

        inst.setupspawner = setupspawner
        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake

        inst.Sway = Sway

        inst:SetStateGraph("SGdeciduoustree1")
        inst.sg:GoToState("empty")
        return inst
    end
    return fn
end

local function tree(name, build, stage, data) return Prefab(name, makefn(build, stage, data), assets, prefabs) end

return tree("teatree", "normal", 0), tree("teatree_burnt", "normal", 0, "burnt"),
       tree("teatree_stump", "normal", 0, "stump"), tree("teatree_piko_nest", "normal", 0, "piko_nest"),
       tree("teatree_tall", "normal", 3), tree("teatree_normal", "normal", 2), tree("teatree_short", "normal", 1)
