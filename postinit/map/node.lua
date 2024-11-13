require("map/graphnode")

local NodeAddEntity = Node.AddEntity



Node.AddEntity = function(self, prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list,
                          prefab_data, rand_offset)
    local tile = WorldSim:GetTile(points_x[current_pos_idx], points_y[current_pos_idx])

    if not IsValidNodeTile(tile) then
        return
    end

    PopulateWorld_AddEntity(prefab, points_x[current_pos_idx], points_y[current_pos_idx], tile, entitiesOut, width,
        height, prefab_list, prefab_data, rand_offset)
end
