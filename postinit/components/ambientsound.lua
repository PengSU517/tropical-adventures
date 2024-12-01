local ambient_sounds =
{
    --TODO需要重新整理地皮
    --shipwrecked
    [GROUND.JUNGLE or 65536] = { sound = "dontstarve_DLC002/mild/jungleAMB", mildsound = "dontstarve_DLC002/mild/jungleAMB", wintersound = "dontstarve_DLC002/wet/jungleAMB", springsound = "dontstarve_DLC002/green/jungleAMB", summersound = "dontstarve_DLC002/dry/jungleAMB", rainsound = "dontstarve_DLC002/rain/jungleAMB", hurricanesound = "dontstarve_DLC002/hurricane/jungleAMB" },
    [GROUND.BEACH or 65536] = { sound = "dontstarve_DLC002/mild/beachAMB", mildsound = "dontstarve_DLC002/mild/beachAMB", wintersound = "dontstarve_DLC002/wet/beachAMB", springsound = "dontstarve_DLC002/green/beachAMB", summersound = "dontstarve_DLC002/dry/beachAMB", rainsound = "dontstarve_DLC002/rain/beachAMB", hurricanesound = "dontstarve_DLC002/hurricane/beachAMB" },
    [GROUND.SWAMP or 65536] = { sound = "dontstarve_DLC002/mild/marshAMB", mildsound = "dontstarve_DLC002/mild/marshAMB", wintersound = "dontstarve_DLC002/wet/marshAMB", springsound = "dontstarve_DLC002/green/marshAMB", summersound = "dontstarve_DLC002/dry/marshAMB", rainsound = "dontstarve_DLC002/rain/marshAMB", hurricanesound = "dontstarve_DLC002/hurricane/marshAMB" },
    [GROUND.MAGMAFIELD or 65536] = { sound = "dontstarve/rocky/rockyAMB", mildsound = "dontstarve_DLC002/mild/rockyAMB", wintersound = "dontstarve_DLC002/wet/rockyAMB", springsound = "dontstarve_DLC002/green/rockyAMB", summersound = "dontstarve_DLC002/dry/rockyAMB", rainsound = "dontstarve/rain/rainrockyAMB", hurricanesound = "dontstarve_DLC002/hurricane/rockyAMB" },
    [GROUND.TIDALMARSH or 65536] = { sound = "dontstarve_DLC002/mild/marshAMB", mildsound = "dontstarve_DLC002/mild/marshAMB", wintersound = "dontstarve_DLC002/wet/marshAMB", springsound = "dontstarve_DLC002/green/marshAMB", summersound = "dontstarve_DLC002/dry/marshAMB", rainsound = "dontstarve_DLC002/rain/marshAMB", hurricanesound = "dontstarve_DLC002/hurricane/marshAMB" },
    [GROUND.MEADOW or 65536] = { sound = "dontstarve_DLC002/mild/grasslandAMB", rainsound = "dontstarve/rain/raingrasslandAMB", mildsound = "dontstarve_DLC002/mild/grasslandAMB", wintersound = "dontstarve_DLC002/wet/grasslandAMB", springsound = "dontstarve_DLC002/green/grasslandAMB", summersound = "dontstarve_DLC002/dry/grasslandAMB", hurricanesound = "dontstarve_DLC002/hurricane/grasslandAMB" },
    [GROUND.OCEAN_SHALLOW or 65536] = { sound = "dontstarve_DLC002/mild/ocean_shallow", mildsound = "dontstarve_DLC002/mild/ocean_shallow", wintersound = "dontstarve_DLC002/wet/ocean_shallowAMB", springsound = "dontstarve_DLC002/green/ocean_shallowAMB", summersound = "dontstarve_DLC002/dry/ocean_shallow", rainsound = "dontstarve_DLC002/rain/ocean_shallowAMB", hurricanesound = "dontstarve_DLC002/hurricane/ocean_shallowAMB" },
    [GROUND.OCEAN_MEDIUM or 65536] = { sound = "dontstarve_DLC002/mild/ocean_shallow", mildsound = "dontstarve_DLC002/mild/ocean_shallow", wintersound = "dontstarve_DLC002/wet/ocean_shallowAMB", springsound = "dontstarve_DLC002/green/ocean_shallowAMB", summersound = "dontstarve_DLC002/dry/ocean_shallow", rainsound = "dontstarve_DLC002/rain/ocean_shallowAMB", hurricanesound = "dontstarve_DLC002/hurricane/ocean_shallowAMB" },
    [GROUND.OCEAN_DEEP or 65536] = { sound = "dontstarve_DLC002/mild/ocean_deep", mildsound = "dontstarve_DLC002/mild/ocean_deep", wintersound = "dontstarve_DLC002/wet/ocean_deepAMB", springsound = "dontstarve_DLC002/green/ocean_deepAMB", summersound = "dontstarve_DLC002/dry/ocean_deep", rainsound = "dontstarve_DLC002/rain/ocean_deepAMB", hurricanesound = "dontstarve_DLC002/hurricane/ocean_deepAMB" },
    [GROUND.OCEAN_SHIPGRAVEYARD or 65536] = { sound = "dontstarve_DLC002/mild/ocean_deep", mildsound = "dontstarve_DLC002/mild/ocean_deep", wintersound = "dontstarve_DLC002/wet/ocean_deepAMB", springsound = "dontstarve_DLC002/green/ocean_deepAMB", summersound = "dontstarve_DLC002/dry/ocean_deep", rainsound = "dontstarve_DLC002/rain/ocean_deepAMB", hurricanesound = "dontstarve_DLC002/hurricane/ocean_deepAMB" },
    [GROUND.OCEAN_SHORE or 65536] = { sound = "dontstarve_DLC002/mild/waves", mildsound = "dontstarve_DLC002/mild/waves", wintersound = "dontstarve_DLC002/wet/waves", springsound = "dontstarve_DLC002/green/waves", summersound = "dontstarve_DLC002/dry/waves", rainsound = "dontstarve_DLC002/rain/waves", hurricanesound = "dontstarve_DLC002/hurricane/waves" },
    [GROUND.OCEAN_CORAL or 65536] = { sound = "dontstarve_DLC002/mild/coral_reef", mildsound = "dontstarve_DLC002/mild/coral_reef", wintersound = "dontstarve_DLC002/wet/coral_reef", springsound = "dontstarve_DLC002/green/coral_reef", summersound = "dontstarve_DLC002/dry/coral_reef", rainsound = "dontstarve_DLC002/rain/coral_reef", hurricanesound = "dontstarve_DLC002/hurricane/coral_reef" },
    [GROUND.MANGROVE or 65536] = { sound = "dontstarve_DLC002/mild/mangrove", mildsound = "dontstarve_DLC002/mild/mangrove", wintersound = "dontstarve_DLC002/wet/mangrove", springsound = "dontstarve_DLC002/green/mangrove", summersound = "dontstarve_DLC002/dry/mangrove", rainsound = "dontstarve_DLC002/rain/mangrove", hurricanesound = "dontstarve_DLC002/hurricane/mangrove" },
    [GROUND.VOLCANO or 65536] = { sound = "dontstarve_DLC002/volcano_amb/ground_ash", dormantsound = "dontstarve_DLC002/volcano_amb/volano_dormant", activesound = "dontstarve_DLC002/volcano_amb/volano_active" },
    [GROUND.VOLCANO_ROCK or 65536] = { sound = "dontstarve_DLC002/volcano_amb/ground_ash", dormantsound = "dontstarve_DLC002/volcano_amb/volano_dormant", activesound = "dontstarve_DLC002/volcano_amb/volano_active" },
    [GROUND.VOLCANO_LAVA or 65536] = { dormantsound = "dontstarve_DLC002/volcano_amb/lava", activesound = "dontstarve_DLC002/volcano_amb/lava" },
    [GROUND.ASH or 65536] = { sound = "dontstarve_DLC002/volcano_amb/ground_ash", dormantsound = "dontstarve_DLC002/volcano_amb/volano_dormant", activesound = "dontstarve_DLC002/volcano_amb/volano_active" },

    --Porkland
    [GROUND.DEEPRAINFOREST or 65536] = { sound = "dontstarve_DLC003/amb/temperate/deep_rainforest", summersound = "dontstarve_DLC003/amb/warm/deep_rainforest", springsound = "dontstarve_DLC003/amb/warm/deep_rainforest", wintersound = "dontstarve_DLC003/amb/cold/deep_rainforest", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/deep_rainforest" },
    [GROUND.RAINFOREST or 65536] = { sound = "dontstarve_DLC003/amb/temperate/rainforest", summersound = "dontstarve_DLC003/amb/warm/rainforest", springsound = "dontstarve_DLC003/amb/warm/rainforest", wintersound = "dontstarve_DLC003/amb/cold/rainforest", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/rainforest" },
    [GROUND.FOUNDATION or 65536] = { sound = "dontstarve_DLC003/amb/temperate/city", summersound = "dontstarve_DLC003/amb/warm/city", springsound = "dontstarve_DLC003/amb/warm/city", wintersound = "dontstarve_DLC003/amb/cold/city", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/city" },
    [GROUND.COBBLEROAD or 65536] = { sound = "dontstarve_DLC003/amb/temperate/city", summersound = "dontstarve_DLC003/amb/warm/city", springsound = "dontstarve_DLC003/amb/warm/city", wintersound = "dontstarve_DLC003/amb/cold/city", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/city" },
    [GROUND.CHECKEREDLAWN or 65536] = { sound = "dontstarve_DLC003/amb/temperate/city", summersound = "dontstarve_DLC003/amb/warm/city", springsound = "dontstarve_DLC003/amb/warm/city", wintersound = "dontstarve_DLC003/amb/cold/city", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/city" },
    [GROUND.GASJUNGLE or 65536] = { sound = "dontstarve_DLC003/amb/temperate/gas_jungle", summersound = "dontstarve_DLC003/amb/warm/gas_jungle", springsound = "dontstarve_DLC003/amb/warm/gas_jungle", wintersound = "dontstarve_DLC003/amb/cold/gas_jungle", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/gas_jungle" },
    [GROUND.SUBURB or 65536] = { sound = "dontstarve_DLC003/amb/temperate/suburbs", summersound = "dontstarve_DLC003/amb/warm/suburbs", springsound = "dontstarve_DLC003/amb/warm/suburbs", wintersound = "dontstarve_DLC003/amb/cold/suburbs", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/suburbs" },
    [GROUND.FIELDS or 65536] = { sound = "dontstarve_DLC003/amb/temperate/fields", summersound = "dontstarve_DLC003/amb/warm/fields", springsound = "dontstarve_DLC003/amb/warm/fields", wintersound = "dontstarve_DLC003/amb/cold/fields", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/fields" },
    [GROUND.PLAINS or 65536] = { sound = "dontstarve_DLC003/amb/temperate/plains", summersound = "dontstarve_DLC003/amb/warm/plains", springsound = "dontstarve_DLC003/amb/warm/plains", wintersound = "dontstarve_DLC003/amb/cold/plains", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/plains" },
    [GROUND.PAINTED or 65536] = { sound = "dontstarve_DLC003/amb/temperate/painted", summersound = "dontstarve_DLC003/amb/warm/painted", springsound = "dontstarve_DLC003/amb/warm/painted", wintersound = "dontstarve_DLC003/amb/cold/painted", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/painted" },
    [GROUND.LILYPOND or 65536] = { sound = "dontstarve_DLC003/amb/temperate/lilypad", summersound = "dontstarve_DLC003/amb/warm/lilypad", springsound = "dontstarve_DLC003/amb/warm/lilypad", wintersound = "dontstarve_DLC003/amb/cold/lilypad", aporkalypse = "dontstarve_DLC003/amb/aporkalypse/lilypad" },

    ["STORE" or 65536] = { sound = "dontstarve_DLC003/amb/inside/store" },
    ["HOUSE" or 65536] = { sound = "dontstarve_DLC003/amb/inside/house" },
    ["PALACE" or 65536] = { sound = "dontstarve_DLC003/amb/inside/palace" },
    ["ANT_HIVE" or 65536] = { sound = "dontstarve_DLC003/amb/inside/ant_hive" },
    ["BAT_CAVE" or 65536] = { sound = "dontstarve_DLC003/amb/inside/bat_cave" },
    ["RUINS" or 65536] = { sound = "dontstarve_DLC003/amb/inside/ruins" },
}


AddComponentPostInit("ambientsound", function(self)
    local inst = self.inst
    AMBIENT_SOUNDS = upvaluehelper.Get(self.OnUpdate, "AMBIENT_SOUNDS")
    for name, v in pairs(ambient_sounds) do
        AMBIENT_SOUNDS[name] = v
    end
end)
