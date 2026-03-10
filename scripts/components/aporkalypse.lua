local daytime = TUNING.TOTAL_DAY_TIME
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)

return Class(function(self, inst)
    local _world = TheWorld
    local _ismastersim = _world.ismastersim

    local function GetTimeTnSeconds()
        return (_world.state.cycles + _world.state.time) * daytime
    end

    self.inst = inst

    self.first_time = true
    self.near_days = 7 * daytime
    self.aporkalypse_duration = 20 * daytime
    self.should_fiesta_duration = 3 * daytime
    self.fiesta_duration = 7 * daytime
    self.periodtime = 120 * daytime

    self.begin_date = self.periodtime
    self.real_start_date = 0
    self.fiesta_begin_date = 0

    local _phasedirty = true
    self._phase = net_tinybyte(inst.GUID, "aporkalypse._phase", "aporkalypsephasedirty")
    self._phase:set(PHASES.calm)

    if _ismastersim then
        local stagefunc = function()
            -- print("aporkalypsephase:", self._phase:value())
            -- print("aporkalypsebegindate:", self.begin_date / daytime)
            -- print("aporkalypsenowadays:", GetTimeTnSeconds() / daytime)
            -- print("fiestadate:", self.fiesta_begin_date / daytime)

            if self._phase:value() <= PHASES.calm then
                if GetTimeTnSeconds() >= (self.begin_date - self.near_days) then
                    self._phase:set(PHASES.near)
                end
            end

            if self._phase:value() <= PHASES.near then
                if GetTimeTnSeconds() >= self.begin_date then
                    self._phase:set(PHASES.aporkalypse)
                    self.real_start_date = GetTimeTnSeconds()
                    self:ScheduleAporkalypseTasks()
                end
            elseif self._phase:value() == PHASES.aporkalypse then
                if GetTimeTnSeconds() > self.begin_date then
                    if (GetTimeTnSeconds() - self.real_start_date) >= self.aporkalypse_duration then
                        self._phase:set(PHASES.fiesta)
                        self.fiesta_begin_date = GetTimeTnSeconds()
                        self:ScheduleAporkalypse()
                        self.first_time = false
                    end
                else
                    if (GetTimeTnSeconds() - self.real_start_date) >= self.should_fiesta_duration then
                        self._phase:set(PHASES.fiesta)
                        self.fiesta_begin_date = GetTimeTnSeconds()
                        self.first_time = false
                    else
                        self._phase:set(PHASES.calm)
                        self.first_time = false
                    end
                end
            end

            if self._phase:value() == PHASES.fiesta then
                local fiesta_elapsed = GetTimeTnSeconds() - self.fiesta_begin_date
                if self.fiesta_duration - fiesta_elapsed < 0 then
                    self._phase:set(PHASES.calm)
                end
            end
        end

        function self:OnSave(data)
            return
            {
                phase = self._phase:value(),
                begin_date = self.begin_date,
                real_start_date = self.real_start_date,
                fiesta_begin_date = self.fiesta_begin_date,
                first_time = self.first_time,
            }
        end

        function self:OnLoad(data)
            if data then
                self._phase:set(data.phase or PHASES.calm) --这里也会推送事件，所以不用手动推送了
                self.fiesta_begin_date = data.fiesta_begin_date
                self.first_time = data.first_time
                self.real_start_date = data.real_start_date
                self.begin_date = data.begin_date or (GetTimeTnSeconds() + (120 * daytime))
            end
        end

        function self:ScheduleAporkalypse(date)
            local currentTime = GetTimeTnSeconds()
            local delta = date and (date - GetTimeTnSeconds()) or self.periodtime
            while delta > self.periodtime do
                delta = delta % self.periodtime
            end

            while delta < 0 do
                delta = delta + self.periodtime
            end

            self.begin_date = currentTime + delta

            SendModRPCToShard(SHARD_MOD_RPC["Tropical adventures"]["aporkalypse begin date"], nil, self.begin_date)
        end

        function self:ScheduleAporkalypseTasks()
            if _world:HasTag("cave") then
                self.inst:DoTaskInTime(TUNING.SEG_TIME, function()
                    self:ScheduleHeraldCheck()
                end)
            end
            self.inst:DoTaskInTime(TUNING.SEG_TIME, function()
                self:ScheduleVampireBatCheck()
            end)
        end

        function self:ScheduleHeraldCheck()
            self.herald_check_task = self.inst:StartThread(function()
                Sleep(math.random(TUNING.SEG_TIME / 2, TUNING.SEG_TIME))
                while self:IsActive() do
                    for _, player in ipairs(AllPlayers) do ----isinworld好像不太对
                        if player and player:IsInWorld() and player:IsValid() and player.components.health and not player.components.health:IsDead() then
                            local herald = GetClosestInstWithTag("ancient", player, 30)
                            if not herald then
                                local valid_position = FindNearbyLand(player:GetPosition())
                                if valid_position then herald = SpawnAt("ancient_herald", valid_position) end
                            end
                            if herald and herald.components.combat then
                                herald.components.combat:SuggestTarget(player)
                                break
                            end
                        end
                    end
                    Sleep(math.random(TUNING.SEG_TIME / 2, TUNING.SEG_TIME))
                end
            end)
        end

        function self:ScheduleVampireBatCheck()
            self.vampire_check_task = self.inst:StartThread(function()
                Sleep(math.random(TUNING.SEG_TIME / 8, TUNING.SEG_TIME / 4))
                if self:IsActive() then
                    local _num = math.ceil(math.min(24 * #AllPlayers, 50) / #AllPlayers)
                    for _, player in ipairs(AllPlayers) do
                        if player and player:IsInWorld() and player:IsValid() and player.components.health and not player.components.health:IsDead() then
                            for i = 1, _num do
                                local x, y, z = player.Transform:GetWorldPosition()
                                local theta = math.random() * TWOPI
                                local r = 4 + math.random() * 16
                                x = x + r * math.sin(theta)
                                z = z + r * math.cos(theta)
                                local vampirebat = SpawnAt("circlingbat", Vector3(x, 0, z))
                                if vampirebat and vampirebat.components.combat then
                                    vampirebat.components.combat:SuggestTarget(player)
                                end
                            end
                        end
                    end
                end
            end)
        end

        inst:ListenForEvent("clocktick", stagefunc, _world)
    end

    function self:IsNear()
        return self._phase:value() == PHASES.near
    end

    function self:GetBeginDate()
        return self.begin_date
    end

    function self:IsActive()
        return self._phase:value() == PHASES.aporkalypse
    end

    function self:GetFiestaActive()
        return self._phase:value() == PHASES.fiesta
    end

    function self:OnUpdate(dt)
        -- print("try update aporkalypse")
        if _phasedirty then
            -- print("aporkalypse phase changed:", PHASE_NAMES[self._phase:value()])
            _world:PushEvent("aporkalypsephasechanged", PHASE_NAMES[self._phase:value()])
            _phasedirty = false
        end
        if _ismastersim then end
    end

    self.LongUpdate = self.OnUpdate

    inst:ListenForEvent("aporkalypsephasedirty", function() _phasedirty = true end)

    inst:StartUpdatingComponent(self)
end)
