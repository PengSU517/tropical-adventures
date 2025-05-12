local Utils = require "tools/utils"
local MigrateList = {}

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

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
            if TUNING.sw_start == true then
                startitem = "porto_raft_old"
            elseif TUNING.ham_start == true then
                startitem = "machete"
            end

            if startitem then
                local item = SpawnPrefab(startitem)
                if item then
                    player.components.inventory:GiveItem(item)
                end
            end

            ----------填海叉
            local startitem
            if TA_CONFIG.DEVELOP.test_mode then
                startitem = "sea2land_fork"
            end

            if startitem then
                local item = SpawnPrefab(startitem)
                if item then
                    player.components.inventory:GiveItem(item)
                    -- local eslot = item.components.equippable.equipslot
                    -- player:PushEvent("equipped", { item = item, eslot = eslot })
                end
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
    function self:AddOnMigrated(playerNetID, PortalID)
        MigrateList[playerNetID] = PortalID
    end
    Utils.FnDecorator(self, "SpawnAtLocation", function(self, player)
        if player.migration ~= nil then
            self._fixmigrate = true
        end
    end, function(rets, self, player)
        if self._fixmigrate then
            self._fixmigrate = nil
            local pid = player.Network:GetNetworkID()
            if MigrateList[pid] then
                local p = ShardPortals[MigrateList[pid]]
                local pt = p:GetPosition()
                pt = pt + (FindWalkableOffset(pt, math.random() * TWOPI, 2, 8, false, true, NoHoles) or Vector3(0,0,0))
                player.Transform:SetPosition(pt:Get())
                MigrateList[pid] = nil
            end
        end
        return rets
    end)
end)
