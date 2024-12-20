local tropical_color = { 0, 0.3, 0.3, 1 }


local COLOURSETS = {
	shipwrecked =
	{
		default = { color = tropical_color, blend_delay = 1, blend_speed = 1.0, ocean_texture_blend = 0 },
		dusk = { color = tropical_color, blend_delay = 0, blend_speed = 0.1, ocean_texture_blend = 1 },
		night = { color = tropical_color, blend_delay = 6, blend_speed = 0.1, ocean_texture_blend = 1 },
		no_ocean = { color = { 0.0, 0.0, 0.0, 1.0 }, blend_delay = 6, blend_speed = 0.1, ocean_texture_blend = 0 }
	},


	hamlet =
	{
		default = { color = tropical_color, blend_delay = 1, blend_speed = 1.0, ocean_texture_blend = 0 },
		dusk = { color = tropical_color, blend_delay = 0, blend_speed = 0.1, ocean_texture_blend = 1 },
		night = { color = tropical_color, blend_delay = 6, blend_speed = 0.1, ocean_texture_blend = 1 },
		no_ocean = { color = { 0.0, 0.0, 0.0, 1.0 }, blend_delay = 6, blend_speed = 0.1, ocean_texture_blend = 0 }
	}
}

AddComponentPostInit("oceancolor", function(self)
	self.currentphase = "default"
	---保存当前phase
	local _OnPhaseChanged = self.OnPhaseChanged
	function self:OnPhaseChanged(phase)
		_OnPhaseChanged(self, phase)
		self.currentphase = phase
	end

	local _COLOURS = upvaluehelper.Get(self.OnPhaseChanged, "COLORS")
	COLOURSETS.forest = deepcopy(_COLOURS)

	local _activatedplayer
	local function OnRegionChanged(src, dat)
		print("OnRegionChanged", dat and dat.region)
		local regionname = REGION_NAMES[dat and dat.region or 1] ----region为什么是个表？
		local colors = COLOURSETS[regionname] or COLOURSETS.forest

		local target_color = colors.default
		if colors[self.phase] ~= nil then
			target_color = colors[self.phase]
		end
		self.start_color[0] = self.current_color[0]
		self.start_color[1] = self.current_color[1]
		self.start_color[2] = self.current_color[2]
		self.start_color[3] = self.current_color[3]
		self.start_ocean_texture_blend = self.current_ocean_texture_blend
		self.end_ocean_texture_blend = target_color.ocean_texture_blend
		self.end_color = target_color.color
		self.lerp = 0
		self.lerp_delay = 0

		self.blend_delay = target_color.blend_delay
		self.blend_speed = target_color.blend_speed
	end

	self.inst:ListenForEvent("playeractivated", function(src, player)
		if player and _activatedplayer ~= player then
			player:ListenForEvent("regionchange_client", OnRegionChanged)
			player:DoTaskInTime(0, function() OnRegionChanged() end) --initialise
		end
		_activatedplayer = player
	end)
	self.inst:ListenForEvent("playerdeactivated", function(src, player)
		if player then
			player:RemoveEventCallback("regionchange_client", OnRegionChanged)
			if _activatedplayer == player then
				_activatedplayer = nil
			end
		end
	end)
end)
