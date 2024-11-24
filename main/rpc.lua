local AddModRPCHandler = AddModRPCHandler
local AddShardModRPCHandler = AddShardModRPCHandler

AddShardModRPCHandler("Tropical adventures", "aporkalypse begin date", function(shardid, date)
    local aporka = TheWorld.net.components.aporkalypse

    if aporka then
        aporka.begin_date = date
    end
end)
