local unpack = GLOBAL.unpack
local kleifileexists = GLOBAL.kleifileexists
local package = GLOBAL.package
local IAROOT = MODROOT
local modimport = modimport
local TAENV = env

--Update this list when adding files
local behaviours_post = {
    "follow",
}

local components_post = {
    "aoespell",
    "armor",

    -- "actionqueuer",
    -- "ambientsound",
    -- "amphibiouscreature",
    -- "areaaware",
    -- "butterflyspawner",
    -- "birdspawner",
    -- "blinkstaff",
    -- "builder",
    -- "burnable",
    -- "childspawner",
    -- "clock",
    -- "colourcube",
    -- "combat",
    -- "cookable",
    -- "crop",
    -- "cursable",
    -- "deployable",
    -- "drownable",
    -- "dryer",
    -- "dsp",
    -- "dynamicmusic",
    -- "eater",
    -- "edible",
    -- "equippable",
    -- "explosive",
    -- "fertilizer",
    -- "firedetector",
    -- "fishable",
    -- "fishingrod",
    -- "floater",
    -- "flotsamgenerator",
    -- "flotationdevice",
    -- "foodmemory",
    -- "frograin",
    -- "frostybreather",
    -- "fuel",
    -- "fueled",
    -- "follower",
    -- "growable",
    -- "health",
    -- "herdmember",
    -- "hounded",
    -- --"hunter",
    -- "inspectable",
    -- "inventory",
    -- "inventoryitem",
    -- "inventoryitemmoisture",
    -- "itemaffinity",
    -- "leader",
    -- "lighter",
    -- "locomotor",
    -- "lootdropper",
    -- "lureplantspawner",
    -- "mermkingmanager",
    -- "minionspawner",
    -- "moisture",
    -- "oar",
    -- "oceancolor",
    -- "oldager",
    -- "penguinspawner",
    -- "periodicspawner",
    -- "perishable",
    -- "pickable",
    -- "placer",
    -- "plantregrowth",
    -- "playeractionpicker",
    -- "playercontroller",
    "playerspawner",
    -- "recallmark",
    -- "regrowthmanager",
    -- "repairable",
    -- "seamlessplayerswapper",
    -- "seasons",
    -- "shadowcreaturespawner",
    -- "shard_clock",
    -- "shard_seasons",
    -- "sheltered",
    -- "specialeventsetup",
    -- "spell",
    -- "stackable",
    -- "stewer",
    -- "skinner",
    -- "sleeper",
    -- "tackler",
    -- "teamleader",
    -- "temperature",
    -- "thief",
    -- "trap",
    -- "uianim",
    -- "walkableplatformplayer",
    -- "waterphysics",
    "wavemanager",
    -- "weather",
    -- "weapon",
    -- "wildfires",
    -- "wisecracker",
    -- "witherable",
    -- "worldstate",
    -- "worldwind",
    -- "klaussackspawner",
    -- "klaussackloot"
}

local prefabs_post = {

    "gears",
    "warningshadow",
    -- "allow_impassable_item",
    -- "amphibious_followers",
    -- "antliontrinket",
    -- "appeasement_item",
    -- "ash",
    -- "balloonvest",
    -- "birdcage",
    -- "boat",
    -- "book_birds",
    -- "book_fish",
    -- "book_rain",
    -- "book_silviculture",
    -- "buff_workeffectiveness",
    -- "cactus",
    -- "campfire",
    -- "cave_entrance",
    -- "cookpot",
    -- "cotl_trinket",
    -- "daywalker_pillar",
    -- "dock_kit",
    -- "dug_grass",
    -- "eel",
    -- "fireflies",
    -- "firesuppressor",
    -- "fish",
    -- "glasscutter",
    -- "grass",
    -- "healthregenbuff",
    -- "heatrock",
    -- "houndwarning",
    -- "icebox",
    -- "inv_phys_item",
    -- "inventoryitem_classified",
    -- "ipecacsyrup",
    -- "lantern",
    -- "leif_idol",
    -- "lighter",
    -- "lightning",
    -- "lureplant",
    -- "oceanfish",
    -- "piratemonkeys",
    -- "marsh_bush",
    -- "meatrack",
    -- "meats",
    -- "megaflare",
    -- "merm",
    -- "mermhouse",
    -- "mermhouse_crafted",
    -- "mermking",
    -- --"minisign",
    -- "player_classified",
    -- "player_common_extensions",
    -- "player_common",
    -- "mermhouse_crafted",
    -- "pocketwatch",
    -- "poison_immune",
    -- "portableblender",
    -- "portablecookpot",
    -- "portablespicer",
    -- "poop",
    -- "prototyper",
    -- "rainometer",
    -- "reskin_tool",
    -- "resurrectionstone",
    -- "sewing_tape",
    -- "shadowcreature",
    -- "shadowmeteor",
    -- "shadowskittish",
    -- "shadowwaxwell",
    -- "shadow_pillar_spell",
    -- "spicepack",
    -- "sporecloud",
    -- "tallbird",
    -- "thunder_close",
    -- "thunder_far",
    -- "torch",
    -- "trident",
    -- "trinkets",
    -- "trophyscale_fish",
    -- "underwater_salvageable",
    -- "variants_ia",
    -- "voidcloth_scythe",
    -- "warly",
    -- "warningshadow",
    -- "walls",
    -- "wave",
    -- "waxwell",
    -- "wes",
    -- "willow",
    -- "winterometer",
    -- "wobster",
    -- "wobybig",
    -- "wolfgang",
    -- "woodcarvedhat",
    -- "woodie",
    -- "world",
    -- "wormwood_plant_fx",
    -- "wortox",
    -- "wurt",
    -- "wx78",
}

if GLOBAL.TUNING.UPDATE_CHECK then
    table.insert(prefabs_post, "storage_robot")
end

local gustable_prefabs_post = {
    "bush",
    "grass",
    "palm",
    "sapling",
    "trees",
}

local stategraphs_post = {
    "bird",
    "commonstates",
    "shadowwaxwell",
    "tornado",
    "merm",
    "shadowcreature",
    "shadowwaxwell",
    "wilson",
    "wilson_client",
}

local brains_post = {
    "mermbrain",
    "oceanshadowcreaturebrain",
    "shadowcreaturebrain",
    "shadowwaxwellbrain",
    -- "wobsterbrain",
}

local class_post = {
    "components/builder_replica",
    "components/combat_replica",
    "components/equippable_replica",
    "components/inventoryitem_replica",
    "screens/playerhud",
    "widgets/redux/craftingmenu_details",
    "widgets/redux/craftingmenu_hud",
    "widgets/redux/craftingmenu_widget",
    "widgets/containerwidget",
    "widgets/healthbadge",
    "widgets/inventorybar",
    "widgets/itemtile",
    "widgets/mapwidget",
    "widgets/seasonclock",
    "widgets/widget",
}

local sim_post = {
    "mainfunctions",
}

local package_post = {
    ["components/map"] = "map",
}

-- modimport("postinit/stategraph")
-- modimport("postinit/entityscript")
-- modimport("postinit/recipe")
-- modimport("postinit/bufferedaction")

-- modimport("postinit/any")
-- modimport("postinit/player")

-- for _,v in pairs(behaviours_post) do
--     modimport("postinit/behaviours/" .. v)
-- end

for _, v in pairs(components_post) do
    modimport("postinit/components/" .. v)
end

for _, v in pairs(prefabs_post) do
    modimport("postinit/prefabs/" .. v)
end

-- for _,v in pairs(gustable_prefabs_post) do
--     modimport("postinit/prefabs/gustable/" .. v)
-- end

-- for _,v in pairs(stategraphs_post) do
--     modimport("postinit/stategraphs/SG" .. v)
-- end

-- for _,v in pairs(brains_post) do
--     modimport("postinit/brains/" .. v)
-- end

-- for _,v in pairs(class_post) do
--     -- These contain a path already, e.g. v= "widgets/inventorybar"
--     modimport("postinit/" .. v)
-- end

-- AddSimPostInit(function()
--     for _, v in pairs(sim_post) do
--         modimport("postinit/sim/" .. v)
--     end
-- end)

-- local _require = GLOBAL.require
-- function GLOBAL.require(modulename, ...)
--     local post_modulename = package_post[modulename] or nil
--     local should_load = post_modulename and package.loaded[modulename] == nil and kleifileexists("scripts/"..modulename..".lua") and kleifileexists(IAROOT.."postinit/package/"..post_modulename..".lua")
--     local rets = {_require(modulename, ...)}
--     if should_load then
--         print("loading module post", "scripts/"..modulename, IAROOT.."postinit/package/"..post_modulename)
--         modimport("postinit/package/" .. post_modulename)
--     end
--     return unpack(rets)
-- end
