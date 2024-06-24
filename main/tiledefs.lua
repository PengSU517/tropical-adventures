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

local WORLD_TILES = WORLD_TILES
local GROUND = GROUND

-- local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddNewTile = function(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
    if WORLD_TILES[tile] then
        return
    end

    AddTile(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
end

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

local function volcano_noisefn(noise)
    return WORLD_TILES.VOLCANO_NOISE
end


local OCEAN_COLOR =
{
    primary_color = { 40, 80, 60, 200 },
    secondary_color = { 21, 96, 110, 140 },
    secondary_color_dusk = { 0, 0, 0, 50 },
    minimap_color = { 23, 51, 62, 102 },
}

local SHALLOW_SHORE_OCEAN_COLOR =
{
    primary_color = { 220, 240, 255, 60 },
    secondary_color = { 21, 96, 110, 140 },
    secondary_color_dusk = { 0, 0, 0, 50 },
    minimap_color = { 23, 51, 62, 102 },
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

    MANGROVE = {
        tile_range       = TileRanges.TRO_OCEAN,
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
        tile_range       = TileRanges.TRO_OCEAN,
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
            -- colors = OCEAN_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
            -- wavetint = WAVETINTS.waterlog,
            is_shoreline = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_water_lilypond",
        },
    },
    -- LILYPOND = {

    --     tile_range       = TileRanges.OCEAN,
    --     tile_data        = {
    --         ground_name = "Lilypond",
    --         old_static_id = GROUND.OCEAN_BRINEPOOL_SHORE,
    --     },
    --     ground_tile_def  = {
    --         name = "cave",                 ----- "water_medium"
    --         noise_texture = "ocean_noise", --"ground_water_lilypond",
    --         is_shoreline = true,           -------------加上
    --         -- flashpoint_modifier = 250,
    --         ocean_depth = "SHALLOW",
    --         colors = SHALLOW_OCEAN_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
    --         wavetint = WAVETINTS.swell,

    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_water_lilypond",
    --     },
    -- },



    OCEAN_CORAL = {
        tile_range       = TileRanges.TRO_OCEAN,
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

    OCEAN_SHALLOW_SHORE = { --was called OCEAN_SHORE in sw, kept for ambientsound
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_noise_water_shallow",
            flashpoint_modifier = 250,
            -- is_shoreline = true,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_watershallow_noise",
        },
    },
    OCEAN_SHALLOW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_noise_water_shallow",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_watershallow_noise",
        },
    },





    OCEAN_MEDIUM = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Medium",
            old_static_id = 102,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_noise_water_medium",
            flashpoint_modifier = 250,
            ocean_depth = "DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_watermedium_noise",
        },
    },
    OCEAN_DEEP = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Deep",
            old_static_id = 103,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_noise_water_deep",
            flashpoint_modifier = 250,
            ocean_depth = "VERY_DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_waterdeep_noise",
        },
    },
    OCEAN_SHIPGRAVEYARD = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Ship Grave",
            old_static_id = 105,
        },
        ground_tile_def  = {
            name = "water_medium",
            noise_texture = "ground_water_graveyard",
            flashpoint_modifier = 250,
            ocean_depth = "BASIC",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_water_graveyard",
        },
    },

    JUNGLE = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Jungle",
            old_static_id = 33,
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

    MAGMAFIELD = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Magmafield",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "noise_magmafield",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            -- runsound = "dontstarve/movement/run_slate",
            -- walksound = "dontstarve/movement/walk_slate",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            -- hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_magmafield",
        },
        turf_def         = {
            name = "magmafield",
            bank_build = "turf",
        },
    },

    ASH = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Ash",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "noise_ash",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            -- hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_ash",
        },
        turf_def         = {
            name = "ash",
            bank_build = "turf",
        },
    },

    VOLCANO_ROCK = { --------------------但这似乎是岩浆地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Beard Rug",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "noise_beardrug",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            flashpoint_modifier = 0,
            flooring = false,
            -- hard = true,
            cannotbedug = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_beardrug",
        },
        -- turf_def         = {
        --     name = "beardrug",
        --     bank_build = "turf",
        -- },

    },

    VOLCANO = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Lava Rock",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "noise_volcano",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            -- hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_volcano",
        },
        turf_def         = {
            name = "volcano",
            bank_build = "turf",
        },
    },

    TIDALMARSH = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Tidal Marsh",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "tidalmarsh",
            noise_texture = "noise_tidalmarsh",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_tidalmarsh",
        },
        turf_def         = {
            name = "tidalmarsh",
            bank_build = "turf",
        },
    },

    MEADOW = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Beach",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "jungle",
            noise_texture = "noise_meadow",
            runsound = "dontstarve/movement/run_tallgrass",
            walksound = "dontstarve/movement/walk_tallgrass",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_meadow",
        },
        turf_def         = {
            name = "meadow",
            bank_build = "turf",
        },
    },

    SNAKESKINFLOOR = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Snakeskin Carpet",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "carpet",
            noise_texture = "noise_snakeskinfloor",
            runsound = "dontstarve/movement/run_carpet",
            walksound = "dontstarve/movement/walk_carpet",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true, -- NO PLANTING ON SNAKESKIN!!! (what a dumb oversight)
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_snakeskinfloor",
        },
        turf_def         = {
            name = "snakeskinfloor",
            bank_build = "turf_ia",
        },
    },

    BEACH = {
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Beach",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "beach",
            noise_texture = "noise_beach",
            runsound = "dontstarve/movement/ia_run_sand",
            walksound = "dontstarve/movement/ia_walk_sand",
            flashpoint_modifier = 0,
            bank_build = "turf_ia",
            cannotbedug = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_beach",
        },
        turf_def         = {
            name = "beach",
            bank_build = "turf",
        }, --------------应该没有turf
    },


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


    PLAINS = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Plains",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "jungle",
            noise_texture = "noise_plains",
            runsound = "dontstarve/movement/run_tallgrass",
            walksound = "dontstarve/movement/walk_tallgrass",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_plains",
        },
        turf_def = {
            name = "plains",
            bank_build = "turf",
        },
    },


    DEEPRAINFOREST = {
        tile_range       = TileRanges.HAM_LAND,
        tile_data        = {
            ground_name = "Jungle Deep",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "deeprainforest",
            noise_texture = "noise_deeprainforest",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_deeprainforest",
        },
        -- turf_def         = {
        --     name = "deeprainforest",
        --     bank_build = "turf",
        -- },
    },

    RAINFOREST = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Rain Forest",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "rainforest",
            noise_texture = "noise_rainforest",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
            flashpoint_modifier = 0,
            floor = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_rainforest",
        },
        turf_def = {
            name = "rainforest",
            bank_build = "turf",
        },
    },

    PAINTED = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Painted",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "noise_painted",
            runsound = "dontstarve/movement/run_sand",
            walksound = "dontstarve/movement/walk_sand",
            mudsound = "run_sand"
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_painted",
        },
        turf_def = {
            name = "painted",
            bank_build = "turf",
        },
    },

    -- BATTLEGROUND = { --------BATTLEGROUND
    --     tile_range = TileRanges.HAM_LAND,
    --     tile_data = {
    --         ground_name = "Battleground",
    --         old_static_id = 33,
    --     },
    --     ground_tile_def = {
    --         name = "cave",
    --         noise_texture = "noise_pigruins",
    --         runsound = "dontstarve/movement/run_dirt",
    --         walksound = "dontstarve/movement/walk_dirt",
    --         snowsound = "run_ice",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_noise_pigruins"
    --     },
    --     turf_def = {
    --         name = "battleground",
    --         bank_build = "turf",
    --     },
    -- },

    PIGRUINS = { --------BATTLEGROUND
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Pigruins",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "noise_pigruins",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_pigruins"
        },
        turf_def = {
            name = "pigruins",
            bank_build = "turf",
        },
    },

    GASJUNGLE = { --note this majestic creature is unused
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Gas Jungle",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "deeprainforest",
            noise_texture = "noise_gasjungle",
            runsound = "dontstarve/movement/run_moss",
            walksound = "dontstarve/movement/walk_moss",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_gasjungle",
        },
        -- turf_def = {
        --     name = "swamp",
        --     bank_build = "turf_ia",
        -- },
    },




    FIELDS = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "fields",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "jungle",
            noise_texture = "noise_fields",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_fields",
        },
        turf_def = {
            name = "fields",
            bank_build = "turf",
        },
    },

    CHECKEREDLAWN = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Lawn",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cobbleroad",
            noise_texture = "noise_checkeredlawn",
            runsound = "dontstarve/movement/run_grass",
            walksound = "dontstarve/movement/walk_grass",
            -- runsound = "run_grass",
            -- walksound = "walk_grass",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_checkeredlawn",
        },

        turf_def = {
            name = "checkeredlawn",
            bank_build = "turf",
        },
    },



    SUBURB = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Suburb",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "deciduous",
            noise_texture = "noise_suburb",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_suburb",
        },
        turf_def = {
            name = "suburb",
            bank_build = "turf",
        },
    },

    -- BEARDRUG = { --------------------但这似乎是岩浆地皮
    --     tile_range       = TileRanges.HAM_LAND,
    --     tile_data        = {
    --         ground_name = "Beard Rug",
    --         old_static_id = 33,
    --     },
    --     ground_tile_def  = {
    --         name = "cave",
    --         noise_texture = "noise_beardrug",
    --         runsound = "dontstarve/movement/run_dirt",
    --         walksound = "dontstarve/movement/walk_dirt",
    --         flashpoint_modifier = 0,
    --         flooring = false,
    --         hard = true,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_noise_beardrug",
    --     },
    --     turf_def         = {
    --         name = "beardrug",
    --         bank_build = "turf",
    --     },

    -- },

    FOUNDATION = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Foundation",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "blocky",
            noise_texture = "noise_foundation",
            runsound = "dontstarve/movement/run_marble",
            walksound = "dontstarve/movement/walk_marble",
            -- runsound = "dontstarve/movement/run_slate",
            -- walksound = "dontstarve/movement/walk_slate",
            snowsound = "run_ice",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_foundation",
        },
        turf_def = {
            name = "foundation",
            bank_build = "turf",
        },
    },


    COBBLEROAD = {
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Cobbleroad",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cobbleroad",
            noise_texture = "noise_cobbleroad",
            runsound = "dontstarve/movement/run_marble",
            walksound = "dontstarve/movement/walk_marble",
            -- runsound = "dontstarve/movement/run_rock",
            -- walksound = "dontstarve/movement/walk_rock",
            snowsound = "run_ice",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "mini_noise_cobbleroad",
        },
        turf_def = {
            name = "cobbleroad",
            bank_build = "turf",
        },
    },


    -- PIGRUINS_NOCANOPY = {
    --     tile_range = TileRanges.HAM_LAND,
    --     tile_data = {
    --         ground_name = "Pigruins",
    --     },
    --     ground_tile_def = {
    --         name = "blocky",
    --         noise_texture = "ground_ruins_slab",
    --         runsound = "run_dirt",
    --         walksound = "walk_dirt",
    --         snowsound = "run_ice",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_ruins_slab"
    --     }
    -- },

    -- DEEPRAINFOREST_NOCANOPY = {
    --     tile_range       = TileRanges.HAM_LAND,
    --     tile_data        = {
    --         ground_name = "Jungle Deep",
    --     },
    --     ground_tile_def  = {
    --         name = "deeprainforest",
    --         noise_texture = "Ground_noise_jungle_deep",
    --         runsound = "dontstarve/movement/run_woods",
    --         walksound = "dontstarve/movement/walk_woods",
    --         flashpoint_modifier = 0,
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_noise_jungle_deep",
    --     },
    --     -- turf_def = {
    --     --     name = "jungle",
    --     --     bank_build = "turf_ia",
    --     -- },
    -- },



}

-- AddTile(
--     "LILYPOND",
--     TileRanges.OCEAN,
--     { ground_name = "Lilypond", old_static_id = GROUND.OCEAN_COASTAL_SHORE },
--     {
--         name = "cave",
--         noise_texture = "ocean_noise",
--         runsound = "dontstarve/movement/run_marsh",
--         walksound = "dontstarve/movement/walk_marsh",
--         snowsound = "dontstarve/movement/run_ice",
--         mudsound = "dontstarve/movement/run_mud",
--         is_shoreline = true,
--         ocean_depth = "SHALLOW",
--         colors = OCEAN_COLOR,
--         wavetint = WAVETINTS.shallow,
--     },
--     {
--         name = "map_edge",
--         noise_texture = "mini_water_shallow",
--     }
-- )

TRO_OCEAN_TILES = {}
SW_LAND_TILES = {}
HAM_LAND_TILES = {}
TRO_LAND_TILES = {}

for tile, def in pairs(tro_tiledefs) do
    local range = def.tile_range
    if range == TileRanges.TRO_OCEAN then
        range = TileRanges.OCEAN
    elseif range == TileRanges.SW_LAND or range == TileRanges.HAM_LAND then
        range = TileRanges.LAND
    elseif type(range) == "function" then
        range = TileRanges.NOISE
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
    elseif def.tile_range == TileRanges.OCEAN then
        if not is_worldgen then
            -- TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.Legacy_OceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, tile_id)
        end
        TRO_OCEAN_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.SW_LAND then
        SW_LAND_TILES[tile_id] = true
        TRO_LAND_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.HAM_LAND then
        HAM_LAND_TILES[tile_id] = true
        TRO_LAND_TILES[tile_id] = true
    elseif type(def.tile_range) == "function" then
        NoiseFunctions[tile_id] = def.tile_range
    end
end






-- TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, WORLD_TILES.OCEAN_COASTAL_SHORE)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_COASTAL_SHORE, WORLD_TILES.DESERT_DIRT, true)


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
ChangeTileRenderOrder(WORLD_TILES.MEADOW, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.TIDALMARSH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.MAGMAFIELD, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.JUNGLE, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.ASH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO_ROCK, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.BEACH, WORLD_TILES.DESERT_DIRT, true)

ChangeTileRenderOrder(WORLD_TILES.GASJUNGLE, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.DEEPRAINFOREST, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.RAINFOREST, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.PLAINS, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.SUBURB, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.FIELDS, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.PAINTED, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.PIGRUINS, WORLD_TILES.CHECKER, true)


-- --Priority turf
ChangeTileRenderOrder(WORLD_TILES.SNAKESKINFLOOR, WORLD_TILES.CARPET, false)
-- ChangeTileRenderOrder(WORLD_TILES.BEARDRUG, WORLD_TILES.CARPET, false)

ChangeTileRenderOrder(WORLD_TILES.COBBLEROAD, WORLD_TILES.WOODFLOOR, true)
ChangeTileRenderOrder(WORLD_TILES.CHECKEREDLAWN, WORLD_TILES.WOODFLOOR, true)
ChangeTileRenderOrder(WORLD_TILES.FOUNDATION, WORLD_TILES.WOODFLOOR, true)

-----ocean turf -------如果是联机海水就不能设置高优先级
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.LILYPOND, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.MANGROVE, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_COASTAL, false)---这种海洋地皮不可能在陆地地皮上面

ChangeTileRenderOrder(WORLD_TILES.LILYPOND, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.MANGROVE, WORLD_TILES.MONKEY_DOCK, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.CARPET2, true)---这种海洋地皮不可能在陆地地皮上面
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW_SHORE, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_MEDIUM, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_DEEP, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHIPGRAVEYARD, WORLD_TILES.MONKEY_DOCK, false)

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
--     for i = #TRO_OCEAN_TILES, 1, -1 do
--         local tile = TRO_OCEAN_TILES[i]
--         if tile ~= ground_last then
--             ChangeTileRenderOrder(tile, ground_last, true)
--             ground_last = tile
--         end
--     end
--     return _Initialize(...)
-- end

-- GroundTiles.Initialize = Initialize


-- GROUND = WORLD_TILES

for tile, def in pairs(tro_tiledefs) do
    if GROUND[tile] == nil then
        GROUND[tile] = WORLD_TILES[tile]
    end
end


local tile_tbl = {
    OCEAN_COASTAL_SHORE = "OCEAN_SHALLOW_SHORE",
    OCEAN_COASTAL = "OCEAN_SHALLOW",
    OCEAN_SWELL = "OCEAN_MEDIUM",
    OCEAN_ROUGH = "OCEAN_DEEP",
    OCEAN_WATERLOG = "OCEAN_SHALLOW",
    OCEAN_BRINEPOOL = "OCEAN_CORAL",
    OCEAN_BRINEPOOL_SHORE = "OCEAN_CORAL",
    OCEAN_HAZARDOUS = "OCEAN_SHIPGRAVEYARD",
}



-- local function tile_redirect(tbl)
--     for k, v in pairs(tbl) do
--         WORLD_TILES[k] = deepcopy(WORLD_TILES[v])
--         GROUND[k] = deepcopy(WORLD_TILES[v])
--     end
-- end

-- if TA_CONFIG.ocean == "tropical" then
--     tile_redirect(tile_tbl)
--     -- WORLD_TILES.OCEAN_COASTAL_SHORE = WORLD_TILES.OCEAN_SHALLOW_SHORE
--     -- GROUND.OCEAN_COASTAL_SHORE = WORLD_TILES.OCEAN_SHALLOW_SHORE

--     -- WORLD_TILES.OCEAN_COASTAL = WORLD_TILES.OCEAN_SHALLOW
--     -- GROUND.OCEAN_COASTAL = WORLD_TILES.OCEAN_SHALLOW

--     -- WORLD_TILES.OCEAN_SWELL = WORLD_TILES.OCEAN_MEDIUM
--     -- GROUND.OCEAN_SWELL = WORLD_TILES.OCEAN_MEDIUM

--     -- WORLD_TILES.OCEAN_ROUGH = WORLD_TILES.OCEAN_DEEP
--     -- GROUND.OCEAN_ROUGH = WORLD_TILES.OCEAN_DEEP

--     -- WORLD_TILES.OCEAN_ROUGH = WORLD_TILES.OCEAN_DEEP
--     -- GROUND.OCEAN_ROUGH = WORLD_TILES.OCEAN_DEEP

--     -- WORLD_TILES.OCEAN_WATERLOG = WORLD_TILES.MANGROVE
--     -- GROUND.OCEAN_WATERLOG = WORLD_TILES.MANGROVE

--     -- WORLD_TILES.OCEAN_BRINEPOOL = WORLD_TILES.OCEAN_CORAL
--     -- GROUND.OCEAN_BRINEPOOL = WORLD_TILES.OCEAN_CORAL

--     -- WORLD_TILES.OCEAN_BRINEPOOL_SHORE = WORLD_TILES.OCEAN_CORAL
--     -- GROUND.OCEAN_BRINEPOOL_SHORE = WORLD_TILES.OCEAN_CORAL

--     -- WORLD_TILES.OCEAN_HAZARDOUS = WORLD_TILES.OCEAN_SHIPGRAVEYARD
--     -- GROUND.OCEAN_HAZARDOUS = WORLD_TILES.OCEAN_SHIPGRAVEYARD
-- end
