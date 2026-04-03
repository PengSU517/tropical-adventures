local Armor = require "components/armor"

function Armor:AddNonresistTags(...)
    self.nonresisttags = self.nonresisttags or {}
    for _, tag in ipairs { ... } do
        table.insert(self.nonresisttags, tag)
    end
end

local CanResist = Armor.CanResist
function Armor:CanResist(attacker, ...)
    if attacker and self.nonresisttags then
        for k, v in ipairs(self.nonresisttags) do
            if attacker:HasTag(v) then
                return false
            end
        end
    end
    return CanResist(self, attacker, ...)
end
