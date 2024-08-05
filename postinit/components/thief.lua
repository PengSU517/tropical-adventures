local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
local Thief = require("components/thief")

TROENV.AddComponentPostInit("thief", function(self)
    self.canopencontainers = true
    self.dropdistance = 1.0
    self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
end)


function Thief:SetDropDistance(dropdistance)
    self.dropdistance = dropdistance
end

function Thief:SetCanOpenContainers(canopen)
    self.canopencontainers = canopen
end

function Thief:SetCanEatTestFn(fn)
    self.caneattest = fn
end

function Thief:AbleToEat(inst)
    if inst and inst.components.edible then
        for k, v in pairs(self.ablefoods) do
            if v == inst.components.edible.foodtype then
                if self.caneattest then
                    return self.caneattest(self.inst, inst)
                end
                return true
            end
        end
    end
end
