---------------------------------------------------------------------tira a neve----------------------------------------------------------------------------------------
if --[[GetModConfigData("disable_snow_effects") ==]] false then
    AddComponentPostInit("weather",
        function(self, inst)
            inst:ListenForEvent(
                "weathertick",
                function(inst, data)
                    if data and data.snowlevel
                    then
                        local newlevel = data.snowlevel <= 0 and data.snowlevel or 0
                        GLOBAL.TheWorld.Map:SetOverlayLerp(newlevel)
                    end
                end,
                GLOBAL.TheWorld
            )
        end
    )
end

if true then
    AddPrefabPostInit("world", function(world)
        local mapfuncs = GLOBAL.getmetatable(world.Map).__index
        local cover = mapfuncs.SetOverlayLerp
        mapfuncs.SetOverlayLerp = function(map, level, ...)
            return --[[ cover(map, 10, ...) ]]
        end
    end)
end
