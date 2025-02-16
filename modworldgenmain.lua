--推荐使用腾讯的lua插件

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local require = require
local modimport = modimport

require("tools/upvaluehelper")
require("tools/tableutil") ----一些表相关的工具函数，都在表tableutil里
require("tools/modutil")
require("tools/tileutil")
require("tools/spawnutil")     ----地形生成相关工具

modimport("main/tuning")       -- tuning + constants
modimport("main/ta_customize") ----世界设置项
modimport("main/ta_config")    ----mod 设置相关内容
modimport("main/tiledefs")     ----缺少行走的声音


-- ModGetLevelDataOverride()





----------新内容
modimport("scripts/map/tro_lockandkey")      ----地形锁钥
modimport("scripts/map/init_static_layouts") --新的 static layouts
modimport("scripts/map/city_layouts")        --新的城镇 layouts
modimport("scripts/map/ruin_maze_layouts")   --新的地下遗迹layouts
modimport("scripts/map/rooms/ham")
modimport("scripts/map/rooms/sw")
modimport("scripts/map/rooms/ocean")
modimport("scripts/map/tasks/ham")
modimport("scripts/map/tasks/sw")
modimport("scripts/map/newstartlocation")

-------------修改之前内容
modimport("postinit/map/rooms")
modimport("postinit/map/tasks")
modimport("postinit/map/levels") -----------[[几乎所有地形修改都在这里]]
modimport("postinit/map/graph")
modimport("postinit/map/storygen")
modimport("postinit/map/forest_map_new") -----在这里添加哈姆雷特城镇
modimport("postinit/map/ocean_gen_new")  ----防止新的水面地皮被覆盖 ---但是暴力覆盖似乎太严重
modimport("postinit/map/node")           ------------防止清空水上内容





-------------加载世界前进行的一些修改
modimport("main/preinit") ------------修改一些prefab的表



print("gerrqdfgdggadfg")
local setting = rawget(_G, "GEN_PARAMETERS")

if setting then
    require("json")
    local world_gen_data = json.decode(setting)
    print("world_gen_data", world_gen_data or "nil")
    for i, v in pairs(world_gen_data) do
        print(i, v)
        if type(v) == "table" then
            for ii, vv in pairs(v) do
                print(i, ii, vv)
                if type(vv) == "table" then
                    for iii, vvv in pairs(vv) do
                        print(i, ii, iii, vvv)
                    end
                end
            end
        end
    end
end
