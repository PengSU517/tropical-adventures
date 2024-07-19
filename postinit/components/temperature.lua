local TAENV = env
GLOBAL.setfenv(1, GLOBAL)


local Temperature = require("components/temperature")

local _SetTemperature = Temperature.SetTemperature
function Temperature:SetTemperature(value, ...)
    if self.volcano_data ~= nil then
        -- max/min --
        local mintemp = self.mintemp
        local maxtemp = self.maxtemp
        local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
        if owner ~= nil and owner:HasTag("fridge") and not owner:HasTag("nocool") then
            -- Inside a fridge, excluding icepack ("nocool")
            -- Don't cool it below freezing unless ambient temperature is below freezing
            mintemp = math.max(mintemp, math.min(0, TheWorld.state.temperature))
        end

        -- eruption --
        local rim_dist_mult = 1
        local mult = TUNING.VOLCANORIM_ACTIVE_MULT
        -- lava rim  --
        if self.volcano_data.DIST ~= nil then
            rim_dist_mult = 1 - (self.volcano_data.DIST / TUNING.VOLCANORIM_LAVA_DIST)
            mult = TUNING.VOLCANORIM_LAVA_MULT
        end
        --  calculation --
        self.rate = mult * rim_dist_mult * self.rate
        value = math.clamp(self.current + self.rate * self.volcano_data.DT, mintemp, maxtemp)
    end
    return _SetTemperature(self, value, ...)
end

local _OnUpdate = Temperature.OnUpdate
function Temperature:OnUpdate(dt, ...)
    local _temperature = rawget(TheWorld.state, "temperature")
    local climate = GetClimate(self.inst)
    if IsTropicalClimate(climate) then
        TheWorld.state.temperature = TheWorld.state.islandtemperature
        local vm = TheWorld.components.volcanomanager
        if IsClimate(climate, "volcano") and TheWorld.Map.GetClosestTileDist and vm then
            local lava_dist = nil
            local volcanic_heat = nil

            if vm:IsErupting() then
                volcanic_heat = TUNING.VOLCANORIM_ACTIVE_HEAT
            else
                local x, y, z = self.inst.Transform:GetWorldPosition()
                lava_dist = TheWorld.Map:GetClosestTileDist(x, y, z, WORLD_TILES.VOLCANO_LAVA,
                    TUNING.VOLCANORIM_LAVA_DIST)
                if lava_dist <= TUNING.VOLCANORIM_LAVA_DIST then
                    volcanic_heat = TUNING.VOLCANORIM_LAVA_HEAT
                end
            end

            if volcanic_heat then
                TheWorld.state.temperature = TheWorld.state.temperature + volcanic_heat
                self.volcano_data = {
                    DT = dt,
                    DIST = lava_dist,
                }
            end
        end
    end

    _OnUpdate(self, dt, ...)
    self.volcano_data = nil

    TheWorld.state.temperature = _temperature
end
