AddComponentPostInit("playerspawner", function(self)
    local OldSpawnAtLocation = self.SpawnAtLocation
    function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
        -- local portal
        if not isloading then
            -- portal = TheSim:FindFirstEntityWithTag("multiplayer_portal") --  multiplayer_portal  constructionsite
            -- if portal ~= nil then
            --     x, y, z = portal.Transform:GetWorldPosition()
            -- end

            -------------添加出生物品---------------修改为DOTAskintime或许会更好
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
        OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)

        -- if portal ~= nil then
        --     local spawnpoint = FindClosestEntity(player, 2, true, "CLASSIFIED") ------这个函数好用啊
        --     if spawnpoint and ((spawnpoint.prefab == "spawnpoint_master") or (spawnpoint.prefab == "spawnpoint_multiplayer")) then
        --         player.Transform:SetPosition(x, y, z)
        --     end
        -- end
    end
end)
