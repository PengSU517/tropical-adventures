GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end }) --GLOBAL 相关照抄

-- local map = require("components/map")

require "components/map"




--得到瓷砖中心点
local old_GetTileCenterPoint = Map.GetTileCenterPoint
Map.GetTileCenterPoint = function(self, x, y, z)
    local map_width, map_height = TheWorld.Map:GetSize()
    if (type(x) == "number" and math.abs(x) >= map_width) and (type(z) == "number" and math.abs(z) >= map_height) then
        return math.floor((x) / 4) * 4 + 2, 0, math.floor((z) / 4) * 4 + 2
    end
    if z then
        return old_GetTileCenterPoint(self, x, y, z)
    else
        return old_GetTileCenterPoint(self, x, y)
    end
end

--------------------------------------------------------------是不是可通行的点--
local function IsHamRoomAtPoint(x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    local entities = TheSim:FindEntities(x, y, z, 20, { "blows_air" })
    if entities then
        for i, v in ipairs(entities) do
            if v then
                local xx, yy, zz = v.Transform:GetWorldPosition()
                if ((x - xx) <= 8 and (x - xx) >= -4.5 and math.abs(z - zz) <= 11) then ---11
                    return true
                end
            end
        end
    end

    return false
end

local function IsHamRoomWallAtPoint(x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    local entities = TheSim:FindEntities(x, y, z, 20, { "blows_air" })
    if entities then
        for i, v in ipairs(entities) do
            if v then
                local xx, yy, zz = v.Transform:GetWorldPosition()
                if (x - xx) <= -5 and (x - xx) > -5.5 and math.abs(z - zz) <= 11 then ---11
                    return "back"
                elseif (z - zz) >= 11.5 and (z - zz) < 12 and (x - xx) <= 8 and (x - xx) >= -4.5 then
                    return "right"
                elseif (zz - z) >= 11.5 and (zz - z) < 12 and (x - xx) <= 8 and (x - xx) >= -4.5 then
                    return "left"
                else
                    return false
                end
            end
        end
    end

    return false
end



Map.IsHamRoomAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z)
end

Map.IsHamRoomWallAtPoint = function(self, x, y, z)
    return IsHamRoomWallAtPoint(x, y, z)
end


local old_IsPassableAtPoint = Map.IsPassableAtPoint
Map.IsPassableAtPoint = function(self, x, y, z, ...)
    return old_IsPassableAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
end

--在该点处是否可见
local old_IsVisualGroundAtPoint = Map.IsVisualGroundAtPoint
Map.IsVisualGroundAtPoint = function(self, x, y, z, ...)
    return old_IsVisualGroundAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
end
--是否在地面上
local old_IsAboveGroundAtPoint = Map.IsAboveGroundAtPoint
Map.IsAboveGroundAtPoint = function(self, x, y, z, ...)
    return old_IsAboveGroundAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
end

-- --能不能种植物---
local old_CanPlantAtPoint = Map.CanPlantAtPoint
Map.CanPlantAtPoint = function(self, x, y, z, ...)
    return old_CanPlantAtPoint(self, x, y, z, ...) or IsHamRoomAtPoint(x, y, z)
end

-- --能不能产生耕地堆
local old_CanTillSoilAtPoint = Map.CanTillSoilAtPoint
Map.CanTillSoilAtPoint = function(self, x, y, z, ignore_tile_type, ...)
    if IsHamRoomAtPoint(x, y, z) then
        return old_CanTillSoilAtPoint(self, x, y, z, true, ...)
    else
        return old_CanTillSoilAtPoint(self, x, y, z, ignore_tile_type, ...)
    end
end

local old_CanDeployRecipeAtPoint = Map.CanDeployRecipeAtPoint

Map.CanDeployRecipeAtPoint = function(self, pt, recipe, rot)
    if recipe.build_mode == "wallsection" then
        local pt_x, pt_y, pt_z = pt:Get()
        return IsHamRoomWallAtPoint(pt_x, pt_y, pt_z)
    else
        return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
    end
end



--------------------------------------------------------------------------------------------
----------------------------------[[ entityscript ]]----------------------------------------
--------------------------------------------------------------------------------------------
require("entityscript")
--实体是否在虚空的房间里面
function EntityScript:IsInHamRoom()
    return TheWorld.Map:IsHamRoomAtPoint(self:GetPosition():Get())
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
local banrecipe = { "hua_player_house_recipe", "homesign", "townportal", "telebase", "hua_player_house1_recipe",
    "hua_player_house_pvz_recipe", "hua_player_house_tardis_recipe", "infantree_carpet", "myth_house_bamboo",
    "playerhouse_city"
}
for i, v in ipairs(banrecipe) do
    local recipe = AllRecipes[v]
    if recipe then
        local old = recipe.testfn or nil
        recipe.testfn = function(pt, rot, ...)
            if IsHamRoomAtPoint(pt.x, 0, pt.z) then
                return false
            end
            if old ~= nil then
                return old(pt, rot, ...)
            end
            return true
        end
    end
end



--以下大部分来自花花的神话方寸山
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("getposition")
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
local dog = { "hound", "firehound", "icehound", "moonhound", "mutatedhound", "warg" }
for i, v in ipairs(dog) do --
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
if TUNING.WATER_BM then
    AddComponentPostInit("moisture", function(self) --房子里面不会降雨
        local old = self.GetMoistureRate
        function self:GetMoistureRate()
            if self.inst:IsInHamRoom() then
                return 0
            end
            return old(self)
        end
    end)
end


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
AddComponentPostInit("sleeper", function(self)
    local old_GoToSleep = self.GoToSleep
    self.GoToSleep = function(...)
        if self.inst:IsInHamRoom() then
            return
        else
            old_GoToSleep(...)
        end
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
                if TheWorld.Map:IsHamRoomAtPoint(pt:Get()) then
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
        if ( --[[inst.prefab == "rain" or]] inst.prefab == "caverain" or inst.prefab == "snow") and data.updateFunc ~= nil then
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
local Old_PlayFootstep = GLOBAL.PlayFootstep
GLOBAL.PlayFootstep = function(inst, volume, ispredicted, ...)
    if inst:IsInHamRoom() then
        local sound = inst.SoundEmitter
        if sound ~= nil then
            sound:PlaySound(
                inst.sg ~= nil and inst.sg:HasStateTag("running") and "dontstarve/movement/run_woods" or
                "dontstarve/movement/walk_woods"
                ..
                ((inst:HasTag("smallcreature") and "_small") or
                    (inst:HasTag("largecreature") and "_large" or "")
                ),
                nil,
                volume or 1,
                ispredicted
            )
        end
    else
        Old_PlayFootstep(inst, volume, ispredicted, ...)
    end
end



------------------------------------------------------------------------------更改相关生物的大脑
--猪在小房子里面不回家
local function MakePigsNotGoHome(brain)
    local flag = 0
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Parallel" and node.children[1].name == "IsDay" then
            node.children[1].fn = function() return TheWorld.state.isday or brain.inst:IsInHamRoom() end
            flag = flag + 1
        elseif node.name == "Parallel" and node.children[1].name == "IsNight" then
            node.children[1].fn = function() return not TheWorld.state.isday and not brain.inst:IsInHamRoom() end
            flag = flag + 1
        end
        if flag >= 2 then break end
    end
end

AddBrainPostInit("pigbrain", MakePigsNotGoHome)
--蜜蜂晚上和冬天依然工作
local function MakeBeesNotGoHome(brain)
    local flag = 0
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Sequence" and node.children[1].name == "IsWinter" then
            local old_fn = node.children[1].fn
            node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInHamRoom() end
            flag = flag + 1
        elseif node.name == "Sequence" and node.children[1].name == "IsNight" then
            local old_fn = node.children[1].fn
            node.children[1].fn = function(...) return old_fn(...) and not brain.inst:IsInHamRoom() end
            flag = flag + 1
        end
        if flag >= 2 then break end
    end
end
AddBrainPostInit("beebrain", MakeBeesNotGoHome)
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

local function MakePerdNotGoHome(brain)
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Parallel" and node.children[1].name == "IsNight" then
            node.children[1].fn = function() return not TheWorld.state.isday and not brain.inst:IsInHamRoom() end
        end
    end
end

AddBrainPostInit("perdbrain", MakePerdNotGoHome)







-- local DEPLOY_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "walkableplatform", "walkableperipheral",
--     "alt_tile", "centerlight", "liberado" }


---------------------------------------------------------------
