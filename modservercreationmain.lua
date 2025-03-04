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

-- print(env.modname)

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

-- function ResetModConfigs()
-- 	local already_reset = KnowModConfigs("already_reset")
-- 	if already_reset == false then
-- 		local configs = KnownModIndex:LoadModConfigurationOptions(env.modname, false)
-- 		if configs then
-- 			for i, v in ipairs(configs) do
-- 				if type(v) == "table" then
-- 					print(11111111111)
-- 					print(v.saved)
-- 					print(v.default)
-- 					v.saved = v.default
-- 				end
-- 			end
-- 		end
-- 		configs.already_reset = true
-- 		-- ChangeModConfigs("already_reset", true)
-- 		KnownModIndex:SaveConfigurationOptions(function() end, env.modname, configs, false)
-- 	end
-- end

-- ResetModConfigs()

-- ChangeTAConfigs("testmode", false)
-- ChangeTAConfigs("testmap", false)



-- print("tropical adventures: Loaded!1111111")
-- print(CheckName or "hahahhahaahhaahha22222222")
-- if tbl then print(tbl[1]) end


-- modimport("main/toolutil")
-- modimport "main/strings" ---加载这玩意有点耗时

local DEV = not modname:find("workshop-")

if DEV then
	local TEMPLATES = require("widgets/redux/templates")
	local ChooseWorldSreen = require("widgets/redux/chooseworldscreen")

	local world_locations = {
		[1] = { FOREST = true, CAVE = true },
		[2] = { FOREST = true, CAVE = true }
	}


	local function SetLevelLocations(servercreationscreen, location, i)
		local server_level_locations = {}
		server_level_locations[i] = location
		server_level_locations[3 - i] = SERVER_LEVEL_LOCATIONS[3 - i] ----有这一句可能就没法设置一样的
		servercreationscreen:SetLevelLocations(server_level_locations)
		local text = servercreationscreen.world_tabs[i]:GetLocationTabName()
		servercreationscreen.world_config_tabs.menu.items[i + 1]:SetText(text)
	end

	local function OnWorldButton(world_tab, i)
		if world_tab:GetParentScreen() then
			world_tab:GetParentScreen().last_focus = TheFrontEnd:GetFocusWidget()
		end
		local currentworld = world_tab:GetLocation()
		local chooseworldscreen = ChooseWorldSreen(world_tab, currentworld, i, SetLevelLocations, world_locations)
		TheFrontEnd:PushScreen(chooseworldscreen)
	end

	scheduler:ExecuteInTime(0, function()
		local servercreationscreen = TheFrontEnd:GetOpenScreenOfType("ServerCreationScreen")

		if not (KnownModIndex:IsModEnabled(modname) and servercreationscreen and servercreationscreen.world_tabs and servercreationscreen.world_tabs[1]) then
			return
		end

		for i, world_tab in ipairs(servercreationscreen.world_tabs) do
			if world_tab:GetLocation() ~= SERVER_LEVEL_LOCATIONS[i] and servercreationscreen:CanResume() then
				SERVER_LEVEL_LOCATIONS[i] = world_tab:GetLocation()
				servercreationscreen.world_tabs[i]:RefreshOptionItems()
				local text = servercreationscreen.world_tabs[i]:GetLocationTabName()
				servercreationscreen.world_config_tabs.menu.items[i + 1]:SetText(text)
			end

			if world_tab.settings_widget:IsNewShard() then
				if not world_tab.choose_world_button then
					world_tab.choose_world_button = world_tab.settings_root:AddChild(TEMPLATES.StandardButton(
						function() OnWorldButton(world_tab, i) end, "Choose World"))
					world_tab.choose_world_button.image:SetScale(.47)
					world_tab.choose_world_button.text:SetColour(0, 0, 0, 1)
					world_tab.choose_world_button:SetTextSize(19.6)
					world_tab.choose_world_button:SetPosition(320, 285)
				elseif not world_tab.choose_world_button.shown then
					world_tab.choose_world_button:Show()
				end
			end
		end
	end)
end
