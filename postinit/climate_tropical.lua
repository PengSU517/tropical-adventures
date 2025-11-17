local Utils = require("tools/utils")

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
