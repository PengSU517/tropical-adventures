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

print(env.modname)

function KnowModConfigs(config)
	local configs = KnownModIndex:LoadModConfigurationOptions(env.modname, false) -- "workshop-1289779251" (live)
	if configs then
		for i, v in ipairs(configs) do
			if v.name == config then
				return v.saved
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, env.modname, configs, false)
end

function ChangeModConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions(env.modname, false) -- "workshop-1289779251" (live)
	if configs then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
				print("Changed " .. config .. " to " .. tostring(value))
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, env.modname, configs, false)
end

-- ChangeTAConfigs("testmode", false)
-- ChangeTAConfigs("testmap", false)
