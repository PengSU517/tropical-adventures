--推荐使用腾讯的lua插件

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local require = require
local modimport = modimport


require("tools/table")               ----一些表相关的工具函数，都在表tabel里
modimport("scripts/ta_config")       ----mod 设置相关内容
modimport("main/tiledefs")           ----缺少行走的声音
modimport("scripts/tools/spawnutil") ----地形生成相关工具
require("map/tro_lockandkey")        ----地形锁钥
require("map/ocean_gen_new")         ----防止新的水面地皮被覆盖 ---但是暴力覆盖似乎太严重


----------新内容
modimport("scripts/map/init_static_layouts") --add new static layouts
modimport("scripts/map/rooms/ham")
modimport("scripts/map/rooms/sw")
modimport("scripts/map/rooms/ocean")
modimport("scripts/map/rooms/unknown")
modimport("scripts/map/tasks/ham")
modimport("scripts/map/tasks/sw")
modimport("scripts/map/newstartlocation")

-------------修改之前内容
modimport("postinit/map/graph")
modimport("postinit/map/storygen")
modimport("postinit/map/rooms")
modimport("postinit/map/tasks")
modimport("postinit/map/node")   ------------防止清空水上内容
modimport("postinit/map/levels") -----------[[几乎所有地形修改都在这里]]




-------------加载世界前进行的一些修改
modimport("main/preinit") ------------修改一些prefab的表
