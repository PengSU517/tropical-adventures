local Utils = require("tools/utils")

AddComponentPostInit("boatphysics", function(self, inst)
    Utils.FnDecorator(self, "ApplyForce", function(self, dir_x, dir_z, force)
        if SWP_WAVEBREAK_EFFICIENCY.BOAT[self.inst.prefab] then
            force = force * math.max(1 - SWP_WAVEBREAK_EFFICIENCY.BOAT[self.inst.prefab], 0)
        end
        if self.inst.components.boatring then
            local bumper = self.inst.components.boatring:GetBumperAtPoint(dir_x, dir_z)
            if bumper and SWP_WAVEBREAK_EFFICIENCY.BUMPER["boat_bumper_" .. bumper.prefab] then
                force = force * math.max(1 - SWP_WAVEBREAK_EFFICIENCY.BUMPER["boat_bumper_" .. bumper.prefab], 0)
            end
        end
        return nil, false, {self, dir_x, dir_z, force}
    end)
end)
