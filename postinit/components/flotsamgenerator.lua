local Utils = require("tools/utils")
----海上漂浮物刷新
local flotsam_prefabs
AddComponentPostInit("flotsamgenerator", function(self)
    if not flotsam_prefabs then
        flotsam_prefabs = Utils.ChainFindUpvalue(self.SpawnFlotsam, "PickFlotsam", "flotsam_prefabs")
        if flotsam_prefabs then
            flotsam_prefabs["waterygrave"] = 1
            flotsam_prefabs["redbarrel"] = 1
            flotsam_prefabs["luggagechest_spawner"] = 1
            flotsam_prefabs["messagebottle1"] = 1
        end
    end
end)
