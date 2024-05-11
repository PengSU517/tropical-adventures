GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end }) --GLOBAL 相关照抄

local Utils = require("tools/utils")


require "components/map"

local function IsTropicalAtPoint(x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end
    return false
end


Map.IsTropicalAtPoint = function(self, x, y, z)
    return IsTropicalAtPoint(x, y, z)
end


require("entityscript")
--实体是否在虚空的房间里面
function EntityScript:IsInTropical()
    return TheWorld.Map:IsTropicalAtPoint(self:GetPosition():Get())
end

--懒得找防寒隔热的组件了，直接覆盖onupdate更省事
local function OnTemperatureUpdateBefore(self)
    if self.inst:IsInTropical() then
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
    if self.inst:IsInTropical() then
        if self.moisture > 0 then
            self:DoDelta(-0.1)
        end
        return nil, true
    end
end


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    -- Utils.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    -- Utils.FnDecorator(inst.components.moisture, "OnUpdate", OnMoistureUpdateBefore)
end)



--以下大部分来自花花的神话方寸山

---脚印
AddPrefabPostInit("dirtpile", function(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(0, function(...)
            if inst:IsInTropical() then
                inst:Remove()
            end
        end)
    end
end)



--陷坑
AddComponentPostInit("sinkholespawner", function(self, inst)
    local old_SpawnSinkhole = self.SpawnSinkhole
    self.SpawnSinkhole = function(self, spawnpt, ...)
        if TheWorld.Map:IsTropicalAtPoint(spawnpt.x, 0, spawnpt.z) then
            return false
        else
            old_SpawnSinkhole(self, spawnpt, ...)
        end
    end
end) --farming_manager


--如果在区域内就更新滤镜  ------------滤镜似乎没有效果
AddComponentPostInit("areaaware", function(self)
    local old = self.UpdatePosition
    function self:UpdatePosition(x, y, z, ...)
        if TheWorld.Map:IsTropicalAtPoint(x, 0, z) then
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
            if TheWorld.Map:IsTropicalAtPoint(x, y, z) then
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
            if TheWorld.Map:IsTropicalAtPoint(x, y, z) then
                self:Enable(false)
                -- print("是否枯萎",crop.prefab)
            end
        end)
    end
end)


local upvaluehelper = require "upvaluehelper"
AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    --青蛙雨
    local frograin = upvaluehelper.GetWorldHandle(inst, "israining", "components/frograin") --下雨
    if frograin then
        -- print("找到了")
        local GetSpawnPoint = upvaluehelper.Get(frograin, "GetSpawnPoint")
        if GetSpawnPoint ~= nil then
            local old = GetSpawnPoint
            local function newGetSpawnPoint(pt)
                if TheWorld.Map:IsTropicalAtPoint(pt:Get()) then
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
                    if TheWorld.Map:IsTropicalAtPoint(x, y, z) then
                        return
                    end
                end
                old(player, rescheduleFn)
            end
            upvaluehelper.Set(wildfires, "LightFireForPlayer", NewLightFireForPlayer)
        end
    end
end)


-- AddPrefabPostInit("player_classified", function(inst)
--     -- if not TheWorld.ismastersim then
--     -- 	return
--     -- end
--     inst:DoTaskInTime(0.1, function()
--         local play_theme_music = upvaluehelper.GetEventHandle(inst, "play_theme_music")
--         if play_theme_music ~= nil then
--             inst:RemoveEventCallback("play_theme_music", play_theme_music)
--             -- inst.entity:GetParent():RemoveEventCallback("play_theme_music",play_theme_music)
--             local function new_play_theme_music(parent, data)
--                 if parent and parent:IsInTropical() then
--                     return
--                 end
--                 if parent and TheWorld.Map:IsTropicalAtPoint(parent.Transform:GetWorldPosition()) then
--                     return
--                 end
--                 -- print("没有屏蔽")
--                 play_theme_music(parent, data)
--             end
--             inst:ListenForEvent("play_theme_music", new_play_theme_music, inst.entity:GetParent())
--             -- inst.entity:GetParent()
--         end
--     end)
-- end)

--消除雨雪
-- local old_update = { rain = nil, caverain = nil, snow = nil }
-- local emitters = GLOBAL.EmitterManager --发射器
-- local oldPostUpdate = emitters.PostUpdate or nil

-- function emitters:PostUpdate(...)
--     for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
--         if ( --[[inst.prefab == "rain" or]] inst.prefab == "caverain" or inst.prefab == "snow") and data.updateFunc ~= nil then
--             if old_update[inst] == nil then
--                 old_update[inst] = data.updateFunc
--             end
--             local x, y, z = inst.Transform:GetWorldPosition()
--             if TheWorld.Map:IsTropicalAtPoint(x, y, z) then
--                 data.updateFunc = function(...) end
--             else
--                 data.updateFunc = old_update[inst]
--             end
--         end
--         -- if TUNING.WATER_BM then
--         if inst.prefab == "rain" and data.updateFunc ~= nil then
--             if old_update[inst] == nil then
--                 old_update[inst] = data.updateFunc
--             end
--             local x, y, z = inst.Transform:GetWorldPosition()
--             if TheWorld.Map:IsTropicalAtPoint(x, y, z) then
--                 data.updateFunc = function(...) end
--             else
--                 data.updateFunc = old_update[inst]
--             end
--         end
--         -- end
--     end
--     if oldPostUpdate ~= nil then
--         oldPostUpdate(emitters, ...)
--     end
-- end

--蜜蜂晚上和冬天依然工作
-- local function MakeBeesNotGoHome(brain)
--     local flag = 0
--     for i, node in ipairs(brain.bt.root.children) do
--         if node.name == "Sequence" and node.children[1].name == "IsWinter" then
--             local old_fn = node.children[1].fn
--             node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInTropical() end
--             flag = flag + 1
--         elseif node.name == "Sequence" and node.children[1].name == "IsNight" then
--             local old_fn = node.children[1].fn
--             node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInTropical() end
--             flag = flag + 1
--         end
--         if flag >= 2 then break end
--     end
-- end
-- AddBrainPostInit("beebrain", MakeBeesNotGoHome)
