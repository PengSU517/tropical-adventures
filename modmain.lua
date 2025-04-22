GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

modimport "main/strings"

--工具函数，全部在GLOBAL里
require "tools/simutil"
require "tools/worldutil"
require "tools/standardcomponents"


modimport "main/prefabfiles"
modimport "main/assets"
modimport "main/actions"
modimport "main/componentactions"
modimport "main/postinit" --postinit相关全都在这里

--recipes, cooking recipes and other important modules
modimport "main/recipe_tabs"
modimport "main/recipes"
modimport "main/skins"
modimport "main/characters"
modimport "main/tropical_fx"
modimport "main/containers" --new contaoiners
modimport "main/rpc"
