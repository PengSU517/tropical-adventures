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


function KnowTAConfigs(config)
	local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2986194136", false) -- "workshop-1289779251" (live)
	-- "workshop-3047220901" (playtest)
	if configs then
		for i, v in ipairs(configs) do
			if v.name == config then
				return v.saved
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2986194136", configs, false)
end

function ChangeTAConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2986194136", false) -- "workshop-1289779251" (live)
	-- "workshop-3047220901" (playtest)
	if configs then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
				print("Changed " .. config .. " to " .. value)
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2986194136", configs, false)
end

-- local languageconfig = KnowTAConfigs("language")
-- print("Current language: ")
-- print(languageconfig)
-- if languageconfig == "English" or languageconfig == "stringsEN" or languageconfig == "ch" then
-- ChangeTAConfigs("language", false)
-- end
