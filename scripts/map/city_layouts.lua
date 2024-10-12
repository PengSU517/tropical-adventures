-- This file loads all static layouts and contains all non-static layouts
local StaticLayout = require("map/static_layout")
local AllLayouts = require("map/layouts").Layouts

local ground_types = {
    -- Translates tile type index from constants.lua into tiled tileset.
    -- Order they appear here is the order they will be used in tiled.
    GROUND.IMPASSABLE or 9, GROUND.ROAD or 9, GROUND.ROCKY or 9, GROUND.DIRT or 9,
    GROUND.SAVANNA or 9, GROUND.GRASS or 9, GROUND.FOREST or 9, GROUND.MARSH or 9,

    GROUND.WOODFLOOR or 9, GROUND.CARPET or 9, GROUND.CHECKER or 9, GROUND.CAVE or 9,
    GROUND.FUNGUS or 9, GROUND.SINKHOLE or 9, GROUND.WALL_ROCKY or 9, GROUND.WALL_DIRT or 9,
    GROUND.WALL_MARSH or 9, GROUND.WALL_CAVE or 9, GROUND.WALL_FUNGUS or 9, GROUND.WALL_SINKHOLE or 9,
    GROUND.UNDERROCK or 9, GROUND.MUD or 9, GROUND.WALL_MUD or 9, GROUND.WALL_WOOD or 9,

    GROUND.BRICK or 9, GROUND.BRICK_GLOW or 9, GROUND.TILES or 9, GROUND.TILES_GLOW or 9,
    GROUND.TRIM or 9, GROUND.TRIM_GLOW or 9, GROUND.WALL_HUNESTONE or 9, GROUND.WALL_HUNESTONE_GLOW or 9,

    GROUND.WALL_STONEEYE or 9, GROUND.WALL_STONEEYE_GLOW or 9, GROUND.FUNGUSRED or 9, GROUND.FUNGUSGREEN or 9,
    GROUND.BEACH or 9, GROUND.JUNGLE or 9, GROUND.SWAMP or 9, GROUND.OCEAN_SHALLOW or 9,

    GROUND.OCEAN_MEDIUM or 9, GROUND.OCEAN_DEEP or 9, GROUND.OCEAN_CORAL or 9, GROUND.MANGROVE or 9,
    GROUND.MAGMAFIELD or 9, GROUND.TIDALMARSH or 9, GROUND.MEADOW or 9, GROUND.VOLCANO or 9,
    GROUND.VOLCANO_LAVA or 9, GROUND.ASH or 9, GROUND.VOLCANO_ROCK or 9, GROUND.OCEAN_SHIPGRAVEYARD or 9,
    GROUND.COBBLEROAD or 9, GROUND.FOUNDATION or 9, GROUND.DEEPRAINFOREST or 9, GROUND.CHECKEREDLAWN or 9,

    GROUND.PIGRUINS or 9, GROUND.LILYPOND or 9, GROUND.GASJUNGLE or 9, GROUND.SUBURB or 9,
    GROUND.RAINFOREST or 9, GROUND.PIGRUINS_NOCANOPY or 9, GROUND.PLAINS or 9, GROUND.PAINTED or 9,
    GROUND.BATTLEGROUND or 9, GROUND.INTERIOR or 9, GROUND.FIELDS
}

local ground_types_rainforest = {
    GROUND.DEEPRAINFOREST or 9, GROUND.GASJUNGLE or 9,
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
