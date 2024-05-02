GLOBAL.setfenv(1, GLOBAL)

local TileGroupManager = TileGroupManager

function GetTileDepth(tile)
    local tileinfo = GetTileInfo(tile) or {}
    return OCEAN_DEPTH[tileinfo.ocean_depth] or 0
end

local function IsUnBuildable(tile)
    if tile == WORLD_TILES.OCEAN_SHIPGRAVEYARD then return true end
    return GetTileDepth(tile) >= OCEAN_DEPTH.DEEP
end

local function IsShallow(tile)
    if tile == WORLD_TILES.MANGROVE then return false end
    return GetTileDepth(tile) <= OCEAN_DEPTH.SHALLOW
end

function IsUnBuildableOceanTile(tile)
	return IsOceanTile(tile) and IsUnBuildable(tile)
end

function IsBuildableOceanTile(tile)
    return IsOceanTile(tile) and not IsUnBuildable(tile)
end

function IsShallowOceanTile(tile)
	return IsOceanTile(tile) and IsShallow(tile)
end

function IsIAOceanTile(tile)
    return IA_OCEAN_TILES[tile] ~= nil
end

function IsIALandTile(tile)
    return IA_LAND_TILES[tile] ~= nil
end

function CheckTileAtPoint(x, y, z, check, ...)
    x, y, z = GetWorldPosition(x, y, z)
	return CheckTileType({x = x, y = y, z = z}, check, ...)
end

function IsOnFlood(x, y, z)
    x, y, z = GetWorldPosition(x, y, z)
    local _flood = TheWorld.components.flooding
	return _flood ~= nil and _flood:OnFlood(x, y, z)
end

function IsOnOcean(x, y, z, onflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
    local _map = TheWorld.Map

    return onflood and IsOnFlood(x, y, z) or _map:IsOceanAtPoint( x, y, z, ignoreboat)
end

--deprecated
IsOnWater = IsOnOcean

function IsOnLand(x, y, z, noflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)

    return (not noflood or not IsOnFlood(x, y, z)) and TheWorld.Map:IsPassableAtPoint(x, y, z, false, ignoreboat)
end

local function _test_is_ocean_at_point(x, y, z, map, flood)
    return flood ~= nil and flood:IsFloodTileAtPoint(x, y, z) or map:IsActualOceanTileAtPoint(x, y, z)
end

local function _test_is_land_at_point(x, y, z, map, flood)
    return (flood == nil or not flood:IsFloodTileAtPoint(x, y, z)) and map:IsActualLandTileAtPoint(x, y, z)
end

function IsSurroundedByTile(x, y, z, radius, check, ...)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1
	return TheWorld.Map:IsSurroundedByTile(x, y, z, radius, 4, CheckTileAtPoint, check, ...)
end

function IsCloseToTile(x, y, z, radius, check, ...)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1
	return TheWorld.Map:IsCloseToTile(x, y, z, radius, 4, CheckTileAtPoint, check, ...)
end

function IsSurroundedByWaterTile(x, y, z, radius, onflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1

    local _world = TheWorld
    local _map = TheWorld.Map
    local _flood = onflood and _world.components.flooding or nil
    return (ignoreboat or _map:GetNearbyPlatformAtPoint(x, y, z, radius) == nil) and _map:IsSurroundedByTile(x, y, z, radius, _flood ~= nil and 2 or 4, _test_is_ocean_at_point, _map, _flood)
end

function IsSurroundedByLandTile(x, y, z, radius, noflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1

    local _world = TheWorld
    local _map = TheWorld.Map
    local _flood = noflood and _world.components.flooding or nil
    return (not ignoreboat and _map:GetNearbyPlatformAtPoint(x, y, z, -radius) ~= nil) or _map:IsSurroundedByTile(x, y, z, radius, _flood ~= nil and 2 or 4, _test_is_land_at_point, _map, _flood)
end

function IsCloseToWaterTile(x, y, z, radius, noflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1

    local _world = TheWorld
    local _map = TheWorld.Map
    local _flood = noflood and _world.components.flooding or nil
    return (ignoreboat or _map:GetNearbyPlatformAtPoint(x, y, z, -radius) == nil) and _map:IsCloseToTile(x, y, z, radius, _flood ~= nil and 2 or 4, _test_is_ocean_at_point, _map, _flood)
end

function IsCloseToLandTile(x, y, z, radius, noflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
	radius = radius or 1

    local _world = TheWorld
    local _map = TheWorld.Map
    local _flood = noflood and _world.components.flooding or nil
    return (not ignoreboat and _map:GetNearbyPlatformAtPoint(x, y, z, radius) ~= nil) or _map:IsCloseToTile(x, y, z, radius, _flood ~= nil and 2 or 4, _test_is_land_at_point, _map, _flood)
end

local _TintByOceanTile = TintByOceanTile
function TintByOceanTile(...)
    if TheWorld.has_ia_ocean then
        return
    end
    return _TintByOceanTile(...)
end

function IsOverhangBetweenTiles(tile, visual_tile)
    return TileGroupManager:IsLandTile(tile) ~= TileGroupManager:IsLandTile(visual_tile)
        or TileGroupManager:IsOceanTile(tile) ~= TileGroupManager:IsOceanTile(visual_tile)
        or TileGroupManager:IsInvalidTile(tile) ~= TileGroupManager:IsInvalidTile(visual_tile)
end

local SPLASH_WETNESS = 9
function DoWaveSplash(inst, boosted)
    local wave_splash = SpawnPrefab(inst.splash or "wave_splash")
    local pos = inst:GetPosition()
    TintByOceanTile(wave_splash)
    wave_splash.Transform:SetPosition(pos.x, pos.y, pos.z)
    wave_splash.Transform:SetRotation(inst.Transform:GetRotation())

    if not boosted then
        --get wet and take damage
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 4)
        for _, v in pairs(ents) do
            local moisture = v.components.moisture
            local owner = v.components.inventoryitem and v.components.inventoryitem:GetGrandOwner()
            if moisture ~= nil and (owner == nil or not owner:IsSailing()) then
                local boat = v.components.sailor and v.components.sailor:GetBoat()
                local hitmoisturerate = v.components.locomotor ~= nil and v.components.locomotor:GetExternalSpeedAdder(v, "SURF") ~= 0 and 0
                or (boat and boat.components.sailable and math.min(boat.components.sailable:GetHitMoistureRate(), 1)) or 1

                local waterproofness = moisture:GetWaterproofness()
                moisture:DoDelta((inst.hitmoisture or SPLASH_WETNESS) * (1 - waterproofness) * hitmoisturerate)

                if inst.damagesplash ~= "" then
                    local entity_splash = SpawnPrefab(inst.damagesplash or "splash")
                    entity_splash.Transform:SetPosition(v:GetPosition():Get())
                end
            end
        end
    end

    inst:Remove()
end

function CollideWithWave(inst, other)

    -- Disable waves colliding with rising waves because some of the ds wave spawns are too close to each other
    -- causing the waves to collide with each other when spawned - Half
    if not other
        or not inst.waveactive --In DST this has a 0.3 sec delay and only disables collision with waves... this is fine -_-
        or (other:HasTag("wave")
        and other.sg:HasStateTag("rising")) then
        return
    end

    local boostThreshold = TUNING.WAVE_BOOST_ANGLE_THRESHOLD
    if other:IsSailing() then
        local surfer = other:HasTag("surfer") and other.components.sailor and other.components.sailor.boat and other.components.sailor.boat:HasTag("surfboard")
        local surffood = other.components.locomotor ~= nil and other.components.locomotor:GetExternalSpeedAdder(other, "SURF") ~= 0
        local moving = other.sg:HasStateTag("moving")

        local playerAngle =  other.Transform:GetRotation()
        if playerAngle < 0 then playerAngle = playerAngle + 360 end

        local waveAngle = inst.Transform:GetRotation()
        if waveAngle < 0 then waveAngle = waveAngle + 360 end

        local angleDiff = math.abs(waveAngle - playerAngle)
        if angleDiff > 180 then angleDiff = 360 - angleDiff end

        if (inst.small or surfer or surffood) and (angleDiff < boostThreshold or surffood) and moving then
            --Do boost
            local rogueboost = surfer and not inst.small and TUNING.SURFBOARD_ROGUEBOOST or nil
            other:PushEvent("boostbywave", {position = inst.Transform:GetWorldPosition(), velocity = inst.Physics:GetVelocity(), boost = rogueboost})
            if other.SoundEmitter then
                other.SoundEmitter:PlaySound("ia/common/waves/boost")
            end

            inst:DoSplash(true)
        else
            if not surffood then
                local boat = other.components.sailor and other.components.sailor:GetBoat()
                if boat and boat.components.boathealth then
                    boat.components.boathealth:DoDelta(inst.hitdamage or -TUNING.ROGUEWAVE_HIT_DAMAGE, "wave")
                end
            end
            inst:DoSplash()
        end
    elseif other:HasTag("player") then
        inst:DoSplash()
    elseif other.components.boatphysics then
        local vx, vy, vz = inst.Physics:GetVelocity()
        local norm_x, norm_z, length = VecUtil_NormalAndLength(vx, vz)
        other.components.boatphysics:ApplyForce(norm_x, norm_z, length * (inst.forcemult or 0.5))
        inst:DoSplash()
    elseif other.components.waveobstacle then
        local hit, splash = other.components.waveobstacle:IsHit(inst)
        if hit then other.components.waveobstacle:OnCollide(inst) end
        if splash then inst:DoSplash() end
    elseif not inst.dontcollideall or other.components.waterphysics and not other.components.waterphysics:IsWeak() then
        inst:DoSplash()
    end
end

-- Store the globals for optimization
local IA_OCEAN_PREFABS = IA_OCEAN_PREFABS
local DST_OCEAN_PREFABS = DST_OCEAN_PREFABS

local WAVE_SPAWN_DISTANCE = 1.5
local _SpawnAttackWaves = SpawnAttackWaves
function SpawnAttackWaves(position, rotation, spawn_radius, numWaves, totalAngle, waveSpeed, wavePrefab, idleTime, instantActive, ...)
    if TheWorld.has_ia_ocean then
        wavePrefab = IA_OCEAN_PREFABS[wavePrefab] or wavePrefab or "wave_rogue"
    else
        wavePrefab = DST_OCEAN_PREFABS[wavePrefab] or wavePrefab or "wave_med"
    end

    if wavePrefab ~= "wave_ripple" and wavePrefab ~= "wave_rogue" then
        return _SpawnAttackWaves(position, rotation, spawn_radius, numWaves, totalAngle, waveSpeed, wavePrefab, idleTime, instantActive, ...)
    end


    waveSpeed = waveSpeed or 6
    idleTime = idleTime or 5
    totalAngle = (numWaves == 1 and 0) or
            (totalAngle and (totalAngle % 361)) or
            360

    local anglePerWave = (totalAngle == 0 and 0) or
            (totalAngle == 360 and totalAngle/numWaves) or
            totalAngle/(numWaves - 1)

    local startAngle = rotation or math.random(-180, 180)
    local total_rad = (spawn_radius or 0.0) + WAVE_SPAWN_DISTANCE

    local wave_spawned = false
    for i = 0, numWaves - 1 do
        local angle = (startAngle - (totalAngle/2)) + (i * anglePerWave)
        local offset_direction = Vector3(math.cos(angle*DEGREES), 0, -math.sin(angle*DEGREES)):Normalize()
        local wavepos = position + (offset_direction * total_rad)

        if not TheWorld.Map:IsPassableAtPoint(wavepos:Get()) then
            wave_spawned = true

            local wave = SpawnPrefab(wavePrefab)
            wave.Transform:SetPosition(wavepos:Get())
            wave.Transform:SetRotation(angle)
            if type(waveSpeed) == "table" then
                wave.Physics:SetMotorVel(waveSpeed[1], waveSpeed[2], waveSpeed[3])
            else
                wave.Physics:SetMotorVel(waveSpeed, 0, 0)
            end
            wave.idle_time = idleTime

            -- Ugh just because of the next two blocks I had to copy and paste all this -_- -Half
            if instantActive then
                wave.sg:GoToState("idle")
            end

            if wave.soundtidal then
                wave.SoundEmitter:PlaySound(wave.soundtidal)
            end
        end
    end

    -- Let our caller know if we actually spawned at least 1 wave.
    return wave_spawned
end

-- function that converts the old wave function params to the new one
 function SpawnWaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActive, random_angle)
    return SpawnAttackWaves(inst:GetPosition(), (random_angle and math.random(-180, 180)) or inst.Transform:GetRotation(), initialOffset or (inst.Physics and inst.Physics:GetRadius()) or 0.0, numWaves, totalAngle, waveSpeed, wavePrefab or "wave_med",  idleTime or 5, instantActive)
end

-- for worldgen checks, use SpawnUtil.FindRandomWaterPoints
-- this works tile coords, not actual ingame points
function FindRandomWaterPoints(checkFn, edge_dist, needed)
	local width, height = TheWorld.Map:GetSize()
	local get_points = function(_points, _checkFn, _edge_dist, inc)
		local adj_width, adj_height = width - 2 * edge_dist, height - 2 * edge_dist
		local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)
		local i, j = 0, 0
		while j < adj_height and #_points < needed do
			local y = ((start_y + j) % adj_height) + edge_dist
			while i < adj_width and #_points < needed do
				local x = ((start_x + i) % adj_width) + edge_dist
				-- local ground = WorldSim:GetTile(x, y)
				-- if checkFn(ground, x, y) then
				if checkFn == nil or checkFn(TheWorld.Map:GetTile(x, y), x, y, _points) then
					table.insert(_points, {x = x, y = y})
				end
				i = i + inc
			end
			j = j + inc
			i = 0
		end
	end

	local points = {}
	local incs = {263, 137, 67, 31, 17, 9, 5, 3, 1}

	for i = 1, #incs do
		if #points < needed then
			get_points(points, checkFn, edge_dist, incs[i])
			-- print(string.format("%d (of %d) points found", #points, needed))
		end
	end

	return shuffleArray(points)
end

function FindOceanBetweenPoints(p0x, p0y, p1x, p1y)
	local map = TheWorld.Map

	local dx = math.abs(p1x - p0x)
	local dy = math.abs(p1y - p0y)

    local ix = p0x < p1x and TILE_SCALE or -TILE_SCALE
    local iy = p0y < p1y and TILE_SCALE or -TILE_SCALE

    local e = 0;
    for i = 0, dx+dy - 1 do
        local tile_at_point = map:GetTileAtPoint(p0x, 0, p0y)
        if IsOceanTile(tile_at_point) then
			return map:GetTileCenterPoint(p0x, 0, p0y)
		end

        local e1 = e + dy
        local e2 = e - dx
        if math.abs(e1) < math.abs(e2) then
            p0x = p0x + ix
            e = e1
		else
            p0y = p0y + iy
            e = e2
        end
	end

	return nil
end

function FindRandomPointOnOceanFromShore(x, y, z, allow_boats)
	local nodes = {}

    for i, node in ipairs(TheWorld.topology.nodes) do
		if node.type ~= NODE_TYPE.Blank and node.type ~= NODE_TYPE.Blocker and node.type ~= NODE_TYPE.SeparatedRoom then
			table.insert(nodes, {n = node, distsq = VecUtil_LengthSq(x - node.x, z - node.y)})
		end
	end
	table.sort(nodes, function(a, b) return a.distsq < b.distsq end)

	local num_rooms_to_pick = 4

	local closest = {}
	for i = 1, num_rooms_to_pick do
		table.insert(closest, nodes[i])
	end
	shuffleArray(closest)

	local dest_x, dest_y, dest_z
	for _, c in ipairs(closest) do
		dest_x, dest_y, dest_z = FindOceanBetweenPoints(c.n.x, c.n.y, x, z)
		if dest_x ~= nil and not TheSim:WorldPointInPoly(dest_x, dest_z, c.n.poly) and (allow_boats or TheWorld.Map:GetNearbyPlatformAtPoint(dest_x, dest_y, dest_z, 3) == nil) then
			return dest_x, dest_y, dest_z
		end
	end

	for i = num_rooms_to_pick + 1, #nodes do
		local c = nodes[i]
		if c ~= nil then
			dest_x, dest_y, dest_z = FindOceanBetweenPoints(x, z, c.n.x, c.n.y)
			if dest_x ~= nil and not TheSim:WorldPointInPoly(dest_x, dest_z, c.n.poly) and (allow_boats or TheWorld.Map:GetNearbyPlatformAtPoint(dest_x, dest_y, dest_z, 3) == nil) then
				return dest_x, dest_y, dest_z
			end
		end
	end

	if TheWorld.components.playerspawner ~= nil then
		return TheWorld.components.playerspawner:GetAnySpawnPoint()
	end

	return nil
end

local SAILABLE_MUST_TAGS = {"sailable"}
local SAILABLE_CANT_TAGS = {"INLIMBO", "fire", "NOCLICK"}
function GetClosestBoatInRange(x, y, z, range)
	return TheSim:FindEntities(x, y, z, range, SAILABLE_MUST_TAGS, SAILABLE_CANT_TAGS)[1]
end