-- local upvaluehelper = require("tools/upvaluehelper")
require("constants")
require("mathutil")

local ta_worldgen = TA_CONFIG.WORLDGEN
local forest_map = require("map/forest_map")

local old_generatemap = forest_map.Generate
local SKIP_GEN_CHECKS = upvaluehelper.Get(old_generatemap, "SKIP_GEN_CHECKS")
if SKIP_GEN_CHECKS ~= nil and TA_CONFIG.DEVELOP.test_map then
    print("Skipping generation checks for test map")
    local old = SKIP_GEN_CHECKS
    upvaluehelper.Set(old_generatemap, "SKIP_GEN_CHECKS", true)
end


forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    ----世界设置覆盖mod设置中的相同内容
    local worldgenset = deepcopy(level.overrides) or {}
    -- print("worldgenset:")
    -- for i, v in pairs(worldgenset) do
    --     print(i .. ":" .. tostring(v))
    -- end

    for i, v in pairs(ta_worldgen) do
        ta_worldgen[i] = (worldgenset[i] ~= nil) and worldgenset[i] or ta_worldgen[i]
        if ta_worldgen[i] == "disabled" then
            ta_worldgen[i] = false
        end
    end

    -- print("ta_worldgen:")
    -- for i, v in pairs(ta_worldgen) do
    --     print(i .. ":" .. tostring(v))
    -- end

    ta_worldgen.sw_start = ta_worldgen.shipwrecked and (ta_worldgen.multiplayerportal == "shipwrecked")
    ta_worldgen.ham_start = ta_worldgen.hamlet and (ta_worldgen.multiplayerportal == "hamlet")
    ta_worldgen.together_not_mainland = (ta_worldgen.sw_start or ta_worldgen.ham_start)
    ta_worldgen.together = not ((not ta_worldgen.rog) and ta_worldgen.together_not_mainland)


    local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)

    if save == nil then return save end
    -- if level.location ~= "forest" then return save end
    -- if not TUNING.hamlet then return save end
    if not tableutil.has_all_of_component(level.tasks, { "Edge_of_civilization", "Pigtopia", "Other_edge_of_civilization", "Other_pigtopia" }) then
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
