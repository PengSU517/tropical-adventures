--[[
tile_name - the name of the tile, this is how you'll refer to your tile in the WORLD_TILES table.
tile_range - the string defining the range of possible ids for the tile.
the following ranges exist: "LAND", "NOISE", "OCEAN", "IMPASSABLE"
tile_data {
    [ground_name]
    [old_static_id] - optional, the static tile id that this tile had before migrating to this API, if you aren't migrating your tiles from an old API to this one, omit this.
}
ground_tile_def {
    [name] - this is the texture for the ground, it will first attempt to load the texture at "levels/texture/<name>.tex", if that fails it will then treat <name> as the whole file path for the texture.
    [atlas] - optional, if missing it will load the same path as name, but ending in .xml instead of .tex,  otherwise behaves the same as <name> but with .xml instead of .tex.
    [noise_texture] -  this is the noise texture for the ground, it will first attempt to load the texture at "levels/texture/<noise_texture>.tex", if that fails it will then treat <noise_texture> as the whole file path for the texture.
    [runsound] - soundpath for the run sound, if omitted will default to "dontstarve/movement/run_dirt"
    [walksound] - soundpath for the walk sound, if omitted will default to "dontstarve/movement/walk_dirt"
    [snowsound] - soundpath for the snow sound, if omitted will default to "dontstarve/movement/run_snow"
    [mudsound] - soundpath for the mud sound, if omitted will default to "dontstarve/movement/run_mud"
    [flashpoint_modifier] - the flashpoint modifier for the tile, defaults to 0 if missing
    [colors] - the colors of the tile when for blending of the ocean colours, will use DEFAULT_COLOUR(see tilemanager.lua for the exact values of this table) if missing.
    [flooring] - if true, inserts this tile into the GROUND_FLOORING table.
    [hard] - if true, inserts this tile into the GROUND_HARD table.
    [cannotbedug] - if true, inserts this tile into the TERRAFORM_IMMUNE table.
    other values can also be stored in this table, and can tested for via the GetTileInfo function.
}
minimap_tile_def {
    [name] - this is the texture for the minimap, it will first attempt to load the texture at "levels/texture/<name>.tex", if that fails it will then treat <name> as the whole file path for the texture.
    [atlas] - optional, if missing it will load the same path as name, but ending in .xml instead of .tex,  otherwise behaves the same as <name> but with .xml instead of .tex.
    [noise_texture] -  this is the noise texture for the minimap, it will first attempt to load the texture at "levels/texture/<noise_texture>.tex", if that fails it will then treat <noise_texture> as the whole file path for the texture.
}
turf_def {
    [name] - the postfix for the prefabname of the turf item
    [anim] - the name of the animation to play for the turf item, if undefined it will use name instead
    [bank_build] - the bank and build containing the animation, if undefined bank_build will use the value "turf"
}
-]]

local GroundTiles = require("worldtiledefs")
local NoiseFunctions = require("noisetilefunctions")
local ChangeTileRenderOrder = ChangeTileRenderOrder
local ChangeMiniMapTileRenderOrder = ChangeMiniMapTileRenderOrder
local AddTile = AddTile

-- local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil

if not is_worldgen then
    TileGroups.IAOceanTiles = TileGroupManager:AddTileGroup()
end

local TileRanges =
{
    LAND = "LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    IA_OCEAN = "IA_OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

local function volcano_noisefn(noise)
    return WORLD_TILES.VOLCANO_NOISE
end

local OCEAN_COLOR =
{
    primary_color = { 140, 255, 180, 50 },
    secondary_color = { 21, 110, 76, 140 },
    secondary_color_dusk = { 0, 0, 0, 50 },
    minimap_color = { 23, 62, 51, 102 },
}

local WAVETINTS =
{
    shallow = { 0.8, 0.9, 1 },
    rough = { 0.65, 0.84, 0.94 },
    swell = { 0.65, 0.84, 0.94 },
    brinepool = { 0.65, 0.92, 0.94 },
    hazardous = { 0.40, 0.50, 0.62 },
    waterlog = { 1, 1, 1 },
}

local ia_tiledefs = {
    -- BEACH = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Beach",
    --         old_static_id = 90,
    --     },
    --     ground_tile_def  = {
    --         name = "beach",
    --         noise_texture = "ground_noise_sand",
    --         runsound = "dontstarve/movement/ia_run_sand",
    --         walksound = "dontstarve/movement/ia_walk_sand",
    --         flashpoint_modifier = 0,
    --         bank_build = "turf_ia",
    --         cannotbedug = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_beach_noise",
    --     },
    --     --turf_def = {
    --     --    name = "beach",
    --     --    bank_build = "turf_ia",
    --     --},
    -- },
    -- MEADOW = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Beach",
    --         old_static_id = 91,
    --     },
    --     ground_tile_def  = {
    --         name = "jungle",
    --         noise_texture = "ground_noise_savannah_detail",
    --         runsound = "dontstarve/movement/run_tallgrass",
    --         walksound = "dontstarve/movement/walk_tallgrass",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_savannah_noise",
    --     },
    --     turf_def         = {
    --         name = "meadow",
    --         bank_build = "turf_ia",
    --     },
    -- },
    JUNGLE = {
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Jungle",
            old_static_id = 92,
        },
        ground_tile_def  = {
            name = "jungle",
            noise_texture = "ground_noise_jungle",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            -- snowsound = "dontstarve/movement/run_ice",
            -- mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_jungle_noise",
        },
        turf_def         = {
            name = "jungle",
            bank_build = "turf",
        },
    },
    -- -- SWAMP = { --note this majestic creature is unused
    -- --     tile_range = TileRanges.LAND,
    -- --     tile_data = {
    -- --         ground_name = "Swamp",
    -- --         old_static_id = 93,
    -- --     },
    -- --     ground_tile_def  = {
    -- --         name = "swamp",
    -- --         noise_texture = "ground_noise_swamp",
    -- --         runsound = "dontstarve/movement/run_marsh",
    -- --         walksound = "dontstarve/movement/walk_marsh",
    -- --     },
    -- --     minimap_tile_def = {
    -- --         name = "map_edge",
    -- --         noise_texture = "mini_swamp_noise",
    -- --     },
    -- --     turf_def = {
    -- --         name = "swamp",
    -- --         bank_build = "turf_ia",
    -- --     },
    -- -- },
    -- TIDALMARSH = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Tidal Marsh",
    --         old_static_id = 94,
    --     },
    --     ground_tile_def  = {
    --         name = "tidalmarsh",
    --         noise_texture = "ground_noise_tidalmarsh",
    --         runsound = "dontstarve/movement/run_marsh",
    --         walksound = "dontstarve/movement/walk_marsh",
    --         flashpoint_modifier = 0,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_tidalmarsh_noise",
    --     },
    --     turf_def         = {
    --         name = "tidalmarsh",
    --         bank_build = "turf_ia",
    --     },
    -- },
    -- MAGMAFIELD = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Magmafield",
    --         old_static_id = 95,
    --     },
    --     ground_tile_def  = {
    --         name = "cave",
    --         noise_texture = "ground_noise_magmafield",
    --         runsound = "dontstarve/movement/run_slate",
    --         walksound = "dontstarve/movement/walk_slate",
    --         snowsound = "dontstarve/movement/run_ice",
    --         flashpoint_modifier = 0,
    --         hard = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_magmafield_noise",
    --     },
    --     turf_def         = {
    --         name = "magmafield",
    --         bank_build = "turf_ia",
    --     },
    -- },
    -- VOLCANO_ROCK = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Volcanic Rock",
    --         old_static_id = 96,
    --     },
    --     ground_tile_def  = {
    --         name = "rocky",
    --         noise_texture = "ground_volcano_noise",
    --         runsound = "dontstarve/movement/run_rock",
    --         walksound = "dontstarve/movement/walk_rock",
    --         snowsound = "dontstarve/movement/run_ice",
    --         flashpoint_modifier = 0,
    --         hard = true,
    --         cannotbedug = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_ground_volcano_noise",
    --     },
    -- },
    -- VOLCANO = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Lava Rock",
    --         old_static_id = 97,
    --     },
    --     ground_tile_def  = {
    --         name = "cave",
    --         noise_texture = "ground_lava_rock",
    --         runsound = "dontstarve/movement/run_rock",
    --         walksound = "dontstarve/movement/walk_rock",
    --         snowsound = "dontstarve/movement/run_ice",
    --         flashpoint_modifier = 0,
    --         hard = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_ground_lava_rock",
    --     },
    --     turf_def         = {
    --         name = "volcano",
    --         bank_build = "turf_ia",
    --     },
    -- },
    -- ASH = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Ash",
    --         old_static_id = 98,
    --     },
    --     ground_tile_def  = {
    --         name = "cave",
    --         noise_texture = "ground_ash",
    --         runsound = "dontstarve/movement/run_dirt",
    --         walksound = "dontstarve/movement/walk_dirt",
    --         snowsound = "dontstarve/movement/run_ice",
    --         flashpoint_modifier = 0,
    --         hard = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_ash",
    --     },
    --     turf_def         = {
    --         name = "ash",
    --         bank_build = "turf_ia",
    --     },
    -- },
    -- SNAKESKIN = {
    --     tile_range       = TileRanges.LAND,
    --     tile_data        = {
    --         ground_name = "Snakeskin Carpet",
    --         old_static_id = 99,
    --     },
    --     ground_tile_def  = {
    --         name = "carpet",
    --         noise_texture = "noise_snakeskinfloor",
    --         runsound = "dontstarve/movement/run_carpet",
    --         walksound = "dontstarve/movement/walk_carpet",
    --         flashpoint_modifier = 0,
    --         flooring = true,
    --         hard = true, -- NO PLANTING ON SNAKESKIN!!! (what a dumb oversight)
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "noise_snakeskinfloor",
    --     },
    --     turf_def         = {
    --         name = "snakeskin",
    --         bank_build = "turf_ia",
    --     },
    -- },

    -------------------------------
    -- OCEAN/SEA/LAKE
    -- (after Land in order to keep render order consistent)
    -------------------------------

    MANGROVE = {
        tile_range       = TileRanges.IA_OCEAN,
        tile_data        = {
            ground_name = "Mangrove",
            old_static_id = 106,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_water_mangrove",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_water_mangrove",
        },
    },

    LILYPOND = {
        tile_range       = TileRanges.IA_OCEAN,
        tile_data        = {
            ground_name = "Lilypond",
            old_static_id = 107,
        },
        ground_tile_def  = {
            name = "water_medium", ----- "water_medium"
            noise_texture = "ground_water_lilypond",
            -- is_shoreline = true,   -------------加上
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            colors = OCEAN_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
            wavetint = WAVETINTS.waterlog,
            is_shoreline = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_water_lilypond",
        },
    },

    CORAL = {
        tile_range       = TileRanges.IA_OCEAN,
        tile_data        = {
            ground_name = "Coral",
            old_static_id = 104,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_water_coral", --   "ground_water_coral",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            -- colors = OCEAN_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
            -- wavetint = WAVETINTS.waterlog,
            -- is_shoreline = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_water_coral",
        },
    },

    -- OCEAN_SHALLOW_SHORE = { --was called OCEAN_SHORE in sw, kept for ambientsound
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Shallow",
    --         old_static_id = 101,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_noise_water_shallow",
    --         flashpoint_modifier = 250,
    --         is_shoreline = true,
    --         ocean_depth = "SHALLOW",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_watershallow_noise",
    --     },
    -- },
    -- OCEAN_SHALLOW = {
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Shallow",
    --         old_static_id = 101,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_noise_water_shallow",
    --         flashpoint_modifier = 250,
    --         ocean_depth = "SHALLOW",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_watershallow_noise",
    --     },
    -- },
    -- OCEAN_CORAL = {
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Coral",
    --         old_static_id = 104,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_water_coral",
    --         flashpoint_modifier = 250,
    --         ocean_depth = "BASIC",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_water_coral",
    --     },
    -- },
    -- OCEAN_MEDIUM = {
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Medium",
    --         old_static_id = 102,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_noise_water_medium",
    --         flashpoint_modifier = 250,
    --         ocean_depth = "DEEP",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_watermedium_noise",
    --     },
    -- },
    -- OCEAN_DEEP = {
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Deep",
    --         old_static_id = 103,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_noise_water_deep",
    --         flashpoint_modifier = 250,
    --         ocean_depth = "VERY_DEEP",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_waterdeep_noise",
    --     },
    -- },
    -- OCEAN_SHIPGRAVEYARD = {
    --     tile_range       = TileRanges.IA_OCEAN,
    --     tile_data        = {
    --         ground_name = "Ship Grave",
    --         old_static_id = 105,
    --     },
    --     ground_tile_def  = {
    --         name = "water_medium",
    --         noise_texture = "ground_water_graveyard",
    --         flashpoint_modifier = 250,
    --         ocean_depth = "BASIC",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_water_graveyard",
    --     },
    -- },

    -------------------------------
    -- IMPASSABLE
    -- (render order doesnt matter)
    -------------------------------

    -- VOLCANO_LAVA = {
    --     tile_range = TileRanges.IMPASSABLE,
    --     tile_data = {
    --         ground_name = "Lava",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_lava_noise",
    --     },
    -- },

    -------------------------------
    -- NOISE
    -- (only for worldgen)
    -------------------------------

    -- VOLCANO_NOISE = {
    --     tile_range = volcano_noisefn,
    -- },
}

IA_OCEAN_TILES = {}
IA_LAND_TILES = {}

for tile, def in pairs(ia_tiledefs) do
    local range = def.tile_range
    if range == TileRanges.IA_OCEAN then
        range = TileRanges.OCEAN
    elseif type(range) == "function" then
        range = TileRanges.NOISE
    end

    AddTile(tile, range, def.tile_data, def.ground_tile_def, def.minimap_tile_def, def.turf_def)

    local tile_id = WORLD_TILES[tile]

    if def.tile_range == TileRanges.IA_OCEAN then
        if not is_worldgen then
            TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.OceanTiles, tile_id)
            TileGroupManager:AddValidTile(TileGroups.IAOceanTiles, tile_id)
        end
        IA_OCEAN_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.LAND then
        IA_LAND_TILES[tile_id] = true
    elseif type(def.tile_range) == "function" then
        NoiseFunctions[tile_id] = def.tile_range
    end
end

--Non flooring floodproof tiles
-- GROUND_FLOODPROOF = setmetatable({
--     [WORLD_TILES.ROAD] = true,
--     [WORLD_TILES.ARCHIVE] = true,
--     [WORLD_TILES.BRICK_GLOW] = true,
--     [WORLD_TILES.BRICK] = true,
--     [WORLD_TILES.TILES_GLOW] = true,
--     [WORLD_TILES.TILES] = true,
--     [WORLD_TILES.TRIM_GLOW] = true,
--     [WORLD_TILES.TRIM] = true,
--     [WORLD_TILES.COTL_BRICK] = true,
-- }, { __index = GROUND_FLOORING })

for prefab, filter in pairs(terrain.filter) do
    if type(filter) == "table" then
        -- table.insert(filter, WORLD_TILES.MANGROVE)
        -- table.insert(filter, WORLD_TILES.LILYPOND)
        -- table.insert(filter, WORLD_TILES.OCEAN_CORAL)
        -- table.insert(filter, WORLD_TILES.OCEAN_SHALLOW)
        -- table.insert(filter, WORLD_TILES.OCEAN_MEDIUM)
        -- table.insert(filter, WORLD_TILES.OCEAN_DEEP)
        -- table.insert(filter, WORLD_TILES.OCEAN_SHIPGRAVEYARD)
        -- if table.contains(filter, WORLD_TILES.CARPET) then
        --     table.insert(filter, WORLD_TILES.SNAKESKIN)
        -- end
    end
end

-- ID 1 is for impassable
-- in ds, tile priority after the desert tile
-- ChangeTileRenderOrder(WORLD_TILES.MEADOW, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.TIDALMARSH, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.MAGMAFIELD, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.JUNGLE, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.ASH, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.VOLCANO, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.VOLCANO_ROCK, WORLD_TILES.DESERT_DIRT, true)
-- ChangeTileRenderOrder(WORLD_TILES.BEACH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.LILYPOND, WORLD_TILES.OCEAN_COASTAL, false)
ChangeTileRenderOrder(WORLD_TILES.CORAL, WORLD_TILES.OCEAN_COASTAL, true)
ChangeTileRenderOrder(WORLD_TILES.MANGROVE, WORLD_TILES.OCEAN_COASTAL, true)
-- --Priority turf
-- ChangeTileRenderOrder(WORLD_TILES.SNAKESKIN, WORLD_TILES.CARPET)

-- local _Initialize = GroundTiles.Initialize
-- local function Initialize(...)
--     local minimap_table = GroundTiles.minimap
--     local ground_table = GroundTiles.ground

--     --Minimap
--     local minimap_first
--     for i, ground in pairs(minimap_table) do
--         if ground[1] ~= nil then
--             minimap_first = ground[1]
--             break
--         end
--     end
--     -- if minimap_first and minimap_first ~= WORLD_TILES.VOLCANO_LAVA then
--     --     ChangeMiniMapTileRenderOrder(WORLD_TILES.VOLCANO_LAVA, minimap_first)
--     --     minimap_first = WORLD_TILES.VOLCANO_LAVA
--     -- end

--     --Ground
--     local ground_last
--     for i = #ground_table, 1, -1 do
--         local ground = ground_table[i]
--         if ground[1] ~= nil then
--             ground_last = ground[1]
--             break
--         end
--     end
--     for i = #IA_OCEAN_TILES, 1, -1 do
--         local tile = IA_OCEAN_TILES[i]
--         if tile ~= ground_last then
--             ChangeTileRenderOrder(tile, ground_last, true)
--             ground_last = tile
--         end
--     end
--     return _Initialize(...)
-- end

-- GroundTiles.Initialize = Initialize


-- GROUND = WORLD_TILES

for tile, def in pairs(ia_tiledefs) do
    if GROUND[tile] == nil then
        GROUND[tile] = WORLD_TILES[tile]
    end
end
