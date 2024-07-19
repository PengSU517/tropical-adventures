GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

require("tools/simutil")

modimport("scripts/tuning")
modimport("main/assets")
modimport("main/standardcomponents")
modimport("main/postinit") --postinit相关全都在这里
modimport("scripts/languages/language_setting.lua")
modimport("scripts/actions.lua")


--recipes and cooking recipes
modimport("scripts/recipe_tabs")
modimport("scripts/recipes")
modimport("scripts/cooking_tropical")



modimport("scripts/characterdata.lua")           -------------这似乎是个大杂烩，需要整理
modimport("scripts/tropical_fx.lua")
