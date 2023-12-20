---------------------------------------------------------------------tira a neve----------------------------------------------------------------------------------------
if GetModConfigData("disable_snow_effects") == true then
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
