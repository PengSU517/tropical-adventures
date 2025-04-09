if not env then return end
local Utils = require("tools/utils")
local AddPlayerPostInit = env.AddPlayerPostInit
local initprint = Utils.FindUpvalue(AddPlayerPostInit, "initprint")

env.AddPlayerPostInit = function(fn)
	if initprint then initprint "AddPlayerPostInit_Overrided" end
    if env.postinitfns.ComponentPostInit["playervision"] == nil then
        env.postinitfns.ComponentPostInit["playervision"] = {}
    end
    table.insert(env.postinitfns.ComponentPostInit["playervision"],
                 function(self) pcall(fn, self and self.inst) end)
end
