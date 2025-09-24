local state, SeasonClock = pcall(require, "widgets/seasonclock")
if not state then return end


local seasonmap = {
    sw = {
        autumn = "mild",
        winter = "wet",
        spring = "green",
        summer = "dry",
    },
    ham = {
        autumn = "temperate",
        winter = "humid",
        spring = "lush",
        summer = "summer",
    },
}

AddClassPostConstruct("widgets/seasonclock", function(self)
    ThePlayer:ListenForEvent("regionchange_client", function(inst, data)
        if ThePlayer and TheWorld then
            self:OnCyclesChanged()
            self:OnSeasonLengthsChanged()
        end
    end)



    local GetSeasonString = self.GetSeasonString
    function self:GetSeasonString()
        local str = GetSeasonString(self)
        -- print("SEASON", str)
        if ThePlayer and TheWorld then
            local season = TheWorld.state.season
            if ThePlayer:IsInShipwreckedArea() then
                str = STRINGS.UI.SANDBOXMENU[string.upper(seasonmap.sw[season])] or str
            elseif ThePlayer:IsInHamletArea() then
                str = STRINGS.UI.SANDBOXMENU[string.upper(seasonmap.ham[season])] or str
            end
        end
        -- print("SEASON", str)
        return str
    end
end)
