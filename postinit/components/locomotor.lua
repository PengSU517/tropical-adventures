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

local function StartHoppingBefore(self, x, z, target_platform)
    if not self.inst.components.driver then return end

    self.inst:RemoveComponent("rowboatwakespawner")
    local barcoinv = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
    if barcoinv and barcoinv.prefab == self.inst.components.driver.vehicle.prefab then
        local consumo = SpawnPrefab(self.inst.components.driver.vehicle.prefab)
        consumo.Transform:SetPosition(self.inst.components.driver.vehicle:GetPosition():Get())
        consumo.components.finiteuses.current = barcoinv.components.finiteuses.current

        local xd, yd, zd = consumo.Transform:GetWorldPosition()
        if not TheWorld.Map:IsOceanAtPoint(xd, yd, zd, false) then
            local posifinal = Vector3(consumo.Transform:GetWorldPosition())
            local destino = FindSwimmableOffset(posifinal, math.random() * TWOPI, 2, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 4, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 6, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 8, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 12, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 14, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 16, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 20, 6) or
                FindSwimmableOffset(posifinal, math.random() * TWOPI, 18, 6)
            if destino then
                consumo.Transform:SetPosition(xd + destino.xd, yd + destino.yd, zd + destino.zd)
            end
        end
        -------------------------将库存船上的物品转移到服务船上---------------------------------
        if barcoinv.components.container then
            local sailslot = barcoinv.components.container:GetItemInSlot(1)
            if sailslot then
                consumo.components.container:GiveItem(sailslot, 1)
            end

            local luzslot = barcoinv.components.container:GetItemInSlot(2)
            if luzslot and luzslot.prefab == "quackeringram" then luzslot.navio1 = nil end
            if luzslot then
                consumo.components.container:GiveItem(luzslot, 2)
            end

            local cargoslot1 = barcoinv.components.container:GetItemInSlot(3)
            if cargoslot1 then
                consumo.components.container:GiveItem(cargoslot1, 3)
            end

            local cargoslot2 = barcoinv.components.container:GetItemInSlot(4)
            if cargoslot2 then
                consumo.components.container:GiveItem(cargoslot2, 4)
            end

            local cargoslot3 = barcoinv.components.container:GetItemInSlot(5)
            if cargoslot3 then
                consumo.components.container:GiveItem(cargoslot3, 5)
            end

            local cargoslot4 = barcoinv.components.container:GetItemInSlot(6)
            if cargoslot4 then
                consumo.components.container:GiveItem(cargoslot4, 6)
            end

            local cargoslot5 = barcoinv.components.container:GetItemInSlot(7)
            if cargoslot5 then
                consumo.components.container:GiveItem(cargoslot5, 7)
            end

            local cargoslot6 = barcoinv.components.container:GetItemInSlot(8)
            if cargoslot6 then
                consumo.components.container:GiveItem(cargoslot6, 8)
            end
        end
        ----------------------------------------------------------------------------------------------------------------------
        barcoinv:Remove()
    end
    --if self.inst.components.driver.simbolo then self.inst.AnimState:ClearOverrideSymbol(self.inst.components.driver.simbolo) end
    --if self.inst.components.driver.simbolo1 then self.inst.AnimState:ClearOverrideSymbol(self.inst.components.driver.simbolo1) end
    if self.inst.components.driver.vehicle then
        self.inst.components.driver.vehicle:Remove()
    end
    if self.inst.components.drownable ~= nil then self.inst.components.drownable.enabled = true end
    self.inst:RemoveComponent("driver")
    self.inst:RemoveTag("sail")
    self.inst:RemoveTag("surf")
    self.inst:RemoveTag("aquatic")
end



AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)
    Utils.FnDecorator(self, "StartHopping", StartHoppingBefore)

    if not TheWorld.ismastersim then return end

    Utils.FnDecorator(self, "ExternalSpeedMultiplier", ExternalSpeedMultiplierBefore)
end)
