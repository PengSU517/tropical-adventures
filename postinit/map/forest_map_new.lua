local upvaluehelper = require("tools/upvaluehelper")
require("constants")
require("mathutil")

-- local separate_region = require("map/separate_region")
-- local build_porkland = require("map/build_porkland")
-- local make_cities = require("map/city_builder")
-- local startlocations = require("map/startlocations")
local forest_map = require("map/forest_map")
-- local BuildPorkLandStory = require("map/pl_storygen")
-- local MULTIPLY = forest_map.MULTIPLY
-- local TRANSLATE_TO_PREFABS = forest_map.TRANSLATE_TO_PREFABS
-- local TRANSLATE_AND_OVERRIDE = forest_map.TRANSLATE_AND_OVERRIDE



local old_generatemap = forest_map.Generate
local SKIP_GEN_CHECKS = upvaluehelper.Get(old_generatemap, "SKIP_GEN_CHECKS")
if SKIP_GEN_CHECKS ~= nil and TA_CONFIG.testmap then
    print("Skipping generation checks for test map")
    local old = SKIP_GEN_CHECKS
    upvaluehelper.Set(old_generatemap, "SKIP_GEN_CHECKS", true)
end


forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)

    if save == nil then return save end
    -- if level.location ~= "forest" then return save end
    -- if not TA_CONFIG.hamlet then return save end
    if not tabel.has_all_of_component(level.tasks, { "Edge_of_civilization", "Pigtopia", "Other_edge_of_civilization", "Other_pigtopia" }) then
        return
            save
    end

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
    -----------------------------------------------------------------------------------------------------------------
    return save
end
