local assert = assert
local unpack = unpack
local math = math
local TILE_SCALE = TILE_SCALE
local TileGroupManager = TileGroupManager

require("components/map")
Map.GetVisualTileAtPoint = Map.FindVisualTileAtPoint



if TUNING.ocean_style == "tropical" then
    Map.tro_overhang = true

    local function checkinsidecorner(self, tx, ty, x_off, y_off)
        return TileGroupManager:IsOceanTile(self:GetTile(tx + x_off, ty))
            and TileGroupManager:IsOceanTile(self:GetTile(tx, ty + y_off))
    end

    local function checkoutsidecorner(self, tx, ty, x_off, y_off)
        return TileGroupManager:IsOceanTile(self:GetTile(tx + x_off, ty))
            or TileGroupManager:IsOceanTile(self:GetTile(tx, ty + y_off))
    end

    local function checkedge(self, tx, ty, x_off, y_off)
        return TileGroupManager:IsOceanTile(self:GetTile(tx + x_off, ty))
            or TileGroupManager:IsOceanTile(self:GetTile(tx, ty + y_off))
            or TileGroupManager:IsOceanTile(self:GetTile(tx + x_off, ty + y_off))
    end

    local _ignore_tro_corners = nil
    function Map:InternalIsVisualTroOceanAtPoint(ptx, pty, ptz, percentile, check_corners)
        -- Note: This is only usefull when ocean has overhang onto land
        -- This is a cheaper function used specifically to check if its an ocean tile
        assert(self.tro_overhang)
        local tx, ty = self:GetTileCoordsAtPoint(ptx, 0, ptz)

        if TileGroupManager:IsOceanTile(self:GetTile(tx, ty)) then
            return true
        end

        local tilecenter_x, tilecenter_y, tilecenter_z = self:GetTileCenterPoint(ptx, 0, ptz)
        if tilecenter_x and tilecenter_z then
            if _ignore_tro_corners then check_corners = false end
            percentile = percentile or 0.25
            local xpercent = ((tilecenter_x - ptx) / TILE_SCALE) + .5
            local ypercent = ((tilecenter_z - ptz) / TILE_SCALE) + .5

            local x_off = 0
            local y_off = 0

            if xpercent < percentile then
                x_off = 1
            elseif xpercent > 1 - percentile then
                x_off = -1
            end

            if ypercent < percentile then
                y_off = 1
            elseif ypercent > 1 - percentile then
                y_off = -1
            end

            if x_off == 0 and y_off == 0 then
                if check_corners then
                    -- inside corners
                    if xpercent + ypercent < 0.5 + percentile then
                        -- bottom left corner
                        return checkinsidecorner(self, tx, ty, 1, 1)
                    elseif xpercent + ypercent > 1.5 - percentile then
                        -- top right corner
                        return checkinsidecorner(self, tx, ty, -1, -1)
                    elseif xpercent + 0.5 - percentile < ypercent then
                        -- top left corner
                        return checkinsidecorner(self, tx, ty, 1, -1)
                    elseif xpercent > ypercent + 0.5 - percentile then
                        -- bottom right corner
                        return checkinsidecorner(self, tx, ty, -1, 1)
                    end
                end
                return false
            elseif x_off == 0 or y_off == 0 then
                return TileGroupManager:IsOceanTile(self:GetTile(tx + x_off, ty + y_off))
            elseif check_corners
                and ((x_off == 1 and y_off == 1 and xpercent + ypercent > 0.5 - percentile)          -- bottom left corner
                    or (x_off == -1 and y_off == -1 and xpercent + ypercent < 1.5 + percentile)      -- top right corner
                    or (x_off == 1 and y_off == -1 and xpercent + 0.5 + percentile > ypercent)       -- top left corner
                    or (x_off == -1 and y_off == 1 and xpercent < ypercent + 0.5 + percentile)) then -- bottom right corner
                -- outside corners
                return checkoutsidecorner(self, tx, ty, x_off, y_off)
            end
            return checkedge(self, tx, ty, x_off, y_off)
        end
    end

    -- Okay so this is very hacky but....
    -- Essentially in SW the corners are not calcuated at all
    -- But in order to keep compatibility with most dst content
    -- for example combat targeting and amphibiouscreatures and embarkers
    -- and proper spawn locations.. etc
    -- the corners are calculated by default for IsVisualGroundAtPoint
    -- So I just use this hack to disable the corners for floating items
    -- and placement checks to be more accurrate to sw
    function Map:RunWithoutTroCorners(fn, ...)
        local _ignore_tro_corners = _ignore_tro_corners
        _ignore_tro_corners = true
        local rets = { fn(...) }
        _ignore_tro_corners = _ignore_tro_corners
        return unpack(rets)
    end

    -- Overhang patches --
    local _IsVisualGroundAtPoint = Map.IsVisualGroundAtPoint
    function Map:IsVisualGroundAtPoint(x, y, z, ...)
        if self.tro_overhang and self:InternalIsVisualTroOceanAtPoint(x, y, z, nil, true) then
            -- What a pain dst's IsVisualGround doesnt support reversed overhang..
            return false
        end
        return _IsVisualGroundAtPoint(self, x, y, z, ...)
    end

    ---------------------------------------------------------

    local function _test_is_land_tile_at_point(x, y, z, map)
        return map:IsActualLandTileAtPoint(x, y, z)
    end

    local function _test_is_water_tile_at_point(x, y, z, map)
        return map:IsActualOceanTileAtPoint(x, y, z)
    end

    local function _test_is_not_above_land_tile_at_point(x, y, z, map)
        return not map:IsActualOceanTileAtPoint(x, y, z)
    end

    --------------------- IsCloseToTile ---------------------

    function Map:IsCloseToTile(x, y, z, radius, tile_scale, typefn, ...)
        if radius == 0 then return typefn(x, y, z, ...) end
        -- Correct improper radiuses caused by changes to the radius based on overhang
        if radius < 0 then return self:IsSurroundedByTile(x, y, z, radius * -1, tile_scale, typefn, ...) end

        local num_edge_points = math.ceil((radius * 2) / tile_scale) - 1

        --test the corners first
        if typefn(x + radius, y, z + radius, ...) then return true end
        if typefn(x - radius, y, z + radius, ...) then return true end
        if typefn(x + radius, y, z - radius, ...) then return true end
        if typefn(x - radius, y, z - radius, ...) then return true end

        --if the radius is less than 2(1 after the -1), it won't have any edges to test and we can end the testing here.
        if num_edge_points == 0 then return false end

        local dist = (radius * 2) / (num_edge_points + 1)
        --test the edges next
        for i = 1, num_edge_points do
            local idist = dist * i
            if typefn(x - radius + idist, y, z + radius, ...) then return true end
            if typefn(x - radius + idist, y, z - radius, ...) then return true end
            if typefn(x - radius, y, z - radius + idist, ...) then return true end
            if typefn(x + radius, y, z - radius + idist, ...) then return true end
        end

        --test interior points last
        for i = 1, num_edge_points do
            local idist = dist * i
            for j = 1, num_edge_points do
                local jdist = dist * j
                if typefn(x - radius + idist, y, z - radius + jdist, ...) then return true end
            end
        end
        return false
    end

    function Map:IsCloseToLand(x, y, z, radius, ignore_impassable)
        if self.tro_overhang then
            if ignore_impassable ~= nil then
                return self:IsCloseToTile(x, y, z, radius - 1, 4, _test_is_land_tile_at_point, self)
            else
                return self:IsCloseToTile(x, y, z, radius + 1, 4, _test_is_land_tile_at_point, self)
                    and self:IsCloseToTile(x, y, z, radius - 1, 4, _test_is_not_above_land_tile_at_point, self)
            end
        end
        return self:IsCloseToTile(x, y, z, radius + 1, 4, _test_is_land_tile_at_point, self)
    end

    function Map:IsCloseToWater(x, y, z, radius, ...)
        if self.tro_overhang then
            return self:IsCloseToTile(x, y, z, radius + 1, 4, _test_is_water_tile_at_point, self)
        end
        return self:IsCloseToTile(x, y, z, radius - 1, 4, _test_is_water_tile_at_point, self)
    end

    ---------------------------------------------------------

    ------------------- IsSurroundedByTile ------------------

    function Map:IsSurroundedByTile(x, y, z, radius, tile_scale, typefn, ...)
        if radius == 0 then return typefn(x, y, z, ...) end
        -- Correct improper radiuses caused by changes to the radius based on overhang
        if radius < 0 then return self:IsCloseToTile(x, y, z, radius * -1, tile_scale, typefn, ...) end

        local num_edge_points = math.ceil((radius * 2) / tile_scale) - 1

        --test the corners first
        if not typefn(x + radius, y, z + radius, ...) then return false end
        if not typefn(x - radius, y, z + radius, ...) then return false end
        if not typefn(x + radius, y, z - radius, ...) then return false end
        if not typefn(x - radius, y, z - radius, ...) then return false end

        --if the radius is less than 2(1 after the -1), it won't have any edges to test and we can end the testing here.
        if num_edge_points == 0 then return true end

        local dist = (radius * 2) / (num_edge_points + 1)
        --test the edges next
        for i = 1, num_edge_points do
            local idist = dist * i
            if not typefn(x - radius + idist, y, z + radius, ...) then return false end
            if not typefn(x - radius + idist, y, z - radius, ...) then return false end
            if not typefn(x - radius, y, z - radius + idist, ...) then return false end
            if not typefn(x + radius, y, z - radius + idist, ...) then return false end
        end

        --test interior points last
        for i = 1, num_edge_points do
            local idist = dist * i
            for j = 1, num_edge_points do
                local jdist = dist * j
                if not typefn(x - radius + idist, y, z - radius + jdist, ...) then return false end
            end
        end
        return true
    end

    function Map:IsSurroundedByLand(x, y, z, radius, ignore_impassable)
        if self.tro_overhang then
            if ignore_impassable then
                return self:IsSurroundedByTile(x, y, z, radius + 1, 4, _test_is_land_tile_at_point, self)
            else
                return self:IsSurroundedByTile(x, y, z, radius + 1, 4, _test_is_not_above_land_tile_at_point, self)
                    and self:IsSurroundedByTile(x, y, z, radius - 1, 4, _test_is_land_tile_at_point, self)
            end
        end
        return self:IsSurroundedByTile(x, y, z, radius - 1, 4, _test_is_land_tile_at_point, self)
    end

    local _IsSurroundedByWater = Map.IsSurroundedByWater
    function Map:IsSurroundedByWater(x, y, z, radius, ...)
        if self.tro_overhang then
            --subtract 1 to radius for map overhang, way cheaper than doing an IsVisualGround test
            --if the radius is less than 2(1 after the -1), We only need to check if the current point is an ocean tile
            return self:IsSurroundedByTile(x, y, z, radius - 1, 4, _test_is_water_tile_at_point, self)
        end
        return _IsSurroundedByWater(self, x, y, z, radius, ...)
    end

    ---------------------------------------------------------

    function Map:IsActualAboveGroundAtPoint(x, y, z, allow_water)
        local tile = self:GetTileAtPoint(x, y, z)
        local valid_water_tile = (allow_water == true) and TileGroupManager:IsOceanTile(tile)
        return valid_water_tile or TileGroupManager:IsLandTile(tile)
    end

    function Map:IsActualLandTileAtPoint(x, y, z)
        local tile = self:GetTileAtPoint(x, y, z)
        return TileGroupManager:IsLandTile(tile)
    end

    function Map:IsActualOceanTileAtPoint(x, y, z)
        local tile = self:GetTileAtPoint(x, y, z)
        return TileGroupManager:IsOceanTile(tile)
    end

    ---------------------------------------------------------

    local _IsAboveGroundAtPoint = Map.IsAboveGroundAtPoint
    function Map:IsAboveGroundAtPoint(x, y, z, allow_water, ...)
        if self.tro_overhang and not allow_water and self:InternalIsVisualTroOceanAtPoint(x, y, z, 0.375) then
            return false
        end
        return _IsAboveGroundAtPoint(self, x, y, z, allow_water, ...)
    end

    local _IsLandTileAtPoint = Map.IsLandTileAtPoint
    function Map:IsLandTileAtPoint(x, y, z, ...)
        if self.tro_overhang and self:InternalIsVisualTroOceanAtPoint(x, y, z, 0.375) then
            return false
        end
        return _IsLandTileAtPoint(self, x, y, z, ...)
    end

    local _IsOceanTileAtPoint = Map.IsOceanTileAtPoint
    function Map:IsOceanTileAtPoint(x, y, z, allow_boats, ...)
        -- Because our overhang is reversed we pretend the overhang is an oceantile for better
        -- compatibility with dst's overhang checks
        if self.tro_overhang then
            return self:InternalIsVisualTroOceanAtPoint(x, y, z, 0.375)
        end
        return _IsOceanTileAtPoint(self, x, y, z, allow_boats, ...)
    end

    ---------------------------------------------------------

    local _IsOceanAtPoint = Map.IsOceanAtPoint
    function Map:IsOceanAtPoint(x, y, z, allow_boats, ...)
        if self.tro_overhang then
            -- Optimization no need to call not self:IsVisualGroundAtPoint(x, y, z) or self:IsOceanTileAtPoint
            return self:InternalIsVisualTroOceanAtPoint(x, y, z, nil, true)
                and (allow_boats or self:GetPlatformAtPoint(x, z) == nil)
        end
        return _IsOceanAtPoint(self, x, y, z, allow_boats, ...)
    end
end
