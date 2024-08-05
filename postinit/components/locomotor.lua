local Utils = require("tools/utils")

local function UpdateGroundSpeedMultiplierAfter(retTab, self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local oncreep = TheWorld.GroundCreep:OnCreep(x, y, z)

    if oncreep and self.triggerscreep then return retTab end

    -- 重新修改groundspeedmultiplier的值
    local current_ground_tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    local isCave = TheWorld:HasTag("cave")
    if current_ground_tile == GROUND.UNDERWATER_SANDY or
        current_ground_tile == GROUND.UNDERWATER_ROCKY or
        (current_ground_tile == GROUND.BEACH and isCave) or
        (current_ground_tile == GROUND.MAGMAFIELD and isCave) or
        (current_ground_tile == GROUND.PAINTED and isCave) or
        (current_ground_tile == GROUND.BATTLEGROUND and isCave) or
        (current_ground_tile == GROUND.PEBBLEBEACH and isCave) then
        if self.inst.prefab ~= "wurt" then
            self.groundspeedmultiplier = 0.5
        end
        if self.inst:HasTag("nadador") then
            self.groundspeedmultiplier = 0.8
        end
    end

    return retTab
end

local function ExternalSpeedMultiplierBefore(self)
    ----------------------efeito dos ventos----------------------------------
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
    ----------------------efeito das correntes marinhas----------------------------------
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
    ----------------------efeito da inundação----------------------------------
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
        -------------------------transfere o conteudo do barco inventario para o barco do criado---------------------------------
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

local function OnUpdate(self, dt, arrive_check_only)
    if self.hopping then
        --self:UpdateHopping(dt)
        return
    end

    if not self.inst:IsValid() then
        Print(VERBOSITY.DEBUG, "OnUpdate INVALID", self.inst.prefab)
        self:ResetPath()
        self:StopUpdatingInternal()
        self:StopMoveTimerInternal()
        return
    end

    if self.enablegroundspeedmultiplier and not arrive_check_only then
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)
        if tx ~= self.lastpos.x or ty ~= self.lastpos.y then
            self:UpdateGroundSpeedMultiplier()
            self.lastpos = { x = tx, y = ty }
        end
    end

    local facedir

    --Print(VERBOSITY.DEBUG, "OnUpdate", self.inst.prefab)
    if self.dest then
        --Print(VERBOSITY.DEBUG, "    w dest")
        if not self.dest:IsValid() or (self.bufferedaction and not self.bufferedaction:IsValid()) then
            self:Clear()
            return
        end

        if self.inst.components.health and self.inst.components.health:IsDead() then
            self:Clear()
            return
        end

        local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
        local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()

        local reached_dest, invalid, in_cooldown = nil, nil, false
        if self.bufferedaction and self.bufferedaction.action.customarrivecheck then
            reached_dest, invalid = self.bufferedaction.action.customarrivecheck(self.inst, self.dest)
        else
            local dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
            local arrive_dsq = self.arrive_dist * self.arrive_dist
            if dt > 0 then
                local run_dist = self:GetRunSpeed() * dt * .5
                arrive_dsq = math.max(arrive_dsq, run_dist * run_dist)
            end
            reached_dest = dsq <= arrive_dsq

            --special case for attacks (in_cooldown can get set here)
            if self.bufferedaction and
                self.bufferedaction.action == ACTIONS.ATTACK and
                not (self.bufferedaction.forced and self.bufferedaction.target == nil)
            then
                local combat = self.inst.replica.combat
                if combat then
                    reached_dest, invalid, in_cooldown = combat:LocomotorCanAttack(reached_dest,
                        self.bufferedaction.target)
                end
            end
        end

        if invalid then
            self:Stop()
            self:Clear()
        elseif reached_dest then
            --I think this is fine? we might need to make OnUpdateFinish() function that we can run to finish up the OnUpdate so we don't duplicate code
            if in_cooldown then return end
            --Print(VERBOSITY.DEBUG, "REACH DEST")
            self.inst:PushEvent("onreachdestination",
                { target = self.dest.inst, pos = Point(destpos_x, destpos_y, destpos_z) })
            if self.atdestfn ~= nil then
                self.atdestfn(self.inst)
            end

            if self.bufferedaction ~= nil and self.bufferedaction ~= self.inst.bufferedaction then
                if self.bufferedaction.target ~= nil and self.bufferedaction.target.Transform ~= nil and not self.bufferedaction.action.skip_locomotor_facing then
                    self:FaceMovePoint(self.bufferedaction.target.Transform:GetWorldPosition())
                elseif self.bufferedaction.invobject ~= nil and not self.bufferedaction.action.skip_locomotor_facing then
                    local act_pos = self.bufferedaction:GetActionPoint()
                    if act_pos ~= nil then
                        self:FaceMovePoint(act_pos:Get())
                    end
                end
                if self.ismastersim then
                    self.inst:PushBufferedAction(self.bufferedaction)
                else
                    self.inst:PreviewBufferedAction(self.bufferedaction)
                end
            end
            self:Stop()
            self:Clear()
        elseif not arrive_check_only then
            --Print(VERBOSITY.DEBUG, "LOCOMOTING")
            if self:WaitingForPathSearch() then
                local pathstatus = TheWorld.Pathfinder:GetSearchStatus(self.path.handle)
                --Print(VERBOSITY.DEBUG, "HAS PATH SEARCH", pathstatus)
                if pathstatus ~= STATUS_CALCULATING then
                    --Print(VERBOSITY.DEBUG, "PATH CALCULATION complete", pathstatus)
                    if pathstatus == STATUS_FOUNDPATH then
                        --Print(VERBOSITY.DEBUG, "PATH FOUND")
                        local foundpath = TheWorld.Pathfinder:GetSearchResult(self.path.handle)
                        if foundpath then
                            --Print(VERBOSITY.DEBUG, string.format("PATH %d steps ", #foundpath.steps))

                            if #foundpath.steps > 2 then
                                self.path.steps = foundpath.steps
                                self.path.currentstep = 2

                                -- for k,v in ipairs(foundpath.steps) do
                                --     Print(VERBOSITY.DEBUG, string.format("%d, %s", k, tostring(Point(v.x, v.y, v.z))))
                                -- end
                            else
                                --Print(VERBOSITY.DEBUG, "DISCARDING straight line path")
                                self.path.steps = nil
                                self.path.currentstep = nil
                            end
                        else
                            Print(VERBOSITY.DEBUG, "EMPTY PATH")
                        end
                    else
                        if pathstatus == nil then
                            Print(VERBOSITY.DEBUG,
                                string.format("LOST PATH SEARCH %u. Maybe it timed out?", self.path.handle))
                        else
                            Print(VERBOSITY.DEBUG, "NO PATH")
                        end
                    end

                    TheWorld.Pathfinder:KillSearch(self.path.handle)
                    self.path.handle = nil
                end
            end

            local canrotate = self.inst.sg == nil or self.inst.sg:HasStateTag("canrotate")
            if canrotate or self.pusheventwithdirection then
                --Print(VERBOSITY.DEBUG, "CANROTATE")
                local facepos_x, facepos_y, facepos_z = destpos_x, destpos_y, destpos_z

                if self.path and self.path.steps and self.path.currentstep < #self.path.steps then
                    --Print(VERBOSITY.DEBUG, "FOLLOW PATH")
                    local step = self.path.steps[self.path.currentstep]
                    local steppos_x, steppos_y, steppos_z = step.x, step.y, step.z

                    --Print(VERBOSITY.DEBUG, string.format("CURRENT STEP %d/%d - %s", self.path.currentstep, #self.path.steps, tostring(steppos)))

                    local step_distsq = distsq(mypos_x, mypos_z, steppos_x, steppos_z)

                    local maxsteps = #self.path.steps
                    if self.path.currentstep < maxsteps then -- Add tolerance to step points that aren't the final destination.
                        local physdiameter = self.inst:GetPhysicsRadius(0) * 2
                        step_distsq = step_distsq - physdiameter * physdiameter
                    end

                    if step_distsq <= (self.arrive_step_dist) * (self.arrive_step_dist) then
                        self.path.currentstep = self.path.currentstep + 1

                        if self.path.currentstep < maxsteps then
                            step = self.path.steps[self.path.currentstep]
                            steppos_x, steppos_y, steppos_z = step.x, step.y, step.z

                            --Print(VERBOSITY.DEBUG, string.format("NEXT STEP %d/%d - %s", self.path.currentstep, #self.path.steps, tostring(steppos)))
                        else
                            --Print(VERBOSITY.DEBUG, string.format("LAST STEP %s", tostring(destpos)))
                            steppos_x, steppos_y, steppos_z = destpos_x, destpos_y, destpos_z
                        end
                    end
                    facepos_x, facepos_y, facepos_z = steppos_x, steppos_y, steppos_z
                end

                facedir = self.inst:GetAngleToPoint(facepos_x, facepos_y, facepos_z)

                local x, y, z = self.inst.Physics:GetMotorVel()
                if x < 0 and self.strafedir == nil then
                    facedir = facedir + 180
                    if canrotate then
                        --V2C: matching legacy behaviour, where this ignores busy state
                        --Print(VERBOSITY.DEBUG, "SET ROT", facedir)
                        self:SetMoveDir(facedir)
                    end
                elseif canrotate and not (self.inst.sg and self.inst.sg:HasStateTag("busy")) then
                    --V2C: while I'd like to remove the busy check,
                    --     we'll keep it to match legacy behaviour:
                    --     it used to call self.inst:FaceMovePoint(...)
                    --Print(VERBOSITY.DEBUG, "FACE PT", Point(facepos_x, facepos_y, facepos_z))
                    self:SetMoveDir(facedir)
                end
            end

            self.wantstomoveforward = self.wantstomoveforward or not self:WaitingForPathSearch()
        end
    end

    if arrive_check_only then
        return
    end

    local should_locomote = false
    if (self.ismastersim and not self.inst:IsInLimbo()) or not (self.ismastersim or self.inst:HasTag("INLIMBO")) then
        local is_moving = self.inst.sg ~= nil and self.inst.sg:HasStateTag("moving")
        local is_running = self.inst.sg ~= nil and self.inst.sg:HasStateTag("running")
        --'not' is being used below as a cast-to-boolean operator
        should_locomote =
            (not is_moving ~= not self.wantstomoveforward) or
            (is_moving and (not is_running ~= not self.wantstorun))

        if is_moving or is_running then
            self:StartMoveTimerInternal()
        end
    end

    if should_locomote then
        self.inst:PushEvent("locomote", self.pusheventwithdirection and facedir and { dir = facedir } or nil)
    elseif not self.wantstomoveforward and not self:WaitingForPathSearch() then
        self:ResetPath()
        self:StopUpdatingInternal()
        self:StopMoveTimerInternal()
    end

    local cur_speed = self.inst.Physics:GetMotorSpeed()
    if cur_speed > 0 then
        if self.allow_platform_hopping and (self.bufferedaction == nil or not self.bufferedaction.action.disable_platform_hopping) then
            local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()

            local rotation = self.inst.Transform:GetRotation() * DEGREES
            local forward_x, forward_z = math.cos(rotation), -math.sin(rotation)

            local hop_distance = self:GetHopDistance(self:GetSpeedMultiplier())

            local my_platform = self.inst:GetCurrentPlatform()
            if TUNING.tropical.disembarkation then
                my_platform = self.inst:GetCurrentPlatform() or
                    GetClosestInstWithTag("barcoapto", self.inst, 0.5)
            end

            local other_platform = nil
            local destpos_x, destpos_y, destpos_z
            if self.dest and self.dest:IsValid() then
                if my_platform == self.dest:GetPlatform() then
                    destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                    other_platform = my_platform
                end
            end

            -- if other_platform == nil then
            --     destpos_x, destpos_z = forward_x * hop_distance + mypos_x, forward_z * hop_distance + mypos_z
            --     other_platform = TheWorld.Map:GetPlatformAtPoint(destpos_x, destpos_z)
            -- end
            --### 解决了小木筏竹筏上不去的问题
            if other_platform == nil then
                local n_steps = 3
                local step = hop_distance / n_steps
                for i = 1, n_steps do
                    destpos_x, destpos_z = forward_x * step * i + mypos_x, forward_z * step * i + mypos_z
                    other_platform = TheWorld.Map:GetPlatformAtPoint(destpos_x, destpos_z)
                    --print(GetTick(), i, other_platform)
                    if other_platform then
                        break
                    end
                end
            end
            local can_hop = false
            local hop_x, hop_z, target_platform, blocked
            local too_early_top_hop = self.time_before_next_hop_is_allowed > 0
            if my_platform ~= other_platform and not too_early_top_hop then
                can_hop, hop_x, hop_z, target_platform, blocked = self:ScanForPlatform(my_platform, destpos_x, destpos_z,
                    hop_distance)
            end
            if not blocked then
                if can_hop then
                    self.last_platform_visited = my_platform

                    self:StartHopping(hop_x, hop_z, target_platform)
                elseif self.inst.components.amphibiouscreature ~= nil and other_platform == nil and not self.inst.sg:HasStateTag("jumping") then
                    local dist = self.inst:GetPhysicsRadius(0) + 2.5
                    local _x, _z = forward_x * dist + mypos_x, forward_z * dist + mypos_z
                    if my_platform ~= nil then
                        local _
                        can_hop, _, _, _, blocked = self:ScanForPlatform(nil, _x, _z, hop_distance)
                    end

                    if not can_hop and self.inst.components.amphibiouscreature:ShouldTransition(_x, _z) then
                        -- If my_platform ~= nil, we already ran the "is blocked" test as part of ScanForPlatform.
                        -- Otherwise, run one now.
                        if (my_platform ~= nil and not blocked) or
                            not self:TestForBlocked(mypos_x, mypos_z, forward_x, forward_z, self.inst:GetPhysicsRadius(0), dist * 1.41421) then -- ~sqrt(2); _x,_z are a dist right triangle so sqrt(dist^2 + dist^2)
                            self.inst:PushEvent("onhop", { x = _x, z = _z })
                        end
                    end
                end
            end

            if (not can_hop and my_platform == nil and target_platform == nil and not self.inst.sg:HasStateTag("jumping")) and self.inst.components.drownable ~= nil and self.inst.components.drownable:ShouldDrown() then
                self.inst:PushEvent("onsink")
            end
        else
            local speed_mult = self:GetSpeedMultiplier()
            local desired_speed = self.isrunning and self:RunSpeed() or self.walkspeed
            if self.dest and self.dest:IsValid() then
                local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
                local dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
                if dsq <= .25 then
                    speed_mult = math.max(.33, math.sqrt(dsq))
                end
            end

            self:SetMotorSpeed(desired_speed * speed_mult)
        end
    end

    self.time_before_next_hop_is_allowed = math.max(self.time_before_next_hop_is_allowed - dt, 0)
end

AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)
    Utils.FnDecorator(self, "StartHopping", StartHoppingBefore)

    if not TheWorld.ismastersim then return end

    Utils.FnDecorator(self, "ExternalSpeedMultiplier", ExternalSpeedMultiplierBefore)

    self.OnUpdate = OnUpdate
end)
