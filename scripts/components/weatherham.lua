--------------------------------------------------------------------------
--[[ Weather class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)
    --------------------------------------------------------------------------
    --[[ Fog constants ]]
    --------------------------------------------------------------------------

    -- fog is a rain type, when humid season, it will moisture greater than 900, will start fog and stop rain fx

    local FOG_STATES =
    {
        inactive = false,
        active = true,
    }

    local POLLEN_STATES =
    {
        inactive = false,
        active = true,
    }

    local POLLEN_PARTICLES = 10000

    --------------------------------------------------------------------------
    --[[ Member variables ]]
    --------------------------------------------------------------------------

    -- Public
    self.inst = inst

    -- Private
    local _world = TheWorld
    local _state = _world.state
    local _ismastersim = _world.ismastersim
    local _activatedplayer = nil

    local _season = "autumn"
    local _seasonprogress = 0

    -- Dedicated server does not need to spawn the local fx
    local _hasfx = not TheNet:IsDedicated()
    local _pollendustfx = _hasfx and SpawnPrefab("pollendust") or nil

    -- Network
    local _fogstate = net_bool(inst.GUID, "weatherham._fogstate")
    local _fograte = net_float(inst.GUID, "weatherham._fograte")
    local _pollenduststate = net_bool(inst.GUID, "weather._pollenduststate")
    local _pollendustrate = net_float(inst.GUID, "weather._pollendustrate")

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------


    local function PushWeather()
        local data =
        {
            fogstate = _fogstate:value(),
            fograte = _fograte:value(),
            pollenduststate = _pollenduststate:value(),
            pollendustrate = _pollendustrate:value(),
        }
        -- print("PushEvent hamweathertick")
        _world:PushEvent("hamweathertick", data)
    end

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function OnSeasonTick(src, data)
        _season = data.season
        _seasonprogress = data.progress
    end

    local function OnPlayerActivated(src, player)
        _activatedplayer = player
        if _hasfx then
            _pollendustfx.entity:SetParent(player.entity)
            self:OnPostInit()
        end
    end

    local function OnPlayerDeactivated(src, player)
        if _activatedplayer == player then
            _activatedplayer = nil
        end
        if _hasfx then
            _pollendustfx.entity:SetParent(nil)
        end
    end

    local OnPlayerJoined = _ismastersim and function(src, player) end or nil
    local OnPlayerLeft = _ismastersim and function(src, player) end or nil

    --------------------------------------------------------------------------
    --[[ Public functions ]]
    --------------------------------------------------------------------------

    if _ismastersim then

    end

    --------------------------------------------------------------------------
    --[[ Initialization ]]
    --------------------------------------------------------------------------

    --Initialize network variables
    _fogstate:set(FOG_STATES.inactive)
    _fograte:set(0)
    _pollenduststate:set(POLLEN_STATES.inactive)
    _pollendustrate:set(0)


    -- Dedicated server does not need to spawn the local fx
    if _hasfx then
        -- Initialize pollen
        _pollendustfx.particles_per_tick = 0
    end

    -- Register network variable sync events
    inst:ListenForEvent("seasontick", OnSeasonTick, _world)
    inst:ListenForEvent("playeractivated", OnPlayerActivated, _world)
    inst:ListenForEvent("playerdeactivated", OnPlayerDeactivated, _world)


    if _ismastersim then
        -- Register master simulation events
        inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, _world)
        inst:ListenForEvent("ms_playerleft", OnPlayerLeft, _world)
    end

    PushWeather()
    inst:StartUpdatingComponent(self)

    --------------------------------------------------------------------------
    --[[ Post initialization ]]
    --------------------------------------------------------------------------

    if _hasfx then
        function self:OnPostInit()
            _pollendustfx:PostInit()
        end
    end

    --------------------------------------------------------------------------
    --[[ Deinitialization ]]
    --------------------------------------------------------------------------

    if _hasfx then
        function self:OnRemoveEntity()
            if _pollendustfx.entity:IsValid() then
                _pollendustfx:Remove()
            end
        end
    end

    --------------------------------------------------------------------------
    --[[ Update ]]
    --------------------------------------------------------------------------

    function self:OnUpdate(dt)
        -- Update fog
        -- fog is created instead of rain during the humid season when it should rain and the atmo moisture is above a threshold
        -- client fog state wait for server sync
        -- print("OnUpdate weatherham")
        if _ismastersim then
            if _state.iswinter and _state.moistureceil > TUNING.FOG_MOISTURE_RATE then
                _fogstate:set(FOG_STATES.active)
                _fograte:set(_state.precipitationrate)
            else
                _fogstate:set(FOG_STATES.inactive)
                _fograte:set(0)
            end

            -- Update pollen
            if _state.issummer then ----究竟该是春季还是夏季呢
                local plrate = math.abs(_seasonprogress - 0.5) * 2
                _pollenduststate:set(POLLEN_STATES.active)
                _pollendustrate:set(plrate)
            else
                _pollenduststate:set(POLLEN_STATES.inactive)
                _pollendustrate:set(0)
            end
        end

        -- Update pollen
        if _hasfx then
            if _activatedplayer and _activatedplayer:AwareInHamletArea() then
                _pollendustfx.particles_per_tick = _pollendustrate:value() * POLLEN_PARTICLES
            else
                _pollendustfx.particles_per_tick = 0
            end
        end

        PushWeather()
    end

    self.LongUpdate = self.OnUpdate

    --------------------------------------------------------------------------
    --[[ Save/Load ]]
    --------------------------------------------------------------------------

    if _ismastersim then
        function self:OnSave()
            return
            {
                fog = _fogstate:value(),
                fograte = _fograte:value(),
                pollendust = _pollenduststate:value(),
                pollendustrate = _pollendustrate:value(),

            }
        end
    end

    if _ismastersim then
        function self:OnLoad(data)
            _fogstate:set(data.fogstate or FOG_STATES.inactive)
            _fograte:set(data.fograte or 0)
            _pollenduststate:set(data.fogstate or FOG_STATES.inactive)
            _pollendustrate:set(data.fograte or 0)
            PushWeather()
        end
    end


    --------------------------------------------------------------------------
    --[[ End ]]
    --------------------------------------------------------------------------
end)
