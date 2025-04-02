local Edible = require("components/edible")
local _OnEaten = Edible.OnEaten
function Edible:OnEaten(eater, ...)
    if eater and self.antihistamine and eater.components.hayfever then
        eater.components.hayfever:SetNextSneezeTime(self.antihistamine)
    end

    _OnEaten(self, eater, ...)
end
