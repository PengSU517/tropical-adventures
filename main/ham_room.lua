GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end }) --GLOBAL 相关照抄

local Utils = require("tools/utils")



--------------rpc用来接收建筑高度数据-------也可以修改placer
TUNING.BUILD_HEIGHT = 0
AddModRPCHandler("ham_room", "build_height", function(player, height)
    TUNING.BUILD_HEIGHT = height
    -- print("!!!!!!!!!!!!" .. TUNING.BUILD_HEIGHT)
end)

local roomtype = {
    playerhouse_city_floor = "large",
    pig_palace_floor = "xlarge",
    vampirebatcave_floor = "cave",
    roc_cave_floor = "cave",
    pig_shop_florist_floor = "small",
    pig_palace_gallery_floor = "big", ----------这两个啥都不合适
    pig_palace_shop_floor = "medium",
}


local roomcamera = {
    small = { pitch = 36, distance = 20, pos = -1 },
    medium = { pitch = 35, distance = 24, pos = -2 },
    big = { pitch = 35, distance = 27, pos = -1 },
    large = { pitch = 36, distance = 27, pos = -2.5 },
    cave = { pitch = 36, distance = 31, pos = 0 },
    xlarge = { pitch = 36, distance = 38, pos = -2 },


}

local roomsize = {
    small = { back = 2, front = 8, side = 7.5 },
    medium = { back = 2, front = 8, side = 7.5 },
    big = { back = 2, front = 8, side = 7.5 },
    large = { back = 5, front = 8, side = 11.5 },
    cave = { back = 5, front = 13, side = 13 },
    xlarge = { back = 6, front = 16, side = 13 },
}



---------------------调整摄像头----------------------------
---------在室内切换角色会黑屏------------
local extra_distance = 0

AddClassPostConstruct("cameras/followcamera", function(self)
    local Old_Apply = self.Apply
    function self:Apply()
        if self.inhamroom == true and self.hamroompos ~= nil then
            ----视角调整
            if TheInput:IsKeyDown(KEY_EQUALS) then
                extra_distance = extra_distance + 0.05
            elseif TheInput:IsKeyDown(KEY_MINUS) then
                extra_distance = extra_distance - 0.05
            end

            extra_distance = math.min(math.max(extra_distance, -5), 5)

            self.headingtarget = 0
            local cameraset = roomcamera[self.roomtype or "small"]
            local pitch = cameraset.pitch * DEGREES
            local heading = 0
            local distance = cameraset.distance


            distance = distance + extra_distance


            local currentpos = Vector3(self.hamroompos:Get()) + Vector3(cameraset.pos, 0, 0)
            local fov = 35
            local currentscreenxoffset = 0
            local cos_pitch = math.cos(pitch)
            local cos_heading = math.cos(heading)
            local sin_heading = math.sin(heading)
            local dx = -cos_pitch * cos_heading
            local dy = -math.sin(pitch)
            local dz = -cos_pitch * sin_heading
            local xoffs, zoffs = 0, 0
            if self.shake ~= nil then
                local shakeOffset = self.shake:Update(FRAMES)
                if shakeOffset ~= nil then
                    local rightOffset = self:GetRightVec() * shakeOffset.x
                    currentpos.x = currentpos.x + rightOffset.x
                    currentpos.y = currentpos.y + rightOffset.y + shakeOffset.y
                    currentpos.z = currentpos.z + rightOffset.z
                else
                    self.shake = nil
                end
            end
            if currentscreenxoffset ~= 0 then
                local hoffs = 2 * currentscreenxoffset / RESOLUTION_Y
                local magic_number = 1.03
                local screen_heights = math.tan(fov * .5 * DEGREES) * distance * magic_number
                xoffs = -hoffs * sin_heading * screen_heights
                zoffs = hoffs * cos_heading * screen_heights
            end

            TheSim:SetCameraPos(
                currentpos.x - dx * distance + xoffs,
                currentpos.y - dy * distance,
                currentpos.z - dz * distance + zoffs
            )
            TheSim:SetCameraDir(dx, dy, dz)

            local right = (heading + 90) * DEGREES
            local rx = math.cos(right)
            local ry = 0
            local rz = math.sin(right)

            local ux = dy * rz - dz * ry
            local uy = dz * rx - dx * rz
            local uz = dx * ry - dy * rx

            TheSim:SetCameraUp(ux, uy, uz)
            TheSim:SetCameraFOV(fov)
            local listendist = -.1 * distance
            TheSim:SetListener(
                dx * listendist + currentpos.x,
                dy * listendist + currentpos.y,
                dz * listendist + currentpos.z,
                dx, dy, dz,
                ux, uy, uz
            )
        else
            Old_Apply(self)
        end
    end
end)


local function OnFocalFocusDirty(inst)
    if ThePlayer ~= nil and inst == ThePlayer then
        if inst._inhamroomcamea:value() ~= nil then
            local ent = inst._inhamroomcamea:value()
            TheCamera.inhamroom = true
            local x1, y1, z1 = ent.Transform:GetWorldPosition()

            TheCamera.roomtype = roomtype[ent.prefab] or "small"
            TheCamera.hamroompos = Vector3(x1 + 2, 0, z1)
        else
            TheCamera.inhamroom = false
            TheCamera.hamroompos = nil
            TheCamera.roomtype = "small"
        end
        if inst.components.playervision then
            inst.components.playervision:UpdateCCTable()
        end
    end
end

--Load
local function OnFocusCamera(inst)
    if inst.spawnanddelete_hamroom then ---------------------------额个东西是啥
        return
    end
    local ent = FindEntity(inst, 30, nil, { "blows_air" })
    if ent then
        if inst._inhamroomcamea:value() ~= ent then
            inst._inhamroomcamea:set(ent)
        end
    elseif inst._inhamroomcamea:value() ~= nil then
        inst._inhamroomcamea:set(nil)
    end
end
--
AddPlayerPostInit(function(inst)
    --房子的net
    inst._inhamroomcamea = net_entity(inst.GUID, "_inhamroomcamea", "inhamroomcameadirty")


    if TheWorld.ismastersim then
        inst:DoPeriodicTask(0.2, OnFocusCamera, 0.2)
    end

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("inhamroomcameadirty", OnFocalFocusDirty)
    end
end)











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
--         local entities = TheSim:FindEntities(x, y, z, 20, { "blows_air" })
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
--         local entities = TheSim:FindEntities(x, y, z, 20, { "blows_air" })
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

local check_size = 1350
local function checkxz(x, z)
    if math.abs(z) >= check_size or math.abs(x) >= check_size then
        return true
    else
        return false
    end
    -- return true
end

-------------------来自于猪人部落-------------
require "components/map"
local HamHome = {}     --室内的中心坐标，由于地皮一定在中心
local DIS = 28         --室内的最大半径
local lastHamHome = {} --缓冲，短时间内在一个房间附近求值的可能性较大
-- 室内可放置建筑，物品不会掉入“水”中

local function IsInHamRoom(x, z, v, checkwall)
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
                local isroom = IsInHamRoom(x, z, lastHamHome.home, checkwall)
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
                local isroom = IsInHamRoom(x, z, ent, checkwall)
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
        local ents = TheSim:FindEntities(x, 0, z, DIS, { "blows_air" }) --查找地板
        if #ents > 0 then
            for _, ent in ipairs(ents) do
                if ent:IsValid() then
                    local ex, _, ez = ent.Transform:GetWorldPosition()
                    HamHome[ent] = { ex, ez }
                    local isroom = IsInHamRoom(x, z, ent, checkwall)
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

local function IsOutsideWorldAtPoint(x, y, z)
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
    elseif tabel.has_component(banrecipe, recipe.name) or string.find(recipe.name, "pig_shop") then
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


-----------新的Map函数---------------
Map.IsHamRoomAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z)
end

Map.IsHamRoomWallAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z, true) --true则检查墙点
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
    elseif tabel.has_component(banrecipe, recipe.name) or string.find(recipe.name, "pig_shop") then
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


-----------进出房间动作--------
local Oldstrfnjumpin = ACTIONS.JUMPIN.strfn
GLOBAL.ACTIONS.JUMPIN.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("hamletteleport") then
        return "HAMLET"
    end
    return Oldstrfnjumpin(act)
end


--------------------------------------------------------------------------------------------
----------------------------------[[ entityscript ]]----------------------------------------
--------------------------------------------------------------------------------------------
require("entityscript")
--实体是否在虚空的房间里面
function EntityScript:IsInHamRoom()
    return TheWorld.Map:IsHamRoomAtPoint(self:GetPosition():Get()) --------------------似乎不太对
end

--推入事件
local _PushEvent = EntityScript.PushEvent
function EntityScript:PushEvent(event, data)
    if not self.eventmuted or not self.eventmuted[event] then                    --没有静默
        _PushEvent(self, event, data)
        if self.eventlistening_shared and self.eventlistening_shared[event] then --是否分享
            local parent = self.entity:GetParent()
            if parent and parent:IsValid() then
                parent:PushEvent(event, data)
            end
        end
    end
end

--事件监听静默
function EntityScript:SetEventMute(event, muted)
    if self.eventmuted == nil then
        self.eventmuted = {}
    end
    -- print(event)
    self.eventmuted[event] = muted and true or nil
end

--事件监听共享--会同时分享给上一级
function EntityScript:SetEventShare(event, shared)
    if self.eventlistening_shared == nil then
        self.eventlistening_shared = {}
    end
    self.eventlistening_shared[event] = shared and true or nil
end

--------------------------------------------------------------------------------------------
----------------------------------[[ 相关物品hook ]]-----------------------------------------
--------------------------------------------------------------------------------------------
local old_CanEntitySeePoint = GLOBAL.CanEntitySeePoint
GLOBAL.CanEntitySeePoint = function(inst, ...)
    return old_CanEntitySeePoint(inst, ...) or inst:IsInHamRoom()
end

local old_CanEntitySeeInDark = GLOBAL.CanEntitySeeInDark
GLOBAL.CanEntitySeeInDark = function(inst)
    return old_CanEntitySeeInDark(inst) or inst:IsInHamRoom()
end


--限制制作的配方
-- local banrecipe = { "hua_player_house_recipe", "homesign", "townportal", "telebase", "hua_player_house1_recipe",
--     "hua_player_house_pvz_recipe", "hua_player_house_tardis_recipe", "infantree_carpet", "myth_house_bamboo",
--     "playerhouse_city"
-- }
-- for i, v in ipairs(banrecipe) do
--     local recipe = AllRecipes[v]
--     if recipe then
--         local old = recipe.testfn or nil
--         recipe.testfn = function(pt, rot, ...)
--             if IsHamRoomAtPoint(pt.x, 0, pt.z) then
--                 return false
--             end
--             if old ~= nil then
--                 return old(pt, rot, ...)
--             end
--             return true
--         end
--     end
-- end

-----------以下来自猪人部落-------------
-- local StopAmbientRainSound, StopTreeRainSound, StopUmbrellaRainSound, StopBarrierSound
-- local _rainfx, _snowfx, _lunarhailfx
-- local function WeatherClientOnUpdateBefore()
--     if not ThePlayer or TheWorld.ismastersim then return end

--     -- 只在客机执行，这里只改本地玩家视觉效果，实际效果在其他地方修改
--     local x, _, z = ThePlayer.Transform:GetWorldPosition()
--     if checkxz(x, z) then
--         if StopAmbientRainSound then
--             StopAmbientRainSound()
--         end
--         if StopTreeRainSound then
--             StopTreeRainSound()
--         end
--         if StopUmbrellaRainSound then
--             StopUmbrellaRainSound()
--         end
--         if StopBarrierSound then
--             StopBarrierSound()
--         end

--         if _rainfx then
--             _rainfx.particles_per_tick = 0
--             _rainfx.splashes_per_tick = 0
--         end
--         if _lunarhailfx then
--             _lunarhailfx.particles_per_tick = 0
--             _lunarhailfx.splashes_per_tick = 0
--         end
--         if _snowfx then
--             _snowfx.particles_per_tick = 0
--         end

--         return nil, true
--     end
-- end

-- AddClassPostConstruct("components/weather", function(self)
--     if not TheWorld.ismastersim then
--         StopAmbientRainSound = Utils.ChainFindUpvalue(self.OnUpdate, "StopAmbientRainSound")
--         StopTreeRainSound = Utils.ChainFindUpvalue(self.OnUpdate, "StopTreeRainSound")
--         StopUmbrellaRainSound = Utils.ChainFindUpvalue(self.OnUpdate, "StopUmbrellaRainSound")
--         StopBarrierSound = Utils.ChainFindUpvalue(self.OnUpdate, "StopBarrierSound")

--         _rainfx = Utils.ChainFindUpvalue(self.OnPostInit, "_rainfx")
--         _snowfx = Utils.ChainFindUpvalue(self.OnPostInit, "_snowfx")
--         _lunarhailfx = Utils.ChainFindUpvalue(self.OnPostInit, "_lunarhailfx")
--         -- _pollenfx = Utils.ChainFindUpvalue(self.OnPostInit, "_pollenfx") --应该不用管这个特效

--         Utils.FnDecorator(self, "OnUpdate", WeatherClientOnUpdateBefore)
--         self.LongUpdate = self.OnUpdate
--     end
-- end)


--懒得找防寒隔热的组件了，直接覆盖onupdate更省事
local function OnTemperatureUpdateBefore(self)
    if self.inst:IsInHamRoom() then
        local cur = self:GetCurrent()
        if cur > 30 then
            self:SetTemperature(self.current - 0.1)
        elseif cur < 20 then
            self:SetTemperature(self.current + 0.1)
        end

        return nil, true
    end
end

local function OnMoistureUpdateBefore(self)
    if self.inst:IsInHamRoom() then
        if self.moisture > 0 then
            self:DoDelta(-0.1)
        end
        return nil, true
    end
end

-- PlayFootstep函数使用，我需要玩家在室内走路时有声音，但是因为没有地皮，只能覆盖函数，这里使用木板地皮的声音
local function GetCurrentTileTypeBefore(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if checkxz(x, z) then
        return { WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR) }, true
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    Utils.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    -- Utils.FnDecorator(inst.components.moisture, "OnUpdate", OnMoistureUpdateBefore)
    Utils.FnDecorator(inst, "GetCurrentTileType", GetCurrentTileTypeBefore)
end)



--以下大部分来自花花的神话方寸山
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("getposition_hamroom")
end)

AddPrefabPostInit("dirtpile", function(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(0, function(...)
            if inst:IsInHamRoom() then
                inst:Remove()
            end
        end)
    end
end)


---------spidereggsack
local _custom_candeploy_fn = function(inst, pt, mouseover, deployer, rot)
    local x, y, z = pt:Get()
    local judge = TheWorld.Map:CanDeployAtPoint(pt, inst, mouseover)
    if judge and not inst:IsInHamRoom() then
        return true
    end
    return false
end

AddPrefabPostInit("spidereggsack", function(inst)
    if TheWorld.ismastersim then
        inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
        inst._custom_candeploy_fn = _custom_candeploy_fn
    end
end)

local monster = { "hound", "firehound", "icehound", "moonhound", "mutatedhound", "warg",
    "warglet", "lunarthrall_plant", "vampirebat", "crawlinghorror", "terrorbeak", "gestalt", "moonglass",
    "moonglass_charged", "warningshadow" }
for i, v in ipairs(monster) do --
    AddPrefabPostInit(v, function(inst)
        if TheWorld.ismastersim then
            inst:DoTaskInTime(0, function(...)
                if inst:IsInHamRoom() then
                    inst:Remove()
                end
            end)
        end
    end)
end
AddPrefabPostInit("telestaff", function(inst)
    if inst.components.spellcaster then
        local old = inst.components.spellcaster.CastSpell
        inst.components.spellcaster.CastSpell = function(self, target, pos, ...)
            local caster = inst.components.inventoryitem.owner or target
            if caster and caster:IsInHamRoom() then
                if TheWorld:HasTag("cave") then --------检查是地上还是地下世界
                    TheWorld:PushEvent("ms_miniquake", { rad = 3, num = 5, duration = 1.5, target = inst })
                else
                    SpawnPrefab("thunder_close")
                end
                if inst.components.finiteuses ~= nil then
                    inst.components.finiteuses:Use(1)
                end
                return
            end
            return old(self, target, pos, ...)
        end
    end
end)

--陷坑
AddComponentPostInit("sinkholespawner", function(self, inst)
    local old_SpawnSinkhole = self.SpawnSinkhole
    self.SpawnSinkhole = function(self, spawnpt, ...)
        if TheWorld.Map:IsHamRoomAtPoint(spawnpt.x, 0, spawnpt.z) then
            return false
        else
            old_SpawnSinkhole(self, spawnpt, ...)
        end
    end
end) --farming_manager




--farming_manager
-- AddComponentPostInit("farming_manager", function(self, inst)
--     if not TheWorld.ismastersim then
--         return
--     end
--     local old_GetTileNutrients = self.GetTileNutrients
--     self.GetTileNutrients = function(self, x, y, ...)
--         if NU_GARDEN_TILES[tostring(x) .. "_" .. tostring(y)] then
--             return 100, 100, 100
--         end
--         return old_GetTileNutrients(self, x, y, ...)
--     end
-- end) --farmplantstress


-- AddComponentPostInit("farmplantstress", function(self, inst)
--     if not TheWorld.ismastersim then
--         return
--     end
--     --[[
--                 self.final_stress_state = stress <= 1 and FARM_PLANT_STRESS.NONE		-- allow one mistake
--                                 or stress <= 6 and FARM_PLANT_STRESS.LOW		-- one and half categories can fail, take your pick
--                                 or stress <= 11 and FARM_PLANT_STRESS.MODERATE  -- almost 3 categories can fail
--                                 or FARM_PLANT_STRESS.HIGH	
--         ]]
--     local old_CalcFinalStressState = self.CalcFinalStressState
--     self.CalcFinalStressState = function(...)
--         if self.inst:IsInHamRoom() then
--             if TUNING.FARM_BM == 100 then
--                 self.stress_points = 0
--                 self.final_stress_state = GLOBAL.FARM_PLANT_STRESS.NONE
--             else
--                 self.stress_points = math.max(self.stress_points - TUNING.FARM_BM, 0)
--             end
--         end
--         old_CalcFinalStressState(...)
--     end
-- end)



--落石--warningshadow---警告阴影
AddPrefabPostInit("cavein_boulder", function(inst)
    inst:ListenForEvent("startfalling", function(inst)
        if inst:IsInHamRoom() then
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("cavein_debris") ---落石的警告
            fx.Transform:SetScale(1, 0.25 + math.random() * 0.07, 1)
            fx.Transform:SetPosition(x, 0, z)

            if inst:HasTag("FX") then
                inst:Hide()
            else
                inst:Remove()
            end
        end
    end)
end)


AddPrefabPostInit("farm_plow_item", function(inst)
    local old = inst._custom_candeploy_fn
    if old then
        inst._custom_candeploy_fn = function(...)
            if inst:IsInHamRoom() then
                return false
            else
                return old(...)
            end
        end
    end
end)


-- AddPrefabPostInit("deciduoustree", function(inst)
--     local old_load=inst.OnLoad or function (...) return end
--     inst.OnLoad=function (inst,...)
--         old_load(inst,...)
--         if inst and inst.components.growable and inst:IsInHamRoom() then
--             inst.components.growable:SetStage(3)
--         end
--     end
-- end)
--tall
--        inst.components.growable:SetStage(stage == 0 and math.random(1, 3) or stage)


--潮湿度--干燥
-- if TUNING.WATER_BM then
AddComponentPostInit("moisture", function(self) --房子里面不会降雨
    local old = self.GetMoistureRate
    function self:GetMoistureRate()
        if self.inst:IsInHamRoom() then
            return 0
        end
        return old(self)
    end
end)
-- end


--如果在区域内就更新滤镜  ------------滤镜似乎没有效果
AddComponentPostInit("areaaware", function(self)
    local old = self.UpdatePosition
    function self:UpdatePosition(x, y, z, ...)
        if TheWorld.Map:IsHamRoomAtPoint(x, 0, z) then
            if self.current_area_data ~= nil then
                self.current_area = -1
                self.current_area_data = nil
                self.inst:PushEvent("changearea", self:GetCurrentArea())
            end
            return
        end
        return old(self, x, y, z, ...)
    end
end)


-- --这个地方应该渺无鸟烟

AddComponentPostInit("birdspawner", function(self)
    local old_GetSpawnPoint = self.GetSpawnPoint
    function self:GetSpawnPoint(pt)
        if TheWorld.Map:IsHamRoomAtPoint(pt:Get()) then
            return nil
        end
        return old_GetSpawnPoint(self, pt)
    end
end)



--清除积雪覆盖效果
local Old_MakeSnowCovered = GLOBAL.MakeSnowCovered
local function ClearSnowCoveredPristine(inst)
    inst.AnimState:ClearOverrideSymbol("snow", "snow", "snow")
    inst:RemoveTag("SnowCovered")
    inst.AnimState:Hide("snow")
end
GLOBAL.MakeSnowCovered = function(inst, ...)
    Old_MakeSnowCovered(inst, ...)
    inst:DoTaskInTime(0, function()
        if inst.Transform ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsHamRoomAtPoint(x, y, z) then
                ClearSnowCoveredPristine(inst)
            end
        end
    end)
end


--是否枯萎
AddComponentPostInit("witherable", function(self)
    if self.inst then
        self.inst:DoTaskInTime(0.1, function(crop)
            local x, y, z = crop.Transform:GetWorldPosition()
            if TheWorld.Map:IsHamRoomAtPoint(x, y, z) then
                self:Enable(false)
                -- print("是否枯萎",crop.prefab)
            end
        end)
    end
end)

--是否睡觉
-- AddComponentPostInit("sleeper", function(self)
--     local old_GoToSleep = self.GoToSleep
--     self.GoToSleep = function(...)
--         if self.inst:IsInHamRoom() then
--             return
--         else
--             old_GoToSleep(...)
--         end
--     end
-- end)



local upvaluehelper = require("tools/upvaluehelper")
AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    --青蛙雨
    local frograin = upvaluehelper.GetWorldHandle(inst, "israining", "components/frograin") --下雨
    if frograin then
        -- print("找到青蛙雨了")
        local GetSpawnPoint = upvaluehelper.Get(frograin, "GetSpawnPoint")
        if GetSpawnPoint ~= nil then
            local old = GetSpawnPoint
            local function newGetSpawnPoint(pt)
                if TheWorld.Map:IsHamRoomAtPoint(pt:Get()) then
                    -- print("成功")
                    return nil
                end
                return old(pt)
            end
            upvaluehelper.Set(frograin, "GetSpawnPoint", newGetSpawnPoint)
        end
    end

    --玻璃雨
    local lunarrain = upvaluehelper.GetWorldHandle(inst, "islunarhailing", "components/lunarhailmanager") --下雨

    if lunarrain then
        -- print("找到玻璃雨了")
        local GetSpawnPoint = upvaluehelper.Get(lunarrain, "GetSpawnPoint")
        if GetSpawnPoint ~= nil then
            local old = GetSpawnPoint
            local function newGetSpawnPoint(pt)
                if TheWorld.Map:IsHamRoomAtPoint(pt:Get()) then
                    -- print("成功玻璃雨")
                    return nil
                end
                return old(pt)
            end
            upvaluehelper.Set(lunarrain, "GetSpawnPoint", newGetSpawnPoint)
        end
    end

    local wildfires = upvaluehelper.GetEventHandle(TheWorld, "ms_lightwildfireforplayer", "components/wildfires") --野火
    if wildfires then
        local LightFireForPlayer = upvaluehelper.Get(wildfires, "LightFireForPlayer")
        if LightFireForPlayer ~= nil then
            local old = LightFireForPlayer
            local function NewLightFireForPlayer(player, rescheduleFn)
                if player ~= nil then
                    local x, y, z = player.Transform:GetWorldPosition()
                    if TheWorld.Map:IsHamRoomAtPoint(x, y, z) then
                        return
                    end
                end
                old(player, rescheduleFn)
            end
            upvaluehelper.Set(wildfires, "LightFireForPlayer", NewLightFireForPlayer)
        end
    end
end)


AddPrefabPostInit("player_classified", function(inst)
    -- if not TheWorld.ismastersim then
    -- 	return
    -- end
    inst:DoTaskInTime(0.1, function()
        local play_theme_music = upvaluehelper.GetEventHandle(inst, "play_theme_music")
        if play_theme_music ~= nil then
            inst:RemoveEventCallback("play_theme_music", play_theme_music)
            -- inst.entity:GetParent():RemoveEventCallback("play_theme_music",play_theme_music)
            local function new_play_theme_music(parent, data)
                if parent and parent:IsInHamRoom() then
                    return
                end
                if parent and TheWorld.Map:IsHamRoomAtPoint(parent.Transform:GetWorldPosition()) then
                    return
                end
                -- print("没有屏蔽")
                play_theme_music(parent, data)
            end
            inst:ListenForEvent("play_theme_music", new_play_theme_music, inst.entity:GetParent())
            -- inst.entity:GetParent()
        end
    end)
end)

--消除雨雪
local old_update = { rain = nil, caverain = nil, snow = nil }
local emitters = GLOBAL.EmitterManager --发射器
local oldPostUpdate = emitters.PostUpdate or nil

function emitters:PostUpdate(...)
    for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
        if ( --[[inst.prefab == "rain" or]]
                inst.prefab == "caverain" or
                inst.prefab == "caveacidrain" or
                inst.prefab == "snow" or
                inst.prefab == "pollen" or
                inst.prefab == "lunarhail") and
            data.updateFunc ~= nil then
            if old_update[inst] == nil then
                old_update[inst] = data.updateFunc
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsHamRoomAtPoint(x, y, z) then
                data.updateFunc = function(...) end
            else
                data.updateFunc = old_update[inst]
            end
        end
        -- if TUNING.WATER_BM then
        if inst.prefab == "rain" and data.updateFunc ~= nil then
            if old_update[inst] == nil then
                old_update[inst] = data.updateFunc
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsHamRoomAtPoint(x, y, z) then
                data.updateFunc = function(...) end
            else
                data.updateFunc = old_update[inst]
            end
        end
        -- end
    end
    if oldPostUpdate ~= nil then
        oldPostUpdate(emitters, ...)
    end
end

--脚步声音
-- local Old_PlayFootstep = GLOBAL.PlayFootstep
-- GLOBAL.PlayFootstep = function(inst, volume, ispredicted, ...)
--     if inst:IsInHamRoom() then
--         local sound = inst.SoundEmitter
--         if sound ~= nil then
--             sound:PlaySound(
--                 inst.sg ~= nil and inst.sg:HasStateTag("running") and "dontstarve/movement/run_woods" or
--                 "dontstarve/movement/walk_woods"
--                 ..
--                 ((inst:HasTag("smallcreature") and "_small") or
--                     (inst:HasTag("largecreature") and "_large" or "")
--                 ),
--                 nil,
--                 volume or 1,
--                 ispredicted
--             )
--         end
--     else
--         Old_PlayFootstep(inst, volume, ispredicted, ...)
--     end
-- end



------------------------------------------------------------------------------更改相关生物的大脑
--猪在小房子里面不回家
-- local function MakePigsNotGoHome(brain)
--     local flag = 0
--     for i, node in ipairs(brain.bt.root.children) do
--         if node.name == "Parallel" and node.children[1].name == "IsDay" then
--             node.children[1].fn = function() return TheWorld.state.isday or brain.inst:IsInHamRoom() end
--             flag = flag + 1
--         elseif node.name == "Parallel" and node.children[1].name == "IsNight" then
--             node.children[1].fn = function() return not TheWorld.state.isday and not brain.inst:IsInHamRoom() end
--             flag = flag + 1
--         end
--         if flag >= 2 then break end
--     end
-- end

-- AddBrainPostInit("pigbrain", MakePigsNotGoHome)


--蜜蜂晚上和冬天依然工作
-- local function MakeBeesNotGoHome(brain)
--     local flag = 0
--     for i, node in ipairs(brain.bt.root.children) do
--         if node.name == "Sequence" and node.children[1].name == "IsWinter" then
--             local old_fn = node.children[1].fn
--             node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInHamRoom() end
--             flag = flag + 1
--         elseif node.name == "Sequence" and node.children[1].name == "IsNight" then
--             local old_fn = node.children[1].fn
--             node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInHamRoom() end
--             flag = flag + 1
--         end
--         if flag >= 2 then break end
--     end
-- end
-- AddBrainPostInit("beebrain", MakeBeesNotGoHome)


--晚上继续产生蝴蝶，蝴蝶不回家
local function MakeButterflyNotGoHome(brain)
    local flag = 0
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Sequence" and (node.children[1].name == "IsNight" or node.children[1].name == "IsFullOfPollen") then
            local old_fn = node.children[1].fn
            node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInHamRoom() end
        end
    end
end
AddBrainPostInit("butterflybrain", MakeButterflyNotGoHome)

-- local function MakePerdNotGoHome(brain)
--     for i, node in ipairs(brain.bt.root.children) do
--         if node.name == "Parallel" and node.children[1].name == "IsNight" then
--             node.children[1].fn = function() return not TheWorld.state.isday and not brain.inst:IsInHamRoom() end
--         end
--     end
-- end

-- AddBrainPostInit("perdbrain", MakePerdNotGoHome)







-- local DEPLOY_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "walkableplatform", "walkableperipheral",
--     "alt_tile", "centerlight", "liberado" }


---------------------------------------------------------------
