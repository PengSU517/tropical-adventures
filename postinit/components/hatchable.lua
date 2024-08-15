local Hatchable = require("components/hatchable")


function Hatchable:SetUpdateFn(fn)
    self.onupdatefn = fn
end

local _old_update = Hatchable.OnUpdate

function Hatchable:OnUpdate(dt)
    _old_update(self, dt)

    if self.onupdatefn then
        self.onupdatefn(self.inst, dt)
    end
end
