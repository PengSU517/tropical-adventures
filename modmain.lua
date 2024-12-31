GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

modimport("main/tuning") -- tuning + constants
modimport("main/strings.lua")

--工具函数，全部在GLOBAL里
require("tools/simutil")
require("tools/worldutil")
require("tools/standardcomponents")

modimport("main/rpc")
modimport("main/prefabfiles")
modimport("main/assets")
modimport("main/actions.lua")
modimport("main/componentactions.lua")
modimport("main/postinit") --postinit相关全都在这里



--recipes and cooking recipes
modimport("main/recipe_tabs")
modimport("main/recipes")
modimport("main/skins")


modimport("main/characters.lua")
modimport("main/tropical_fx.lua")

modimport "scripts/datadefs/sw_fertilizer_nutrient_defs" --肥料值定义
