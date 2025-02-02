-- local upvaluehelper = require("tools/upvaluehelper")
require("constants")
require("mathutil")
local forest_map = require("map/forest_map")

local old_generatemap = forest_map.Generate
local SKIP_GEN_CHECKS = upvaluehelper.Get(old_generatemap, "SKIP_GEN_CHECKS")
if SKIP_GEN_CHECKS ~= nil and TA_CONFIG.testmap then
    print("Skipping generation checks for test map")
    local old = SKIP_GEN_CHECKS
    upvaluehelper.Set(old_generatemap, "SKIP_GEN_CHECKS", true)
end


forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    -- local worldgenset = deepcopy(level.overrides)
    -- local multi = worldgenset.world_size_multi or 1


    -- if GLOBAL.rawget(GLOBAL, "WorldSim") then
    --     local idx = GLOBAL.getmetatable(GLOBAL.WorldSim).__index

    --     if multi ~= 1 then
    --         local OldSetWorldSize = idx.SetWorldSize
    --         idx.SetWorldSize = function(self, width, height)
    --             print("Setting world size to " .. width .. " times " .. multi)
    --             OldSetWorldSize(self, math.ceil(multi * width), math.ceil(multi * height))
    --         end

    --         local OldConvertToTileMap = idx.ConvertToTileMap
    --         idx.ConvertToTileMap = function(self, length)
    --             OldConvertToTileMap(self, math.ceil(multi * length))
    --         end
    --     end

    --     if worldgenset.coastline then
    --         idx.SeparateIslands = function(self) print("不分离土地") end
    --     end
    -- end


    local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)

    if save == nil then return save end
    -- if level.location ~= "forest" then return save end
    -- if not TA_CONFIG.hamlet then return save end
    if not tableutil.has_all_of_component(level.tasks, { "Edge_of_civilization", "Pigtopia", "Other_edge_of_civilization", "Other_pigtopia" }) then
        return
            save
    end

    ------在这里可以获取所有信息
    -- print("Generating map for hamlet!")
    -- for i, v in pairs(level.overrides) do
    --     print("overrides", i, v)
    -- end

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
