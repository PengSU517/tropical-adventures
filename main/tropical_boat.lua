modimport("postinit/player_load")

------------------测试内容------------------
-- require "components/map"

-- local old_IsPassableAtPoint = Map.IsPassableAtPoint

-- function Map:IsPassableAtPoint(x, y, z, allow_water, exclude_boats)
--     local valid_tile, is_overhang = self:IsPassableAtPointWithPlatformRadiusBias(x, y, z, allow_water, exclude_boats, 0)

--     -- if is_overhang == nil then
--     --     if not allow_water and not valid_tile then
--     --         if not exclude_boats then
--     --             if TheSim:FindEntities(x, y, z, 0.1, { "boatsw" }) then
--     --                 return true
--     --             end
--     --         end
--     --         return false
--     --     end
--     -- end
--     return valid_tile, is_overhang
-- end
