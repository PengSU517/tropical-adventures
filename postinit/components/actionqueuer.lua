-- for client mod ActionQueue
AddComponentPostInit("actionqueuer", function(self)
    if self.AddActionList then
        self.AddActionList("allclick", "HACK", "HACK1")
        self.AddActionList("leftclick", "HACK", "HACK1")
        self.AddActionList("autocollect", "HACK", "HACK1")
        self.AddActionList("noworkdelay", "HACK", "HACK1")
    end
end)
