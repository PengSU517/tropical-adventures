local assets =
{
    --Asset("ANIM", "anim/arrow_indicator.zip"),
}

local prefabs =
{
    "spider_monkey",
}

local SPIDER_MONKEY_MATING_SEASON_BABYDELAY = 480 * 1.5
local SPIDER_MONKEY_MATING_SEASON_BABYDELAY_VARIANCE = 0.5 * 480

local function CanSpawn(inst)
    return inst.components.herd and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, newent)
    if inst.components.herd then
        inst.components.herd:AddMember(newent)
    end
end

local function OnHomeDestroyed(inst)
    RefreshHomeTree(inst)
end

local function ReplaceTree(tree)
    local treePos = Vector3(tree.Transform:GetWorldPosition())
    tree:Remove()
    local homeTree = SpawnPrefab("spider_monkey_tree")
    homeTree.Transform:SetPosition(treePos.x, treePos.y, treePos.z)
    return homeTree
end

local function GetNewHomeTree(inst)
    for k, v in pairs(inst.components.herd.members) do
        local x, y, z = k.Transform:GetWorldPosition()
        local noneOfTags = { "player", "fx", "burnt", "stump" }
        local possibleHomeTrees = nil

        if x and y and z then
            possibleHomeTrees = TheSim:FindEntities(x, y, z, 300, { "jungletree" }, noneOfTags)
        end

        if possibleHomeTrees then
            for i, possibleHomeTree in ipairs(possibleHomeTrees) do
                local possibleHomeTreePos = Vector3(possibleHomeTree.Transform:GetWorldPosition())
                local tile = TheWorld.Map:GetTileAtPoint(possibleHomeTreePos.x, 0, possibleHomeTreePos.z)

                -- Only get the new tree if it's offscreen because there is no animation
                -- for it transforming from a jungle tree to a spider monkey tree.
                local isJungleTile = tile == GROUND.DEEPRAINFOREST

                if isJungleTile then
                    local possibleNeighborTrees = TheSim:FindEntities(possibleHomeTreePos.x, possibleHomeTreePos.y,
                        possibleHomeTreePos.z, 7, { "jungletree" }, noneOfTags)

                    -- Allow neighboring trees to be affected by the ground creep of the cobwebs.
                    if possibleNeighborTrees then
                        for i, possibleNeighborTree in ipairs(possibleNeighborTrees) do
                            if possibleNeighborTree ~= possibleHomeTree then
                                ReplaceTree(possibleNeighborTree)
                            end
                        end
                    end

                    return ReplaceTree(possibleHomeTree)
                end
            end
        end
    end

    return nil
end

local function OnAddMember(inst, member)
    if inst.homeTree then
        member.components.knownlocations:RememberLocation("home", Point(inst.homeTree.Transform:GetWorldPosition()),
            false)
    end
end

local function RefreshHerdMemberHomeLocations(inst)
    for k, v in pairs(inst.components.herd.members) do
        OnAddMember(inst, k)
    end
end

local function RefreshHomeTree(inst)
    if not inst.homeTree or inst.homeTree:HasTag("stump") or inst.homeTree:HasTag("burnt") then
        inst.homeTree = GetNewHomeTree(inst)

        if inst.homeTree then
            -- Cross reference the spider monkey tree with the herd
            inst.homeTree.spiderMonkeyHerd = inst

            -- Ensure that all of the herd members remember the home tree location.
            RefreshHerdMemberHomeLocations(inst)
        end
    end
end

local function OnEmpty(inst)
    inst:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("herd")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("spider_monkey")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetOnEmptyFn(OnEmpty)
    inst.components.herd:SetAddMemberFn(OnAddMember)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(SPIDER_MONKEY_MATING_SEASON_BABYDELAY,
        SPIDER_MONKEY_MATING_SEASON_BABYDELAY_VARIANCE)
    inst.components.periodicspawner:SetPrefab("spider_monkey")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    --    inst.components.periodicspawner:Start()

    inst.RefreshHomeTreeFn = RefreshHomeTree
    inst.RefreshHomeTreeTask = inst:DoPeriodicTask(5, RefreshHomeTree)

    return inst
end

return Prefab("forest/animals/spider_monkey_herd", fn, assets, prefabs)
