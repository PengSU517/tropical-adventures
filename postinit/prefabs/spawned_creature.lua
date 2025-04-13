local creatures = require("datadefs/creature_spawn_defs").creatures
for i, v in ipairs(creatures) do
    local prefabname = v.checkname or v.prefab
    AddPrefabPostInit(prefabname, function(inst)
        inst:AddTag("spawned_" .. prefabname)
    end)
end
