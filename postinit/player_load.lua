local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local unpack = unpack

-- -----------防止重新进档落水---------------需要和playerpost配合使用
TAENV.AddComponentPostInit("playerspawner", function(self)
    local OldSpawnAtLocation = self.SpawnAtLocation
    function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
        if isloading then
            local ship = player.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
            if ship then
                if player.components.drownable ~= nil then
                    player.components.drownable.enabled = false
                    player.undrownable_bcz_ship = true
                end
            end
        end
        OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)

        -- local ship = player.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        -- if ship then
        --     if player.components.drownable ~= nil then
        --         player.components.drownable.enabled = true
        --     end
        -- end
    end
end)


TAENV.AddPlayerPostInit(function(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(2 * FRAMES, function()
            if inst.undrownable_bcz_ship and inst.components.drownable then
                inst.components.drownable.enabled = true
            end
        end)
    end
end)
