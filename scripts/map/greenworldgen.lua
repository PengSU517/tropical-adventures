AddRoom("BGGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			distributepercent = 0.25,
			distributeprefabs =
			{
				marshberry = 0.08,
				reeds = 0.3,
				marsh_bush = 0.3,
				evergreen = 0.5,
				marsh_tree = 0.5,
				greententacle = 0.2
			},
		}
	})

AddRoom("SnakesGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			countprefabs =
			{
				shelves_bonestaff = 1,
			},
			distributepercent = 0.3,
			distributeprefabs =
			{
				evergreen = 1.2,
				reeds = 0.07,
				greententacle = 0.04,
				snake_hole = 0.01,
			},
		}
	})

AddRoom("SpidersGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			countprefabs =
			{

			},
			distributepercent = 0.3,
			distributeprefabs =
			{
				evergreen = 1.2,
				reeds = 0.07,
				greententacle = 0.06,
				snake_hole = 0.01,
				spiderden = 0.09,
				rock1 = 0.02
			},
			prefabdata =
			{
				spiderden = function()
					if math.random() < 0.2 then
						return { growable = { stage = 2 } }
					else
						return { growable = { stage = 1 } }
					end
				end,
			},
		}
	})

AddRoom("ForestGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			countprefabs =
			{

			},
			distributepercent = 0.7,
			distributeprefabs =
			{
				evergreen = 1.2,
				sapling = 0.05,
				snake_hole = 0.01,
				green_mushroom = 0.05,
				blue_mushroom = 0.05,
				red_mushroom = 0.05,
			},
			prefabdata =
			{

			},
		}
	})

AddRoom("WatcherGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		tags = { "StagehandGarden", "RoadPoison" },
		contents =
		{
			countprefabs =
			{
				shelves_bossboar = 1
			},
			distributepercent = 0.1,
			distributeprefabs =
			{
				reeds = 0.1,
				greententacle = 0.02,
				goldnugget = 0.01
			},
		}
	})

AddRoom("WillageGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			countprefabs =
			{
				pond = 1,
			},
			distributepercent = 0.3,
			distributeprefabs =
			{
				evergreen = 0.7,
				sapling = 0.3,
				grassnova = 0.3,
				lizardman_cave = 0.15,
				rock1 = 0.1,
			},
		}
	})

AddRoom("EntranceGreenSwamp",
	{
		colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
		value = GROUND.MARSH_SW,
		contents =
		{
			distributepercent = 0.5,
			distributeprefabs =
			{
				evergreen = 2,
				rock1 = 0.04,
				sapling = 0.05,
				spiderden = 0.3,
				grassnova = 0.05,
			},
			prefabdata =
			{
				spiderden = function()
					if math.random() < 0.2 then
						return { growable = { stage = 2 } }
					else
						return { growable = { stage = 1 } }
					end
				end,
			},
		}
	})


AddTask("GREENSWAMP_TASK_FOREST",
	{
		locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
		keys_given = { KEYS.TIER4 },
		room_choices =
		{
			["SnakesGreenSwamp"] = math.random(1),
			["SpidersGreenSwamp"] = math.random(1),
			["ForestGreenSwamp"] = math.random(1),
			["WillageGreenSwamp"] = math.random(1),
			["WatcherGreenSwamp"] = 1,
		},
		entrance_room = "EntranceGreenSwamp",
		room_bg = GROUND.MARSH_SW,
		background_room = "BGGreenSwamp",
		colour = { r = 1, g = 0, b = 0.6, a = 1 },
	})

AddTask("GREENSWAMP_TASK_FOREST_ISLAND",
	{
		locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
		keys_given = { KEYS.TIER4 },
		region_id = "greenworld",
		room_choices =
		{
			["SnakesGreenSwamp"] = math.random(1),
			["SpidersGreenSwamp"] = math.random(1),
			["ForestGreenSwamp"] = math.random(1),
			["WillageGreenSwamp"] = math.random(1),
			["WatcherGreenSwamp"] = 1,
			["EntranceGreenSwamp"] = 1,
		},
		room_bg = GROUND.MARSH_SW,
		background_room = "BGGreenSwamp",
		colour = { r = 1, g = 0, b = 0.6, a = 1 },
	})




local function LevelPreInitBoth(level)
	if level.location == "forest" then
		if GetModConfigData("kindofworld") == 10 then
			table.insert(level.tasks, "GREENSWAMP_TASK_FOREST_ISLAND")
		elseif GetModConfigData("kindofworld") ~= 20 then --não adiciona no Sea World
			table.insert(level.tasks, "GREENSWAMP_TASK_FOREST")
		end
	end
end

AddLevelPreInitAny(LevelPreInitBoth)

AddRoomPreInit("WatcherGreenSwamp", function(room)
	if not room.contents.countstaticlayouts then
		room.contents.countstaticlayouts = {}
	end
	room.contents.countstaticlayouts["gwestatua"] = 1
end)
