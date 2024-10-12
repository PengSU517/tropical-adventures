GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })


modimport("scripts/tuning") -- tuning + constants
modimport("scripts/languages/language_setting.lua")

require("tools/simutil")

modimport("main/assets")
modimport("main/standardcomponents")
modimport("main/postinit") --postinit相关全都在这里
modimport("scripts/actions.lua")


--recipes and cooking recipes
modimport("scripts/recipe_tabs")
modimport("scripts/recipes")
modimport("scripts/cooking_tropical")



modimport("scripts/characterdata.lua")
modimport("scripts/tropical_fx.lua")
