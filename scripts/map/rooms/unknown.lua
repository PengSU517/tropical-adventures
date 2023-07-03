--出生地设置相关
AddTask("Dig that hamlet", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINdeeprainforest_flytrap_grove"] = 1,
        ["MAINRockyham"] = 1,
        ["MAINdeeprainforest_ruins_exit"] = 1,
        --			["Forest"] = 1,				
    },
    room_bg = GROUND.PLAINS,
    background_room = "MAINRockyham",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("iniciosw", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINJungleDenseMedHome"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "MAINBeachUnkeptInicio",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("iniciosw2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINJungleGrassy"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "MAINJungleDenseMedHome",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("inicioswsw", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["JungleDenseMedHome"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachUnkeptInicio",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("inicioswsw2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["JungleGrassy"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMedHome",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("inicioham", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINBG_plains_inicio"] = 2,
    },
    room_bg = GROUND.PLAINS,
    background_room = "MAINBG_plains_base",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("inicioham2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINdeeprainforest_fireflygrove"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "MAINBG_deeprainforest_base",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})
