--configurar idioma

-- if GetModConfigData("set_idioma") ~= nil then
-- 	if GetModConfigData("set_idioma") == "strings" then
-- 		modimport("scripts/stringsEU.lua")
-- 	else
-- 		modimport("scripts/" .. GetModConfigData("set_idioma") .. ".lua")
-- 	end
-- end


modimport("scripts/languages/stringsEU.lua")

-- print("check languages!!!!!!!!!!!!") -------------为啥不能用中文覆盖呢，但是中文能被英文覆盖???  因为被角色台词覆盖了。。。
-- print(GLOBAL.TUNING.tropical.language)
-- print(GLOBAL.TUNING.tropical.language == "stringsCH")
-- modimport("scripts/languages/stringscomplement.lua")
modimport("scripts/languages/stringscreeps.lua") ------------------不知道为啥这个不引入就会闪退,而且有大量重复内容
-- modimport("scripts/languages/wurt_quotes.lua")

if GLOBAL.TUNING.tropical.language == "stringsCH" then
    modimport("scripts/languages/stringsCH.lua")
end
