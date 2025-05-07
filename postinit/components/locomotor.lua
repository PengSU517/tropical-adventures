local Utils = require("tools/utils")

local function UpdateGroundSpeedMultiplierAfter(retTab, self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local oncreep = TheWorld.GroundCreep:OnCreep(x, y, z)

    if oncreep and self.triggerscreep then return retTab end

    -- 修改石板路的加速
    local current_ground_tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if current_ground_tile == GROUND.COBBLEROAD then
        self.groundspeedmultiplier = 1.3
    end

    return retTab
end

local function ExternalSpeedMultiplierBefore(self)
    ----------------------efeito dos ventos风效应----------------------------------
    local wind_speed = 1
    local vento = GetClosestInstWithTag("vento", self.inst, 10)
    if vento then
        local wind = vento.Transform:GetRotation() + 180
        local windangle = self.inst.Transform:GetRotation() - wind
        local windproofness = 1.0
        local velocidadedovento = 1.5

        if self.inst.components.inventory then
            local corpo = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            local cabeca = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if cabeca and cabeca.prefab == "aerodynamichat" then
                windproofness = 0.5
            end
            if corpo and corpo.prefab == "armor_windbreaker" then
                windproofness = 0
            end
        end

        local windfactor = 0.4 * windproofness * velocidadedovento * math.cos(windangle * DEGREES) + 1.0
        wind_speed = math.max(0.1, windfactor)
    end
    ----------------------efeito das correntes marinhas海流的影响----------------------------------
    local wave_speed = 1
    local ondamarinha = GetClosestInstWithTag("ondamarinha", self.inst, 6)
    if ondamarinha then
        local wave = ondamarinha.Transform:GetRotation() + 180
        local waveangle = self.inst.Transform:GetRotation() - wave
        local waveproofness = 1.0
        local velocidadedoondamarinha = 2


        local wavefactor = 0.4 * waveproofness * velocidadedoondamarinha * math.cos(waveangle * DEGREES) + 1.0
        wave_speed = math.max(0.1, wavefactor)
    end
    ----------------------efeito da inundação洪水效应----------------------------------
    local flood_speed = 1
    local alagamento = GetClosestInstWithTag("mare", self.inst, 8)
    if alagamento and not self.inst:HasTag("ghost") then
        if not self.inst:HasTag("playerghost") then
            flood_speed = 0.6
        end
    end
    -------------------------------------------------------------------------------------------
    local fogspeed = 1
    if self.inst:HasTag("hamfogspeed") then
        fogspeed = 0.4
    end

    return self.externalspeedmultiplier * wind_speed * wave_speed * fogspeed * flood_speed
end

AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)
    if not TheWorld.ismastersim then return end
    Utils.FnDecorator(self, "ExternalSpeedMultiplier", ExternalSpeedMultiplierBefore)
end)
