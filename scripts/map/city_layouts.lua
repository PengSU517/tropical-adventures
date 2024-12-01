-- This file loads all static layouts and contains all non-static layouts
local StaticLayout = require("map/static_layout")
local AllLayouts = require("map/layouts").Layouts

local ground_types = {
    -- Translates tile type index from constants.lua into tiled tileset.
    -- Order they appear here is the order they will be used in tiled.
    GROUND.IMPASSABLE or 65536, GROUND.ROAD or 65536, GROUND.ROCKY or 65536, GROUND.DIRT or 65536,
    GROUND.SAVANNA or 65536, GROUND.GRASS or 65536, GROUND.FOREST or 65536, GROUND.MARSH or 65536,

    GROUND.WOODFLOOR or 65536, GROUND.CARPET or 65536, GROUND.CHECKER or 65536, GROUND.CAVE or 65536,
    GROUND.FUNGUS or 65536, GROUND.SINKHOLE or 65536, GROUND.WALL_ROCKY or 65536, GROUND.WALL_DIRT or 65536,
    GROUND.WALL_MARSH or 65536, GROUND.WALL_CAVE or 65536, GROUND.WALL_FUNGUS or 65536, GROUND.WALL_SINKHOLE or 65536,
    GROUND.UNDERROCK or 65536, GROUND.MUD or 65536, GROUND.WALL_MUD or 65536, GROUND.WALL_WOOD or 65536,

    GROUND.BRICK or 65536, GROUND.BRICK_GLOW or 65536, GROUND.TILES or 65536, GROUND.TILES_GLOW or 65536,
    GROUND.TRIM or 65536, GROUND.TRIM_GLOW or 65536, GROUND.WALL_HUNESTONE or 65536, GROUND.WALL_HUNESTONE_GLOW or 65536,
    GROUND.WALL_STONEEYE or 65536, GROUND.WALL_STONEEYE_GLOW or 65536,
    GROUND.FUNGUSRED or 65536, GROUND.FUNGUSGREEN or 65536,
    GROUND.BEACH or 65536, GROUND.JUNGLE or 65536, GROUND.SWAMP or 65536, GROUND.OCEAN_SHALLOW or 65536,

    GROUND.OCEAN_MEDIUM or 65536, GROUND.OCEAN_DEEP or 65536, GROUND.OCEAN_CORAL or 65536, GROUND.MANGROVE or 65536,
    GROUND.MAGMAFIELD or 65536, GROUND.TIDALMARSH or 65536, GROUND.MEADOW or 65536, GROUND.VOLCANO or 65536,
    GROUND.VOLCANO_LAVA or 65536, GROUND.ASH or 65536, GROUND.VOLCANO_ROCK or 65536, GROUND.OCEAN_SHIPGRAVEYARD or 65536,
    GROUND.COBBLEROAD or 65536, GROUND.FOUNDATION or 65536, GROUND.DEEPRAINFOREST or 65536, GROUND.CHECKEREDLAWN or 65536,
    GROUND.PIGRUINS or 65536, GROUND.LILYPOND or 65536, GROUND.GASJUNGLE or 65536, GROUND.SUBURB or 65536,
    GROUND.RAINFOREST or 65536, GROUND.PIGRUINS_NOCANOPY or 65536, GROUND.PLAINS or 65536, GROUND.PAINTED or 65536,
    GROUND.BATTLEGROUND or 65536, GROUND.INTERIOR or 65536, GROUND.FIELDS
}

local ground_types_rainforest = {
    GROUND.DEEPRAINFOREST or 65536, GROUND.GASJUNGLE or 65536,
}

-- AllLayouts["PorkLandStart"] = StaticLayout.Get("map/static_layouts/porkland_start", {
--     start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
--     fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
--     layout_position = LAYOUT_POSITION.CENTER,
-- })
-- AllLayouts["PorkLandStart"].ground_types = ground_types

-- local function LilypadResource()
--     return math.random() < 0.5 and { "frog_poison_lilypad" } or { "mosquito_lilypad" }
-- end

-- AllLayouts["lilypad"] = StaticLayout.Get("map/static_layouts/lilypad", {
--     water = true,
--     areas = {
--         resource_area = LilypadResource
--     }
-- })
-- AllLayouts["lilypad"].ground_types = ground_types

-- AllLayouts["lilypad2"] = StaticLayout.Get("map/static_layouts/lilypad_2", {
--     water = true,
--     areas = {
--         resource_area = LilypadResource,
--         resource_area2 = LilypadResource
--     }
-- })
-- AllLayouts["lilypad2"].ground_types = ground_types

-- AllLayouts["PigRuinsHead"] = StaticLayout.Get("map/static_layouts/pig_ruins_head", {
--     areas = {
--         item1 = { "pig_ruins_head" },
--         item2 = function()
--             local list = { "smashingpot", "grass", "pig_ruins_torch" }
--             for i = #list, 1, -1 do
--                 if math.random() < 0.7 then
--                     table.remove(list, i)
--                 end
--             end
--             return list
--         end
--     }
-- })
-- AllLayouts["PigRuinsHead"].ground_types = ground_types_rainforest

-- local function GetRandomSmashingpot()
--     return math.random() < 0.7 and { "smashingpot" } or nil
-- end

-- local function GetSmashingpot()
--     return math.random() < 1 and { "smashingpot" } or nil
-- end

-- AllLayouts["PigRuinsArtichoke"] = StaticLayout.Get("map/static_layouts/pig_ruins_artichoke", {
--     areas = {
--         item1 = GetRandomSmashingpot,
--         item2 = { "pig_ruins_artichoke" }
--     }
-- })
-- AllLayouts["PigRuinsArtichoke"].ground_types = ground_types_rainforest

-- local function PigRuinsEntranceProps()
--     return {
--         areas = {
--             item1 = GetSmashingpot,
--             item2 = GetSmashingpot,
--             item3 = GetSmashingpot
--         }
--     }
-- end

-- AllLayouts["PigRuinsEntrance1"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_1", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance1"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance2"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_2")
-- AllLayouts["PigRuinsEntrance2"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance3"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_3")
-- AllLayouts["PigRuinsEntrance3"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance4"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_4", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance4"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance5"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_5", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance5"].ground_types = ground_types

-- AllLayouts["PigRuinsExit1"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_1")
-- AllLayouts["PigRuinsExit1"].ground_types = ground_types

-- local function GetPigRuinsExitProps()
--     return {
--         areas = {
--             item1 = GetRandomSmashingpot,
--             item2 = GetRandomSmashingpot,
--             item3 = GetRandomSmashingpot
--         }
--     }
-- end

-- AllLayouts["PigRuinsExit2"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_2", GetPigRuinsExitProps())
-- AllLayouts["PigRuinsExit2"].ground_types = ground_types

-- AllLayouts["PigRuinsExit4"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_4", GetPigRuinsExitProps())
-- AllLayouts["PigRuinsExit4"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy")
-- AllLayouts["pig_ruins_nocanopy"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_2")
-- AllLayouts["pig_ruins_nocanopy_2"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_3")
-- AllLayouts["pig_ruins_nocanopy_3"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_4")
-- AllLayouts["pig_ruins_nocanopy_4"].ground_types = ground_types

-- AllLayouts["mandraketown"] = StaticLayout.Get("map/static_layouts/mandraketown")
-- AllLayouts["mandraketown"].ground_types = ground_types

-- AllLayouts["nettlegrove"] = StaticLayout.Get("map/static_layouts/nettlegrove")
-- AllLayouts["nettlegrove"].ground_types = ground_types

-- AllLayouts["fountain_of_youth"] = StaticLayout.Get("map/static_layouts/pugalisk_fountain")
-- AllLayouts["fountain_of_youth"].ground_types = ground_types

-- AllLayouts["roc_nest"] = StaticLayout.Get("map/static_layouts/roc_nest")
-- AllLayouts["roc_nest"].ground_types = ground_types

-- AllLayouts["roc_cave"] = StaticLayout.Get("map/static_layouts/roc_cave")
-- AllLayouts["roc_cave"].ground_types = ground_types

--AllLayouts["teleportato_hamlet_potato_layout"] = StaticLayout.Get("map/static_layouts/teleportato_hamlet_potato_layout")
--AllLayouts["teleportato_hamlet_potato_layout"].ground_types = ground_types

AllLayouts["city_park_1"] = StaticLayout.Get("map/static_layouts/city_park_1")
AllLayouts["city_park_1"].ground_types = ground_types

AllLayouts["city_park_2"] = StaticLayout.Get("map/static_layouts/city_park_2")
AllLayouts["city_park_2"].ground_types = ground_types

AllLayouts["city_park_3"] = StaticLayout.Get("map/static_layouts/city_park_3")
AllLayouts["city_park_3"].ground_types = ground_types

AllLayouts["city_park_4"] = StaticLayout.Get("map/static_layouts/city_park_4")
AllLayouts["city_park_4"].ground_types = ground_types

AllLayouts["city_park_5"] = StaticLayout.Get("map/static_layouts/city_park_5")
AllLayouts["city_park_5"].ground_types = ground_types

AllLayouts["city_park_6"] = StaticLayout.Get("map/static_layouts/city_park_6")
AllLayouts["city_park_6"].ground_types = ground_types

AllLayouts["city_park_7"] = StaticLayout.Get("map/static_layouts/city_park_7")
AllLayouts["city_park_7"].ground_types = ground_types

AllLayouts["city_park_8"] = StaticLayout.Get("map/static_layouts/city_park_8")
AllLayouts["city_park_8"].ground_types = ground_types

AllLayouts["city_park_9"] = StaticLayout.Get("map/static_layouts/city_park_9")
AllLayouts["city_park_9"].ground_types = ground_types

AllLayouts["city_park_10"] = StaticLayout.Get("map/static_layouts/city_park_10")
AllLayouts["city_park_10"].ground_types = ground_types

AllLayouts["farm_1"] = StaticLayout.Get("map/static_layouts/farm_1")
AllLayouts["farm_1"].ground_types = ground_types

AllLayouts["farm_2"] = StaticLayout.Get("map/static_layouts/farm_2")
AllLayouts["farm_2"].ground_types = ground_types

AllLayouts["farm_3"] = StaticLayout.Get("map/static_layouts/farm_3")
AllLayouts["farm_3"].ground_types = ground_types

AllLayouts["farm_4"] = StaticLayout.Get("map/static_layouts/farm_4")
AllLayouts["farm_4"].ground_types = ground_types

AllLayouts["farm_5"] = StaticLayout.Get("map/static_layouts/farm_5")
AllLayouts["farm_5"].ground_types = ground_types

AllLayouts["farm_fill_1"] = StaticLayout.Get("map/static_layouts/farm_fill_1")
AllLayouts["farm_fill_1"].ground_types = ground_types

AllLayouts["farm_fill_2"] = StaticLayout.Get("map/static_layouts/farm_fill_2")
AllLayouts["farm_fill_2"].ground_types = ground_types

AllLayouts["farm_fill_3"] = StaticLayout.Get("map/static_layouts/farm_fill_3")
AllLayouts["farm_fill_3"].ground_types = ground_types

AllLayouts["pig_playerhouse_1"] = StaticLayout.Get("map/static_layouts/pig_playerhouse_1")
AllLayouts["pig_playerhouse_1"].ground_types = ground_types

AllLayouts["pig_palace_1"] = StaticLayout.Get("map/static_layouts/pig_palace_1")
AllLayouts["pig_palace_1"].ground_types = ground_types

AllLayouts["pig_cityhall_1"] = StaticLayout.Get("map/static_layouts/pig_cityhall_1")
AllLayouts["pig_cityhall_1"].ground_types = ground_types
