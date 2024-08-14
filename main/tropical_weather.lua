GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end }) --GLOBAL 相关照抄

local Utils = require("tools/utils")
local upvaluehelper = require("tools/upvaluehelper")
require("tools/tile_util")
require("components/map")

local oldfindvisualnodeatpoint = Map.FindVisualNodeAtPoint

Map.FindVisualNodeAtPoint = function(self, x, y, z, has_tag)
    local node, node_index = oldfindvisualnodeatpoint(self, x, y, z, has_tag)
    if node ~= nil then
        return node, node_index
    else
        local tile_type = self:GetTileAtPoint(x, y, z) --水面似乎检测不到tag
        if tile_type == WORLD_TILES.MANGROVE or tile_type == WORLD_TILES.LILYPOND
        then
            local tile_info = GetTileInfo(tile_type)
            local render_layer = tile_info ~= nil and tile_info._render_layer or 0
            local best = {}
            best.tile_type = tile_type
            best.render_layer = render_layer
            best.x = x
            best.z = z

            local node_index = (best ~= nil) and self:GetNodeIdAtPoint(best.x, 0, best.z) or 0
            if has_tag == nil then
                return TheWorld.topology.nodes[node_index], node_index
            else
                local node = TheWorld.topology.nodes[node_index]
                return ((node ~= nil and table.contains(node.tags, has_tag)) and node or nil), node_index
            end
        end
    end
end


Map.IsTropicalAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "tropical")

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

require("entityscript") --实体是否在

function EntityScript:IsInTropicalArea()
    return TheWorld.Map:IsTropicalAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:AwareInTropicalArea() ----减少计算量
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("tropical") and true or false
    return aware
end

function EntityScript:IsInShipwreckedArea()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:AwareInShipwreckedArea() ----减少计算量
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("shipwrecked") and true
    return aware or false
end

function EntityScript:IsInHamletArea()
    return TheWorld.Map:IsHamletAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:AwareInHamletArea() ----减少计算量
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("hamlet") and true
    return aware or false
end

--温度变化更加丝滑
local function OnTemperatureUpdateBefore(self)
    if self.inst:AwareInTropicalArea() then
        local tro_tem = math.max(10 - TheWorld.state.temperature, 0) + 5
        self:SetModifier("tropicalregion", tro_tem)
    else
        self:RemoveModifier("tropicalregion")
    end

    return nil, false
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    Utils.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    -- Utils.FnDecorator(inst.components.weather, "OnUpdate", OnWeatherUpdateAfter)
end)







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
                if parent and parent:IsInTropicalArea() then
                    return
                end
                if parent and TheWorld.Map:IsTropicalAreaAtPoint(parent.Transform:GetWorldPosition()) then
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


--消除雨雪------------------还是有问题
-- local old_update = { rain = nil, caverain = nil, snow = nil }
-- local emitters = GLOBAL.EmitterManager --发射器
-- local oldPostUpdate = emitters.PostUpdate or nil

-- function emitters:PostUpdate(...)
--     for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
--         if (inst.prefab == "snow" --[[or
--                 inst.prefab == "pollen" or
--                 inst.prefab == "lunarhail"]]) and
--             data.updateFunc ~= nil then
--             if old_update[inst] == nil then
--                 old_update[inst] = data.updateFunc
--             end

--             if inst:IsInTropicalArea() then -----------似乎函数不起效
--                 data.updateFunc = function(...) end
--             else
--                 data.updateFunc = old_update[inst]
--             end
--         end
--     end
--     if oldPostUpdate ~= nil then
--         oldPostUpdate(emitters, ...)
--     end
-- end

---------以下来自猪人部落-------------

-- if GLOBAL.ThePlayer then
--     print "getplayer1111!!!!!!!"
-- else
--     print "no player1111!!!!!!!"
-- end

-- --这里怎么取到玩家的位置呢，搞不清楚
-- AddClassPostConstruct("components/weather", function(self)
--     local _rainfx = Utils.ChainFindUpvalue(self.OnPostInit, "_rainfx")
--     local _snowfx = Utils.ChainFindUpvalue(self.OnPostInit, "_snowfx")
--     local _lunarhailfx = Utils.ChainFindUpvalue(self.OnPostInit, "_lunarhailfx")
--     local _pollenfx = Utils.ChainFindUpvalue(self.OnPostInit, "_pollenfx") --应该不用管这个特效

--     local oldupdate = self.OnUpdate



--     self.OnUpdate = function(self, dt)
--         oldupdate(self, dt)

--         if _snowfx then
--             print "issnowhere!!!!!!!!!"
--             if true --[[self.inst:IsInTropicalArea()]] then
--                 print "areasnowhere!!!!!!!!!"
--                 if _rainfx then
--                     print "israinhere!!!!!!!!!"
--                     _rainfx.particles_per_tick = _snowfx.particles_per_tick
--                     _rainfx.splashes_per_tick = _snowfx.particles_per_tick
--                 end
--                 _snowfx.particles_per_tick = 0
--             end
--         end
--     end
--     self.LongUpdate = self.OnUpdate
-- end)


----prefabs 相关修改--

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
    if tag == "nohasslers" and (
            self:CurrentlyInTag("tropical")
            or self:CurrentlyInTag("hamlet")
            or self:CurrentlyInTag("frost")
        )
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

        inst:DoTaskInTime(0.5, function(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if ground == GROUND.MAGMAFIELD
                    or ground == GROUND.JUNGLE
                    or ground == GROUND.ASH
                    or ground == GROUND.VOLCANO
                    or ground == GROUND.TIDALMARSH
                    or ground == GROUND.MEADOW
                    or ground == GROUND.BEAH then
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
for _, prefab in pairs({ "butterfly" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0, function(inst)
            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local butterfly
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if IsSwLandTile(ground) then
                    butterfly = SpawnPrefab("butterfly_tropical")
                elseif IsHamLandTile(ground) then
                    butterfly = SpawnPrefab("glowfly")
                end

                if butterfly then
                    -- if butterfly.components.pollinator ~= nil then
                    --     butterfly.components.pollinator:Pollinate(spawnflower)
                    -- end
                    -- if butterfly.components.homeseeker ~= nil then
                    --     butterfly.components.homeseeker:SetHome(spawnflower)
                    -- end
                    butterfly.Transform:SetPosition(x, y, z)
                    inst:Remove()
                end
            end
        end)
    end)
end


--[[ ----毒蜘蛛刷新
for _, prefab in pairs({ "spider_warrior" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0.5, function(inst)
            if inst:IsInTropicalArea() then
                local bolha = SpawnPrefab("spider_tropical")
                if bolha then
                    bolha.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    inst:Remove()
                end
            end
        end)
    end)
end


----热带蝴蝶刷新
for _, prefab in pairs({ "butterfly" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0, function(inst)
            if inst:IsInTropicalArea() then
                local bolha = SpawnPrefab("butterfly_tropical")
                if bolha then
                    bolha.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    inst:Remove()
                end
            end
        end)
    end)
end ]]
