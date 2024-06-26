local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

TUNING.MAPWRAPPER_WARN_RANGE = 14
TUNING.MAPEDGE_PADDING = TUNING.MAPWRAPPER_WARN_RANGE + 10

require("map/network")

local function GenerateBermudaTriangles(root, entities, width, height)
    local numTriangles = TUNING.BERMUDA_AMOUNT
    local minDistSq = 50 * 50

    if entities.bermudatriangle_MARKER == nil then
        entities.bermudatriangle_MARKER = {}
    end

    local function checkTriangle(tile, x, y, points)
        if tile ~= WORLD_TILES.OCEAN_SWELL then
            return false
        end
        for i = 1, #points, 1 do
            local dx = x - points[i].x
            local dy = y - points[i].y
            local dsq = dx * dx + dy * dy

            if dsq < minDistSq then
                return false
            end
        end
        return true
    end

    local pointsX, pointsY = SpawnUtil.FindRandomWaterPoints(checkTriangle, width, height, TUNING.MAPEDGE_PADDING,
        numTriangles)

    for i = 1, #pointsX, 1 do
        local entData = {}
        entData.x = (pointsX[i] - width / 2.0) * TILE_SCALE
        entData.z = (pointsY[i] - height / 2.0) * TILE_SCALE
        table.insert(entities.bermudatriangle_MARKER, entData)
    end
    ---------------------------------
    print(#entities.bermudatriangle_MARKER .. " points for bermudatriangle")
    if #entities.bermudatriangle_MARKER < 2 then return print("WARNING: Not enough points for new bermudatriangle") end

    if entities.bermudatriangle == nil then
        entities.bermudatriangle = {}
    end

    local id = root.MIN_WORMHOLE_ID
    local pair = 0
    minDistSq = minDistSq * TILE_SCALE
    local is_farenough = function(marker1, marker2)
        local diffx, diffz = marker2.x - marker1.x, marker2.z - marker1.z
        local mag = diffx * diffx + diffz * diffz
        if mag < minDistSq then
            return false
        end
        return true
    end

    for i = #entities.bermudatriangle_MARKER, 1, -1 do
        local firstMarkerData = entities.bermudatriangle_MARKER[i]
        if firstMarkerData ~= nil then
            for j = #entities.bermudatriangle_MARKER, 1, -1 do
                local secondMarkerData = entities.bermudatriangle_MARKER[j]
                if secondMarkerData ~= nil and i ~= j and is_farenough(firstMarkerData, secondMarkerData) then
                    firstMarkerData["id"] = id
                    secondMarkerData["id"] = id + 1
                    id = id + 2
                    pair = pair + 1

                    firstMarkerData["data"] = { teleporter = { target = secondMarkerData["id"] } }
                    secondMarkerData["data"] = { teleporter = { target = firstMarkerData["id"] } }

                    table.insert(entities.bermudatriangle, firstMarkerData)
                    table.insert(entities.bermudatriangle, secondMarkerData)

                    entities.bermudatriangle_MARKER[i] = nil
                    entities.bermudatriangle_MARKER[j] = nil
                    break
                end
            end

            if pair > 6 --[[ IAENV.max_pairs and pair >= IAENV.max_pairs ]] then
                break
            end
        end
    end

    print(pair .. " bermudatriangle pairs placed.")

    root.MIN_WORMHOLE_ID = id
    entities.bermudatriangle_MARKER = nil
end

local function GenerateTreasure(root, entities, width, height)
    print("GenerateTreasure")

    if entities.buriedtreasure == nil then
        entities.buriedtreasure = {}
    end
    if entities.ia_messagebottle == nil then
        entities.ia_messagebottle = {}
    end

    local minPaddingTreasure = 4

    local numTreasures = 18 + math.random(0, 2)
    local numBottles = numTreasures +
        #entities
        .buriedtreasure --some might already exist (e.g. DeadmansChest/RockSkull setpiece)

    local function checkLand(tile, x, y)
        if not IsLandTile(tile) then return false end
        local halfw, halfh = width / 2, height / 2
        for prefab, ents in pairs(entities) do
            for i, spawn in ipairs(ents) do
                local dx, dy = (x - halfw) * TILE_SCALE - spawn.x, (y - halfh) * TILE_SCALE - spawn.z
                if math.abs(dx) < minPaddingTreasure and math.abs(dy) < minPaddingTreasure then --This way, it accurately simulates the setpiece dimensions -M
                    -- print("FAILED POINT", dx, dy)
                    return false
                end
            end
        end
        return true
    end
    local function checkWater(tile)
        return IsOceanTile(tile)
    end

    --Yes, using SpawnUtil.FindRandomWaterPoints to get explicitly non-water points. -M
    local pointsX_g, pointsY_g = SpawnUtil.FindRandomWaterPoints(checkLand, width, height, TUNING.MAPEDGE_PADDING,
        numTreasures)
    local pointsX_w, pointsY_w = SpawnUtil.FindRandomWaterPoints(checkWater, width, height, TUNING.MAPEDGE_PADDING,
        numBottles)

    for i = 1, #pointsX_g, 1 do
        local entData = {}
        entData.x = (pointsX_g[i] - width / 2.0) * TILE_SCALE
        entData.z = (pointsY_g[i] - height / 2.0) * TILE_SCALE
        table.insert(entities.buriedtreasure, entData)
    end
    for i = 1, #pointsX_w, 1 do
        local entData = {}
        entData.x = (pointsX_w[i] - width / 2.0) * TILE_SCALE
        entData.z = (pointsY_w[i] - height / 2.0) * TILE_SCALE
        -- entData.data = {treasureguid = 1234}
        table.insert(entities.ia_messagebottle, entData)
    end

    print("GenerateTreasure done")
end

local _PostPopulate = Graph.GlobalPostPopulate
Graph.GlobalPostPopulate = function(self, entities, width, height, ...)
    _PostPopulate(self, entities, width, height, ...)
    if true --[[ IA_worldtype ~= "default" and self.isshipwrecked ]] then
        GenerateBermudaTriangles(self, entities, width, height)
        -- GenerateTreasure(self, entities, width, height)
    end
end

-- function Graph:ShipwreckedConvertGround(map, spawnFN, entities, check_col)
-- 	local nodes = self:GetNodes(true)
-- 	for k, node in pairs(nodes) do
-- 		node:ShipwreckedConvertGround(map, spawnFN, entities, check_col)
-- 	end
-- end
