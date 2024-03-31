local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

TAENV.AddComponentPostInit("wildfires", function(cmp)
    local ForceWildfireForPlayer
    local _LightFireForPlayer, _fn_i, scope_fn
    for i, v in ipairs(cmp.inst.event_listening["ms_lightwildfireforplayer"][cmp.inst]) do
        _LightFireForPlayer, _fn_i, scope_fn = UpvalueHacker.GetUpvalue(v, "LightFireForPlayer")
        if _LightFireForPlayer then
            ForceWildfireForPlayer = v
            break
        end
    end

    local _scheduledtasks = UpvalueHacker.GetUpvalue(_LightFireForPlayer, "_scheduledtasks")

    debug.setupvalue(scope_fn, _fn_i, function(player, reschedule, ...)
        if IsInIAClimate(player) then
            _scheduledtasks[player] = nil
            reschedule(player)
        else
            _LightFireForPlayer(player, reschedule, ...)
        end
    end)
end)
