local state, SeasonClock = pcall(require, "widgets/seasonclock")
if not state then return end
local seasonmap = {
    sw = {
        autumn = "MILD",
        winter = "WET",
        spring = "GREEN",
        summer = "DRY",
    },
    ham = {
        autumn = "TEMPERATE",
        winter = "HUMID",
        spring = "LUSH",
        summer = "TEMPERATE",
    },
}
local GetSeasonString = SeasonClock.GetSeasonString
function SeasonClock:GetSeasonString()
    local str = GetSeasonString(self)
    -- print("SEASON", str)
    if ThePlayer and TheWorld then
        local season = TheWorld.state.season
        if ThePlayer:IsInShipwreckedArea() then
            str = STRINGS.UI.SANDBOXMENU[seasonmap.sw[season]] or str
        elseif ThePlayer:IsInHamletArea() then
            str = STRINGS.UI.SANDBOXMENU[seasonmap.ham[season]] or str
        end
    end
    -- print("SEASON", str)
    return str
end
