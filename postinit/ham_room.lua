local Utils = require("tools/utils")

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
    if TheWorld.Map:IsHamRoomAtPoint(x, 0, z) then
        return { WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR) }, true
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    Utils.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    Utils.FnDecorator(inst.components.moisture, "OnUpdate", OnMoistureUpdateBefore)
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
    "warglet", "lunarthrall_plant", "vampirebat", "crawlinghorror", "terrorbeak", "gestalt", "warningshadow" }
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
-- AddComponentPostInit("moisture", function(self) --房子里面不会降雨
--     local old = self.GetMoistureRate
--     function self:GetMoistureRate()
--         if self.inst:IsInHamRoom() then
--             return 0
--         end
--         return old(self)
--     end
-- end)
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
    ----最终搜到的也不是这个组件，而只是worldhandle对应的函数
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
