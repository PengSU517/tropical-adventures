require("constants")

local StaticLayout = require("map/static_layout")



local ruins_areas =
{
	rubble = function(area) return nil end,
	debris = function(area)
		return PickSomeWithDups(0.25 * area
		, { "rocks" })
	end,
}

local archive_areas =
{
	creature_area = function()
		if math.random() < 0.2 then
			return { "archive_centipede_husk" }
		end
	end,

	archive_sound_area = function()
		if math.random() < 0.5 then
			return { "archive_ambient_sfx" }
		end
	end,

	archive_cookpot_area = function(area, data)
		if math.random() < 0.2 then
			return { {
				prefab = "archive_cookpot",
				x = data.x,
				y = data.y,
				properties = { data = { additems = { "refined_dust" } } },
			} }
		end
	end,

	mothden_area_low = function()
		if math.random() < 0.08 then
			return { "dustmothden" }
		end
	end,

	mothden_area_high = function()
		if math.random() < 0.25 then
			return { "dustmothden" }
		end
	end,
}

local function GetLayoutsForType(name, sub_dir, params, areas)
	sub_dir = "map/static_layouts/" .. (sub_dir or "rooms") .. "/"
	params = params or {}
	local layouts =
	{
		["SINGLE_NORTH"] = StaticLayout.Get(sub_dir .. name .. "/one", {
			force_rotation = LAYOUT_ROTATION.NORTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["SINGLE_EAST"] = StaticLayout.Get(sub_dir .. name .. "/one", {
			force_rotation = LAYOUT_ROTATION.EAST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["L_NORTH"] = StaticLayout.Get(sub_dir .. name .. "/two", {
			force_rotation = LAYOUT_ROTATION.NORTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["SINGLE_SOUTH"] = StaticLayout.Get(sub_dir .. name .. "/one", {
			force_rotation = LAYOUT_ROTATION.SOUTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["TUNNEL_NS"] = StaticLayout.Get(sub_dir .. name .. "/long", {
			force_rotation = LAYOUT_ROTATION.NORTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["L_EAST"] = StaticLayout.Get(sub_dir .. name .. "/two", {
			force_rotation = LAYOUT_ROTATION.EAST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["THREE_WAY_N"] = StaticLayout.Get(sub_dir .. name .. "/three", {
			force_rotation = LAYOUT_ROTATION.NORTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["SINGLE_WEST"] = StaticLayout.Get(sub_dir .. name .. "/one", {
			force_rotation = LAYOUT_ROTATION.WEST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["L_WEST"] = StaticLayout.Get(sub_dir .. name .. "/two", {
			force_rotation = LAYOUT_ROTATION.WEST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["TUNNEL_EW"] = StaticLayout.Get(sub_dir .. name .. "/long", {
			force_rotation = LAYOUT_ROTATION.EAST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["THREE_WAY_W"] = StaticLayout.Get(sub_dir .. name .. "/three", {
			force_rotation = LAYOUT_ROTATION.WEST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["L_SOUTH"] = StaticLayout.Get(sub_dir .. name .. "/two", {
			force_rotation = LAYOUT_ROTATION.SOUTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["THREE_WAY_S"] = StaticLayout.Get(sub_dir .. name .. "/three", {
			force_rotation = LAYOUT_ROTATION.SOUTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["THREE_WAY_E"] = StaticLayout.Get(sub_dir .. name .. "/three", {
			force_rotation = LAYOUT_ROTATION.EAST,
			fill_mask = params.fill_mask,
			areas = areas
		}),
		["FOUR_WAY"] = StaticLayout.Get(sub_dir .. name .. "/four", {
			force_rotation = LAYOUT_ROTATION.NORTH,
			fill_mask = params.fill_mask,
			areas = areas
		}),
	}

	for k, v in pairs(layouts) do
		v.start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED
		v.fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED

		if string.find(name, "hamlet") then
			v.ground_types[42] = GROUND.PIGRUINS
		end
		-- v.areas = ruins_areas
	end

	return layouts
end


local function GetSpecialLayoutsForType(layout_dir, name, sub_dir, areas)
	local path = "map/static_layouts/" .. (sub_dir or "rooms") .. "/" .. layout_dir .. "/" .. name
	local layouts =
	{
		["SINGLE_NORTH"] = StaticLayout.Get(path, {
			force_rotation = LAYOUT_ROTATION.NORTH, areas = areas }),
		["SINGLE_EAST"] = StaticLayout.Get(path, {
			force_rotation = LAYOUT_ROTATION.EAST, areas = areas }),
		["SINGLE_SOUTH"] = StaticLayout.Get(path, {
			force_rotation = LAYOUT_ROTATION.SOUTH, areas = areas }),
		["SINGLE_WEST"] = StaticLayout.Get(path, {
			force_rotation = LAYOUT_ROTATION.WEST, areas = areas }),
	}

	for k, v in pairs(layouts) do
		v.start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED
		v.fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED


		if string.find(name, "hamlet") then
			v.ground_types[42] = GROUND.PIGRUINS
		end
		-- v.areas = ruins_areas
	end
	return layouts
end

local maze_rooms = require("map/maze_layouts")
local alllayouts = maze_rooms.AllLayouts

local ruinlayouts = {
	["hamlet_start"] = GetSpecialLayoutsForType("hamlet_start", "hamlet_start", nil, nil, archive_areas),
	["hamlet_hallway"] = GetLayoutsForType("hamlet_hallway", nil, nil, archive_areas),
	["hamlet_hallway_two"] = GetLayoutsForType("hamlet_hallway_two", nil, nil, archive_areas),
	["hamlet_keyroom"] = GetSpecialLayoutsForType("hamlet_keyroom", "hamlet_keyroom_1", nil, nil, archive_areas),
	["hamlet_end"] = GetSpecialLayoutsForType("hamlet_end", "hamlet_end", nil, nil, archive_areas),
}

tableutil.deep_merge(alllayouts, ruinlayouts, false)
