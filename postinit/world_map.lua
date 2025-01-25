--@Author: Peng
local Utils = require("tools/utils")
-- local upvaluehelper = require("tools/upvaluehelper")


-----------map related--------------------------
require("components/map")


----种植判定改动
local function FindVisualTileAtPoint_TestArea(map, pt_x, pt_z, r)
    local best = { tile_type = WORLD_TILES.INVALID, render_layer = -1 }
    for _z = -1, 1 do
        for _x = -1, 1 do
            local x, z = pt_x + _x * r, pt_z + _z * r

            local tile_type = map:GetTileAtPoint(x, 0, z) -----这里判断地皮总有点不太合适，判断初始地皮会好一些
            local tile_info = GetTileInfo(tile_type)
            local render_layer = tile_info ~= nil and tile_info._render_layer or 0
            if render_layer > best.render_layer then
                best.tile_type = tile_type
                best.render_layer = render_layer
                best.x = x
                best.z = z
            end
        end
    end

    return best.tile_type ~= WORLD_TILES.INVALID and best or nil
end

Map.FindVisualTileAtPoint = function(self, x, y, z)
    local best = FindVisualTileAtPoint_TestArea(self, x, z, 0.95)
    return (best ~= nil) and best.tile_type or 1 ---1应该是虚空吧
end

function Map:CanPlantAtPoint(x, y, z)
    local tile = self:FindVisualTileAtPoint(x, y, z)
    if not TileGroupManager:IsLandTile(tile) then
        return false
    end
    return not GROUND_HARD[tile]
end

-------区域判定改动
local function FindVisualNodeAtPoint_TestArea(map, pt_x, pt_z, r)
    local best = { tile_type = WORLD_TILES.INVALID, render_layer = -1 }
    for _z = -1, 1 do
        for _x = -1, 1 do
            local x, z = pt_x + _x * r, pt_z + _z * r

            local tile_type = map:GetTileAtPoint(x, 0, z) -----这里判断地皮总有点不太合适，判断初始地皮会好一些
            if IsValidNodeTile(tile_type) then
                local tile_info = GetTileInfo(tile_type)
                local render_layer = tile_info ~= nil and tile_info._render_layer or 0
                if render_layer > best.render_layer then
                    best.tile_type = tile_type
                    best.render_layer = render_layer
                    best.x = x
                    best.z = z
                end
            end
        end
    end

    return best.tile_type ~= WORLD_TILES.INVALID and best or nil
end

Map.FindVisualNodeAtPoint = function(self, x, y, z, has_tag)
    local node_index

    local nodeid = self:GetNodeIdAtPoint(x, 0, z)
    local in_node = nodeid and nodeid ~= 0

    local tile_type = self:GetTileAtPoint(x, 0, z)
    local is_valid_tile = IsValidNodeTile(tile_type)
    if in_node and is_valid_tile then
        node_index = nodeid
    else
        local best = FindVisualNodeAtPoint_TestArea(self, x, z, 4)
            or FindVisualNodeAtPoint_TestArea(self, x, z, 16)
            or FindVisualNodeAtPoint_TestArea(self, x, z, 64)

        node_index = (best ~= nil) and self:GetNodeIdAtPoint(best.x, 0, best.z) or 0
    end


    if has_tag == nil then
        return TheWorld.topology.nodes[node_index], node_index
    else
        local node = TheWorld.topology.nodes[node_index]
        return ((node ~= nil and table.contains(node.tags, has_tag)) and node or nil), node_index
    end
end


Map.IsTropicalAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "tropical")
        or self:FindVisualNodeAtPoint(x, y, z, "ForceDisconnected")

    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsShipwreckedAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "shipwrecked")
    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsHamletAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "hamlet")
    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsVolcanoAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "volcano")
    if node ~= nil then
        return true
    else
        return false
    end
end


-----area aware related -------------
--[[ AddComponentPostInit("areaaware", function(self)
    self.current_nearby_area = -1
    self.current_nearby_area_data = nil


    local old = self.UpdatePosition
    function self:UpdatePosition(x, y, z, ...)
        local node, node_index = TheWorld.Map:FindVisualNodeAtPoint(x, y, z)
        if node_index ~= self.current_nearby_area then
            self.current_nearby_area = node_index or 0

            self.current_nearby_area_data = node and {
                    id = TheWorld.topology.ids[node_index],
                    type = node.type,
                    center = node.cent,
                    poly = node.poly,
                    tags = node.tags,
                }
                or nil

            -- self.inst:PushEvent("changearea", self.current_nearby_area_data)
        end

        old(self, x, y, z, ...)
    end

    function self:CurrentlyInTag(tag)
        return self.current_nearby_area_data and self.current_nearby_area_data.tags and
            table.contains(self.current_nearby_area_data.tags, tag)
    end
end) ]]


--------------------------调整地图判定
-- require "components/map"

-- --得到瓷砖中心点
-- local old_GetTileCenterPoint = Map.GetTileCenterPoint
-- Map.GetTileCenterPoint = function(self, x, y, z)
--     local map_width, map_height = TheWorld.Map:GetSize()
--     if (type(x) == "number" and math.abs(x) >= map_width) and (type(z) == "number" and math.abs(z) >= map_height) then
--         return math.floor((x) / 4) * 4 + 2, 0, math.floor((z) / 4) * 4 + 2
--     end
--     if z then
--         return old_GetTileCenterPoint(self, x, y, z)
--     else
--         return old_GetTileCenterPoint(self, x, y)
--     end
-- end






------------------------------------是不是可通行的点----------------------------




-- local function IsHamRoomAtPoint(x, y, z)
--     if type(x) ~= "number" then
--         x, y, z = x.x or x, x.y or y, x.z or z
--     end
--     if checkxz(x, z) then -----判断一下以减少运算
--         local entities = TheSim:FindEntities(x, y, z, 20, { "interior_center" })
--         if entities then
--             for i, v in ipairs(entities) do
--                 if v then
--                     local rsize = roomsize[roomtype[v.prefab] or "small"]
--                     local xx, yy, zz = v.Transform:GetWorldPosition()
--                     if ((x - xx) <= rsize.front and (x - xx) >= -rsize.back and math.abs(z - zz) <= rsize.side) then ---11
--                         return true
--                     end
--                 end
--             end
--         end
--     end

--     return false
-- end

-- local function IsHamRoomWallAtPoint(x, y, z)
--     if type(x) ~= "number" then
--         x, y, z = x.x or x, x.y or y, x.z or z
--     end

--     if checkxz(x, z) then
--         local entities = TheSim:FindEntities(x, y, z, 20, { "interior_center" })
--         if entities then
--             for i, v in ipairs(entities) do
--                 if v --[[and v.prefab == "playerhouse_city_floor" ]] then
--                     local rsize = roomsize[roomtype[v.prefab] or "small"]
--                     local xx, yy, zz = v.Transform:GetWorldPosition()
--                     if (x - xx) <= -rsize.back and (x - xx) > -(rsize.back + 0.5) and math.abs(z - zz) <= (rsize.side - 0.5) then ---11
--                         return "back"
--                     elseif (z - zz) >= rsize.side and (z - zz) < (rsize.side + 0.5) and (x - xx) <= rsize.front and (x - xx) >= -(rsize.back - 0.5) then
--                         return "right"
--                     elseif (zz - z) >= rsize.side and (zz - z) < (rsize.side + 0.5) and (x - xx) <= rsize.front and (x - xx) >= -(rsize.back - 0.5) then
--                         return "left"
--                     else
--                         -- return false
--                     end
--                 end
--             end
--         end
--     end

--     return false
-- end



-- Map.IsHamRoomAtPoint = function(self, x, y, z)
--     return IsHamRoomAtPoint(x, y, z)
-- end

-- Map.IsHamRoomWallAtPoint = function(self, x, y, z)
--     return IsHamRoomWallAtPoint(x, y, z)
-- end


-- local old_IsPassableAtPoint = Map.IsPassableAtPoint
-- Map.IsPassableAtPoint = function(self, x, y, z, ...)
--     return old_IsPassableAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
-- end

-- --在该点处是否可见
-- local old_IsVisualGroundAtPoint = Map.IsVisualGroundAtPoint
-- Map.IsVisualGroundAtPoint = function(self, x, y, z, ...)
--     return old_IsVisualGroundAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
-- end
-- --是否在地面上
-- local old_IsAboveGroundAtPoint = Map.IsAboveGroundAtPoint
-- Map.IsAboveGroundAtPoint = function(self, x, y, z, ...)
--     return old_IsAboveGroundAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
-- end

-- -- --能不能种植物---
-- local old_CanPlantAtPoint = Map.CanPlantAtPoint
-- Map.CanPlantAtPoint = function(self, x, y, z, ...)
--     return old_CanPlantAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
-- end

-- -- --能不能产生耕地堆
-- local old_CanTillSoilAtPoint = Map.CanTillSoilAtPoint
-- Map.CanTillSoilAtPoint = function(self, x, y, z, ignore_tile_type, ...)
--     if IsHamRoomAtPoint(x, y, z) then
--         return old_CanTillSoilAtPoint(self, x, y, z, true, ...)
--     else
--         return old_CanTillSoilAtPoint(self, x, y, z, ignore_tile_type, ...)
--     end
-- end

-- local old_CanDeployRecipeAtPoint = Map.CanDeployRecipeAtPoint

-- Map.CanDeployRecipeAtPoint = function(self, pt, recipe, rot)
--     if recipe.build_mode == "wallsection" then
--         local pt_x, pt_y, pt_z = pt:Get()
--         return IsHamRoomWallAtPoint(pt_x, pt_y, pt_z)
--     else
--         return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
--     end
-- end


-------------------地图判定（新）------------------------------------

-- local worldwidth, worldheight = TheWorld.Map:GetWorldSize()
local check_size = 1350
local function checkxz(x, z)
    if math.abs(z) >= check_size or math.abs(x) >= check_size then
        return true
    else
        return false
    end
end

-------------------来自于猪人部落-------------
local HamHome = {}     --室内的中心坐标，由于地皮一定在中心
local DIS = 28         --室内的最大半径
local lastHamHome = {} --缓冲，短时间内在一个房间附近求值的可能性较大
local roomsize = TUNING.HAMROOM.roomsize
local roomtype = TUNING.HAMROOM.roomtype
-- 室内可放置建筑，物品不会掉入“水”中

local function CheckNearRoomCenter(x, z, v, checkwall)
    if checkxz(x, z) then -----判断一下以减少运算
        local rsize = roomsize[roomtype[v.prefab] or "small"]
        local xx, yy, zz = v.Transform:GetWorldPosition()

        if not checkwall then
            if ((x - xx) <= rsize.front and (x - xx) >= -rsize.back and math.abs(z - zz) <= rsize.side) then
                return true
            end
        else
            if (x - xx) < -(rsize.back - 0.5) and (x - xx) > -(rsize.back + 0.5) and math.abs(z - zz) <= (rsize.side - 2) then ---11
                return "back"
            elseif (z - zz) > (rsize.side - 0.5) and (z - zz) < (rsize.side + 0.5) and (x - xx) <= (rsize.front - 1) and (x - xx) >= -(rsize.back - 1) then
                return "right"
            elseif (zz - z) > (rsize.side - 0.5) and (zz - z) < (rsize.side + 0.5) and (x - xx) <= (rsize.front - 1) and (x - xx) >= -(rsize.back - 1) then
                return "left"
            end
        end
    end

    return false
end

local function IsHamRoomAtPoint(x, y, z, checkwall)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    if checkxz(x, z) then --判断的基础，也许光判断z就行了
        -- 缓存
        if lastHamHome.home then
            if lastHamHome.home:IsValid() then
                local isroom = CheckNearRoomCenter(x, z, lastHamHome.home, checkwall)
                if isroom
                --[[VecUtil_DistSq(lastHamHome.pos[1], lastHamHome.pos[2], x, z) < DIS_SQ]] then
                    return isroom
                end
            else
                lastHamHome.home = nil
                lastHamHome.pos = nil
            end
        end

        -- 缓存表
        for ent, pos in pairs(HamHome) do
            if ent:IsValid() then
                -- print(x, z, pos[1], pos[2], VecUtil_DistSq(pos[1], pos[2], x, z))
                local isroom = CheckNearRoomCenter(x, z, ent, checkwall)
                if isroom
                --[[VecUtil_DistSq(pos[1], pos[2], x, z) < DIS_SQ]] then
                    lastHamHome.home = ent
                    lastHamHome.pos = pos
                    return isroom
                end
            else
                HamHome[ent] = nil
            end
        end

        -- 查找
        local ents = TheSim:FindEntities(x, 0, z, DIS, { "interior_center" }) --查找地板
        if #ents > 0 then
            for _, ent in ipairs(ents) do
                if ent:IsValid() then
                    local ex, _, ez = ent.Transform:GetWorldPosition()
                    HamHome[ent] = { ex, ez }
                    local isroom = CheckNearRoomCenter(x, z, ent, checkwall)
                    if isroom then
                        lastHamHome.home = ent
                        lastHamHome.pos = { ex, ez }
                        return isroom
                    end
                end
            end
        end
    end
    return false
end

-----------新的Map函数---------------
Map.IsHamRoomAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z, false)
end

Map.IsHamRoomWallAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z, true) --true则检查墙点
end

Map.OutsideWorldAtPoint = function(x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    if checkxz(x, z) then --判断的基础，也许光判断z就行了
        return true
    end
    return false
end





----------房间-----------------
local function CheckHamRoomBefore(self, x, y, z)
    local isroom = IsHamRoomAtPoint(x, y, z, false)

    if isroom == true then
        return { true }, true
    end
end


local function GetHamHomeBefore(self, x, y, z, extra_radius) ----yz乱用的后果
    local isroom = IsHamRoomAtPoint(x, y, z or y, false)
    if isroom == true then
        return { lastHamHome.home }, true
    end
end


---------放置检查---------------------限制制作的配方-----------------------
local banrecipe = { "playerhouse_city", "pighouse_city", "city_lamp", "pig_guard_tower", "pig_guard_tower_palace",
    "pugaliskfountain_made",
    "hua_player_house_recipe",
    "homesign", "townportal", "telebase", "hua_player_house1_recipe",
    "hua_player_house_pvz_recipe", "hua_player_house_tardis_recipe", "infantree_carpet", "myth_house_bamboo"

}

-- local function isbanned(name, banrecipe)
--     for i, v in ipairs(banrecipe) do
--         if name == v then
--             return true
--         end
--     end
-- end

local function CheckHamRoomBeforeDeploy(self, pt, recipe, rot)
    if recipe.build_mode == "insidedoor" then
        local pt_x, pt_y, pt_z = pt:Get()
        local isbackwall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if isbackwall ~= "back" then
            return { false }, true
        end
    elseif recipe.build_mode == "wallsection" then
        local pt_x, pt_y, pt_z = pt:Get()
        local iswall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if not iswall then
            return { false }, true
        end
    elseif tableutil.has_component(banrecipe, recipe.name) or string.find(recipe.name, "pig_shop") then
        local pt_x, pt_y, pt_z = pt:Get()
        local isroom = IsHamRoomAtPoint(pt_x, pt_y, pt_z, false)
        if isroom then
            return { false }, true
        end
    end
end


-----------地皮中心点----------------
local function GetHamTileCenterPointBefore(self, x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    if z and checkxz(x, z) then
        return { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }, true
    end
end




---------- 根据components/deployable.lua判断需要覆盖的方法
Utils.FnDecorator(Map, "IsAboveGroundAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "IsPassableAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "IsVisualGroundAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "CanPlantAtPoint", CheckHamRoomBefore)             --允许房间里种植，不知道算不算超模
-- Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", CheckHamRoomBeforeDeploy) -------检查放置
Utils.FnDecorator(Map, "GetTileCenterPoint", GetHamTileCenterPointBefore) -------地皮中心
-- Utils.FnDecorator(Map, "GetPlatformAtPoint", GetHamHomeBefore)             -------platform



local old_CanDeployRecipeAtPoint = Map.CanDeployRecipeAtPoint
Map.CanDeployRecipeAtPoint = function(self, pt, recipe, rot)
    if recipe.build_mode == "insidedoor" then
        local pt_x, pt_y, pt_z = pt:Get()
        local isbackwall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if isbackwall == "back" then
            return true
        else
            return false
        end
    elseif recipe.build_mode == "wallsection" then
        local pt_x, pt_y, pt_z = pt:Get()
        local iswall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if iswall then
            return true
        else
            return false
        end
    elseif tableutil.has_component(banrecipe, recipe.name) or string.find(recipe.name, "pig_shop") then
        local pt_x, pt_y, pt_z = pt:Get()
        local isroom = IsHamRoomAtPoint(pt_x, pt_y, pt_z, false)
        if isroom then
            return false
        else
            return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
        end
    else
        return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
    end
end
