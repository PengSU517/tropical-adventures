local WorldMigrator = require "components/worldmigrator"
local Utils = require "tools/utils"

Utils.FnDecorator(WorldMigrator, "Activate", nil, function(rets, self, doer)
    if rets[1] == true then
        SendModRPCToShard(GetShardModRPC("Tropical adventures", "ReconnectCaveEntrances"),
                          self.linkedWorld, doer.Network:GetNetworkID(), self.id, self.receivedPortal)
    end
    return rets
end)