local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
local Armor = require("components/armor")

TROENV.AddComponentPostInit("Armor", function(self)

end)

function Armor:SetImmuneTags(tags)
    self.immunetags = tags
end

local oldcanresist = Armor.CanResist
function Armor:CanResist(attacker, weapon)
    if attacker and self.immunetags then
        for k, v in pairs(self.immunetags) do
            if attacker:HasTag(v) then
                return false
            end
        end
    end

    return oldcanresist
end
