-- AddTask("Edge_of_the_unknown", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamletpugalisk",
--     room_choices = {
--         ["BG_plains_base"] = 2,
--         ["BG_plains_base_nocanopy1"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("plains", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet2",
--     room_choices = {
--         ["plains_tallgrass"] = math.random(2, 3),
--         ["plains_pogs_ruin"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })


-- AddTask("plains_ruins", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet3",
--     room_choices = {
--         ["plains_ruins"] = 1,
--         ["plains_ruins_set"] = 1,
--         ["plains_pogs"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- ---------------------	
-- AddTask("painted_sands", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet4",
--     room_choices = {
--         ["BG_battleground_base"] = 1,
--         ["battleground_ribs"] = 1,
--         ["battleground_claw"] = 1,
--         ["battleground_leg"] = 1,
--         ["battleground_claw1"] = 1,
--         ["battleground_leg1"] = 1,
--         ["battleground_head"] = 1,
--         ["BG_painted_base"] = 4,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_painted_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })
-- -----------------------------------------
-- AddTask("Deep_rainforest", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet5",
--     room_choices = {
--         ["BG_rainforest_base"] = math.random(2, 3),
--         ["BG_deeprainforest_base"] = 1,
--         ["deeprainforest_spider_monkey_nest"] = 1,
--         ["deeprainforest_fireflygrove"] = math.random(1, 1),
--         ["deeprainforest_flytrap_grove"] = math.random(1, 2),
--         ["deeprainforest_anthill_exit2"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Deep_rainforest_2", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet6",
--     room_choices = {
--         ["BG_rainforest_base"] = 1,
--         ["deeprainforest_spider_monkey_nest"] = 1,
--         ["deeprainforest_fireflygrove"] = 1,
--         ["deeprainforest_flytrap_grove"] = 1,
--         ["deeprainforest_anthill_exit"] = 1,    -----遗迹竟然在这个room
--         ["deeprainforest_ruins_entrance2"] = 1, ----这个room反而没有遗迹
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Deep_rainforest_mandrake", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet7",
--     --	entrance_room = "ForceDisconnectedRoom",   --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
--     room_choices = {
--         ["deeprainforest_mandrakeman"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })



-- AddTask("rainforest_ruins", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet8",
--     room_choices = {
--         ["rainforest_ruins"] = 3,
--         ["rainforest_ruins_entrance"] = 1,
--     },
--     room_bg = GROUND.RAINFOREST,
--     background_room = "BG_rainforest_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })
-- -------------------------
-- AddTask("Edge_of_civilization", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet9",
--     room_choices = {
--         ["cultivated_base_1"] = 1,
--         ["cultivated_base_2"] = 1,
--         --			["cultivated_base_3"] = 1,
--         ["cultivated_base_4"] = 1,
--         ["cultivated_base_5"] = 1,
--         ["piko_land"] = 1,
--     },
--     room_bg = GROUND.FIELDS,
--     background_room = "BG_cultivated_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("Pigcity", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet10",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,
--         ["city_base_1_set"] = 1,
--         ["city_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Deep_rainforest_4", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet10",
--     --	entrance_room = "ForceDisconnectedRoom",   --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
--     room_choices = {
--         ["BG_deeprainforest_base"] = 2,
--         ["deeprainforest_fireflygrove"] = 1,
--         ["deeprainforest_flytrap_grove"] = 1,
--         ["deeprainforest_ruins_exit"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcity2", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet12",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,
--         ["city_base_2_set"] = 1,
--         ["city_base"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Deep_rainforest_3", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet12",
--     --	entrance_room = "ForceDisconnectedRoom",   --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
--     room_choices = {
--         ["BG_deeprainforest_base"] = 2,
--         ["deeprainforest_fireflygrove"] = 1,
--         ["deeprainforest_flytrap_grove"] = 1,
--         ["deeprainforest_ruins_exit"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Edge_of_the_unknown_2", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet13",
--     room_choices = {
--         ["BG_rainforest_base"] = math.random(2, 3),
--         ["plains_tallgrass"] = math.random(1, 2),
--         ["plains_pogs"] = math.random(0, 2),
--         ["rainforest_ruins"] = math.random(2, 3),
--         ["BG_painted_base"] = math.random(1, 2),
--         ["BG_rainforest_base"] = math.random(1, 3),
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Deep_lost_ruins_gas", {
--     locks = {},
--     keys_given = {},
--     region_id = "hamlet14",
--     room_choices = {
--         ["deeprainforest_gas"] = math.random(3, 4),
--         ["deeprainforest_gas_flytrap_grove"] = math.random(2),
--         ["deeprainforest_gas_entrance6"] = 1,
--     },
--     room_bg = GROUND.GASJUNGLE,
--     background_room = "deeprainforest_gas",
--     colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
-- })

AddTask("Pincale", {
    locks = {},
    keys_given = {},
    region_id = "mainland",
    room_choices = {
        ["BG_pinacle_base_set"] = 1,
        ["BG_pinacle_base"] = 2,
    },
    room_bg = GROUND.ROCKY,
    background_room = "BG_pinacle_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

------------------------------------------------------------------------HAMLET continental tasks----------------------------------------------------------------------	
AddTask("Edge_of_the_unknown", {
    locks = {},
    keys_given = { KEYS.JUNGLE_DEPTH_2 },
    region_id = "hamlet",
    room_choices = {
        ["BG_plains_base"] = 2,
        ["BG_plains_base_nocanopy1"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Plains", {
    locks = {},
    keys_given = { KEYS.RAINFOREST, KEYS.EDGE, KEYS.PAINTED, KEYS.DEEPRAINFOREST },
    region_id = "hamlet",
    room_choices = {
        ["BG_plains_base"] = math.random(2, 3),
        ["Lilypond"] = math.random(2, 3),
        ["Ham start"] = 1,
        -- ["plains_tallgrass"] = math.random(2, 3),
        ["plains_pogs_ruin"] = 1, -----这个和"plains_pogs"完全一致
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    -- cove_room_name = "rainforest_ruins",
    -- make_loop = true,
    crosslink_factor = 10, --大概是跨过空room的连接数 交联级数？穿过某个node的次数？
    -- cove_room_chance = 1,  --加边界房间把中心房间围起来 但是coveroom的个数不能多于room个数
    -- cove_room_max_edges = 10,
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Plains_ruins", {
    locks = { LOCKS.JUNGLE_DEPTH_2 },
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["plains_ruins"] = 1,
        ["plains_ruins_set"] = 1,
        ["plains_pogs"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Rainforest_ruins", {
    locks = { LOCKS.RAINFOREST },
    keys_given = { KEYS.DEEPRAINFOREST, KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["rainforest_ruins"] = 2,
        ["rainforest_ruins_entrance"] = 1,
        ["Lilypond"] = 2,
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    -- cove_room_name = "rainforest_ruins",
    -- make_loop = true,
    crosslink_factor = 10, --大概是跨过空room的连接数 交联级数？穿过某个node的次数？
    -- cove_room_chance = 1,  --加边界房间把中心房间围起来 但是coveroom的个数不能多于room个数
    -- cove_room_max_edges = 10,
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


---------------------	
AddTask("Painted_sands", {
    locks = { LOCKS.PAINTED },
    keys_given = { KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["BG_battleground_base"] = 1,
        ["battleground_ribs"] = 1,
        ["battleground_claw"] = 1,
        ["battleground_leg"] = 1,
        ["battleground_claw1"] = 1,
        ["battleground_leg1"] = 1,
        ["battleground_head"] = 1,
        ["BG_painted_base"] = 4,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_painted_base",
    crosslink_factor = 10,
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-----------------------------------------

AddTask("Deep_rainforest", {
    locks = { LOCKS.DEEPRAINFOREST },
    keys_given = { KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["BG_rainforest_base"] = math.random(2, 3),
        ["BG_deeprainforest_base"] = 1,
        ["deeprainforest_spider_monkey_nest"] = 1,
        ["deeprainforest_fireflygrove"] = math.random(1, 1),
        ["deeprainforest_flytrap_grove"] = math.random(1, 2),
        ["deeprainforest_anthill_exit2"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    crosslink_factor = 10,
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Deep_rainforest_2", {
    locks = { LOCKS.DEEPRAINFOREST },
    keys_given = { KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["BG_deeprainforest_base"] = 1,
        ["deeprainforest_spider_monkey_nest"] = 1,
        ["deeprainforest_fireflygrove"] = 1,
        ["deeprainforest_flytrap_grove"] = 1,
        ["deeprainforest_anthill_exit"] = 1,
        ["deeprainforest_ruins_entrance2"] = 1,
        ["deeprainforest_mandrakeman"] = 1, -----------------------
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

-- AddTask("Deep_rainforest_mandrake", {
--     locks = { LOCKS.JUNGLE_DEPTH_2 },
--     keys_given = { KEYS.JUNGLE_DEPTH_2 },
--     region_id = "hamlet",
--     room_choices = {
--         ["deeprainforest_mandrakeman"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "BG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-------------------------
AddTask("Edge_of_civilization", {
    locks = { LOCKS.EDGE },
    keys_given = { KEYS.CITY_1, KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["cultivated_base_1"] = 1,
        ["cultivated_base_2"] = 1,
        --			["cultivated_base_3"] = 1,
        ["cultivated_base_4"] = 1,
        ["cultivated_base_5"] = 1,
        ["piko_land"] = 1,
    },
    room_bg = GROUND.FIELDS,
    background_room = "BG_cultivated_base",
    crosslink_factor = 10,
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Pigcity", {
    locks = { LOCKS.CITY_1 },
    keys_given = { KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base_1_set"] = 1,
        ["city_base"] = 2,
    },
    room_bg = GROUND.SUBURB,
    -- entrance_room = "city_base",
    background_room = "BG_suburb_base",
    cove_room_name = "city_base",
    make_loop = true,
    crosslink_factor = 10, --大概是跨过空room的连接数 交联级数？穿过某个node的次数？
    cove_room_chance = 1,  --加边界房间把中心房间围起来 但是coveroom的个数不能多于room个数
    cove_room_max_edges = 10,
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

-- AddTask("Pigcityside1", {
--     locks = { LOCKS.JUNGLE_DEPTH_3 },
--     keys_given = { KEYS.NONE },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,
--     },
--     entrance_room = "city_base",
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcityside2", {
--     locks = { LOCKS.JUNGLE_DEPTH_2 },
--     keys_given = { KEYS.JUNGLE_DEPTH_1 },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,

--     },
--     entrance_room = "city_base",
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcityside3", {
--     locks = { LOCKS.JUNGLE_DEPTH_3 },
--     keys_given = { KEYS.NONE },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,

--     },
--     entrance_room = "city_base",
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcityside4", {
--     locks = { LOCKS.JUNGLE_DEPTH_3 },
--     keys_given = { KEYS.NONE },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,

--     },
--     entrance_room = "city_base",
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })


AddTask("Deep_rainforest_3", {
    locks = {},
    keys_given = { KEYS.CIVILIZATION_2 },
    region_id = "hamlet",
    room_choices = {
        ["BG_deeprainforest_base"] = 2,
        ["deeprainforest_fireflygrove"] = 1,
        ["deeprainforest_flytrap_grove"] = 1,
        ["deeprainforest_ruins_exit"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    crosslink_factor = 10,
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Pigcity2", {
    locks = { LOCKS.CITY_2 },
    keys_given = {},
    region_id = "hamlet",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base_2_set"] = 1,
        ["city_base"] = 2,
    },
    room_bg = GROUND.SUBURB,
    -- entrance_room = "city_base",
    background_room = "BG_suburb_base",
    cove_room_name = "city_base",
    make_loop = true,
    crosslink_factor = 10, --大概是跨过空room的连接数 交联级数？穿过某个node的次数？
    cove_room_chance = 1,  --加边界房间把中心房间围起来 但是coveroom的个数不能多于room个数
    cove_room_max_edges = 10,
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

-- AddTask("Pigcity2side1", {
--     locks = { LOCKS.CIVILIZATION_3 },
--     keys_given = { KEYS.CIVILIZATION_2 },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcity2side2", {
--     locks = { LOCKS.CIVILIZATION_2 },
--     keys_given = { KEYS.CIVILIZATION_1 },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcity2side3", {
--     locks = { LOCKS.CIVILIZATION_3 },
--     keys_given = { KEYS.NONE },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Pigcity2side4", {
--     locks = { LOCKS.CIVILIZATION_3 },
--     keys_given = { KEYS.NONE },
--     region_id = "island3",
--     room_tags = { "RoadPoison", "hamlet" },
--     room_choices = {
--         ["city_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "BG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })



AddTask("Edge_of_the_unknown_2", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = { KEYS.HAM_BLANK },
    region_id = "hamlet",
    room_choices = {
        ["BG_rainforest_base"] = math.random(2, 3),
        ["plains_tallgrass"] = math.random(1, 2),
        ["plains_pogs"] = math.random(0, 2),
        ["rainforest_ruins"] = math.random(2, 3),
        ["BG_painted_base"] = math.random(1, 2),
        ["BG_rainforest_base"] = math.random(1, 3),
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Deep_lost_ruins_gas", {
    locks = { LOCKS.DEEPRAINFOREST },
    keys_given = {},
    region_id = "hamlet",
    room_choices = {
        ["deeprainforest_gas"] = math.random(3, 4),
        ["deeprainforest_gas_flytrap_grove"] = math.random(2),
        ["deeprainforest_gas_entrance6"] = 1,
    },
    room_bg = GROUND.GASJUNGLE,
    background_room = "deeprainforest_gas",
    colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Ham_blank1", {
    locks = { LOCKS.HAM_BLANK },
    keys_given = { KEYS.CITY_2 },
    region_id = "hamlet",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("Ham_blank2", {
    locks = { LOCKS.HAM_BLANK },
    keys_given = { KEYS.SNALE },
    region_id = "island3",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("Deep_rainforestC", {
    locks = { LOCKS.ISLAND9 },
    keys_given = { KEYS.ISLAND9 },
    region_id = "island3",
    room_choices = {
        ["city_base_2_set"] = 1,
        ["BG_rainforest_base"] = math.random(2, 3),
        ["BG_deeprainforest_base"] = 1,
        ["deeprainforest_spider_monkey_nest"] = 1,
        ["deeprainforest_fireflygrove"] = math.random(1, 1),
        ["deeprainforest_flytrap_grove"] = math.random(1, 2),
        ["deeprainforest_anthill_exit2"] = 1,
        ["deeprainforest_gas"] = math.random(3, 4),
        ["deeprainforest_gas_flytrap_grove"] = math.random(2),
        ["deeprainforest_gas_entrance6"] = 1,
        ["plains_tallgrass"] = math.random(2, 3),
        ["plains_pogs_ruin"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})


-- AddTask("M_BLANK2", {
--     locks = { LOCKS.ISLAND10 },
--     keys_given = { KEYS.ISLAND11 },
--     region_id = "island3",
--     room_choices =
--     {
--         ["ForceDisconnectedRoom"] = 10,
--     },
--     entrance_room = "ForceDisconnectedRoom",
--     room_bg = GROUND.IMPASSABLE,
--     background_room = "ForceDisconnectedRoom",
--     colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
-- })

AddTask("Edge_of_the_unknown", {
    locks = { LOCKS.SNAKE },
    keys_given = {},
    region_id = "island3",
    room_choices = {
        ["BG_plains_base"] = 2,
        ["BG_plains_base_nocanopy1"] = 1,
        ["BG_deeprainforest_base"] = 2,
        ["deeprainforest_flytrap_grove"] = 2,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-- --------------------------------------------------------------------------------Hamlet Merged----------------------------------------------------------------------------
-- AddTask("XEdge_of_the_unknown", {
--     locks = LOCKS.NONE,
--     keys_given = KEYS.JUNGLE_DEPTH_1,
--     --		locks=LOCKS.NONE,
--     --		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
--     room_choices = {
--         ["MAINBG_plains_base"] = 2,
--         ["MAINBG_plains_base_nocanopy1"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "MAINBG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("Xplains", {
--     locks = { LOCKS.ROCKS },
--     keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
--     room_choices = {
--         ["MAINplains_tallgrass"] = math.random(2, 3),
--         ["MAINplains_pogs_ruin"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "MAINBG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("Xplains_ruins", {
--     locks = { LOCKS.ROCKS, LOCKS.BASIC_COMBAT, LOCKS.TIER1 },
--     keys_given = { KEYS.MEAT, KEYS.POOP, KEYS.WOOL, KEYS.GRASS, KEYS.TIER2 },
--     room_choices = {
--         ["MAINplains_ruins"] = 1,
--         ["MAINplains_ruins_set"] = 1,
--         ["MAINplains_pogs"] = 1,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "MAINBG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- ---------------------	
-- AddTask("Xpainted_sands", {
--     locks = { LOCKS.SPIDERDENS, LOCKS.TIER2 },
--     keys_given = { KEYS.MEAT, KEYS.SILK, KEYS.SPIDERS, KEYS.TIER3 },
--     room_choices = {
--         ["MAINBG_battleground_base"] = 1,
--         ["MAINbattleground_ribs"] = 1,
--         ["MAINbattleground_claw"] = 1,
--         ["MAINbattleground_leg"] = 1,
--         ["MAINbattleground_claw1"] = 1,
--         ["MAINbattleground_leg1"] = 1,
--         ["MAINbattleground_head"] = 1,
--         ["MAINBG_painted_base"] = 4,
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "MAINBG_painted_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })
-- -----------------------------------------
-- AddTask("XDeep_rainforest", {
--     locks = { LOCKS.BEEHIVE, LOCKS.TIER1 },
--     keys_given = { KEYS.HONEY, KEYS.TIER2 },
--     room_choices = {
--         ["MAINBG_rainforest_base"] = math.random(2, 3),
--         ["MAINBG_deeprainforest_base"] = 1,
--         ["MAINdeeprainforest_spider_monkey_nest"] = 1,
--         ["MAINdeeprainforest_fireflygrove"] = math.random(1, 1),
--         ["MAINdeeprainforest_flytrap_grove"] = math.random(1, 2),
--         ["MAINdeeprainforest_anthill_exit2"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "MAINBG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XDeep_rainforest_2", {
--     locks = { LOCKS.PIGKING, LOCKS.TIER2 },
--     keys_given = { KEYS.PIGS, KEYS.GOLD, KEYS.TIER3 },
--     room_choices = {
--         ["MAINBG_deeprainforest_base"] = 2,
--         ["MAINdeeprainforest_spider_monkey_nest"] = 1,
--         ["MAINdeeprainforest_fireflygrove"] = 1,
--         ["MAINdeeprainforest_flytrap_grove"] = 1,
--         ["MAINdeeprainforest_anthill_exit"] = 1,
--         ["MAINdeeprainforest_ruins_entrance2"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "MAINBG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XDeep_rainforest_mandrake", {
--     locks = { LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER3 },
--     keys_given = { KEYS.WALRUS, KEYS.TIER4 },
--     room_choices = {
--         ["MAINdeeprainforest_mandrakeman"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "MAINBG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XDeep_rainforest_3", {
--     locks = { LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER4 },
--     keys_given = { KEYS.HOUNDS, KEYS.TIER5, KEYS.ROCKS },
--     room_choices = {
--         ["MAINBG_deeprainforest_base"] = 2,
--         ["MAINdeeprainforest_fireflygrove"] = 1,
--         ["MAINdeeprainforest_flytrap_grove"] = 1,
--         ["MAINdeeprainforest_ruins_exit"] = 1,
--     },
--     room_bg = GROUND.DEEPRAINFOREST,
--     background_room = "MAINBG_deeprainforest_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- -------------------------
-- AddTask("XEdge_of_civilization", {
--     locks = { LOCKS.BASIC_COMBAT, LOCKS.TIER2 },
--     keys_given = { KEYS.POOP, KEYS.WOOL, KEYS.WOOD, KEYS.GRASS, KEYS.TIER2 },
--     room_choices = {
--         ["MAINcultivated_base_1"] = 1,
--         ["MAINcultivated_base_2"] = 1,
--         --			["MAINcultivated_base_3"] = 1,
--         ["MAINcultivated_base_4"] = 1,
--         ["MAINcultivated_base_5"] = 1,
--         ["MAINpiko_land"] = 1,
--     },
--     room_bg = GROUND.FIELDS,
--     background_room = "MAINBG_cultivated_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("XPigcity", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER1 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base_1_set"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcityside1", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER1 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcityside2", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER1 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcityside3", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER1 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcityside4", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER1 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcity2", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base_2_set"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcity2side1", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,
--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcity2side2", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcity2side3", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("XPigcity2side4", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_tags = { "RoadPoison" },
--     room_choices = {
--         ["MAINcity_base"] = 1,

--     },
--     room_bg = GROUND.SUBURB,
--     background_room = "MAINBG_suburb_base",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("Xrainforest_ruins", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.ROCKS, KEYS.GOLD, KEYS.TIER2 },
--     room_choices = {
--         ["MAINrainforest_ruins"] = 3,
--         ["MAINrainforest_ruins_entrance"] = 1,
--     },
--     room_bg = GROUND.RAINFOREST,
--     background_room = "MAINBG_rainforest_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("XEdge_of_the_unknown_2", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.ROCKS, KEYS.GOLD, KEYS.TIER2 },
--     room_choices = {
--         ["MAINBG_rainforest_base"] = math.random(2, 3),
--         ["MAINplains_tallgrass"] = math.random(1, 2),
--         ["MAINplains_pogs"] = math.random(0, 2),
--         ["MAINrainforest_ruins"] = math.random(2, 3),
--         ["MAINBG_painted_base"] = math.random(1, 2),
--         ["MAINBG_rainforest_base"] = math.random(1, 3),
--     },
--     room_bg = GROUND.PLAINS,
--     background_room = "BG_plains_base",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- AddTask("XDeep_lost_ruins_gas", {
--     locks = { LOCKS.TIER4 },
--     keys_given = { KEYS.TIER4 },
--     room_choices = {
--         ["MAINdeeprainforest_gas"] = math.random(3, 4),
--         ["MAINdeeprainforest_gas_flytrap_grove"] = math.random(2),
--         ["MAINdeeprainforest_gas_entrance6"] = 1,
--     },
--     room_bg = GROUND.GASJUNGLE,
--     background_room = "MAINdeeprainforest_gas",
--     colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
-- })


--------------------------------------separahamcave--------------------------------------------------------
AddTask("separahamcave", {
    locks = {
        LOCKS.SACRED,
    },
    keys_given = KEYS.LAND_DIVIDE_5,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.VOLCANO,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("HamMudWorld", {
    locks = { LOCKS.HAM_CAVE },
    keys_given = { KEYS.HAM_ANT }, -- KEYS.ISLAND1, KEYS.ISLAND2,
    -- region_id = "hamlet_cave",
    room_choices = {
        ["HamLightPlantField"] = 1,
        ["HamLightPlantFieldexit"] = 1, --exit1
        -- ["HamMudWithRabbitexit"] = 1,   --exit2
        ["HamWormPlantField"] = 1,
        ["HamFernGully"] = 1,
        ["HamSlurtlePlains"] = 1,
        ["HamMudWithRabbit"] = 1,
        ["PitRoom"] = 1,
    },
    entrance_room = "HamArchiveMazeEntrance",
    background_room = "HamBGMud",
    room_bg = GROUND.MUD,
    colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
})

AddTask("HamMudCave", {
    locks = { LOCKS.HAM_CAVE2 },    --LOCKS.ISLAND1, LOCKS.ISLAND2
    keys_given = { KEYS.HAM_MAZE }, --KEYS.ISLAND1, KEYS.ISLAND3
    region_id = "hamlet_cave",
    room_choices = {
        ["HamWormPlantField"] = 1,
        ["HamSlurtlePlains"] = 1,
        ["HamMudWithRabbit"] = 1,
        ["HamMudWithRabbitexit"] = 1, --exit2
        ["PitRoom"] = 1,
    },
    background_room = "HamBGBatCaveRoom",
    room_bg = GROUND.MUD,
    colour = { r = 0.7, g = 0.5, b = 0.0, a = 0.9 },
})

AddTask("HamMudLights", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND2 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND3 },
    room_choices = {
        ["HamLightPlantField"] = 3,
        ["HamWormPlantField"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamWormPlantField",
    room_bg = GROUND.MUD,
    colour = { r = 0.7, g = 0.5, b = 0.0, a = 0.9 },
})

AddTask("HamMudPit", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND2 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND3 },
    room_choices = {
        ["SlurtlePlains"] = 1,
        ["PitRoom"] = 2,
    },
    background_room = "HamFernGully",
    room_bg = GROUND.MUD,
    colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
})

------------------------------------------------------------
-- Main Caves Branches
------------------------------------------------------------
-- Big Bat Cave
AddTask("HamBigBatCave", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamBatCave"] = 3,
        ["HamBattyCave"] = 1,
        ["HamFernyBatCave"] = 1,
        ["HamFernyBatCaveexit"] = 1,
        ["PitRoom"] = 2,
    },
    background_room = "HamBGBatCaveRoom",
    room_bg = GROUND.CAVE,
    colour = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 },
})

-- Rocky Land
AddTask("HamRockyLand", {
    locks = { LOCKS.HAM_ANT },       --LOCKS.ISLAND1, LOCKS.ISLAND3
    keys_given = { KEYS.HAM_CAVE2 }, -- KEYS.ISLAND1, KEYS.ISLAND4, KEYS.ISLAND7
    room_choices = {
        ["HamSlurtleCanyon"] = 1,
        ["HamBatsAndSlurtles"] = 1,
        ["HamRockyPlains"] = 1,
        ["HamRockyPlainsexit"] = 1, ---sem saida
        ["HamRockyHatchingGrounds"] = 1,
        ["HamBatsAndRocky"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGRockyCaveRoom",
    room_bg = GROUND.CAVE,
    colour = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
})

----------------------------------

-- Red Forest
AddTask("HamRedForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamRedMushForest"] = 2,
        ["HamRedSpiderForest"] = 1,
        ["HamRedSpiderForestexit"] = 1, ---sem saida
        ["HamRedMushPillars"] = 1,
        ["HamStalagmiteForest"] = 1,
        ["HamSpillagmiteMeadow"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGRedMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 1.0, g = 0.5, b = 0.5, a = 0.9 },
})


---------------------------------------cave exit -------------------------------------------------
AddTask("caveruinsexit", {
    locks = { LOCKS.ENTRANCE_INNER },
    keys_given = {},
    room_choices = {
        ["caveruinexitroom"] = 1,
    },
    background_room = "BGSinkhole",
    room_bg = GROUND.SINKHOLE,
    colour = { r = 1, g = 0, b = 1, a = 1 },
})

AddTask("caveruinsexit2", {
    locks = { LOCKS.ENTRANCE_OUTER },
    keys_given = {},
    room_choices = {
        ["caveruinexitroom2"] = 1,
    },
    background_room = "BGSinkhole",
    room_bg = GROUND.SINKHOLE,
    colour = { r = 1, g = 0, b = 1, a = 1 },
})

-- Green Forest
AddTask("HamGreenForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamGreenMushForest"] = 2,
        ["HamGreenMushPonds"] = 1,
        ["HamGreenMushSinkhole"] = 1,
        ["HamGreenMushMeadow"] = 1,
        ["HamGreenMushRabbits"] = 1,
        ["HamGreenMushNoise"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGGreenMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 0.5, g = 1.0, b = 0.5, a = 0.9 },
})

-- Blue Forest
AddTask("HamBlueForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4, KEYS.ISLAND5 },
    room_choices = {
        ["HamBlueMushForest"] = 3,
        ["HamBlueMushMeadow"] = 2,
        ["HamBlueSpiderForest"] = 1,
        ["HamDropperDesolation"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGBlueMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 0.5, g = 0.5, b = 1.0, a = 0.9 },
})

--------------------ham pigmaze--------------------------

AddTask("HamMoonCaveForest", {
    locks = { LOCKS.ISLAND5 },
    keys_given = { KEYS.ISLAND6 },
    room_tags = { "nocavein" },
    room_choices = {
        ["HamCaveGraveyard"] = 1,
        ["HamCaveGraveyardentrance"] = 1,
    },
    background_room = "HamCaveGraveyard",
    room_bg = GROUND.FUNGUSMOON,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})

AddTask("HamArchiveMaze", {
    locks = { LOCKS.HAM_MAZE },
    keys_given = {},
    room_tags = { "nocavein" },
    entrance_room = "HamArchiveMazeEntrance",
    room_choices =
    {
        ["ArchiveMazeRooms"] = 4,
    },
    room_bg = GROUND.ARCHIVE,
    --    maze_tiles = {rooms = {"archive_hallway"}, bosses = {"archive_hallway"}, keyroom = {"archive_keyroom"}, archive = {start={"archive_start"}, finish={"archive_end"}}, bridge_ground=GROUND.FAKE_GROUND},
    maze_tiles = {
        rooms = { "hamlet_hallway", "hamlet_hallway_two" },
        bosses = { "hamlet_hallway" },
        archive = { keyroom = { "hamlet_keyroom" } },
        special = { finish = { "hamlet_end" }, start = { "hamlet_start" } },
        bridge_ground = GROUND.FAKE_GROUND
    },
    background_room = "ArchiveMazeRooms",
    cove_room_chance = 0,
    cove_room_max_edges = 0,
    make_loop = true,
    colour = { r = 1, g = 0, b = 0.0, a = 1 },
})


AddTask("HamSpillagmiteCaverns", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamSpidersAndBats"] = 1,
        ["HamThuleciteDebris"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGSpillagmite",
    room_bg = GROUND.UNDERROCK,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})

AddTask("HamSpillagmiteCaverns1", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamSpillagmiteForest"] = 1,
        ["HamDropperCanyon"] = 1,
        ["HamStalagmitesAndLights"] = 1,
    },
    background_room = "HamSpillagmiteForest",
    room_bg = GROUND.FUNGUS,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})
