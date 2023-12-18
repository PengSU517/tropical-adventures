AddComponentPostInit("playerspawner", function(self)
    local OldSpawnAtLocation = self.SpawnAtLocation
    function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
        local stone
        if not isloading then
            stone = TheSim:FindFirstEntityWithTag("multiplayer_portal") --  multiplayer_portal  constructionsite
            if stone ~= nil then
                x, y, z = stone.Transform:GetWorldPosition()
            end
        end
        OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)
        if stone ~= nil then
            player.Transform:SetPosition(x, y, z)
            --player.sg:GoToState("wakeup")
            -- if stone.components.growable ~= nil then
            --     stone.components.growable:DoGrowth()
            -- end
        end
    end
end)
