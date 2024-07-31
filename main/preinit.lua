---------------------------override before main-------------------

local oceanfishdefs = require("prefabs/oceanfishdef")
local tro_oceanfishdefs = require("prefabs/tro_oceanfishdef")

if not TUNING.tropical.ndnr then
    tabel.deep_merge(oceanfishdefs, tro_oceanfishdefs, false)
end

-- if oceanfishdefs.school[SEASONS.SPRING][WORLD_TILES.LILYPOND].oceanfish_small_11 then
--     print(oceanfishdefs.school[SEASONS.SPRING][WORLD_TILES.LILYPOND].oceanfish_small_11 .. "!!!!!!!!!!!!!")
-- end
