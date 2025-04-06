AddComponentPostInit("hounded", function(cmp)
    cmp.inst:DoTaskInTime(0, function()
        local _spawndata = upvaluehelper.Get(cmp.SetSpawnData, "_spawndata")
        local _SummonSpawn = upvaluehelper.Get(cmp.SummonSpawn, "SummonSpawn")
        local _GetSpawnPrefab = upvaluehelper.Get(_SummonSpawn, "GetSpawnPrefab")
        local _GetSpawnPoint = upvaluehelper.Get(_SummonSpawn, "GetSpawnPoint")
        local _GetSpecialSpawnChance = upvaluehelper.Get(_GetSpawnPrefab, "GetSpecialSpawnChance")
        local _SPAWN_DIST = upvaluehelper.Get(_GetSpawnPoint, "SPAWN_DIST")

        local function SummonSpawn(pt, upgrade, radius_override)
            local map = TheWorld.Map
            local x, y, z = pt:Get()

            local spawndat = deepcopy(_spawndata)

            if TheWorld:HasTag("cave") then
                _spawndata.base_prefab = "worm"
                _spawndata.winter_prefab = "worm"
                _spawndata.summer_prefab = "worm"
                _spawndata.upgrade_spawn = "worm_boss"
            elseif TheWorld.Map:IsHamletAreaAtPoint(x, 0, z) then
                _spawndata.base_prefab = "circlingbat"
                _spawndata.winter_prefab = "circlingbat"
                _spawndata.summer_prefab = "circlingbat"
                _spawndata.upgrade_spawn = " "
            elseif TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z) then
                _spawndata.base_prefab = "crocodog"
                _spawndata.winter_prefab = "watercrocodog"
                _spawndata.summer_prefab = "poisoncrocodog"
                _spawndata.upgrade_spawn = " "
            else
                _spawndata.base_prefab = "hound"
                _spawndata.winter_prefab = "icehound"
                _spawndata.summer_prefab = "firehound"
                _spawndata.upgrade_spawn = "warglet"
            end

            if _spawndata.base_prefab == "circlingbat" then
                _SPAWN_DIST = 4
            else
                _SPAWN_DIST = 30
            end

            upvaluehelper.Set(_GetSpawnPoint, "SPAWN_DIST", _SPAWN_DIST)
            upvaluehelper.Set(cmp.SetSpawnData, "_spawndata", spawndat)
            _SummonSpawn(pt, upgrade, radius_override)
        end

        upvaluehelper.Set(cmp.SummonSpawn, "SummonSpawn", SummonSpawn)
    end)
end)
