local Hounded = require "components/hounded"

local _spawndata = upvaluehelper.Get(Hounded.SetSpawnData, "_spawndata")
local _preservedata = deepcopy(_spawndata)
local _SummonSpawn = upvaluehelper.Get(Hounded.SummonSpawn, "SummonSpawn")

local function SummonSpawn(pt, upgrade, radius_override)
    if not TheWorld:HasTag("cave") then
        local x, _, z = pt:Get()
        if TheWorld.Map:IsHamletAreaAtPoint(x, 0, z) then
            _spawndata.base_prefab = "circlingbat"
            _spawndata.winter_prefab = "circlingbat"
            _spawndata.summer_prefab = "circlingbat"
            _spawndata.upgrade_spawn = " "
            radius_override = 4
        elseif TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z) then
            _spawndata.base_prefab = "crocodog"
            _spawndata.winter_prefab = "watercrocodog"
            _spawndata.summer_prefab = "poisoncrocodog"
            _spawndata.upgrade_spawn = " "
        else
            _spawndata.base_prefab = _preservedata.base_prefab
            _spawndata.winter_prefab = _preservedata.winter_prefab
            _spawndata.summer_prefab = _preservedata.summer_prefab
            _spawndata.upgrade_spawn = _preservedata.upgrade_spawn
        end
    end
    return _SummonSpawn(pt, upgrade, radius_override)
end

upvaluehelper.Set(Hounded.SummonSpawn, "SummonSpawn", SummonSpawn)
