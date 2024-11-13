function IsSwLandTile(tile)
    return SW_LAND_TILES[tile] ~= nil
end

function IsHamLandTile(tile)
    return HAM_LAND_TILES[tile] ~= nil
end

function IsTroLandTile(tile)
    return TRO_LAND_TILES[tile] ~= nil
end

function IsOnFlood(x, y, z)
    x, y, z = GetWorldPosition(x, y, z)
    local _flood = TheWorld.components.flooding
    return _flood ~= nil and _flood:OnFlood(x, y, z)
end

function IsOnOcean(x, y, z, onflood, ignoreboat)
    x, y, z = GetWorldPosition(x, y, z)
    local _map = TheWorld.Map

    return onflood and IsOnFlood(x, y, z) or _map:IsOceanAtPoint(x, y, z, ignoreboat)
end

function IsValidNodeTile(tile)
    return (IsLandTile(tile) or tile == WORLD_TILES.MANGROVE or tile == WORLD_TILES.LILYPOND) and true or false
end
