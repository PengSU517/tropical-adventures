AddComponentPostInit("playerspawner", function(self)
    local OldSpawnAtLocation = self.SpawnAtLocation
    function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
        local portal
        if not isloading then
            portal = TheSim:FindFirstEntityWithTag("multiplayer_portal") --  multiplayer_portal  constructionsite
            if portal ~= nil then
                x, y, z = portal.Transform:GetWorldPosition()
            end
        end
        OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)

        if portal ~= nil then
            player.Transform:SetPosition(x, y, z)

            -------------添加出生物品
            local startitem
            if TUNING.tropical.startlocation == "shipwrecked" then
                startitem = SpawnPrefab("porto_raft_old")
            elseif TUNING.tropical.startlocation == "hamlet" then
                startitem = SpawnPrefab("machete")
            end
            if startitem then
                player.components.inventory:GiveItem(startitem)
            end
        end
    end
end)
