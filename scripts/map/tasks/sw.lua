local salasvolcano =
{
    [1] = "VolcanoRock",
    [2] = "VolcanoAsh",
    [3] = "VolcanoObsidian",
    [4] = "VolcanoRock",
    [5] = "VolcanoRock",
}

local salasmagma =
{
    [1] = "Magma",
    [2] = "MagmaHome",
    [3] = "MagmaHomeBoon",
    [4] = "GenericMagmaNoThreat",
    [5] = "MagmaGold",
    [6] = "MagmaGoldBoon",
    [7] = "MagmaTallBird",
    [8] = "MagmaVolcano",
}

local salasbeach =
{
    [1] = "BeachSkull",
    [2] = "BeachShells",
    [3] = "BeachShells1",
    [4] = "BeachNoCrabbits",
    [5] = "BeachNoLimpets",
    [6] = "BeachFlowers",
    [7] = "BeachNoFlowers",
    [8] = "BeachSpider",
    [9] = "BeachLimpety",
    [10] = "BeachRocky",
    [11] = "BeachSappy",
    [12] = "BeachGrassy",
    [13] = "BeachDunes",
    [14] = "BeachCrabTown",
    [15] = "BeesBeach",
    [16] = "BeachPiggy",
    [17] = "BeachPalmForest",
    [18] = "BeachWaspy",
    [19] = "DoydoyBeach",
    [20] = "BeachSinglePalmTreeHome",
    [21] = "BeachGravel",
    [22] = "BeachUnkeptDubloon",
    [23] = "BeachUnkept",
    [24] = "BeachSand",
}

local salasjungle =
{
    [1] = "JungleEyeplant",
    [2] = "JungleFrogSanctuary",
    [3] = "JungleBees",
    [4] = "JungleDenseVery",
    [5] = "JungleClearing",
    [6] = "Jungle",
    [7] = "JungleSparse",
    [8] = "JungleSparseHome",
    [9] = "JungleDense",
    [10] = "JungleDenseHome",
    [11] = "JungleDenseMed",
    [12] = "JungleDenseBerries",
    [13] = "JungleDenseMedHome",
    [14] = "JunglePigGuards",
    [15] = "JungleFlower",
    [16] = "JungleSpidersDense",
    [17] = "JungleSpiderCity",
    [18] = "JungleBamboozled",
    [19] = "JungleMonkeyHell",
    [20] = "JungleCritterCrunch",
    [21] = "JungleDenseCritterCrunch",
    [22] = "JungleShroomin",
    [23] = "JungleRockyDrop",
    [24] = "JungleGrassy",
    [25] = "JungleSappy",
    [26] = "JungleEvilFlowers",
    [27] = "JungleParrotSanctuary",
    [28] = "JungleNoBerry",
    [29] = "JungleNoRock",
    [30] = "JungleNoMushroom",
    [31] = "JungleNoFlowers",
    [32] = "JungleMorePalms",
    [33] = "JungleSkeleton",
}

local salastidal =
{
    [1] = "TidalMarsh",
    [2] = "TidalMarsh1",
    [3] = "TidalMermMarsh",
    [4] = "ToxicTidalMarsh",
}

local salasmeadow =
{
    [1] = "NoOxMeadow",
    [2] = "MeadowOxBoon",
    [3] = "MeadowFlowery",
    [4] = "MeadowBees",
    [5] = "MeadowCarroty",
    [6] = "MeadowSappy",
    [7] = "MeadowSpider",
    [8] = "MeadowRocky",
    [9] = "MeadowMandrake",
}



-------------add map tags --------
for i, room in ipairs(salasjungle) do
    AddRoomPreInit(room, function(room)
        table.insert(room.tags, "Terrarium_Spawner")
        table.insert(room.tags, "StatueHarp_HedgeSpawner")
    end)
end

for i, room in ipairs(salasbeach) do
    AddRoomPreInit(room, function(room)
        table.insert(room.tags, "CharlieStage_Spawner")
        table.insert(room.tags, "Junkyard_Spawner")
    end)
end

for i, room in ipairs(salasmagma) do
    AddRoomPreInit(room, function(room)
        table.insert(room.tags, "Junkyard_Spawner")
    end)
end
for i, room in ipairs(salasvolcano) do
    AddRoomPreInit(room, function(room)
        -- table.insert(room.tags, "Junkyard_Spawner")
    end)
end

for i, room in ipairs(salasmeadow) do
    AddRoomPreInit(room, function(room)
        table.insert(room.tags, "StagehandGarden")
    end)
end




AddTask("HomeIsland_start", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["JungleDenseMedHome"] = 2,
        ["BeachUnkept"] = 1,
        ["Shipwrecked start"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSandHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIsland", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["JungleDenseMedHome"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
        ["BeachUnkept"] = 1,
        -- ["BeachPalmCasino"] = 1,---抽奖机和醍醐
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSandHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Casino", {
    locks = {},
    keys_given = { KEYS.MUSHROOM, KEYS.RABBIT, KEYS.AREA, KEYS.CAVERN, KEYS.SINKHOLE, KEYS.PASSAGE },
    region_id = "shipwrecked",
    room_choices = {
        ["BeachPalmCasino"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.BEACH,
    background_room = salasbeach[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK1", {
    locks = { LOCKS.MUSHROOM },
    keys_given = { KEYS.CAVE },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("RockyGold", {
    locks = { LOCKS.CAVE },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
    room_choices = {
        ["MagmaGold"] = 2,
        ["MagmaGoldBoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.MAGMAFIELD,
    background_room = "Magma",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK7", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("BoreKing", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
    room_choices = {
        ["PigVillagesw"] = 1,
        ["JungleDenseBerries"] = 1,
        ["BeachShark"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})

AddTask("RockyTallJungle", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
    room_choices = {
        ["MagmaTallBird"] = 1,
        ["MagmaGoldBoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.MAGMAFIELD,
    background_room = "BeachDunes",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK2", {
    locks = { LOCKS.RABBIT },
    keys_given = { KEYS.INNERTIER },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("BeachSkull", {
    locks = { LOCKS.INNERTIER },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["JungleRockSkull"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = salasjungle[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK8", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("MagmaJungle", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
    room_choices = {
        ["MagmaForest"] = 1, -- MR went from 1-3
        ["JungleDense"] = 1,
        ["JunglePigs"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDense",
    colour = { 1, .5, .5, .2 },
})


AddTask("Volcano ground", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoAsh"] = 1,
        ["Volcano"] = 1, ---------火山入口room
        ["VolcanoObsidian"] = 1,
        ["VolcanoNoise"] = 2,

    },
    entrance_room = "VolcanoNoise",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano entrance", {
    locks = { LOCKS.VOLCANO_ENTRANCE },
    keys_given = { KEYS.VOLCANO },
    -- region_id = "volcano",
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoNoise"] = 2,

    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 0,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano", {
    locks = { LOCKS.VOLCANO },
    keys_given = { KEYS.VOLCANO_INNER },
    -- region_id = "volcano",
    room_choices = {
        ["VolcanoAsh"] = 1,
        ["VolcanoNoise"] = 2,
        ["VolcanoObsidian"] = 3,
        ["VolcanoRock"] = 2,
        ["VolcanoStart"] = 1, ------火山出口room
        ["VolcanoAltar"] = 1,
        ["VolcanoObsidianBench"] = 1,
    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano inner", {
    locks = { LOCKS.VOLCANO_INNER },
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoRock"] = 2,
        ["VolcanoCage"] = 1,
    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK3", {
    locks = { LOCKS.AREA },
    keys_given = { KEYS.OUTERTIER },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleMarshy", {
    locks = { LOCKS.OUTERTIER },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["TidalMermMarsh"] = 3,
        [salasbeach[math.random(1, 24)]] = 1,
        ["BeachSappy"] = 1,
        ["WaterMangrove"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK9", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleBushy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,

    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("JungleBeachy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["JungleDenseMed"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSand",
    "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK4", {
    locks = { LOCKS.CAVERN },
    keys_given = { KEYS.LIGHT },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleMonkey", {
    locks = { LOCKS.LIGHT },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 33)]] = 1,
        --        [salasjungle[math.random(1, 33)]] = 1,
        ["JungleMonkeyHell"] = 2,
        ["WaterMangrove"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "TidalMarsh",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK10", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("BeachMarshy", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
    room_choices = {
        [salastidal[math.random(1, 4)]] = 2,
        [salastidal[math.random(1, 4)]] = 3,
        ["WaterMangrove"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.BEACH,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("MoonRocky", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
    room_choices = {
        ["Magma"] = 1, -- MR went from 1-3
        ["MagmaGold"] = 1,
        ["MagmaGoldmoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.BEACH,
    background_room = "MagmaGold",
    "MagmaHomeBoon",
    colour = { 1, .5, .5, .2 },
})



AddTask("A_BLANK5", {
    locks = { LOCKS.SINKHOLE },
    keys_given = { KEYS.FUNGUS },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("TigerSharky", {
    locks = { LOCKS.FUNGUS },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
    room_choices = {
        -- ["JungleNoBerry"] = 1,
        ["TidalSharkHome"] = 1,
        -- ["JungleNoBerry"] = 1,
        ["ForceDisconnectedRoomSW"] = 3,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleRockyDrop",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK11", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("Verdent", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
    room_choices = {
        ["Beaverkinghome"] = 1,
        ["Beaverkingcity"] = 1,
        [salasmeadow[math.random(1, 9)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.MEADOW,
    background_room = "MeadowFlowery",
    colour = { 1, .5, .5, .2 },
})



AddTask("BeachBeachy", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
    room_choices = {
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1, --CM was 5 +
        ["BeachShark"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.BEACH,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK6", {
    locks = { LOCKS.PASSAGE },
    keys_given = { KEYS.LABYRINTH },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 2,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("BeachPiggy", {
    locks = { LOCKS.LABYRINTH },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
    room_choices = {
        ["BeachSand"] = 1,
        ["BeachPiggy"] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK12", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoomSW"] = 5,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoomSW",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("DoyDoyM", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyM"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})

AddTask("DoyDoyF", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyF"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoomSW",
    room_bg = GROUND.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})
