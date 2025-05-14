local AddModRPCHandler = AddModRPCHandler
local AddShardModRPCHandler = AddShardModRPCHandler

AddShardModRPCHandler("Tropical adventures", "aporkalypse begin date", function(shardid, date)
    local aporka = TheWorld.net.components.aporkalypse

    if aporka then
        aporka.begin_date = date
    end
end)

local function GetNetworkPlayer(NetworkID)
    for _, p in ipairs(AllPlayers) do
        if NetworkID == p.Network:GetNetworkID() then
            return p
        end
    end
end

AddShardModRPCHandler("Tropical adventures", "ReconnectCaveEntrances", function(shardid, playerNetID, otherPortal, portal)
    if shardid ~= nil then shardid = tostring(shardid) end
    local player = playerNetID and GetNetworkPlayer(playerNetID)
    local handled, reason = false, nil
    if ShardPortals[portal] then
        local wm = ShardPortals[portal].components.worldmigrator
        if wm.receivedPortal ~= otherPortal then
            print(string.format("Tropical Adventures: Reconnect portal %d(%d) -> %d(%d) to -> %d(%d)",
                                TheShard:GetShardId(), wm.id, wm.linkedWorld, wm.receivedPortal, shardid, otherPortal))
            wm.linkedWorld = shardid
            wm.receivedPortal = otherPortal
            handled = true
        end
    else
        for _, p in pairs(ShardPortals) do
            local wm = p.components.worldmigrator
            if wm.linkedWorld == shardid and wm.receivedPortal == otherPortal and player ~= nil then
                TheWorld.components.playerspawner:AddOnMigrated(playerNetID, portal)
                SendModRPCToShard(GetShardModRPC("Tropical adventures", "ReconnectCaveEntrances"), shardid, nil, otherPortal, portal)
                handled = true
                break
            end
        end
        reason = handled ~= true and "NO SHOT"
    end
    if handled == false and reason == "NO SHOT" then
        print(string.format("Tropical Adventures: Could not connect no shot portal"))
    end
end)

AddModRPCHandler("Tropical adventures", "FiniteusesGet", function(player, item)
    SendModRPCToClient(GetClientModRPC("Tropical adventures", "FiniteusesPost"), player, item, item.components.finiteuses:GetPercent())
end)

AddClientModRPCHandler("Tropical adventures", "FiniteusesPost", function(item, percent)
    item:PushEvent("percentusedchange", { percent = percent })
end)