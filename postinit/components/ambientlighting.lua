local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
local ambientlighting = require("components/ambientlighting")

local BAT_COLOURS =
{
    PHASE_COLOURS =
    {
        default =
        {
            day = { colour = Point(40 / 255, 40 / 255, 40 / 255), time = 4 },
            dusk = { colour = Point(120 / 255, 120 / 255, 120 / 255), time = 6 },
            night = { colour = Point(120 / 255, 120 / 255, 120 / 255), time = 8 },
        },
    },

    FULL_MOON_COLOUR = { colour = Point(120 / 255, 120 / 255, 120 / 255), time = 8 },
    CAVE_COLOUR = { colour = Point(120 / 255, 120 / 255, 120 / 255), time = 2 },
}



TROENV.AddComponentPostInit("ambientlighting", function(self)
    self.underwater = false
    self.aporkalypse = false
    -- cmp.SetWaveSettings = SetWaveSettings

    local oldpushcurrentcolor = self.PushCurrentColour
    function self:PushCurrentColour()
        if _flashstate <= 0 then
            TheSim:SetAmbientColour(_realcolour.currentcolour.x * _realcolour.lightpercent,
                _realcolour.currentcolour.y * _realcolour.lightpercent,
                _realcolour.currentcolour.z * _realcolour.lightpercent)
            TheSim:SetVisualAmbientColour(_overridecolour.currentcolour.x * _overridecolour.lightpercent,
                _overridecolour.currentcolour.y * _overridecolour.lightpercent,
                _overridecolour.currentcolour.z * _overridecolour.lightpercent)
        else
            oldpushcurrentcolor()
        end
    end

    local function OnOverrideAmbientLighting(inst, colour)
        if colour ~= (_overridefixedcolour ~= nil and _overridefixedcolour.colour or nil) then
            _overridefixedcolour = colour ~= nil and { colour = Point(colour:Get()) } or nil
            ComputeTargetColour(_realcolour, 0)
            ComputeTargetColour(_overridecolour, 0)
            PushCurrentColour()
        end
    end

    local function OnPhaseChanged(src, phase)
        _phase = phase
        _isfullmoon = phase == "night" and _moonphase == "full"

        ComputeTargetColour(_realcolour)
        ComputeTargetColour(_overridecolour)
        PushCurrentColour()

        if self.aporkalypse == true then
            OnOverrideAmbientLighting(true, Point(200 / 255, 0 / 255, 0 / 255))
        end

        if self.underwater == true then
            if TUNING.tropical.removedark ~= true then
                OnOverrideAmbientLighting(true, Point(20 / 255, 20 / 255, 20 / 255))
            end
        end
    end
end)
