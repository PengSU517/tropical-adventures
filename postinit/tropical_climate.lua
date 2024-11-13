local Utils = require("tools/utils")
local upvaluehelper = require("tools/upvaluehelper")

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
