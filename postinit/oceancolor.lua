local ChangeTileRenderOrder = ChangeTileRenderOrder
local AddTile = AddTile
local WORLD_TILES = WORLD_TILES
local GROUND = GROUND

local AddNewTile = function(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
    if WORLD_TILES[tile] then
        return
    end

    AddTile(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
end

-- local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil

if not is_worldgen then
    TileGroups.TAOceanTiles = TileGroupManager:AddTileGroup()
end


local TileRanges =
{
    LAND = "LAND",
    SW_LAND = "SW_LAND",
    HAM_LAND = "HAM_LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    TRO_OCEAN = "TRO_OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

if TA_CONFIG.CLIENT.ocean == "blue" then
    TUNING.OCEAN_SHADER.OCEAN_FLOOR_COLOR      = { 0, 100, 100, 255 } ---------------------------------------------------修改这个调整世界背景颜色
    TUNING.OCEAN_SHADER.OCEAN_FLOOR_COLOR_DUSK = { 0, 60, 60, 155 }
end



local OCEAN_COLOR =
{
    primary_color = { 220, 240, 255, 60 },
    secondary_color = { 21, 96, 110, 140 },
    secondary_color_dusk = { 0, 0, 0, 50 },
    minimap_color = { 23, 51, 62, 102 },
}

local SHALLOW_SHORE_OCEAN_COLOR =
{
    primary_color = { 120, 255, 240, 60 },
    secondary_color = { 21, 110, 96, 140 },
    secondary_color_dusk = { 0, 0, 0, 50 },
    minimap_color = { 23, 62, 51, 102 },
}

local SHALLOW_OCEAN_COLOR =
{
    primary_color = { 0, 255, 255, 100 }, --{ 20, 255, 150, 255 },--255是全白   透明度调成0就是完全透明（基底颜色且没有纹理）
    secondary_color = { 25, 123, 167, 100 },
    secondary_color_dusk = { 10, 120, 125, 120 },
    minimap_color = { 23, 51, 62, 102 },
}

local MEDIUM_OCEAN_COLOR =
{
    primary_color = { 150, 255, 255, 18 },
    secondary_color = { 0, 45, 80, 220 },
    secondary_color_dusk = { 9, 52, 57, 150 },
    minimap_color = { 14, 34, 61, 204 },
}

local DEEP_OCEAN_COLOR =
{
    primary_color = { 10, 200, 220, 30 },
    secondary_color = { 1, 20, 45, 230 },
    secondary_color_dusk = { 5, 20, 25, 230 },
    minimap_color = { 19, 20, 40, 230 },
}

local SHIPGRAVEYARD_OCEAN_COLOR =
{
    primary_color = { 255, 255, 255, 25 },
    secondary_color = { 0, 8, 18, 51 },
    secondary_color_dusk = { 0, 0, 0, 150 },
    minimap_color = { 8, 8, 14, 51 },
}

local MANGROVE_OCEAN_COLOR =
{
    primary_color = { 5, 185, 220, 60 },
    secondary_color = { 5, 20, 45, 200 },
    secondary_color_dusk = { 5, 15, 20, 200 },
    minimap_color = { 40, 87, 93, 51 },
}

local CORAL_OCEAN_COLOR =
{
    primary_color = { 220, 255, 255, 28 },
    secondary_color = { 25, 123, 167, 100 },
    secondary_color_dusk = { 10, 120, 125, 120 },
    minimap_color = { 40, 87, 93, 51 },
}

local LILYPOND_SHORE_OCEAN_COLOR =
{
    primary_color = { 255, 255, 255, 25 },
    secondary_color = { 255, 0, 0, 255 },
    secondary_color_dusk = { 255, 0, 0, 255 },
    minimap_color = { 255, 0, 0, 255 },
}

local WAVETINTS =
{
    shallow = { 0.8, 0.9, 1 },
    rough = { 0.65, 0.84, 0.94 },
    swell = { 0.65, 0.84, 0.94 },
    brinepool = { 0.65, 0.92, 0.94 },
    hazardous = { 0.40, 0.50, 0.62 },
    waterlog = { 1, 1, 1 },
    lilypond = { 1, 1, 1 },
}

local tro_tiledefs = {
    -------------------------------
    -- OCEAN/SEA/LAKE
    -- (after Land in order to keep render order consistent)
    -------------------------------

    -------------------以下为水体地皮---------------------
    -------------------以下为水体地皮---------------------
    MANGROVE_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Mangrove",
            old_static_id = 106,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_mangrove",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            -- colors = MANGROVE_COLOR,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_mangrove",
        },
    },


    LILYPOND_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Lilypond",
            old_static_id = 107,
        },
        ground_tile_def  = {
            name = "sw/water_medium", ----- "water_medium"
            noise_texture = "ham/water_lilypond2",
            -- is_shoreline = true,   -------------加上
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            -- colors = LILYPOND_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
            -- wavetint = WAVETINTS.waterlog,
            is_shoreline = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_water_lilypond",
        },
    },

    OCEAN_CORAL_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Coral",
            old_static_id = 104,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_coral", --   "ground_water_coral",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            -- colors = OCEAN_CORAL_COLOR,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_coral",
        },
    },

    OCEAN_SHALLOW_SHORE_NEW = { --was called OCEAN_SHORE in sw, kept for ambientsound
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow Shore",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "sw/water_shallow",
            noise_texture = "sw/water_shallow",
            flashpoint_modifier = 250,
            -- is_shoreline = true,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_shallow",
        },
    },
    OCEAN_SHALLOW_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "sw/water_shallow",
            noise_texture = "sw/water_shallow",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_shallow",
        },
    },


    OCEAN_MEDIUM_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Medium",
            old_static_id = 102,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_medium",
            flashpoint_modifier = 250,
            ocean_depth = "DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_medium",
        },
    },
    OCEAN_DEEP_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Deep",
            old_static_id = 103,
        },
        ground_tile_def  = {
            name = "sw/water_deep",
            noise_texture = "sw/water_deep",
            flashpoint_modifier = 250,
            ocean_depth = "VERY_DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_deep",
        },
    },
    OCEAN_SHIPGRAVEYARD_NEW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Ship Grave",
            old_static_id = 105,
        },
        ground_tile_def  = {
            name = "sw/water_deep",
            noise_texture = "sw/water_graveyard",
            flashpoint_modifier = 250,
            ocean_depth = "BASIC",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_graveyard",
        },
    },
}


TRO_OCEAN_TILES = {}

for tile, def in pairs(tro_tiledefs) do
    local range = def.tile_range
    if range == TileRanges.TRO_OCEAN then
        range = TileRanges.OCEAN
    end

    AddNewTile(tile, range, def.tile_data, def.ground_tile_def, def.minimap_tile_def, def.turf_def)

    local tile_id = WORLD_TILES[tile]
    if def.tile_range == TileRanges.TRO_OCEAN then
        if not is_worldgen then
            TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.OceanTiles, tile_id)
            TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, tile_id)
        end
        TRO_OCEAN_TILES[tile_id] = true
    end
end


ChangeTileRenderOrder(WORLD_TILES.LILYPOND_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.MANGROVE_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW_SHORE_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_MEDIUM_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_DEEP_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL_NEW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHIPGRAVEYARD_NEW, WORLD_TILES.MONKEY_DOCK, false)


for tile, def in pairs(tro_tiledefs) do
    if GROUND[tile] == nil then
        GROUND[tile] = WORLD_TILES[tile]
    end
end


local GroundTiles = require("worldtiledefs")

local tile_tbl = {
    OCEAN_COASTAL_SHORE = "OCEAN_SHALLOW_SHORE_NEW",
    OCEAN_COASTAL = "OCEAN_SHALLOW_NEW",
    OCEAN_SWELL = "OCEAN_MEDIUM_NEW",
    OCEAN_ROUGH = "OCEAN_DEEP_NEW",
    OCEAN_WATERLOG = "MANGROVE_NEW",
    OCEAN_BRINEPOOL = "OCEAN_CORAL_NEW",
    OCEAN_BRINEPOOL_SHORE = "OCEAN_CORAL_NEW",
    OCEAN_HAZARDOUS = "OCEAN_SHIPGRAVEYARD_NEW",
}

local function tile_redirect(tbl)
    for origin, override in pairs(tbl) do
        if not WORLD_TILES[origin] then
            return
        end

        if TA_CONFIG.CLIENT.ocean == "tropical" then
            if not is_worldgen then
                TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, WORLD_TILES[origin])
                TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, WORLD_TILES[origin])
            end
            -- ChangeTileRenderOrder(WORLD_TILES[origin], WORLD_TILES.MONKEY_DOCK, false)

            for k, v in pairs(GroundTiles.ground) do
                if v[1] == WORLD_TILES[origin] then
                    -- print("findit!!!!!!!!!!!!")

                    v[2] = tro_tiledefs[override].ground_tile_def
                end
            end
        elseif TA_CONFIG.CLIENT.ocean == "blue" then
            for k, v in pairs(GroundTiles.ground) do
                if v[1] == WORLD_TILES[origin] then
                    v[2].colors = tro_tiledefs[override].ground_tile_def.colors
                end
            end
        end

        for k, v in pairs(GroundTiles.minimap) do
            if v[1] == WORLD_TILES[origin] then
                -- print("findit!!!!!!!!!!!!")
                v[2] = tro_tiledefs[override].minimap_tile_def
            end
        end
    end
end

if TA_CONFIG.CLIENT.ocean ~= "default" and (not TheNet:IsDedicated()) then
    tile_redirect(tile_tbl)
end
