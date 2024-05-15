local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

local FLOCK_SIZE = 9
local MIN_SPAWN_DIST = 40
local LAND_CHECK_RADIUS = 6
local WATER_CHECK_RADIUS = 2

local MAX_DIST_FROM_PLAYER = 12
local MAX_DIST_FROM_WATER = 6
local MIN_DIST_FROM_STRUCTURES = 20

local SEARCH_RADIUS = 50
local SEARCH_RADIUS2 = SEARCH_RADIUS * SEARCH_RADIUS

local FindLandNextToWater

local function FindSpawnLocationForPlayer(player)
    if IsInIAClimate(player) then return end --no penguins in tropical lands!
    local playerPos = Vector3(player.Transform:GetWorldPosition())

    local radius = LAND_CHECK_RADIUS
    local landPos
    local tmpAng
    local map = TheWorld.Map

    local test = function(offset)
        local run_point = playerPos + offset
        -- Above ground, this should be water
        if not map:IsAboveGroundAtPoint(run_point:Get()) or IsOnOcean(run_point) then
            local loc, ang, def = FindLandNextToWater(playerPos, run_point)
            if loc ~= nil then
                landPos = loc
                tmpAng = ang
                --print("true angle",ang,ang/DEGREES)
                return true
            end
        end
        return false
    end

    local cang = (math.random() * 360) * DEGREES
    --print("cang:",cang)
    local loc, landAngle, deflected = FindValidPositionByFan(cang, radius, 7, test)
    if loc ~= nil then
        return landPos, tmpAng, deflected
    end
end


TAENV.AddComponentPostInit("penguinspawner", function(cmp)
    --all of these functions are to be overridden in TryToSpawnFlockForPlayer -> TryToSpawnFlock -> periodic task
    local TryToSpawnFlock
    for per, _ in pairs(cmp.inst.pendingtasks) do
        TryToSpawnFlock = UpvalueHacker.GetUpvalue(per.fn, "TryToSpawnFlock")
        if TryToSpawnFlock then
            break
        end
    end
    local TryToSpawnFlockForPlayer
    if TryToSpawnFlock then
        TryToSpawnFlockForPlayer = UpvalueHacker.GetUpvalue(TryToSpawnFlock, "TryToSpawnFlockForPlayer")
    end
    if not TryToSpawnFlockForPlayer then
        return print("Failed to edit penguinspawner", TryToSpawnFlock, TryToSpawnFlockForPlayer)
    end

    local _EstablishColony = UpvalueHacker.GetUpvalue(TryToSpawnFlockForPlayer, "EstablishColony")
    local _SpawnFlock = UpvalueHacker.GetUpvalue(TryToSpawnFlockForPlayer, "SpawnFlock")
    local SpawnPenguin = UpvalueHacker.GetUpvalue(_SpawnFlock, "SpawnPenguin")

    local _maxColonySize = UpvalueHacker.GetUpvalue(_EstablishColony, "_maxColonySize")
    local _numBoulders = UpvalueHacker.GetUpvalue(_EstablishColony, "_numBoulders")
    local _flockSize = UpvalueHacker.GetUpvalue(_SpawnFlock, "_flockSize")
    local _spacing = UpvalueHacker.GetUpvalue(_EstablishColony, "_spacing")

    FindLandNextToWater = function(playerpos, waterpos)
        --print("FindWalkableOffset:")
        local ignore_walls = true
        local radius = WATER_CHECK_RADIUS
        local world = TheWorld
        local map = world.Map

        local test = function(offset)
            local run_point = waterpos + offset

            return map:IsAboveGroundAtPoint(run_point:Get()) and
                not IsOnOcean(run_point) and
                world.Pathfinder:IsClear(
                    playerpos.x, playerpos.y, playerpos.z,
                    run_point.x, run_point.y, run_point.z,
                    { ignorewalls = ignore_walls, ignorecreep = true })
        end

        -- FindValidPositionByFan(start_angle, radius, attempts, test_fn)
        -- returns offset, check_angle, deflected
        local loc, landAngle, deflected = FindValidPositionByFan(0, radius, 8, test)
        if loc then
            --print("Fan angle=",landAngle)
            return waterpos + loc, landAngle, deflected
        end
    end



    local function SpawnFlock(colonyNum, loc, check_angle)
        local map = TheWorld.Map
        local flock = GetRandomWithVariance(_flockSize, 3)
        local spawned = 0
        local i = 0
        local pang = check_angle / DEGREES
        while spawned < flock and i < flock + 7 do
            local spawnPos = loc + Vector3(GetRandomWithVariance(0, 0.5), 0.0, GetRandomWithVariance(0, 0.5))
            i = i + 1
            if map:IsAboveGroundAtPoint(spawnPos:Get()) and not IsOnOcean(spawnPos) then
                spawned = spawned + 1
                --print(TheCamera:GetHeading()%360,"Spawn flock at:",spawnPos,(check_angle/DEGREES),"degrees"," c_off=",c_off)
                --print(TheCamera:GetHeading()," spawnPenguin at",pos,"angle:",angle)
                cmp.inst:DoTaskInTime(GetRandomWithVariance(1, 1), SpawnPenguin, cmp, colonyNum, spawnPos,
                    (check_angle / DEGREES))
            end
        end
    end

    local function EstablishColony(loc)
        local _colonies = UpvalueHacker.GetUpvalue(_EstablishColony, "_colonies")

        local radius = SEARCH_RADIUS
        local pos
        local ignore_walls = false
        local check_los = true
        local colonies = _colonies
        local world = TheWorld
        local map = world.Map

        local testfn = function(offset)
            local run_point = loc + offset
            if not map:IsAboveGroundAtPoint(run_point:Get()) or IsOnOcean(run_point) then
                --print("not above ground")
                return false
            end

            if IsInIAClimate(run_point) then
                return false
            end

            local NearWaterTest = function(offset)
                local test_point = run_point + offset
                return not map:IsAboveGroundAtPoint(test_point:Get()) or IsOnOcean(test_point)
            end

            --  FindValidPositionByFan(start_angle, radius, attempts, test_fn)
            if check_los and
                not world.Pathfinder:IsClear(loc.x, loc.y, loc.z,
                    run_point.x, run_point.y, run_point.z,
                    { ignorewalls = ignore_walls, ignorecreep = true }) then
                --print("no path or los")
                return false
            end

            if FindValidPositionByFan(0, 6, 16, NearWaterTest) then
                --print("colony too near water")
                return false
            end

            if #(TheSim:FindEntities(run_point.x, run_point.y, run_point.z, MIN_DIST_FROM_STRUCTURES, { "structure" })) > 0 then
                --print("colony too close to structures")
                return false
            end

            -- Now check that the rookeries are not too close together
            local found = true
            for i, v in ipairs(colonies) do
                local pos = v.rookery
                -- What about penninsula effects? May have a long march
                if pos and distsq(run_point, pos) < _spacing * _spacing then
                    --print("too close to another rookery")
                    found = false
                end
            end
            return found
        end

        -- Look for any nearby colonies with enough room
        -- return the colony if you find it
        for i, v in ipairs(_colonies) do
            if GetTableSize(v.members) <= (_maxColonySize - (FLOCK_SIZE * .8)) then
                pos = v.rookery
                if pos and distsq(loc, pos) < SEARCH_RADIUS2 + 60 and
                    world.Pathfinder:IsClear(loc.x, loc.y, loc.z, -- check for interposing water
                        pos.x, pos.y, pos.z,
                        { ignorewalls = false, ignorecreep = true }) then
                    --print("************* Found existing colony")
                    return i
                end
            end
        end

        -- Make a new colony
        local newFlock = { members = {} }

        -- Find good spot far enough away from the other colonies
        radius = SEARCH_RADIUS
        while not newFlock.rookery and radius > 30 do
            newFlock.rookery = FindValidPositionByFan(math.random() * PI * 2.0, radius, 32, testfn)
            radius = radius - 10
        end

        if newFlock.rookery then
            for i, node in ipairs(TheWorld.topology.nodes) do
                if TheSim:WorldPointInPoly(loc.x, loc.z, node.poly) then
                    if node.tags ~= nil and table.contains(node.tags, "moonhunt") then
                        newFlock.is_mutated = true
                    end
                    break
                end
            end

            newFlock.rookery = newFlock.rookery + loc
            newFlock.ice = SpawnPrefab("penguin_ice")
            newFlock.ice.Transform:SetPosition(newFlock.rookery:Get())
            newFlock.ice.spawner = cmp
            if newFlock.is_mutated then
                newFlock.ice.MiniMapEntity:SetIcon("mutated_penguin.png")
            end

            local numboulders = math.random(math.floor(_numBoulders / 2), _numBoulders)
            local sectorsize = 360 / numboulders
            local numattempts = 50
            while numboulders > 0 and numattempts > 0 do
                local foundvalidplacement = false
                local placement_attempts = 0
                while not foundvalidplacement do
                    local minang = (sectorsize * (numboulders - 1)) >= 0 and (sectorsize * (numboulders - 1)) or 0
                    local maxang = (sectorsize * numboulders) <= 360 and (sectorsize * numboulders) or 360
                    local angle = math.random(minang, maxang)
                    local pos = newFlock.ice:GetPosition()
                    local offset = FindWalkableOffset(pos, angle * DEGREES, math.random(5, 15), 120, false, false)
                    if offset then
                        local ents = TheSim:FindEntities(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z, 1.2)
                        if #ents == 0 then
                            foundvalidplacement = true
                            numboulders = numboulders - 1

                            local icerock = SpawnPrefab("rock_ice")
                            icerock.Transform:SetPosition(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z)
                            icerock.remove_on_dryup = true
                        end
                    end
                    placement_attempts = placement_attempts + 1
                    --print("placement_attempts:", placement_attempts)
                    if placement_attempts > 10 then break end
                end
                numattempts = numattempts - 1
            end
        else
            return false
        end

        _colonies[#_colonies + 1] = newFlock
        return #_colonies
    end

    UpvalueHacker.SetUpvalue(TryToSpawnFlockForPlayer, FindSpawnLocationForPlayer, "FindSpawnLocationForPlayer")
    UpvalueHacker.SetUpvalue(TryToSpawnFlockForPlayer, SpawnFlock, "SpawnFlock")
    UpvalueHacker.SetUpvalue(TryToSpawnFlockForPlayer, EstablishColony, "EstablishColony")
end)
