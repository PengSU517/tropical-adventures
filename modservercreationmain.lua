GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
print("tropical adventures: Loaded!")

FrontEndAssets = {
	Asset("IMAGE", "images/hud/customization_porkland.tex"),
	Asset("ATLAS", "images/hud/customization_porkland.xml"),
	Asset("IMAGE", "images/hud/customization_shipwrecked.tex"),
	Asset("ATLAS", "images/hud/customization_shipwrecked.xml"),


}

ReloadFrontEndAssets()

-- modimport("main/strings.lua")
-- modimport("main/ta_customize")
