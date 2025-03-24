--------------------------------------------------------------------------
--[[ Banditmanager class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Banditmanager should not exist on client")

    local CITY1_TAG = "City1"
    local CITY2_TAG = "City2"
    local BANDIT_TIMER_NAME = "pig_bandit_respawn_time_" -- one bandit for each city... one day

    -- Public
    self.inst = inst

    -- Private
    local _world = TheWorld
    local _map = _world.Map
    local _worldsettingstimer = _world.components.worldsettingstimer

    local _active_players = {}
    local _bandit
    local _stored_bandit

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function StartRespawnTimer(time)
        _worldsettingstimer:StopTimer(BANDIT_TIMER_NAME)
        _worldsettingstimer:StartTimer(BANDIT_TIMER_NAME, time or TUNING.PIG_BANDIT_RESPAWN_TIME, false)
    end

    local function OnBanditDeath(src, data)
        StartRespawnTimer(TUNING.PIG_BANDIT_DEATH_RESPAWN_TIME)
        _bandit = nil
    end

    local function OnBanditEscaped(src, data)
        if not (data and data.bandit and data.bandit:IsValid() and data.bandit == _bandit) then
            return
        end

        _bandit.components.health:SetPercent(1)
        _bandit.attacked = nil
        _stored_bandit = _bandit:GetSaveRecord()
        _bandit:Remove()
        _bandit = nil

        StartRespawnTimer()
    end

    local function OnPlayerJoined(src, player)
        for _, v in ipairs(_active_players) do
            if v == player then
                return
            end
        end
        table.insert(_active_players, player)
    end

    local function OnPlayerLeft(src, player)
        for i, v in ipairs(_active_players) do
            if v == player then
                table.remove(_active_players, i)
                return
            end
        end
    end

    local function IsPlayerInCity(player)
        local x, y, z = player.Transform:GetWorldPosition()
        local node_index = _map:GetNodeIdAtPoint(x, y, z)
        local node = _world.topology.nodes[node_index]
        if node == nil or node.tags == nil then
            return false
        end

        for _, tag in pairs(node.tags) do
            if tag == CITY1_TAG or tag == CITY2_TAG then
                return true
            end
        end
        return false
    end

    local function TrySpawnBanit()
        if self:GetIsBanditActive() then
            return
        end

        if _world.state.isaporkalypse then
            return
        end

        local choices = {}
        for _, player in pairs(_active_players) do
            if not IsEntityDeadOrGhost(player) and IsPlayerInCity(player) then
                choices[#choices + 1] = player
            end
        end
        local player = GetRandomItem(choices)

        if not player then
            return
        end

        local value = 0

        local oincs = player.components.inventory:GetItemsWithTag("oinc")
        for _, oinc in pairs(oincs) do
            value = value + oinc.oincvalue * oinc.components.stackable:StackSize()
        end

        if _world.state.isdusk then
            value = value * 1.5
        end
        if _world.state.isnight then
            value = value * 3
        end

        local chance = 1 / 100
        if value >= 150 then
            chance = 1 / 5
        elseif value >= 100 then
            chance = 1 / 10
        elseif value >= 50 then
            chance = 1 / 20
        elseif value >= 10 then
            chance = 1 / 40
        elseif value == 0 then
            chance = 0
        end

        local roll = math.random()
        if roll < chance then
            self:SpawnBanditOnPlayer(player)
        end
    end

    --------------------------------------------------------------------------
    --[[ Public member functions ]]
    --------------------------------------------------------------------------

    function self:SpawnBanditOnPlayer(player)
        if _bandit then
            print("already have a bandit in world!!!")
            return
        end

        local x, y, z = player.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 40, { "bandit_cover" })

        local cover = GetRandomItem(ents)

        if cover then
            if _stored_bandit then
                _bandit = SpawnSaveRecord(_stored_bandit)
                _stored_bandit = nil
            else
                _bandit = SpawnPrefab("pigbandit")
            end

            local cx, _, cz = cover.Transform:GetWorldPosition()
            local angle = TheCamera:GetHeadingTarget() * DEGREES
            cx = cx - 1 * math.cos(angle)
            cz = cz - 1 * math.sin(angle)

            _bandit.Transform:SetPosition(cx, 0, cz)
        end
    end

    function self:GetIsBanditActive()
        if _bandit and _bandit:IsValid() then
            return true
        else
            _bandit = nil
            return false
        end
    end

    --------------------------------------------------------------------------
    --[[ Initialization ]]
    --------------------------------------------------------------------------
    -- Initialize variables
    for i, v in ipairs(AllPlayers) do
        table.insert(_active_players, v)
    end

    -- Register events
    self.inst:ListenForEvent("bandit_death", OnBanditDeath)
    self.inst:ListenForEvent("bandit_escaped", OnBanditEscaped)
    self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, _world)
    self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, _world)

    _worldsettingstimer:AddTimer(BANDIT_TIMER_NAME, TUNING.PIG_BANDIT_RESPAWN_TIME, TUNING.PIG_BANDIT_ENABLED, function()
        TrySpawnBanit()
        if _bandit then
            _worldsettingstimer:StopTimer(BANDIT_TIMER_NAME)
        else
            StartRespawnTimer()
        end
    end)
    StartRespawnTimer()

    --------------------------------------------------------------------------
    --[[ Save/Load ]]
    --------------------------------------------------------------------------

    function self:OnSave()
        local refs = {}
        local data = {}

        if _bandit then
            data.bandit = _bandit.GUID
            table.insert(refs, _bandit.GUID)
        end

        if _stored_bandit then
            data.stored_bandit = _stored_bandit
        end

        return data, refs
    end

    function self:OnLoad(data)
        if not data then
            return
        end

        _stored_bandit = data.stored_bandit or nil
    end

    function self:LoadPostPass(ents, data)
        if data.bandit and ents[data.bandit] then
            _bandit = ents[data.bandit].entity
        end
    end

    --------------------------------------------------------------------------
    --[[ End ]]
    --------------------------------------------------------------------------
end)
