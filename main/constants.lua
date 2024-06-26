--[WARNING]: This file is imported into modclientmain.lua for MiM, be careful!
local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

-- TODO: Not here... -Half
-- Get the length of the dict portion of a table
-- Im really suprised lua doesnt have something like this built in?
function GetDictLength(tbl)
    local num = 0
    for i, v in pairs(tbl) do
        num = num + 1
    end
    return num - #tbl
end

for k, v in pairs(CLOTHING) do
    if v and v.symbol_overrides_by_character and v.symbol_overrides_by_character.warly then
        CLOTHING[k].symbol_overrides_by_character.walani = v.symbol_overrides_by_character.warly
        CLOTHING[k].symbol_overrides_by_character.wilbur = v.symbol_overrides_by_character.warly
        CLOTHING[k].symbol_overrides_by_character.woodlegs = v.symbol_overrides_by_character.warly
    end
end

if IAENV.is_mim_enabled then return end --Stop here if MiM

FOODSTATE = {
    RAW = 0,
    COOKED = 1,
    DRIED = 2,
    PREPARED = 3,
}

FOODGROUP.TIGERSHARK = {
    name = "TIGERSHARK",
    types = {
        FOODTYPE.MEAT,
        FOODTYPE.VEGGIE,
        FOODTYPE.GENERIC,
    },
}

WORMHOLETYPE.BERMUDA = GetDictLength(WORMHOLETYPE) + 1

FOODTYPE.NONE = "NONE" -- Just to prevent potential crashes

WORLDTYPES = {
    mainclimate = {
        ["volcanoonly"] = "volcano",
        ["islandsonly"] = "island",
    },
    volcanoclimate = table.invert({
        "volcanoonly",
    }),
    islandclimate = table.invert({
        "islandsonly",
        --"merged",
    }),
    defaultclimate = table.invert({
        "default",
        --"merged",
    }),
    worldgen = {
        ["volcanoonly"] = "volcano",
        ["islandsonly"] = "shipwrecked",
        --["merged"] = "merged",
    },
}

FUELTYPE.MECHANICAL = "MECHANICAL"
FUELTYPE.TAR = "TAR"

MATERIALS.BOAT = "boat"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.SANDBAGSMALL = "sandbagsmall"

TOOLACTIONS.HACK = true

-- Luckily we dont need to change much due to oceanblending
IA_OCEAN_PREFABS = {
    ["splash_green_small"] = "splash_white_small",
    ["splash_green"] = "splash_white",
    ["splash_green_large"] = "splash_white_large",
    ["crab_king_waterspout"] = "splash_white_large",
    ["wave_med"] = "wave_rogue",
    ["wave_splash"] = "splash_water_wave",
}
DST_OCEAN_PREFABS = {
    ["splash_white_small"] = "splash_green_small",
    ["splash_white"] = "splash_green",
    ["splash_white_large"] = "splash_green_large",
    ["bombsplash"] = "splash_green_large",
    ["wave_ripple"] = "wave_med",
    ["wave_rogue"] = "wave_med",
    ["splash_water_wave"] = "wave_splash",
}

EXIT_DESTINATION = {
    WATER = 1,
    LAND = 2
}

BOATEQUIPSLOTS = {
    BOAT_SAIL = "sail",
    BOAT_LAMP = "lamp",
}

if rawget(_G, "GetNextAvaliableCollisionMask") then
    COLLISION.PERMEABLE_GROUND = GetNextAvaliableCollisionMask()
    COLLISION.GROUND = COLLISION.GROUND + COLLISION.PERMEABLE_GROUND
    COLLISION.WORLD = COLLISION.WORLD + COLLISION.PERMEABLE_GROUND
end

FISH_FARM = {
    SIGN = {
        pondfish_tropical = "buoy_sign_2",
        pondpurple_grouper = "buoy_sign_3",
        pondpierrot_fish = "buoy_sign_4",
        pondneon_quattro = "buoy_sign_5",
    },
    SEEDWEIGHT = {
        pondfish_tropical = 3,
        pondpurple_grouper = 1,
        pondpierrot_fish = 1,
        pondneon_quattro = 1,
    },
}

CLIMATES = {
    "forest",
    "cave",
    "island",
    "volcano",
}
CLIMATE_IDS = table.invert(CLIMATES)

--any turf NOT listed in these two tables is considered to be for the climate FOREST/CAVE(depending on the wether your in a forest/cave shard)
CLIMATE_TURFS = {
    --TODO, fill in with default entries from the tiles that exist in DST
    FOREST = setmetatable({}, {
        __index = function(t, key)
            for k, v in pairs(CLIMATE_TURFS) do
                if k ~= "FOREST" and k ~= "CAVE" then
                    if v[key] then
                        return false
                    end
                end
            end
            return true
        end
    }),
    CAVE = setmetatable({}, {
        __index = function(t, key)
            for k, v in pairs(CLIMATE_TURFS) do
                if k ~= "FOREST" and k ~= "CAVE" then
                    if v[key] then
                        return false
                    end
                end
            end
            return true
        end
    }),
    --NEUTRAL is a special case, this means, keep your current climate.
    NEUTRAL = {
        [WORLD_TILES.INVALID] = true,
        [WORLD_TILES.IMPASSABLE] = true,
        [WORLD_TILES.DIRT] = true,
        [WORLD_TILES.BEACH] = true,
    },
    ISLAND = {
        [WORLD_TILES.MEADOW] = true,
        [WORLD_TILES.JUNGLE] = true,
        [WORLD_TILES.TIDALMARSH] = true,
        [WORLD_TILES.MAGMAFIELD] = true,
        [WORLD_TILES.OCEAN_SHALLOW_SHORE] = true,
        [WORLD_TILES.OCEAN_SHALLOW] = true,
        [WORLD_TILES.OCEAN_MEDIUM] = true,
        [WORLD_TILES.OCEAN_DEEP] = true,
        [WORLD_TILES.OCEAN_CORAL] = true,
        [WORLD_TILES.OCEAN_SHIPGRAVEYARD] = true,
        [WORLD_TILES.MANGROVE] = true,
    },
    VOLCANO = {
        [WORLD_TILES.VOLCANO] = true,
        [WORLD_TILES.VOLCANO_ROCK] = true,
        [WORLD_TILES.ASH] = true,
        [WORLD_TILES.VOLCANO_LAVA] = true,
        [WORLD_TILES.VOLCANO_NOISE] = true, --should be impossible
    },
}

CLIMATE_ROOMS = {
    ISLAND = {
        "Beach",
        -- "Jungle", --conflicts with "CaveJungle" in ruins
        "Magma",
        "Mangrove",
        -- "Meadow", --conflicts with several cave mushroom rooms
        "TidalMarsh",
        "Ocean",
    },
}

INVERTED_RECIPE_BOAT_TYPE = {
    "IA",
    "DST",
}

RECIPE_BOAT_TYPE = table.invert(INVERTED_RECIPE_BOAT_TYPE)

INVERTED_RECIPE_GAME_TYPE = {
    "ROG",
    "SW",
    "HAM",
}

RECIPE_GAME_TYPE = table.invert(INVERTED_RECIPE_GAME_TYPE)

CUSTOM_CHARACTER_SAILFACES = {}

-- example to enable custom sailfaces on a character (use only if the character has a custom sailface)
-- CUSTOM_CHARACTER_SAILFACES.player_prefab.skinname = true
-- or
-- CUSTOM_CHARACTER_SAILFACES.wilton = {
--	wilton_none = true, --this is the default (default skinname is the same name as the characters prefab but with a _none at the end)
--	wilton_combatant = true,
--	wilton_gladiator = true,
--	wilton_magma = true,
--	wilton_survivor = true,
--}

-- This allows Brain of Thought to give access to recipes with TECHs listed below:
TECH.LOST.SEAFARING = 10        -- Think Tank
TECH.LOST.OBSIDIAN = 10         -- Obsidian Workbench
TECH.LOST.CELESTIAL = 10        -- Lunar Altar
TECH.LOST.MASHTURFCRAFTING = 10 -- Wurt's Marsh Turfs
TECH.LOST.TURFCRAFTING = 10     -- Terra Firma Tamper
TECH.LOST.FISHING = 10          -- Tackle Receptacle
TECH.LOST.SPIDERCRAFT = 10      -- Webber's Crafts
TECH.LOST.ROBOTMODULECRAFT = 10 -- WX78's Modules
TECH.LOST.CARTOGRAPHY = 10      -- Cartographer's Desk
TECH.LOST.LUNARFORGING = 10     -- Lunar Forge
TECH.LOST.SHADOWFORGING = 10    -- Shadow Forge
TECH.LOST.CARPENTRY = 10        -- Sawhorse
