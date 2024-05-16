local TAENV = env
GLOBAL.setfenv(1, GLOBAL)




local function CLIENT_CanDeployDockKit(inst, pt, mouseover, deployer, rotation)
    local x, y, z = pt:Get()
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if (tile == WORLD_TILES.OCEAN_COASTAL_SHORE or tile == WORLD_TILES.OCEAN_COASTAL or
            tile == WORLD_TILES.OCEAN_SHALLOW_SHORE or tile == WORLD_TILES.OCEAN_SHALLOW or
            tile == WORLD_TILES.MANGROVE or tile == WORLD_TILES.LILYPOND) then
        for _, entity_on_tile in ipairs(TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0, z)) do
            if entity_on_tile:HasTag("dockjammer") then
                return false
            end
        end

        local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)
        local found_adjacent_safetile = false
        for x_off = -1, 1, 1 do
            for y_off = -1, 1, 1 do
                if (x_off ~= 0 or y_off ~= 0) and IsLandTile(TheWorld.Map:GetTile(tx + x_off, ty + y_off)) then
                    found_adjacent_safetile = true
                    break
                end
            end

            if found_adjacent_safetile then break end
        end

        if found_adjacent_safetile then
            local center_pt = Vector3(TheWorld.Map:GetTileCenterPoint(tx, ty))
            return found_adjacent_safetile and TheWorld.Map:CanDeployDockAtPoint(center_pt, inst, mouseover)
        end
    end

    return false
end


TAENV.AddPrefabPostInit("dock_kit", function(inst)
    inst._custom_candeploy_fn = CLIENT_CanDeployDockKit
end)
