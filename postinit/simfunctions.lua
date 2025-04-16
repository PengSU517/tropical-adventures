-- Store the globals for optimization
local converted_prefabs = require("datadefs/translated_prefabs").converted_prefabs

local _SpawnPrefab = SpawnPrefab
function SpawnPrefab(name, ...)
    -- print("SpawnPrefab1111", name)
    name = converted_prefabs[name] or name
    return _SpawnPrefab(name, ...)
end

-- local _DebugSpawn = DebugSpawn
-- function DebugSpawn(name)
--     print("debugSpawnPrefab1111", name)
--     name = converted_prefabs[name] or name
--     return _DebugSpawn(name)
-- end
