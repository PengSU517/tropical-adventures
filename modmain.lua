GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- modimport"main/tuning" -- tuning + constants
modimport "main/strings"

--工具函数，全部在GLOBAL里
require "tools/simutil"
require "tools/worldutil"
require "tools/standardcomponents"


modimport "main/ta_config_main" ----modmain中用到的内容
modimport "main/rpc"
modimport "main/prefabfiles"
modimport "main/assets"
modimport "main/actions"
modimport "main/componentactions"
modimport "main/postinit" --postinit相关全都在这里



--recipes and cooking recipes
modimport "main/recipe_tabs"
modimport "main/recipes"
modimport "main/skins"


modimport "main/characters"
modimport "main/tropical_fx"

modimport "scripts/datadefs/sw_fertilizer_nutrient_defs" --肥料值定义
