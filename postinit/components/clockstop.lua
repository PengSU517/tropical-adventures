local Utils = require("tools/utils")

AddComponentPostInit("clock", function(Clock)
    Utils.FnDecorator(Clock, "OnUpdate", function(self, dt, ...)
        return nil, nil, { self, dt > FRAMES * 2 and dt or 0, ... }
    end)
end)
