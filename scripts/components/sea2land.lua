local GroundTiles = require("worldtiledefs")

local Sea2land = Class(function(self, inst)
    self.inst = inst
end)

local turfs = {
    [GROUND.IMPASSABLE] = 1,
    [GROUND.OCEAN_COASTAL] = 1,
    [GROUND.OCEAN_COASTAL_SHORE] = 1,
    [GROUND.OCEAN_SWELL] = 1,
    [GROUND.OCEAN_ROUGH] = 1,
    [GROUND.OCEAN_BRINEPOOL] = 1,
    [GROUND.OCEAN_BRINEPOOL_SHORE] = 1,
    [GROUND.OCEAN_HAZARDOUS] = 1,
    [GROUND.OCEAN_WATERLOG] = 1,
    [GROUND.LILYPOND] = 1,
}

function Sea2land:Sea2land(pt)
    local world = TheWorld
    local map = world.Map
    local _x, _y, _z = pt:Get()

    local original_tile_type = map:GetTileAtPoint(_x, _y, _z)
    local x, y = map:GetTileCoordsAtPoint(_x, _y, _z)

    local below_soil_turf
    if original_tile_type == GROUND.FARMING_SOIL and TheWorld.components.farming_manager then
        below_soil_turf = TheWorld.components.farming_manager:GetTileBelowSoil(x, y)
    end

    local turf = self.turf or below_soil_turf or GROUND.DIRT

    if turfs[original_tile_type] == nil then
        turf = self.inst.turf
    end

    map:SetTile(x, y, turf)
    map:RebuildLayer(original_tile_type, x, y)
    map:RebuildLayer(turf, x, y)

    world.minimap.MiniMap:RebuildLayer(original_tile_type, x, y)
    world.minimap.MiniMap:RebuildLayer(turf, x, y)

    local spawnturf = GroundTiles.turf[original_tile_type] or nil
    if spawnturf ~= nil then
        local loot = SpawnPrefab("turf_" .. spawnturf.name)
        if loot.components.inventoryitem ~= nil then
            loot.components.inventoryitem:InheritMoisture(world.state.wetness, world.state.iswet)
        end
        loot.Transform:SetPosition(_x, _y, _z)
        if loot.Physics ~= nil then
            local angle = math.random() * 2 * PI
            loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
        end
    else
        SpawnPrefab("sinkhole_spawn_fx_" .. tostring(math.random(3))).Transform:SetPosition(_x, _y, _z)
    end

    if not self.plow then
        for _, ent in ipairs(TheWorld.Map:GetEntitiesOnTileAtPoint(_x, _y, _z)) do
            if ent:HasTag("soil") then
                ent:PushEvent("collapsesoil")
            end
        end
    end

    return true
end

return Sea2land
