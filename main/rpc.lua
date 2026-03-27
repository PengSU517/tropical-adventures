local AddModRPCHandler = AddModRPCHandler
local AddShardModRPCHandler = AddShardModRPCHandler

AddShardModRPCHandler("TropicalAdventures", "SyncAporkalypseBeginDate", function(shardid, date)
    local aporkalypse = TheWorld.components.aporkalypse
    if aporkalypse ~= nil then
        aporkalypse.begin_date = date
    end
end)

--[=[
local function GetNetworkPlayer(NetworkID)
    for _, p in ipairs(AllPlayers) do
        if NetworkID == p.Network:GetNetworkID() then
            return p
        end
    end
end

local function r_print(msg, ...)
    print(string.format(">> Torpical Reconnector(%s): ", tostring(TheShard:GetShardId())), string.format(msg, ...))
end

local function ResetReceived(portal, receivedID)
    local wm = portal.components.worldmigrator
    local old = wm.receivedPortal
    wm.receivedPortal = receivedID
    wm._isreconnect = true
    r_print("Reconnect Portal(%s) received from %s(shard %s) -> %s(shard %s)",
            tostring(TheShard:GetShardId()),
            tostring(old),               tostring(wm.linkedWorld),
            tostring(wm.receivedPortal), tostring(wm.linkedWorld))
end

AddShardModRPCHandler("Tropical adventures", "ForceMatchPortal", function(shardid, playerNetID, portal, otherportal)
    if ShardPortals[otherportal] then
        ResetReceived(ShardPortals[otherportal], portal)
        if playerNetID then
            TheWorld.components.playerspawner:AddOnMigrated(playerNetID, otherportal)
        end
    else
        local shortest = { id = nil, dist = 999 }
        for id, localportal in pairs(ShardPortals) do
            local wm = localportal.components.worldmigrator
            if wm.linkedWorld == shardid then
                local dist = math.abs(tonumber(portal) - tonumber(id))
                if shortest.dist > dist then
                    shortest.id = id
                    shortest.dist = dist
                end
            end
        end
        if shortest.id ~= nil then
            ResetReceived(ShardPortals[shortest.id], shortest.id)
            if playerNetID then
                TheWorld.components.playerspawner:AddOnMigrated(playerNetID, otherportal)
            end
        end
    end
end)
]=]
