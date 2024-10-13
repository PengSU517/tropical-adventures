-- GLOBAL.setfenv(1, GLOBAL)

require("constants")
require("mathutil")

-- local separate_region = require("map/separate_region")
-- local build_porkland = require("map/build_porkland")
local make_cities = require("map/city_builder")
-- local startlocations = require("map/startlocations")
local forest_map = require("map/forest_map")
-- local BuildPorkLandStory = require("map/pl_storygen")
-- local MULTIPLY = forest_map.MULTIPLY
-- local TRANSLATE_TO_PREFABS = forest_map.TRANSLATE_TO_PREFABS
-- local TRANSLATE_AND_OVERRIDE = forest_map.TRANSLATE_AND_OVERRIDE





local old_generatemap = forest_map.Generate
forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)

    if save == nil then return save end
    if level.location ~= "forest" then return save end
    if not TA_CONFIG.hamlet then return save end


    -- require "map/monkeyisland_worldgen"
    -- MonkeyIsland_GenerateDocks(WorldSim, save.ents, map_width, map_height)


    --------------------building porkland cities---------------------------------------------------------------------
    local make_cities = require("map/city_builder")
    local build_porkland = function(entities, topology_save, map_width, map_height, current_gen_params)
        print("Building porkland cities!")
        make_cities(entities, topology_save, WorldSim, map_width, map_height, current_gen_params)



        local join_islands = not current_gen_params.no_joining_islands
        save.map.tiles, save.map.tiledata, save.map.nav, save.map.adj, save.map.nodeidtilemap =
            WorldSim:GetEncodedMap(join_islands) ----这是存储地形数据的关键
    end

    build_porkland(save.ents, TOPOLOGY_SAVE, save.map.width, save.map.height, deepcopy(level.overrides))
    ----mapwidth,height在其中发生过改变
    -------------------------------------------------------------------------------------------------------------------
    return save
end
