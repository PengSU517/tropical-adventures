local Utils = require("tools/utils")
local upvaluehelper = require("tools/upvaluehelper")
require("tools/tile_util")


-----------map related--------------------------
require("components/map")

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

------entity related--------------------------
require("entityscript")

function EntityScript:IsInTropicalArea()
    return TheWorld.Map:IsTropicalAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInShipwreckedArea()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInHamletArea()
    return TheWorld.Map:IsHamletAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInVolcanoArea()
    return TheWorld.Map:IsVolcanoAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsOnLandTile()
    return TheWorld.Map:IsLandTileAtPoint(self.Transform:GetWorldPosition())
end

GLOBAL.IsInTropicalArea = function(inst)
    -- local x, _, z = inst:GetPosition():Get()-----这个东西似乎要等待一帧
    local x, _, z = inst.Transform:GetWorldPosition() ----这个东西也取不到值
    for i, node in ipairs(TheWorld.topology.nodes) do
        if TheSim:WorldPointInPoly(x, z, node.poly) then
            if node.tags ~= nil and table.contains(node.tags, "tropical") then
                return true
            end
        end
    end
    return false
end

GLOBAL.IsInShipwreckedArea = function(inst)
    return inst:IsInShipwreckedArea()
end

GLOBAL.IsInHamletArea = function(inst)
    return inst:IsInHamletArea()
end

GLOBAL.IsInVolcanoArea = function(inst)
    return inst:IsInVolcanoArea()
end

GLOBAL.IsOnLandTile = function(inst)
    return inst:IsOnLandTile()
end







----area aware related--------------------
function EntityScript:AwareInTropicalArea() ----减少计算量
    return self.components.areaaware and
        (self.components.areaaware:CurrentlyInTag("tropical")
            or self.components.areaaware:CurrentlyInTag("ForceDisconnected")) and
        true or false
end

function EntityScript:AwareInShipwreckedArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("shipwrecked") and true
    return aware or false
end

function EntityScript:AwareInHamletArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("hamlet") and true
    return aware or false
end

function EntityScript:AwareInVolcanoArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("volcano") and true
    return aware or false
end

--温度变化更加丝滑
local function OnTemperatureUpdateBefore(self)
    if self.inst:AwareInVolcanoArea() then
        local volcano_tem = 40
        self:SetModifier("volcanoregion", volcano_tem)

        return nil, false
    else
        self:RemoveModifier("volcanoregion")
    end


    if self.inst:AwareInTropicalArea() then
        local tro_tem = math.max(10 - TheWorld.state.temperature, 0) + 5
        self:SetModifier("tropicalregion", tro_tem)
    else
        self:RemoveModifier("tropicalregion")
    end



    return nil, false
end

-- local function GetMoistureRateBefore(self)
--     if TheWorld.state.issnowing and self.inst:AwareInTropicalArea() then
--         return { self:_GetMoistureRateAssumingRain() }, false
--     end
--     return nil, false
-- end



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    Utils.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    -- Utils.FnDecorator(inst.components.weather, "OnUpdate", OnWeatherUpdateAfter)
    -- Utils.FnDecorator(inst.components.moisture, "GetMoistureRate", GetMoistureRateBefore)
end)



local Moisture = require("components/moisture")
function Moisture:GetMoistureRate()
    if not TheWorld.state.israining and not (TheWorld.state.issnowing and self.inst:AwareInTropicalArea()) then
        return -0.005 ---没搞懂为什么冬天不会自然干燥
    end

    return self:_GetMoistureRateAssumingRain()
end

--如果在区域内就更新滤镜  ------------滤镜似乎没有效果
-- AddComponentPostInit("areaaware", function(self)
--     local old = self.UpdatePosition
--     function self:UpdatePosition(x, y, z, ...)
--         if TheWorld.Map:IsTropicalAreaAtPoint(x, 0, z) then
--             if self.current_area_data ~= nil then
--                 self.current_area = -1
--                 self.current_area_data = nil
--                 self.inst:PushEvent("changearea", self:GetCurrentArea())
--             end
--             return
--         end
--         return old(self, x, y, z, ...)
--     end
-- end)



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
            if TheWorld.Map:IsTropicalAreaAtPoint(x, y, z) then
                ClearSnowCoveredPristine(inst)
            end
        end
    end)
end



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
                if TheWorld.Map:IsTropicalAreaAtPoint(pt:Get()) then
                    -- print("成功")
                    return nil
                end
                return old(pt)
            end
            upvaluehelper.Set(frograin, "GetSpawnPoint", newGetSpawnPoint)
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
                    if TheWorld.Map:IsTropicalAreaAtPoint(x, y, z) then
                        return
                    end
                end
                old(player, rescheduleFn)
            end
            upvaluehelper.Set(wildfires, "LightFireForPlayer", NewLightFireForPlayer)
        end
    end
end)



----prefabs 相关修改--
---
---
-- local function OnTransplantfnAfter(retTab, inst)
--     -- checks to turn into Tall Grass if on the right terrain
--     local map = TheWorld.Map
--     local x, y, z = inst.Transform:GetWorldPosition()
--     local tiletype = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

--     if tiletype == GROUND.PLAINS
--         or tiletype == GROUND.RAINFOREST
--         or tiletype == GROUND.DEEPRAINFOREST then
--         local newgrass = SpawnPrefab("grass_tall")
--         newgrass.Transform:SetPosition(x, y, z)
--         if newgrass:HasTag("machetecut") then
--             inst:RemoveTag("machetecut")
--         end
--         newgrass.components.workable:SetWorkAction(ACTIONS.DIG)
--         newgrass.components.workable:SetWorkLeft(1)
--         newgrass.components.timer:StartTimer("spawndelay", 60 * 8 * 4)
--         newgrass.AnimState:PlayAnimation("picked", true)
--         inst:Remove()
--     end
-- end

-- AddPrefabPostInit("grass", function(inst)
--     inst:DoTaskInTime(0, function(...)
--         if not inst:IsOnLandTile() then
--             TheSim:ReskinEntity(inst.GUID, inst.skinname, "grass_water", nil)
--         elseif inst:IsInTropicalArea() then
--             TheSim:ReskinEntity(inst.GUID, inst.skinname, "grass_tropical", nil)
--         end
--     end)
-- end)


-- AddPrefabPostInit("grass", function(inst)
--     inst:DoTaskInTime(0, function(...)
--         if inst:IsInTropicalArea() then
--             inst.AnimState:SetBuild("grassgreen_build")
--             inst.AnimState:PlayAnimation("idle", true)
--         end
--     end)
-- end)


--脚印
AddPrefabPostInit("dirtpile", function(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(0, function(...)
            if inst:IsInTropicalArea() then
                inst:Remove()
            end
        end)
    end
end)



--陷坑
AddComponentPostInit("sinkholespawner", function(self, inst)
    local old_SpawnSinkhole = self.SpawnSinkhole
    self.SpawnSinkhole = function(self, spawnpt, ...)
        if TheWorld.Map:IsTropicalAreaAtPoint(spawnpt.x, 0, spawnpt.z) then
            return false
        else
            old_SpawnSinkhole(self, spawnpt, ...)
        end
    end
end) --farming_manager


-- 用于控制熊大和巨鹿刷新条件，组件没有可以hook的方法，只好通过该方式来阻止生成
local function AreaAwareCurrentlyInTagBefore(self, tag)
    if tag == "nohasslers" and (self:CurrentlyInTag("tropical"))
    then
        return { true }, true
    end
end

AddComponentPostInit("areaaware", function(self)
    Utils.FnDecorator(self, "CurrentlyInTag", AreaAwareCurrentlyInTagBefore)
end)


----毒蜘蛛刷新
for _, prefab in pairs({ "spider_warrior" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0, function(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if IsSwLandTile(ground) then
                    local bolha = SpawnPrefab("spider_tropical")
                    if bolha then
                        bolha.Transform:SetPosition(x, y, z)
                    end
                    inst:Remove()
                end
            end
        end)
    end)
end


----热带蝴蝶和发光飞虫刷新
-- for _, prefab in pairs({ "butterfly" }) do
--     AddPrefabPostInit(prefab, function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end

--         inst:DoTaskInTime(0, function(inst)
--             local map = TheWorld.Map
--             local x, y, z = inst.Transform:GetWorldPosition()
--             if x and y and z then
--                 local butterfly
--                 local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
--                 if IsSwLandTile(ground) then
--                     butterfly = SpawnPrefab("butterfly_tropical")
--                 elseif IsHamLandTile(ground) then
--                     butterfly = SpawnPrefab("glowfly")
--                 end

--                 if butterfly then
--                     -- if butterfly.components.pollinator ~= nil then
--                     --     butterfly.components.pollinator:Pollinate(spawnflower)
--                     -- end
--                     -- if butterfly.components.homeseeker ~= nil then
--                     --     butterfly.components.homeseeker:SetHome(spawnflower)
--                     -- end
--                     butterfly.Transform:SetPosition(x, y, z)
--                     inst:Remove()
--                 end
--             end
--         end)
--     end)
-- end
