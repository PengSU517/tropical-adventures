---------------------------override before main-------------------

local oceanfishdefs = require("prefabs/oceanfishdef")
local tro_oceanfishdefs = require("prefabs/tro_oceanfishdef")
tabel.deep_merge(oceanfishdefs, tro_oceanfishdefs, false)

-- if oceanfishdefs.school[SEASONS.SPRING][WORLD_TILES.LILYPOND].oceanfish_small_11 then
--     print(oceanfishdefs.school[SEASONS.SPRING][WORLD_TILES.LILYPOND].oceanfish_small_11 .. "!!!!!!!!!!!!!")
-- end
