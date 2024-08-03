local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
-- local groundpounder = require("components/groundpounder")

TROENV.AddComponentPostInit("groundpounder", function(self)
    table.insert(self.noTags, "groundpoundimmune")
end)
