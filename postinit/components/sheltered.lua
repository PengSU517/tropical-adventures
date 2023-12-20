----umidade interior------

local Sheltered = GLOBAL.require("components/sheltered")
local SHELTERED_MUST_TAGS = { "shelter" }
local SHELTERED_CANT_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "stump", "burnt" }
local SHADECANOPY_MUST_TAGS = { "shadecanopy" }
local SHADECANOPY_SMALL_MUST_TAGS = { "shadecanopysmall" }
function Sheltered:OnUpdate(dt)
    local sheltered = false
    local level = 1
    self.waterproofness = TUNING.WATERPROOFNESS_SMALLMED --adicionado
    self.announcecooldown = math.max(0, self.announcecooldown - dt)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, SHELTERED_MUST_TAGS, SHELTERED_CANT_TAGS)
    local blowsent = TheSim:FindEntities(x, y, z, 40, { "blows_air" })


    if #blowsent > 0 then
        self:SetSheltered(#blowsent > 0)
        for _, v in ipairs(blowsent) do
            --if v:HasTag("dryshelter") then
            self.waterproofness = TUNING.WATERPROOFNESS_ABSOLUTE
            break
            --end
        end
    else
        if #ents > 0 then
            sheltered = true
        end

        local canopy = TheSim:FindEntities(x, y, z, TUNING.SHADE_CANOPY_RANGE, SHADECANOPY_MUST_TAGS)
        local canopy_small = TheSim:FindEntities(x, y, z, TUNING.SHADE_CANOPY_RANGE_SMALL, SHADECANOPY_SMALL_MUST_TAGS)
        if #canopy > 0 or #canopy_small > 0 then
            sheltered = true
            level = 2
        end

        self:SetSheltered(sheltered, level)
    end
end
