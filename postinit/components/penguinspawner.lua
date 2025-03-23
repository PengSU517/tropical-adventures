AddComponentPostInit("penguinspawner", function(cmp)
    local TryToSpawnFlock
    for per, _ in pairs(cmp.inst.pendingtasks) do
        TryToSpawnFlock = upvaluehelper.Get(per.fn, "TryToSpawnFlock")
        if TryToSpawnFlock then
            break
        end
    end
    local TryToSpawnFlockForPlayer
    if TryToSpawnFlock then
        TryToSpawnFlockForPlayer = upvaluehelper.Get(TryToSpawnFlock, "TryToSpawnFlockForPlayer")
    end
    if not TryToSpawnFlockForPlayer then
        return print("Failed to edit penguinspawner", TryToSpawnFlock, TryToSpawnFlockForPlayer)
    else
        local newTryToSpawnFlockForPlayer = function(playerdata)
            if playerdata.player and playerdata.player:AwareInTropicalArea() then
                return
            end
            TryToSpawnFlockForPlayer(playerdata)
        end
        upvaluehelper.Set(TryToSpawnFlock, "TryToSpawnFlockForPlayer", newTryToSpawnFlockForPlayer)
    end
end)
