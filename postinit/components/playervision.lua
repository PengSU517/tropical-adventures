local Utils = require("tools/utils")

-- 新增
local NIGHTVISION_COLOURCUBES2 =
{
    day = "images/colour_cubes/mole_vision_off_cc.tex",
    dusk = "images/colour_cubes/mole_vision_off_cc.tex",
    night = "images/colour_cubes/mole_vision_off_cc.tex",
    full_moon = "images/colour_cubes/mole_vision_off_cc.tex",
}

----------------------------------------------------------------------------------------------------
-- 源代码拷贝
local GHOSTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/ghost_cc.tex",
    dusk = "images/colour_cubes/ghost_cc.tex",
    night = "images/colour_cubes/ghost_cc.tex",
    full_moon = "images/colour_cubes/ghost_cc.tex",
}

local NIGHTVISION_PHASEFN =
{
    blendtime = 0.25,
    events = {},
    fn = nil,
}

local NIGHTMARE_COLORCUBES =
{
    calm = "images/colour_cubes/ruins_dark_cc.tex",
    warn = "images/colour_cubes/ruins_dim_cc.tex",
    wild = "images/colour_cubes/ruins_light_cc.tex",
    dawn = "images/colour_cubes/ruins_dim_cc.tex",
}

local NIGHTMARE_PHASEFN =
{
    blendtime = 8,
    events = { "nightmarephasechanged" }, -- note: actual (client-side) world component event, not worldstate
    fn = function()
        return TheWorld.state.nightmarephase
    end,
}

----------------------------------------------------------------------------------------------------

local function UpdateCCTableBefore(self)
    if not GetClosestInstWithTag("blows_air", self.inst, 30) then
        return
    end

    local cctable =
        (self.ghostvision and GHOSTVISION_COLOURCUBES)
        or self.overridecctable
        or ((self.nightvision or self.forcenightvision) and NIGHTVISION_COLOURCUBES2)
        or (self.nightmarevision and NIGHTMARE_COLORCUBES)
        or nil

    local ccphasefn =
        (cctable == NIGHTVISION_COLOURCUBES2 and NIGHTVISION_PHASEFN)
        or (cctable == NIGHTMARE_COLORCUBES and NIGHTMARE_PHASEFN)
        or nil

    if cctable ~= self.currentcctable then
        self.currentcctable = cctable
        self.currentccphasefn = ccphasefn
        self.inst:PushEvent("ccoverrides", cctable)
        self.inst:PushEvent("ccphasefn", ccphasefn)
    end

    return nil, true
end

AddClassPostConstruct("components/playervision", function(self)
    Utils.FnDecorator(self, "UpdateCCTable", UpdateCCTableBefore)
end)
