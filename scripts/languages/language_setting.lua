modimport("scripts/languages/stringsEU.lua")
-- modimport("scripts/languages/stringscreeps.lua") ---有些没删干净的东西需要这个语言包


if GLOBAL.TUNING.tropical.language == "stringsCH" then
    modimport("scripts/languages/stringsCH.lua")
elseif GLOBAL.TUNING.tropical.language == "stringsEN" then
    -- modimport("scripts/languages/stringsCharacters.lua")
end
