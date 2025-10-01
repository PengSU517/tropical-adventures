local relative_temperature_thresholds = { -30, -10, 10, 30 }
local function GetRangeForTemperature(temp, ambient)
    local range = 1
    for i, v in ipairs(relative_temperature_thresholds) do
        if temp > ambient + v then
            range = range + 1
        end
    end
    return range
end
local emitted_temperatures = { -10, 10, 25, 40, 60 }
local function HeatFn(inst, observer)
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    return emitted_temperatures[range]
end

function MakeObsidianTool(inst)
    inst:AddTag("heatrock")
    -- local temperature = inst:AddComponent("temperature")
    local temperature = inst.components.temperature
    temperature.inherentinsulation = TUNING.INSULATION_MED
    temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE * 2
    temperature:IgnoreTags("heatrock")
    local heater = inst:AddComponent("heater")
    heater.heatfn = HeatFn
    heater.equippedheatfn = HeatFn
    heater.carriedheatfn = HeatFn
    heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR
    heater:SetThermics(true, false)
end

IsInTropicalArea = function(inst)
    -- local x, _, z = inst:GetPosition():Get()-----这个东西似乎要等待一帧
    local x, _, z = inst.Transform:GetWorldPosition() ----这个东西也取不到值
    return TheWorld.Map:IsTropicalAreaAtPoint(x, 0, z)
end

IsInShipwreckedArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z)
end

IsInHamletArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsHamletAreaAtPoint(x, 0, z)
end

IsInVolcanoArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsVolcanoAreaAtPoint(x, 0, z)
end

IsInHamRoom = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsHamRoomAtPoint(x, 0, z)
end


local old_MakeNoGrowInWinter = MakeNoGrowInWinter
function MakeNoGrowInWinter(inst)
    inst:DoTaskInTime(0.05, function()
        if inst.Transform ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsForestAreaAtPoint(x, y, z) then
                old_MakeNoGrowInWinter(inst)
            end
        end
    end)
end

function MakeNoWinterItem(inst)
    -- inst:StopAllWatchingWorldStates()
    inst:StopWatchingOneOfWorldStates("iswinter")
    inst:StopWatchingOneOfWorldStates("snowlevel")
end

-- function CancelMakeNoWinterItem(inst)
--     -- inst:ReWatchingOneOfWorldStates("iswinter")
--     -- inst:ReWatchingOneOfWorldStates("snowlevel")
-- end

--清除积雪覆盖效果
local Old_MakeSnowCovered = MakeSnowCovered
local function ClearSnowCoveredPristine(inst)
    inst.AnimState:ClearOverrideSymbol("snow", "snow", "snow")
    inst:RemoveTag("SnowCovered")
    inst.AnimState:Hide("snow")
end
MakeSnowCovered = function(inst, ...)
    Old_MakeSnowCovered(inst, ...)
    inst:DoTaskInTime(0.05, function()
        if inst.Transform ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsNotForestAreaAtPoint(x, y, z) then
                ClearSnowCoveredPristine(inst)
            end
        end
    end)
end


function SpawnWavesSW(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActive,
                      random_angle)
    wavePrefab = wavePrefab or "rogue_wave"
    totalAngle = math.clamp(totalAngle, 1, 360)

    local pos = inst:GetPosition()
    local startAngle = (random_angle and math.random(-180, 180)) or inst.Transform:GetRotation()
    local anglePerWave = totalAngle / (numWaves - 1)

    if totalAngle == 360 then
        anglePerWave = totalAngle / numWaves
    end

    for i = 0, numWaves - 1 do
        local wave = SpawnPrefab(wavePrefab)

        local angle = (startAngle - (totalAngle / 2)) + (i * anglePerWave)
        local rad = initialOffset or (inst.Physics and inst.Physics:GetRadius()) or 0.0
        local total_rad = rad + wave.Physics:GetRadius() + 0.1
        local offset = Vector3(math.cos(angle * DEGREES), 0, -math.sin(angle * DEGREES)):Normalize()
        local wavepos = pos + (offset * total_rad)

        --        if inst:GetIsOnWater(wavepos:Get()) then
        wave.Transform:SetPosition(wavepos:Get())

        local speed = waveSpeed or 6
        wave.Transform:SetRotation(angle)
        wave.Physics:SetMotorVel(speed, 0, 0)
        wave.idle_time = idleTime or 5

        if instantActive then
            wave.sg:GoToState("idle")
        end
    end
end
