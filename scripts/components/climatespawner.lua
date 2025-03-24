--------------------------------------------------------------------------
--[[ BirdSpawner class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
    assert(TheWorld.ismastersim, "BirdSpawner should not exist on client")

    --------------------------------------------------------------------------
    --[[ Constants ]]
    --------------------------------------------------------------------------

    local WAVE_TYPES =
    {
        [GROUND.OCEAN_HAZARDOUS] = { "wave_ripple" },
        [GROUND.OCEAN_ROUGH] = { "wave_ripple" },
        [GROUND.OCEAN_SWELL] = { "wave_ripple" },
    }

    --------------------------------------------------------------------------
    --[[ Member variables ]]
    --------------------------------------------------------------------------

    --Public
    self.inst = inst


    --Private
    local _activeplayers = {}
    local _scheduledtasks = {}
    local _world = TheWorld
    local map = _world.Map
    local _worldstate = _world.state
    local _map = _world.Map
    local _groundcreep = _world.GroundCreep
    local _updating = true
    local _generated = {}
    local _maxvalue = 100 --numero de efeitos de agua
    local _minspawndelay = 2
    local _maxspawndelay = 6
    local wind_level = 4
    local hail_level = 4

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------
    local function SpawnBirdForPlayer(player, reschedule)
        local pt = player:GetPosition()
        local ex, ey, ez = pt:Get()


        ----删除bramble
        ----删除火山喷发
        ---删除flood

        ---------------------------- hail----------------------------------------
        if TUNING.hail then
            if player:IsInShipwreckedArea() then
                if _worldstate.israining and _worldstate.isspring and math.random() < 0.07 then
                    hail_level = hail_level - 3
                end

                if _worldstate.issnowing and _worldstate.iswinter and math.random() < 0.13 then
                    hail_level = hail_level - 3
                end

                if hail_level <= 0 then
                    local hail = SpawnPrefab("hail_ice")
                    hail.Transform:SetPosition(ex + math.random(-15, 15), 35, ez + math.random(-15, 15))

                    hail_level = 4
                end
            end
        end

        ---------------------------------------------wind -------------------------------------------------------------
        if TUNING.wind then
            if player:IsInTropicalArea() then
                if _worldstate.israining and _worldstate.isspring and math.random() < 0.13 then
                    wind_level = wind_level - 1
                end
                if _worldstate.issnowing and _worldstate.iswinter and math.random() < 0.07 then
                    wind_level = wind_level - 1
                end
                if _worldstate.israining and _worldstate.isautumn and math.random() < 0.02 then
                    wind_level = wind_level - 1
                end

                if wind_level <= 0 then
                    local vento = SpawnPrefab("ventania")
                    vento.Transform:SetPosition(ex, 0, ez)
                    wind_level = 4
                end
            end
        end
        ---------------------------------------------waves------------------------------------------------------
        if TUNING.waves then
            local spawnpoint = self:GetSpawnPoint(pt)
            local sx, sy, sz = spawnpoint:Get()
            local tile = _map:GetTileAtPoint(spawnpoint:Get())


            local prefab = GetRandomItem(WAVE_TYPES[tile])
            if prefab ~= nil then
                if (_worldstate.issummer or _worldstate.moonphase == "new") and math.random() > 0.10 then
                    prefab = "rogue_wave"
                elseif (_worldstate.iswinter or _worldstate.moonphase == "full") and math.random() < 0.3 then
                    prefab = "rogue_wave"
                end

                if IsOceanTile(tile) and not TheWorld.Map:IsPassableAtPoint(sx, sy, sz) then
                    local wave = SpawnPrefab(prefab)
                    wave.Transform:SetPosition(spawnpoint:Get())

                    if _worldstate.isday then
                        wave.Transform:SetRotation(90)
                        if prefab == "rogue_wave" then
                            wave.Physics:SetMotorVel(6, 0, 6)
                        else
                            wave.Physics:SetMotorVel(2, 0, 2)
                        end
                    else
                        wave.Transform:SetRotation(-90)
                        if prefab == "rogue_wave" then
                            wave.Physics:SetMotorVel(6, 0, 6)
                        else
                            wave.Physics:SetMotorVel(2, 0, 2)
                        end
                    end
                end
            end
        end

        _scheduledtasks[player] = nil
        reschedule(player)
    end

    local function ScheduleSpawn(player, initialspawn)
        if _scheduledtasks[player] == nil then
            _scheduledtasks[player] = player:DoTaskInTime(0.6, SpawnBirdForPlayer, ScheduleSpawn)
        end
    end

    local function CancelSpawn(player)
        if _scheduledtasks[player] ~= nil then
            _scheduledtasks[player]:Cancel()
            _scheduledtasks[player] = nil
        end
    end

    local function AutoRemoveTarget(inst, target)
        if _generated[target] ~= nil and target:IsAsleep() then
            target:Remove()
        end
    end

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function OnTargetSleep(target)
        inst:DoTaskInTime(0, AutoRemoveTarget, target)
    end


    local function OnPlayerJoined(src, player)
        for i, v in ipairs(_activeplayers) do
            if v == player then
                return
            end
        end
        table.insert(_activeplayers, player)
        if _updating then
            ScheduleSpawn(player, true)
        end
    end

    local function OnPlayerLeft(src, player)
        for i, v in ipairs(_activeplayers) do
            if v == player then
                CancelSpawn(player)
                table.remove(_activeplayers, i)
                return
            end
        end
    end

    --------------------------------------------------------------------------
    --[[ Initialization ]]
    --------------------------------------------------------------------------

    --Initialize variables
    for i, v in ipairs(AllPlayers) do
        table.insert(_activeplayers, v)
    end

    --Register events
    inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
    inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

    --------------------------------------------------------------------------
    --[[ Public member functions ]]
    --------------------------------------------------------------------------

    function self:SetSpawnTimes(delay)
        print "DEPRECATED: SetSpawnTimes() in birdspawner.lua, use birdattractor.spawnmodifier instead"
        _minspawndelay = delay.min
        _maxspawndelay = delay.max
    end

    function self:GetSpawnPoint(pt)
        --We have to use custom test function because birds can't land on creep
        local function TestSpawnPoint(offset)
            local spawnpoint = pt + offset
            return not _groundcreep:OnCreep(spawnpoint:Get())
        end

        local theta = math.random() * 2 * PI
        local radius = 2 + math.random() * 25
        local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

        if resultoffset ~= nil then
            return pt + resultoffset
        end
    end

    function self.StartTrackingFn(target)
        if _generated[target] == nil then
            _generated[target] = target.persists == true
            target.persists = false
            inst:ListenForEvent("entitysleep", OnTargetSleep, target)
        end
    end

    function self:StartTracking(target)
        self.StartTrackingFn(target)
    end

    function self.StopTrackingFn(target)
        local restore = _generated[target]
        if restore ~= nil then
            target.persists = restore
            _generated[target] = nil
            inst:RemoveEventCallback("entitysleep", OnTargetSleep, target)
        end
    end

    function self:StopTracking(target)
        self.StopTrackingFn(target)
    end

    --------------------------------------------------------------------------
    --[[ Save/Load ]]
    --------------------------------------------------------------------------

    function self:OnSave()
        return
        {
            maxbirds = _maxvalue,
            minspawndelay = _minspawndelay,
            maxspawndelay = _maxspawndelay,
        }
    end

    function self:OnLoad(data)
        _maxvalue = data.maxbirds or TUNING.BIRD_SPAWN_MAX
        _minspawndelay = data.minspawndelay or TUNING.BIRD_SPAWN_DELAY.min
        _maxspawndelay = data.maxspawndelay or TUNING.BIRD_SPAWN_DELAY.max
    end

    --------------------------------------------------------------------------
    --[[ Debug ]]
    --------------------------------------------------------------------------

    function self:GetDebugString()
        local numbirds = 0
        for k, v in pairs(_generated) do
            numbirds = numbirds + 1
        end
        return string.format("birds:%d/%d", numbirds, _maxvalue)
    end

    --------------------------------------------------------------------------
    --[[ End ]]
    --------------------------------------------------------------------------
end)
