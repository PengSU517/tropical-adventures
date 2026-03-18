local _daytime = TUNING.TOTAL_DAY_TIME -- 480s
local _seg = TUNING.SEG_TIME -- 30s
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)

local function onbegindate(self, new)
    if TheWorld ~= nil then
        if TheWorld.shard ~= nil and TheWorld.shard._aporkalypse_begin_date ~= nil then
            TheWorld.shard._aporkalypse_begin_date:set(new)
        end
        if TheWorld.components.dsa_aporkalypse_proxy ~= nil then
            TheWorld.components.dsa_aporkalypse_proxy:SetDate(new)
        end
    end
end

local function onphase(self, new)
    if TheWorld ~= nil then
        if TheWorld.net ~= nil and TheWorld.net._aporkalypse_phase ~= nil then
            TheWorld.net._aporkalypse_phase:set(new)
        end
    end
end

return Class(function(self, inst)
    local _world = TheWorld
    --local _ismastersim = _world.ismastersim
    assert(_world.ismastersim, "aporkalypse should not exist on client")

    local function GetTimeTnSeconds()
        return (_world.state.cycles + _world.state.time) * _daytime
    end

    self.inst = inst

    self.first_time = true
    self.near_days = 7 * _daytime
    self.aporkalypse_duration = 20 * _daytime
    self.should_fiesta_duration = 3 * _daytime
    self.fiesta_duration = 7 * _daytime
    self.periodtime = 120 * _daytime

    self.begin_date = self.periodtime
    self.real_start_date = 0
    self.fiesta_begin_date = 0

    local _herald_check_timer = .0
    local _vampire_check_timer = .0

    local _phase = PHASES.calm

    --if _ismastersim then
    local stagefunc = function()
        -- print("aporkalypsephase:", _phase)
        -- print("aporkalypsebegindate:", self.begin_date / daytime)
        -- print("aporkalypsenowadays:", GetTimeTnSeconds() / daytime)
        -- print("fiestadate:", self.fiesta_begin_date / daytime)

        if _phase <= PHASES.calm then
            if GetTimeTnSeconds() >= (self.begin_date - self.near_days) then
                _phase = PHASES.near
            end
        end

        if _phase <= PHASES.near then
            if GetTimeTnSeconds() >= self.begin_date then
                _phase = PHASES.aporkalypse
                self.real_start_date = GetTimeTnSeconds()
                self:ScheduleAporkalypseTasks()
            end
        elseif _phase == PHASES.aporkalypse then
            if GetTimeTnSeconds() > self.begin_date then
                if (GetTimeTnSeconds() - self.real_start_date) >= self.aporkalypse_duration then
                    _phase = PHASES.fiesta
                    self.fiesta_begin_date = GetTimeTnSeconds()
                    self:ScheduleAporkalypse()
                    self.first_time = false
                end
            else
                if (GetTimeTnSeconds() - self.real_start_date) >= self.should_fiesta_duration then
                    _phase = PHASES.fiesta
                    self.fiesta_begin_date = GetTimeTnSeconds()
                    self.first_time = false
                else
                    _phase = PHASES.calm
                    self.first_time = false
                end
            end
        end

        if _phase == PHASES.fiesta then
            local fiesta_elapsed = GetTimeTnSeconds() - self.fiesta_begin_date
            if self.fiesta_duration - fiesta_elapsed < 0 then
                _phase = PHASES.calm
            end
        end
    end

    function self:OnSave(data)
        return
        {
            phase = _phase,
            begin_date = self.begin_date,
            real_start_date = self.real_start_date,
            fiesta_begin_date = self.fiesta_begin_date,
            first_time = self.first_time,
        }
    end

    function self:OnLoad(data)
        if data then
            _phase = data.phase or PHASES.calm --这里也会推送事件，所以不用手动推送了
            self.fiesta_begin_date = data.fiesta_begin_date
            self.first_time = data.first_time
            self.real_start_date = data.real_start_date
            self.begin_date = data.begin_date or (GetTimeTnSeconds() + (120 * _daytime))
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

        --SendModRPCToShard(SHARD_MOD_RPC["Tropical adventures"]["aporkalypse begin date"], nil, self.begin_date)
    end

    function self:ScheduleAporkalypseTasks()
        if _world:HasTag("cave") then
            self:ScheduleHeraldCheck()
        end
        self:ScheduleVampireBatCheck()
    end

    function self:ScheduleHeraldCheck()
        self.herald_check_task = self.inst:StartThread(function()
            Sleep(_seg)
            repeat
                _herald_check_timer = math.random(_seg / 2, _seg)
                Sleep(_herald_check_timer)
                for _, player in ipairs(AllPlayers) do
                    if player and player:IsValid() and player.components.health and not player.components.health:IsDead() then
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
            until not self:IsActive()
            self.herald_check_task = nil
            _herald_check_timer = 0
        end)
    end

    function self:ScheduleVampireBatCheck()
        self.vampire_check_task = self.inst:StartThread(function()
            _vampire_check_timer = math.random(_seg / 8, _seg / 4) + _seg
            Sleep(_vampire_check_timer)
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
            self.vampire_check_task = nil
            _vampire_check_timer = 0
        end)
    end

    inst:ListenForEvent("clocktick", stagefunc, _world)
    --end

    function self:GetHeraldTimer()
        return _herald_check_timer
    end

    function self:GetVampireTimer()
        return _vampire_check_timer
    end

    function self:IsNear()
        return _phase == PHASES.near
    end

    function self:GetBeginDate()
        return self.begin_date
    end

    function self:IsActive()
        return _phase == PHASES.aporkalypse
    end

    function self:GetFiestaActive()
        return _phase == PHASES.fiesta
    end

    function self:OnUpdate(dt)
        if _herald_check_timer and _herald_check_timer > .0 then
            _herald_check_timer = math.max(.0, _herald_check_timer - dt)
        end
        if _vampire_check_timer and _vampire_check_timer > .0 then
            _vampire_check_timer = math.max(.0, _vampire_check_timer - dt)
        end
    end

    self.LongUpdate = self.OnUpdate

    inst:StartUpdatingComponent(self)
end, nil, {
    begin_date = onbegindate,
    _phase = onphase,
})
