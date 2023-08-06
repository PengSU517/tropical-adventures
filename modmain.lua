local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local require = GLOBAL.require
local TheInput = GLOBAL.TheInput
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local Inv = require "widgets/inventorybar"
local containers = GLOBAL.require "containers"
local TheWorld = GLOBAL.TheWorld

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

_G = GLOBAL; require, rawget, getmetatable, unpack = _G.require, _G.rawget, _G.getmetatable, _G.unpack
TheNet = _G.TheNet; IsServer, IsDedicated = TheNet:GetIsServer(), TheNet:IsDedicated()
TheSim = _G.TheSim
STRINGS = _G.STRINGS
RECIPETABS, TECH, AllRecipes, GetValidRecipe = _G.RECIPETABS, _G.TECH, _G.AllRecipes, _G.GetValidRecipe
EQUIPSLOTS, FRAMES, FOODTYPE, FUELTYPE = _G.EQUIPSLOTS, _G.FRAMES, _G.FOODTYPE, _G.FUELTYPE

State, TimeEvent, EventHandler = _G.State, _G.TimeEvent, _G.EventHandler
ACTIONS, ActionHandler = _G.ACTIONS, _G.ActionHandler
CAMERASHAKE, ShakeAllCameras = _G.CAMERASHAKE, _G.ShakeAllCameras

SpawnPrefab, ErodeAway, FindEntity = _G.SpawnPrefab, _G.ErodeAway, _G.FindEntity
KnownModIndex, Vector3, Remap = _G.KnownModIndex, _G.Vector3, _G.Remap
COMMAND_PERMISSION, BufferedAction, SendRPCToServer, RPC = _G.COMMAND_PERMISSION, _G.BufferedAction, _G.SendRPCToServer,
	_G.RPC
COLLISION = _G.COLLISION

AllPlayers = _G.AllPlayers



GLOBAL.TUNING.tropical = {
	wind                         = GetModConfigData("wind"),
	hail                         = GetModConfigData("hail"),
	hamworld                     = GetModConfigData("kindofworld"),
	bramble                      = GetModConfigData("bramble"),
	roc                          = GetModConfigData("roc"),
	megarandomCompatibilityWater = GetModConfigData("megarandomCompatibilityWater"),
	disableWater                 = GetModConfigData("Disable_Water"),
	springflood                  = GetModConfigData("flood"),
	sealnado                     = GetModConfigData("sealnado"),
	waves                        = GetModConfigData("Waves"),
	hamlet                       = GetModConfigData("Hamlet"),
	shipwrecked                  = GetModConfigData("Shipwrecked"),
	tropicalshards               = GetModConfigData("tropicalshards"),
	removedark                   = GetModConfigData("removedark"),
	aporkalypse                  = GetModConfigData("aporkalypse"),
	multiplayerportal            = GetModConfigData("startlocation"),
	greenmod                     = GLOBAL.KnownModIndex:IsModEnabled("workshop-1418878027"),
	kindofworld                  = GetModConfigData("kindofworld"),
	volcaniceruption             = GetModConfigData("volcaniceruption"),
	forge                        = GetModConfigData("forge"),
	fog                          = GetModConfigData("fog"),
	hayfever                     = GetModConfigData("hayfever"),
	disembarkation               = GetModConfigData("automatic_disembarkation"),
	bosslife                     = GetModConfigData("bosslife"),
}



PrefabFiles =
{
	"house_wall",
	"sparkle_fx",
	"fx",
	"Axes",
	"armor_obsidian",
	"meteor_impact",
	"dug_cofeecactus",
	"turfesvolcanobiome",
	"snake",
	"snake_hole",
	"snakeskin",
	"poisonbubble",
	"venom_gland",
	"harpoon",
	"new_hats",
	"parrot_pirate",
	"dubloon",
	"machetes",
	"tunacan",
	"seagull",
	"toucan",
	"lake",
	--"lakeinside",
	"boatcork",
	"frogpoison",
	"mosquitopoison",
	"cormorant",
	"antidote",
	"chiminea",
	"chimineafire",
	"armor_seashell",
	"ox_horn",
	"ox",
	"oxherd",
	"knightboat_cannonshot",
	"rowboat_wake", --trail do rowboat
	"splash_water",
	"blubber",
	"fish_med",
	"debris", --debris_1, debris_2, debris_3, debris_4 espalhar na praia
	"boatrepairkit",
	"sandbag",
	"cutlass",
	"cookpotfoodssw",
	"luggarechestspawn",
	"porto",
	"porto2",
	"buriedtreasure",
	"windtrail",
	"windswirl",
	"ventania",
	"sail",
	"boattorch",
	"boatlantern",
	"boatcannon",
	"woodlegs_boatcannon",
	"quackeringram",
	"quackenbeak",
	"quackendrill",
	"quackering_wave",
	"quackering_wake",
	"trawlnet",
	"boatsurf",
	"boatsurfothers",
	"boatpirate",
	"turbine_blades",
	"buoy",
	"armor_lifejacket",
	"saplingnova",
	"edgefog",
	"boatpirateamigo",
	"shadowwaxwell_boat",
	"luckyhat",
	"telescope",
	"thatchpack",
	"parrot",
	"seagullwater",
	"seaweed_stalk",
	"corallarve",
	"nubbin",
	"coconade",
	"piratepack",
	"ox_flute",
	"blubbersuit",
	"tarsuit",
	"tarlamp",
	"waterchest",
	"mussel_bed",
	"mussel_stick",
	"messagebottle1",
	"bottlelantern",
	"researchlab5",
	"roe",
	"roe_fish",
	"fishfarm",
	"fishfarm_sign",
	"mussel_farm",
	"sea_chiminea",
	"tar_extractor",
	"seatrap",
	--"flood",
	"hail",
	"wave_ripple",
	-------------------------complemento---------------------------------
	"twister_defogo",
	"twister_tornadodefogo",
	"firetwister_spawner",
	"fire_twister_seal",
	"walani",
	"wilbur",
	"woodlegs",
	"glass",
	"grass_tall",
	"asparagus",
	"deep_jungle_fern_noise",
	"vampirebatcave",
	"vampirebatcave_interior",
	"roc_cave_entrance",
	"roc_cave_interior",
	"vampitecave_deco",
	"spearlauncher",
	"spear_wathgrithr",
	"speargun",
	"jungletreeguard",
	"seataro_planted",
	"seatarospawner",
	"ox_wool",
	"conch",
	"seacucumber",
	"watercress",
	"jungletreeguard_snake",
	"armor_cactus",
	"scorpionte",
	"cookpotfoodshamlet",
	"cork",
	"corkbat",
	"hats_hamlet",
	"sedimentpuddle",
	"flood_ice",
	"snake2",
	"bramble",
	"bramble_bulb",
	"dungball",
	"dungbeetle",
	"dungpile",
	"chitin",
	"pinkman",
	"oincpile",
	"piggolem",
	"turfshamlet",
	"krakenchest",
	"lavaarena_hound",
	"lavaarena_knight",
	"lavaarena_merm",
	"lavaarena_spider",
	"lavaarena_bishop",
	"frog_poison",
	"spearsw",
	"boatmetal",
	"bird_swarm",
	"birds_ham",
	"blunderbuss",

	"cloudpuff",
	"bishopwater",
	"rookwater",
	"solofish",
	"tropicalspawnblocker",
	"whaletrack",
	"swfishbait",

	"beds",
	"rug",
	"shears",
	"gold_dust",
	"goldpan",
	-------
	"icebearger",
	"icedeerclops",
	"icerockcreatures",
	"cave_exit_vulcao",
	"cave_entrance_vulcao",
	"vidanomar",
	"vidanomarseaworld",
	"ashfx",
	"boat_raft_rot",
	"panda",
	"pandaskin",
	"pandatree",
	"nectar_pod",
	"piggravestone",
	"mangrovespawner",
	"oxwaterspawner",
	"grasswaterspawner",
	"waterreedspawner",
	"fishinholewaterspawner",
	"poisonbalm",
	"seasack",
	"magic_seal",
	"wind_conch",
	"sail_stick",
	"armor_windbreaker",
	"vine",
	"basefan",
	"floodsw",
	"birdwhistle",
	"bundled_structure",
	"lavaarena_armor",
	"lavarenainside",
	"teleportato2",
	"galinheiro",
	"invisiblepondfish",
	"spider_mutators_new",
	"anthillcave",
	"anthill_cavelamp",
	"grotto_grub_nest",
	"grotto_grub",
	"grotto_parsnip",
	"otter",
	"grottoqueen",
	"icedpad",
	--"yeti",
	"artic_flower",
	"watertree_pillar2",
	"firerain",
	"lavapool",
	"obsidian",
	"bramble_bush",
	"tidalpoolnew",
	"marsh_tree_new",
	"ligamundo",
}

if GetModConfigData("whirlpools") then
	table.insert(PrefabFiles, "whirlpool")
end

table.insert(PrefabFiles, "pigbanditexit")
if GetModConfigData("tropicalshards") ~= 0 then
	table.insert(PrefabFiles, "porkland_sw_entrance")
end

if GetModConfigData("kindofworld") == 10 or GetModConfigData("raftlog") then
	table.insert(PrefabFiles, "boatraft_old")
	table.insert(PrefabFiles, "boatlog_old")
end
table.insert(PrefabFiles, "boatraft")

table.insert(PrefabFiles, "vampirebat")
table.insert(PrefabFiles, "aporkalypse_clock")
table.insert(PrefabFiles, "hanging_vine")
table.insert(PrefabFiles, "grabbing_vine")

table.insert(PrefabFiles, "dragoonegg") --jogo da erro de memoria se tirar
table.insert(PrefabFiles, "tigersharkpool")
table.insert(PrefabFiles, "tigersharktorch")
table.insert(PrefabFiles, "hatty_piggy_tfc")
table.insert(PrefabFiles, "boarmound")
table.insert(PrefabFiles, "roc_nest")
table.insert(PrefabFiles, "glowfly")
table.insert(PrefabFiles, "rabid_beetle")
table.insert(PrefabFiles, "obsidianstaff")
table.insert(PrefabFiles, "mermhouse_fisher")
table.insert(PrefabFiles, "mermtrader")
table.insert(PrefabFiles, "pig_scepter")

table.insert(PrefabFiles, "quagmire_mushroomstump")
table.insert(PrefabFiles, "quagmire_mushrooms")
table.insert(PrefabFiles, "quagmire_fern")
table.insert(PrefabFiles, "quagmire_pebblecrab")
table.insert(PrefabFiles, "quagmire_safe")
table.insert(PrefabFiles, "wildbeaver")
table.insert(PrefabFiles, "wildbeaver_house")
table.insert(PrefabFiles, "beaverskin")
table.insert(PrefabFiles, "quagmire_park_gate")
table.insert(PrefabFiles, "quagmire_parkspike")
table.insert(PrefabFiles, "wildbeaverguard")
table.insert(PrefabFiles, "beaver_head")
table.insert(PrefabFiles, "beavertorch")
table.insert(PrefabFiles, "quagmire_key")
table.insert(PrefabFiles, "quagmire_goatkid")


if GetModConfigData("kindofworld") == 5 or GetModConfigData("enableallprefabs") == true then
	table.insert(PrefabFiles, "roc")
	table.insert(PrefabFiles, "roc_leg")
	table.insert(PrefabFiles, "roc_head")
	table.insert(PrefabFiles, "roc_tail")
end
table.insert(PrefabFiles, "roc_robin_egg")
table.insert(PrefabFiles, "ro_bin_gizzard_stone")
table.insert(PrefabFiles, "ro_bin")
table.insert(PrefabFiles, "gnatmound")
table.insert(PrefabFiles, "gnat")

---------------lillypad biome------------------------
if GetModConfigData("lilypad") ~= 0 or GetModConfigData("enableallprefabs") == true or GetModConfigData("kindofworld") == 5 or GetModConfigData("hamletcaves_shipwreckedworld") == 1 then
	table.insert(PrefabFiles, "hippo_antler")
	table.insert(PrefabFiles, "hippoherd")
	table.insert(PrefabFiles, "hippoptamoose")
	table.insert(PrefabFiles, "lillypad")
	table.insert(PrefabFiles, "lotus")
	table.insert(PrefabFiles, "lotus_flower1")
	table.insert(PrefabFiles, "bill")
	table.insert(PrefabFiles, "bill_quill")
	table.insert(PrefabFiles, "reeds_water")
end
---------------lavaarena volcano---------------------


table.insert(PrefabFiles, "flame_elemental_tfc")
table.insert(PrefabFiles, "tfwp_elemental")
table.insert(PrefabFiles, "tfwp_hats")
table.insert(PrefabFiles, "tfwp_armor")
--table.insert(PrefabFiles,"tfwp_control_book")
--table.insert(PrefabFiles,"tfwp_summon_book")
table.insert(PrefabFiles, "tfwp_lava_hammer")
table.insert(PrefabFiles, "tfwp_spear_gung")
table.insert(PrefabFiles, "tfwp_spear_lance")
table.insert(PrefabFiles, "tfwp_healing_staff")
table.insert(PrefabFiles, "tfwp_infernal_staff")
table.insert(PrefabFiles, "tfwp_dragon_dart")
table.insert(PrefabFiles, "tfwp_lava_dart")
--table.insert(PrefabFiles,"tfwp_freeze_emitter")
table.insert(PrefabFiles, "tfwp_fire_bomb")
table.insert(PrefabFiles, "tfwp_heavy_sword")

table.insert(PrefabFiles, "tfwp_riledlucy")
table.insert(PrefabFiles, "tfwp_forge_books")
table.insert(PrefabFiles, "tfwp_forge_fireball_projectile")
table.insert(PrefabFiles, "tfwp_infernalstaff_meteor")
table.insert(PrefabFiles, "tfwp_weaponsparks_fx")
table.insert(PrefabFiles, "tfwp_forgespear_fx")
table.insert(PrefabFiles, "tfwp_healingcircle")
table.insert(PrefabFiles, "tfwp_healingcircle_regenbuff")

if GetModConfigData("greenworld") or GetModConfigData("forge") == 1 then
	table.insert(PrefabFiles, "lavaarena_bossboar")
end

-- if GetModConfigData("forge") == 1 then
-- 	table.insert(PrefabFiles, "teleportato_sw_parts")
-- 	table.insert(PrefabFiles, "teleportato_sw")
-- 	table.insert(PrefabFiles, "lavaarena_rhinodrill")
-- 	table.insert(PrefabFiles, "lavaarena_beetletaur")
-- 	table.insert(PrefabFiles, "lavaarena_boarlord")
-- 	table.insert(PrefabFiles, "lavaarena_spectator")
-- 	table.insert(PrefabFiles, "lavaarena_spawner2")
-- 	table.insert(PrefabFiles, "lavaarena_center")
-- 	table.insert(PrefabFiles, "lavaarena_floorgrate")
-- 	table.insert(PrefabFiles, "lavarenaescada")
-- 	table.insert(PrefabFiles, "strange_scorpion_tfc")
-- 	table.insert(PrefabFiles, "lizardman_tfc")
-- 	table.insert(PrefabFiles, "spiky_turtle_tfc")
-- 	table.insert(PrefabFiles, "spiky_monkey_tfc")
-- 	table.insert(PrefabFiles, "lavarenawaves")
-- end

-- table.insert(PrefabFiles, "quagmire_coins")

--------------------------------------------------------
table.insert(PrefabFiles, "obsidianbomb")
table.insert(PrefabFiles, "obsidianbombactive")
table.insert(PrefabFiles, "fabric")
table.insert(PrefabFiles, "armor_snakeskin")
if GetModConfigData("Shipwrecked") ~= 5 and GetModConfigData("kindofworld") ~= 5 or GetModConfigData("enableallprefabs") == true or GetModConfigData("Shipwrecked_plus") == true or GetModConfigData("kindofworld") == 20 then
	table.insert(PrefabFiles, "crate")
	table.insert(PrefabFiles, "dragoon")
	table.insert(PrefabFiles, "dragoonfire")
	table.insert(PrefabFiles, "dragoonspit")
	table.insert(PrefabFiles, "dragoonden")
	table.insert(PrefabFiles, "dragoonheart")
	table.insert(PrefabFiles, "volcano_shrub")
	table.insert(PrefabFiles, "flamegeyser")
	table.insert(PrefabFiles, "rock_obsidian")
	table.insert(PrefabFiles, "magma_rocks")
	table.insert(PrefabFiles, "obsidian_workbench")
	table.insert(PrefabFiles, "obsidianfirepit")
	table.insert(PrefabFiles, "obsidianfirefire")
	table.insert(PrefabFiles, "elephantcactus")
	table.insert(PrefabFiles, "coffeebush")
	table.insert(PrefabFiles, "coffeebeans")
	table.insert(PrefabFiles, "coffee")
	table.insert(PrefabFiles, "lavaerupt")
	table.insert(PrefabFiles, "volcano")
	table.insert(PrefabFiles, "woodlegs_cage")
	table.insert(PrefabFiles, "woodlegs_key1")
	table.insert(PrefabFiles, "woodlegs_key2")
	table.insert(PrefabFiles, "woodlegs_key3")
	table.insert(PrefabFiles, "woodlegs1")
	table.insert(PrefabFiles, "woodlegsghost")
	table.insert(PrefabFiles, "woodlegs_unlock")
	table.insert(PrefabFiles, "vulcano")
	table.insert(PrefabFiles, "escadadovulcao")
	--table.insert(PrefabFiles,"mermfisher")
	table.insert(PrefabFiles, "flup")
	table.insert(PrefabFiles, "flupegg")
	table.insert(PrefabFiles, "tidalpool")
	table.insert(PrefabFiles, "poisonhole")
	table.insert(PrefabFiles, "tigershark")
	table.insert(PrefabFiles, "tigersharkshadow")
	table.insert(PrefabFiles, "volcanofog")
	table.insert(PrefabFiles, "flupspawner")
	table.insert(PrefabFiles, "jungletrees")
	table.insert(PrefabFiles, "jungletreeseed")
	table.insert(PrefabFiles, "bambootree")
	table.insert(PrefabFiles, "bamboo")
	table.insert(PrefabFiles, "wildbore")
	table.insert(PrefabFiles, "wildborehouse")
	table.insert(PrefabFiles, "doydoy")
	table.insert(PrefabFiles, "doydoy_mating_fx")
	table.insert(PrefabFiles, "doydoyegg")
	table.insert(PrefabFiles, "doydoyfeather")
	table.insert(PrefabFiles, "doydoyherd")
	table.insert(PrefabFiles, "doydoynest")
	table.insert(PrefabFiles, "livingjungletree")
	table.insert(PrefabFiles, "doydoy_spawner")
	table.insert(PrefabFiles, "berrybush2_snake")
	table.insert(PrefabFiles, "lavapondbig")
	table.insert(PrefabFiles, "bigfoot")
	table.insert(PrefabFiles, "glommerbell")
	table.insert(PrefabFiles, "sweet_potato")
	table.insert(PrefabFiles, "doydoyfan")
	table.insert(PrefabFiles, "sand_castle")
	table.insert(PrefabFiles, "sandhill")
	table.insert(PrefabFiles, "sand")
	table.insert(PrefabFiles, "seashell")
	table.insert(PrefabFiles, "seashell_beached")
	table.insert(PrefabFiles, "rock_limpet")
	table.insert(PrefabFiles, "limpets")
	table.insert(PrefabFiles, "palmleaf")
	table.insert(PrefabFiles, "palmleafhut")
	table.insert(PrefabFiles, "palmtrees")
	table.insert(PrefabFiles, "coconut")
	table.insert(PrefabFiles, "crab")
	table.insert(PrefabFiles, "crabhole")
	table.insert(PrefabFiles, "treeguard")
	table.insert(PrefabFiles, "treeguard_coconut")
	table.insert(PrefabFiles, "warningshadow")
	table.insert(PrefabFiles, "slotmachine")
	table.insert(PrefabFiles, "sharkitten")
	table.insert(PrefabFiles, "sharkittenspawner")
	table.insert(PrefabFiles, "bush_vine")
	table.insert(PrefabFiles, "primeapebarrel")
	table.insert(PrefabFiles, "monkeyball")
	table.insert(PrefabFiles, "shark_gills")
	table.insert(PrefabFiles, "primeape")
	table.insert(PrefabFiles, "icemaker")
	table.insert(PrefabFiles, "tigereye")
	table.insert(PrefabFiles, "packim")
	table.insert(PrefabFiles, "packim_fishbone")
end

-------- pprefabs gorge -----------

-- table.insert(PrefabFiles, "q_swampig")
-- table.insert(PrefabFiles, "q_swampig_house")
-- table.insert(PrefabFiles, "q_pond")
-- table.insert(PrefabFiles, "q_beefalo")
-- table.insert(PrefabFiles, "q_sugarwoodtree")
-- table.insert(PrefabFiles, "q_sap")
-- table.insert(PrefabFiles, "q_sugarwoodtree_sapling")
-- table.insert(PrefabFiles, "quagmiregoat")
-- table.insert(PrefabFiles, "quagmiregoatherd")
-- table.insert(PrefabFiles, "q_sugarwoodtree_cone")
-- table.insert(PrefabFiles, "q_pigeon")
-- table.insert(PrefabFiles, "q_spiceshrub")
-- table.insert(PrefabFiles, "maxwellendgame")
-- table.insert(PrefabFiles, "maxwelllight")
-- table.insert(PrefabFiles, "maxwelllight_flame")
-- table.insert(PrefabFiles, "maxwellminions")
-- table.insert(PrefabFiles, "maxwellboss")
-- table.insert(PrefabFiles, "maxwelllock")
-- table.insert(PrefabFiles, "maxwellshadowmeteor")
-- table.insert(PrefabFiles, "maxwellphonograph")
-- table.insert(PrefabFiles, "maxwellestatua")
-- table.insert(PrefabFiles, "maxwellshadowheart")

table.insert(PrefabFiles, "tree_forest")
table.insert(PrefabFiles, "tree_forest_deep")
table.insert(PrefabFiles, "tree_forest_rot")
table.insert(PrefabFiles, "tree_forestseed")
table.insert(PrefabFiles, "spider_monkey_tree")
table.insert(PrefabFiles, "spider_monkey")
table.insert(PrefabFiles, "spider_monkey_herd")
table.insert(PrefabFiles, "spider_ape")
table.insert(PrefabFiles, "trapslug")
table.insert(PrefabFiles, "antman2")
table.insert(PrefabFiles, "fennel")
table.insert(PrefabFiles, "pig_palace2")
table.insert(PrefabFiles, "pig_palace2_interior")
table.insert(PrefabFiles, "peagawk_prism")
table.insert(PrefabFiles, "peagawkfeather_prism")
table.insert(PrefabFiles, "city_lamp2")
table.insert(PrefabFiles, "pig_guard_tower2")
table.insert(PrefabFiles, "wall_spawn_city")
table.insert(PrefabFiles, "spider_ape_tree")
table.insert(PrefabFiles, "slipstor")
table.insert(PrefabFiles, "slip")
table.insert(PrefabFiles, "slipstor_spawner")

-- if GetModConfigData("Shipwrecked_plus") == true or GetModConfigData("enableallprefabs") == true or GetModConfigData("Shipwreckedworld_plus") == true then
-- 	table.insert(PrefabFiles, "goldbishop")
-- 	table.insert(PrefabFiles, "goldentomb")
-- 	table.insert(PrefabFiles, "goldmonkey")
-- 	table.insert(PrefabFiles, "goldbishop")
-- 	table.insert(PrefabFiles, "goldobi")


-- 	table.insert(PrefabFiles, "tikihead")
-- 	table.insert(PrefabFiles, "teepee")
-- 	table.insert(PrefabFiles, "tikimask")
-- 	table.insert(PrefabFiles, "tikifire")
-- 	table.insert(PrefabFiles, "wanawanatiki")
-- 	table.insert(PrefabFiles, "tikistick")

-- 	table.insert(PrefabFiles, "summerwalrus")
-- 	table.insert(PrefabFiles, "summerigloo")

-- 	table.insert(PrefabFiles, "octoatt")
-- 	table.insert(PrefabFiles, "octopus")
-- 	table.insert(PrefabFiles, "octohouse")
-- end

----- prefabs marinhos---------------
table.insert(PrefabFiles, "coralreef")
table.insert(PrefabFiles, "coral")
table.insert(PrefabFiles, "seaweed_planted")
table.insert(PrefabFiles, "seaweed")
table.insert(PrefabFiles, "mangrovetrees")
table.insert(PrefabFiles, "mangrovetreesbee")
table.insert(PrefabFiles, "spidercoralhole")
table.insert(PrefabFiles, "tentacleunderwater")
table.insert(PrefabFiles, "grass_water")
table.insert(PrefabFiles, "rocksunderwater")
table.insert(PrefabFiles, "wreck")

table.insert(PrefabFiles, "fishinhole")
table.insert(PrefabFiles, "octopusking")
table.insert(PrefabFiles, "kraken_tentacle")
table.insert(PrefabFiles, "kraken_projectile")
table.insert(PrefabFiles, "kraken")
table.insert(PrefabFiles, "kraken_jellyfish")
table.insert(PrefabFiles, "kraken_spawner")
table.insert(PrefabFiles, "solofish")
table.insert(PrefabFiles, "swordfish")

table.insert(PrefabFiles, "sharx")
table.insert(PrefabFiles, "stungray")
table.insert(PrefabFiles, "pirateghost")
table.insert(PrefabFiles, "redbarrel")
table.insert(PrefabFiles, "lobsterhole")
table.insert(PrefabFiles, "mussel")
table.insert(PrefabFiles, "waterygrave")
table.insert(PrefabFiles, "bioluminescence")
table.insert(PrefabFiles, "boatrowarmored")
table.insert(PrefabFiles, "boatrowcargo")
table.insert(PrefabFiles, "rawling")
table.insert(PrefabFiles, "coral_brain_rock")
table.insert(PrefabFiles, "coral_brain")
table.insert(PrefabFiles, "limestone")
table.insert(PrefabFiles, "shark_fin")

table.insert(PrefabFiles, "rainbowjellyfish")
table.insert(PrefabFiles, "rainbowjellyfish_planted")
table.insert(PrefabFiles, "sea_yard")
table.insert(PrefabFiles, "sea_yard_arms_fx")
table.insert(PrefabFiles, "tar")
table.insert(PrefabFiles, "tar_pool")
table.insert(PrefabFiles, "bioluminescence_spawner")
table.insert(PrefabFiles, "boatrow")
table.insert(PrefabFiles, "flotsam_debris_sw")
table.insert(PrefabFiles, "boatrowencrusted")
table.insert(PrefabFiles, "ballphin")
table.insert(PrefabFiles, "ballphinhouse")

table.insert(PrefabFiles, "dorsalfin")
table.insert(PrefabFiles, "ballphinpod")
table.insert(PrefabFiles, "jellyfish")
table.insert(PrefabFiles, "jellyfish_planted")
table.insert(PrefabFiles, "crocodog_spawner")
table.insert(PrefabFiles, "crocodog")
table.insert(PrefabFiles, "whale")
table.insert(PrefabFiles, "whale_carcass")
table.insert(PrefabFiles, "knightboat")
table.insert(PrefabFiles, "poisonmistparticle")


table.insert(PrefabFiles, "deco_util")
table.insert(PrefabFiles, "deco_util2")
table.insert(PrefabFiles, "deco_swinging_light")
table.insert(PrefabFiles, "deco_lightglow")
table.insert(PrefabFiles, "pig_shop_spears")

if GetModConfigData("pigcity1") ~= 5 or GetModConfigData("pigcity2") ~= 5 or GetModConfigData("kindofworld") == 5 or GetModConfigData("frost_island") ~= 5 or GetModConfigData("enableallprefabs") == true or GetModConfigData("hamletcaves_shipwreckedworld") == 1 then
	table.insert(PrefabFiles, "topiary")
	table.insert(PrefabFiles, "lawnornaments")
	table.insert(PrefabFiles, "hedge")
	table.insert(PrefabFiles, "clippings")
	table.insert(PrefabFiles, "city_lamp")
	table.insert(PrefabFiles, "hamlet_cones")
	table.insert(PrefabFiles, "securitycontract")
	table.insert(PrefabFiles, "city_hammer")
	table.insert(PrefabFiles, "magnifying_glass")
	table.insert(PrefabFiles, "pigbandit")
	table.insert(PrefabFiles, "banditmap")
	table.insert(PrefabFiles, "pig_shop")
	table.insert(PrefabFiles, "pig_shop_produce_interior")
	table.insert(PrefabFiles, "pig_shop_hoofspa_interior")
	table.insert(PrefabFiles, "pig_shop_general_interior")
	table.insert(PrefabFiles, "pig_shop_florist_interior")
	table.insert(PrefabFiles, "pig_shop_deli_interior")
	table.insert(PrefabFiles, "pig_shop_academy_interior")

	table.insert(PrefabFiles, "pig_shop_cityhall_interior")
	table.insert(PrefabFiles, "pig_shop_cityhall_player_interior")

	table.insert(PrefabFiles, "pig_shop_hatshop_interior")
	table.insert(PrefabFiles, "pig_shop_weapons_interior")
	table.insert(PrefabFiles, "pig_shop_bank_interior")
	table.insert(PrefabFiles, "pig_shop_arcane_interior")
	table.insert(PrefabFiles, "pig_shop_antiquities_interior")
	table.insert(PrefabFiles, "pig_shop_tinker_interior")
	table.insert(PrefabFiles, "pig_palace_interior")
	table.insert(PrefabFiles, "pig_palace")

	table.insert(PrefabFiles, "pigman_shopkeeper_desk")
	table.insert(PrefabFiles, "shop_pedestals")
	table.insert(PrefabFiles, "deed")
	table.insert(PrefabFiles, "playerhouse_city_interior")
	table.insert(PrefabFiles, "playerhouse_city_interior2")
	table.insert(PrefabFiles, "shelf")
	table.insert(PrefabFiles, "shelf_slot")
	table.insert(PrefabFiles, "trinkets_giftshop")
	table.insert(PrefabFiles, "key_to_city")
	table.insert(PrefabFiles, "wallpaper")
	table.insert(PrefabFiles, "player_house_kits")
	table.insert(PrefabFiles, "player_house")

	table.insert(PrefabFiles, "pigman_city")
	table.insert(PrefabFiles, "pighouse_city")
	table.insert(PrefabFiles, "pig_guard_tower")
	table.insert(PrefabFiles, "armor_metal")
	table.insert(PrefabFiles, "reconstruction_project")
	table.insert(PrefabFiles, "water_spray")
	table.insert(PrefabFiles, "water_pipe")
	table.insert(PrefabFiles, "sprinkler1")
	table.insert(PrefabFiles, "alloy")
	table.insert(PrefabFiles, "smelter")
	table.insert(PrefabFiles, "halberd")
	table.insert(PrefabFiles, "oinc")
	table.insert(PrefabFiles, "oinc10")
	table.insert(PrefabFiles, "oinc100")
end

if GetModConfigData("startlocation") == 15 or GetModConfigData("kindofworld") == 5 or GetModConfigData("enableallprefabs") == true then
	table.insert(PrefabFiles, "porklandintro")
end


if TUNING.tropical.sealnado or GetModConfigData("enableallprefabs") == true then
	table.insert(PrefabFiles, "twister")
	table.insert(PrefabFiles, "twister_spawner")
	table.insert(PrefabFiles, "twister_seal")
	table.insert(PrefabFiles, "twister_tornado")
end



if GetModConfigData("frost_island") ~= 5 and GetModConfigData("kindofworld") ~= 5 or GetModConfigData("enableallprefabs") == true then
	table.insert(PrefabFiles, "billsnow")
	table.insert(PrefabFiles, "giantsnow")
	table.insert(PrefabFiles, "snowman")
	table.insert(PrefabFiles, "bear")
	table.insert(PrefabFiles, "ice_deer")
	table.insert(PrefabFiles, "mammoth")
	table.insert(PrefabFiles, "bearden")
	table.insert(PrefabFiles, "snowitem")
	table.insert(PrefabFiles, "snow_dune")
	table.insert(PrefabFiles, "snow_castle")
	table.insert(PrefabFiles, "cratesnow")
	table.insert(PrefabFiles, "snowpile1")
	table.insert(PrefabFiles, "snowbigball")
	table.insert(PrefabFiles, "snowbeetle")
	table.insert(PrefabFiles, "snowspider_spike")
	table.insert(PrefabFiles, "snowspiderden")
	table.insert(PrefabFiles, "snowberrybush")
	table.insert(PrefabFiles, "snowspider")
	table.insert(PrefabFiles, "snowspider2")
	table.insert(PrefabFiles, "snowspider_spike2")
	table.insert(PrefabFiles, "snowspiderden2")
	table.insert(PrefabFiles, "rock_ice_frost")
	table.insert(PrefabFiles, "icepillar")
	table.insert(PrefabFiles, "snowgoat")
	table.insert(PrefabFiles, "snowgoatherd")
	table.insert(PrefabFiles, "snowwarg")
	table.insert(PrefabFiles, "snowperd")
	table.insert(PrefabFiles, "snowdeciduoustrees")
	table.insert(PrefabFiles, "rock_ice_frost_spawner")
	table.insert(PrefabFiles, "snowwarg_spawner")
end
--[[
if (GetModConfigData("frost_island") == 15 or GetModConfigData("frost_island") == 25) and GetModConfigData("kindofworld") ~= 5 then
table.insert(PrefabFiles,"lavarenainside")
table.insert(PrefabFiles,"teleportato2")
table.insert(PrefabFiles,"telebase")


table.insert(PrefabFiles,"quest")
table.insert(PrefabFiles,"maxwellinside")	
table.insert(PrefabFiles,"maxwellportal")
table.insert(PrefabFiles,"maxwellthrone")

end
]]

table.insert(PrefabFiles, "chicken")
table.insert(PrefabFiles, "peekhen")
table.insert(PrefabFiles, "peekhenspawner")
table.insert(PrefabFiles, "snapdragon")
table.insert(PrefabFiles, "snapdragonherd")
table.insert(PrefabFiles, "crabapple_tree")
table.insert(PrefabFiles, "zeb")
table.insert(PrefabFiles, "wildboreking")
table.insert(PrefabFiles, "wildbore_minion")
table.insert(PrefabFiles, "wildborekingstaff")
table.insert(PrefabFiles, "wildboreking_spawner")


if GetModConfigData("Hamlet") ~= 5 or GetModConfigData("startlocation") == 15 or GetModConfigData("kindofworld") == 5 or GetModConfigData("enableallprefabs") == true or GetModConfigData("hamletcaves_shipwreckedworld") == 1 then --GetModConfigData("Plains_Hamlet")
	table.insert(PrefabFiles, "rainforesttrees")
	table.insert(PrefabFiles, "rainforesttree_sapling")
	table.insert(PrefabFiles, "meteor_impact")
	table.insert(PrefabFiles, "tuber")
	table.insert(PrefabFiles, "tubertrees")
	table.insert(PrefabFiles, "pangolden")
	table.insert(PrefabFiles, "thunderbird")
	table.insert(PrefabFiles, "thunderbirdnest")
	table.insert(PrefabFiles, "ancient_robots")
	table.insert(PrefabFiles, "ancient_hulk")
	table.insert(PrefabFiles, "ancient_herald")
	table.insert(PrefabFiles, "armor_vortex_cloak")
	table.insert(PrefabFiles, "living_artifact")
	table.insert(PrefabFiles, "rock_basalt")
	table.insert(PrefabFiles, "ancient_robots_assembly")
	table.insert(PrefabFiles, "laser_ring")
	table.insert(PrefabFiles, "laser")
	table.insert(PrefabFiles, "iron")

	table.insert(PrefabFiles, "pheromonestone")

	if GetModConfigData("luajit") then
		table.insert(PrefabFiles, "pig_ruins_maze_old")
	else
		if GetModConfigData("compactruins") then
			table.insert(PrefabFiles, "pig_ruins_mazecompact")
		else
			table.insert(PrefabFiles, "pig_ruins_maze")
		end
	end

	table.insert(PrefabFiles, "anthill_interior")
	table.insert(PrefabFiles, "anthill_lamp")
	table.insert(PrefabFiles, "anthill_stalactite")
	table.insert(PrefabFiles, "antchest")
	table.insert(PrefabFiles, "antcombhome")
	table.insert(PrefabFiles, "antcombhomecave")
	table.insert(PrefabFiles, "giantgrub")
	table.insert(PrefabFiles, "antqueen")
	table.insert(PrefabFiles, "rocksham")
	table.insert(PrefabFiles, "deco_ruins_fountain")

	table.insert(PrefabFiles, "pig_ruins_entrance_interior")
	table.insert(PrefabFiles, "pig_ruins_entrance")
	table.insert(PrefabFiles, "pig_ruins_dart_statue")
	table.insert(PrefabFiles, "pig_ruins_dart")
	table.insert(PrefabFiles, "pig_ruins_creeping_vines")
	table.insert(PrefabFiles, "pig_ruins_pressure_plate")
	table.insert(PrefabFiles, "pig_ruins_spear_trap")
	table.insert(PrefabFiles, "smashingpot")
	table.insert(PrefabFiles, "pig_ruins_light_beam")
	table.insert(PrefabFiles, "littlehammer")
	table.insert(PrefabFiles, "relics")
	table.insert(PrefabFiles, "gascloud")
	table.insert(PrefabFiles, "bugrepellent")


	table.insert(PrefabFiles, "teatree_nut")
	table.insert(PrefabFiles, "teatrees")
	table.insert(PrefabFiles, "piko")
	table.insert(PrefabFiles, "clawpalmtrees")
	table.insert(PrefabFiles, "clawpalmtree_sapling")
	table.insert(PrefabFiles, "bugfood")
	table.insert(PrefabFiles, "rock_flippable")
	table.insert(PrefabFiles, "peagawkfeather")
	table.insert(PrefabFiles, "peagawk")
	table.insert(PrefabFiles, "aloe")
	table.insert(PrefabFiles, "pog")
	table.insert(PrefabFiles, "weevole")
	table.insert(PrefabFiles, "weevole_carapace")
	table.insert(PrefabFiles, "armor_weevole")
	table.insert(PrefabFiles, "pugalisk")
	table.insert(PrefabFiles, "pugalisk_trap_door")
	table.insert(PrefabFiles, "pugalisk_ruins_pillar")
	table.insert(PrefabFiles, "pugalisk_fountain")
	table.insert(PrefabFiles, "waterdrop")
	table.insert(PrefabFiles, "floweroflife")
	table.insert(PrefabFiles, "gaze_beam")
	table.insert(PrefabFiles, "snake_bone")
	table.insert(PrefabFiles, "mandrakehouse")
	table.insert(PrefabFiles, "mandrakeman")

	table.insert(PrefabFiles, "jungle_border_vine")
	table.insert(PrefabFiles, "light_rays_ham")
	table.insert(PrefabFiles, "nettle")
	table.insert(PrefabFiles, "nettle_plant")
	table.insert(PrefabFiles, "rainforesttrees")
	table.insert(PrefabFiles, "rainforesttree_sapling")
	table.insert(PrefabFiles, "tree_pillar")
	table.insert(PrefabFiles, "flower_rainforest")
	table.insert(PrefabFiles, "pig_ruins_torch")
	table.insert(PrefabFiles, "mean_flytrap")
	table.insert(PrefabFiles, "radish")
	table.insert(PrefabFiles, "adult_flytrap")
	table.insert(PrefabFiles, "antman_warrior_egg")
	table.insert(PrefabFiles, "antman_warrior")
	table.insert(PrefabFiles, "antman")
	table.insert(PrefabFiles, "antlarva")
	table.insert(PrefabFiles, "anthill")
	table.insert(PrefabFiles, "antsuit")
	table.insert(PrefabFiles, "venus_stalk")
	table.insert(PrefabFiles, "walkingstick")
	table.insert(PrefabFiles, "cloudpuff")
end

Assets =
{
	--Asset("SOUNDPACKAGE", "sound/volcano.fev"),
	--Asset("SOUND", "sound/volcano.fsb"),
	--Asset("SOUND", "sound/boats.fsb"),
	--Asset("SOUND", "sound/creatures.fsb"),
	--Asset("SOUND", "sound/slot_machine.fsb"),
	--Asset("SOUND", "sound/waves.fsb"),
	--LOD SOUND FILE
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUNDPACKAGE", "sound/sw_character.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
	Asset("SOUND", "sound/sw_character.fsb"),
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
	Asset("IMAGE", "images/fog_cloud.tex"),
	--Asset("SOUND", "sound/amb_stream_SW.fsb"),
	--NEW SOUND FILE
	--Asset("SOUNDPACKAGE", "sound/volcano_new.fev"),
	--Asset("SOUND", "sound/volcano_new.fsb"),
	--Asset("SOUNDPACKAGE", "sound/tropical.fev"),
	--Asset("SOUND", "sound/tropical.fsb"),

	Asset("IMAGE", "images/barco.tex"),
	Asset("ATLAS", "images/barco.xml"),

	Asset("ATLAS", "images/inventoryimages/volcanoinventory.xml"),
	Asset("IMAGE", "images/inventoryimages/volcanoinventory.tex"),
	Asset("ATLAS", "images/inventoryimages/novositens.xml"),
	Asset("IMAGE", "images/inventoryimages/novositens.tex"),

	Asset("ANIM", "anim/player_actions_paddle.zip"),
	Asset("ANIM", "anim/player_actions_speargun.zip"),
	Asset("ANIM", "anim/player_actions_tap.zip"),
	Asset("ANIM", "anim/player_actions_panning.zip"),
	Asset("ANIM", "anim/player_actions_hand_lens.zip"),
	Asset("ANIM", "anim/player_mount_actions_speargun.zip"),
	Asset("ANIM", "anim/walani_paddle.zip"),
	Asset("ANIM", "anim/player_boat_death.zip"),
	Asset("ANIM", "anim/player_sneeze.zip"),
	Asset("ANIM", "anim/des_sail.zip"),
	Asset("ANIM", "anim/player_actions_trawl.zip"),
	Asset("ANIM", "anim/player_actions_machete.zip"),
	Asset("ANIM", "anim/player_actions_shear.zip"),
	Asset("ANIM", "anim/player_actions_cropdust.zip"),
	Asset("ANIM", "anim/ripple_build.zip"),
	Asset("ATLAS", "images/fx4te.xml"),
	Asset("IMAGE", "images/fx4te.tex"),
	Asset("ANIM", "anim/boat_health.zip"),
	Asset("ANIM", "anim/player_actions_telescope.zip"),
	Asset("ANIM", "anim/pig_house_old.zip"),

	Asset("ANIM", "anim/parrot_pirate_intro.zip"),
	Asset("ANIM", "anim/parrot_pirate.zip"),


	Asset("ANIM", "anim/pig_house_sale.zip"),


	Asset("ANIM", "anim/fish2.zip"),
	Asset("ANIM", "anim/fish3.zip"),
	Asset("ANIM", "anim/fish4.zip"),
	Asset("ANIM", "anim/fish5.zip"),
	Asset("ANIM", "anim/fish6.zip"),
	Asset("ANIM", "anim/fish7.zip"),
	Asset("ANIM", "anim/coi.zip"),
	Asset("ANIM", "anim/ballphinocean.zip"),
	Asset("ANIM", "anim/dogfishocean.zip"),
	Asset("ANIM", "anim/goldfish.zip"),
	Asset("ANIM", "anim/salmon.zip"),
	Asset("ANIM", "anim/sharxocean.zip"),
	Asset("ANIM", "anim/swordfishjocean.zip"),
	Asset("ANIM", "anim/swordfishjocean2.zip"),
	Asset("ANIM", "anim/mecfish.zip"),
	Asset("ANIM", "anim/whaleblueocean.zip"),
	Asset("ANIM", "anim/kingfisher_build.zip"),
	Asset("ANIM", "anim/parrot_blue_build.zip"),
	Asset("ANIM", "anim/toucan_hamlet_build.zip"),
	Asset("ANIM", "anim/toucan_build.zip"),
	Asset("ANIM", "anim/parrot_build.zip"),
	Asset("ANIM", "anim/parrot_pirate_build.zip"),
	Asset("ANIM", "anim/cormorant_build.zip"),
	Asset("ANIM", "anim/seagull_build.zip"),
	Asset("ANIM", "anim/quagmire_pigeon_build.zip"),
	Asset("ANIM", "anim/skeletons.zip"),
	Asset("ANIM", "anim/fish2.zip"),
	Asset("ANIM", "anim/oceanfish_small.zip"),
	Asset("ANIM", "anim/oceanfish_small_1.zip"),
	Asset("ANIM", "anim/oceanfish_small_2.zip"),
	Asset("ANIM", "anim/oceanfish_small_3.zip"),
	Asset("ANIM", "anim/oceanfish_small_4.zip"),
	Asset("ANIM", "anim/oceanfish_small_5.zip"),
	Asset("ANIM", "anim/oceanfish_small_6.zip"),
	Asset("ANIM", "anim/oceanfish_small_7.zip"),
	Asset("ANIM", "anim/oceanfish_small_8.zip"),
	Asset("ANIM", "anim/oceanfish_medium.zip"),
	Asset("ANIM", "anim/oceanfish_medium_1.zip"),
	Asset("ANIM", "anim/oceanfish_medium_2.zip"),
	Asset("ANIM", "anim/oceanfish_medium_3.zip"),
	Asset("ANIM", "anim/oceanfish_medium_4.zip"),
	Asset("ANIM", "anim/oceanfish_medium_5.zip"),
	Asset("ANIM", "anim/oceanfish_medium_6.zip"),
	Asset("ANIM", "anim/oceanfish_medium_7.zip"),
	Asset("ANIM", "anim/oceanfish_medium_8.zip"),
	Asset("IMAGE", "levels/textures/outro.tex"),
	Asset("IMAGE", "levels/textures/ground_noise_water_deep.tex"),
	Asset("IMAGE", "images/inventoryimages/hamletinventory.tex"),
	Asset("ATLAS", "images/inventoryimages/hamletinventory.xml"),
	Asset("IMAGE", "images/inventoryimages/meated_nettle.tex"),
	Asset("ATLAS", "images/inventoryimages/meated_nettle.xml"),

	Asset("ATLAS", "map_icons/hamleticon.xml"),
	Asset("IMAGE", "map_icons/hamleticon.tex"),
	Asset("ATLAS", "map_icons/creepindedeepicon.xml"),
	Asset("IMAGE", "map_icons/creepindedeepicon.tex"),
	Asset("ANIM", "anim/butterflymuffin.zip"),
	Asset("IMAGE", "images/tfwp_inventoryimgs.tex"),
	Asset("ATLAS", "images/tfwp_inventoryimgs.xml"),
	--Asset("SOUNDPACKAGE", "sound/Hamlet.fev"),
	--Asset("SOUND", "sound/Hamlet.fsb"),


	Asset("IMAGE", "images/names_wilbur.tex"),
	Asset("ATLAS", "images/names_wilbur.xml"),
	Asset("IMAGE", "images/names_woodlegs.tex"),
	Asset("ATLAS", "images/names_woodlegs.xml"),
	Asset("IMAGE", "images/names_walani.tex"),
	Asset("ATLAS", "images/names_walani.xml"),


	Asset("ATLAS", "images/tabs.xml"),
	Asset("IMAGE", "images/tabs.tex"),
	Asset("IMAGE", "images/turfs/turf01-9.tex"),
	Asset("ATLAS", "images/turfs/turf01-9.xml"),

	Asset("IMAGE", "images/turfs/turf01-10.tex"),
	Asset("ATLAS", "images/turfs/turf01-10.xml"),

	Asset("IMAGE", "images/turfs/turf01-11.tex"),
	Asset("ATLAS", "images/turfs/turf01-11.xml"),

	Asset("IMAGE", "images/turfs/turf01-12.tex"),
	Asset("ATLAS", "images/turfs/turf01-12.xml"),

	Asset("IMAGE", "images/turfs/turf01-13.tex"),
	Asset("ATLAS", "images/turfs/turf01-13.xml"),

	Asset("IMAGE", "images/turfs/turf01-14.tex"),
	Asset("ATLAS", "images/turfs/turf01-14.xml"),
	Asset("ANIM", "anim/vagner_over.zip"),
	Asset("ANIM", "anim/leaves_canopy2.zip"),

	Asset("ANIM", "anim/mushroom_tree_yelow.zip"),
	Asset("ANIM", "anim/speedicon.zip"),
}

AddMinimapAtlas("map_icons/creepindedeepicon.xml")



if GetModConfigData("gorgeisland") and GetModConfigData("kindofworld") == 15 or GetModConfigData("enableallprefabs") == true then
	table.insert(PrefabFiles, "quagmire_mealingstone")
	table.insert(PrefabFiles, "quagmire_flour")
	table.insert(PrefabFiles, "quagmire_foods")
	table.insert(PrefabFiles, "quagmire_goatmilk")
	table.insert(PrefabFiles, "quagmire_sap")
	table.insert(PrefabFiles, "quagmire_syrup")

	table.insert(PrefabFiles, "quagmire_casseroledish")
	table.insert(PrefabFiles, "quagmire_crates")
	table.insert(PrefabFiles, "quagmire_grill")
	table.insert(PrefabFiles, "quagmire_oven")
	table.insert(PrefabFiles, "quagmire_plates")
	table.insert(PrefabFiles, "quagmire_pot")
	table.insert(PrefabFiles, "quagmire_pot_hanger")
	table.insert(PrefabFiles, "quagmire_salt_rack")
	table.insert(PrefabFiles, "quagmire_sapbucket")
	table.insert(PrefabFiles, "quagmire_slaughtertool")
	table.insert(PrefabFiles, "quagmire_altar")
	table.insert(PrefabFiles, "quagmire_seedpackets")

	table.insert(PrefabFiles, "quagmire_sugarwoodtree")
	table.insert(PrefabFiles, "quagmire_sugarwood_sapling")

	table.insert(PrefabFiles, "quagmire_goatmum")
	table.insert(PrefabFiles, "quagmire_swampigelder")

	table.insert(PrefabFiles, "quagmire_oldstructures")
	table.insert(PrefabFiles, "quagmire_lamp_post")
	table.insert(PrefabFiles, "quagmire_altar_statue")
	table.insert(PrefabFiles, "quagmire_portal")

	table.insert(Assets, Asset("ATLAS", "images/inventoryimages/quagmirefoods.xml"))
	table.insert(Assets, Asset("IMAGE", "images/inventoryimages/quagmirefoods.tex"))
end


RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "limpets_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "limpets.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coconut_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coconut_halved.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coffeebeans.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coffeebeans_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "sweet_potato.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "sweet_potatos_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish_med.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "dead_swordfish.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish_raw.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish_med_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "quagmire_crabmeat.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "quagmire_crabmeat_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "lobster_land.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "lobster_dead.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "lobster_dead_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish_dogfish.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "mussel_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "mussel.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "shark_fin.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "crab.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_dried.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "doydoyegg.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "dorsalfin.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "jellyfish.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "jellyfish_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "jellyfish_dead.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "jellyjerky.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish2_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish3.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish3_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish4.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish4_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish5.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish5_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish6.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish6_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish7.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fish7_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "salmon.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "salmon_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coi.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "coi_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "snowitem.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "roe.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "roe_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seataro.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seataro_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "blueberries.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "blueberries_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seacucumber.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seacucumber_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "gooseberry.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "gooseberry_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "quagmire_mushrooms.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "quagmire_mushrooms_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_61_inv.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_61_inv_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_71_inv.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_71_inv_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_81_inv.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "oceanfish_small_81_inv_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "butterfly_tropical_wings.tex")

RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "jellybug.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "jellybug_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "slugbug.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "slugbug_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "cutnettle.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "radish.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "radish_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "asparagus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "asparagus_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "aloe.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "aloe_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "weevole_carapace.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "piko_orange.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "snake_bone.tex")


modimport("scripts/stringscomplement.lua")
modimport("scripts/stringscreeps.lua")
modimport("scripts/wurt_quotes.lua")

--configurar idioma
if GetModConfigData("set_idioma") ~= nil then
	if GetModConfigData("set_idioma") == "strings" then
		modimport("scripts/stringsEU.lua")
	else
		modimport("scripts/" .. GetModConfigData("set_idioma") .. ".lua")
	end
end



modimport("scripts/actions.lua")
modimport "tileadder.lua"
modimport("scripts/ham_fx.lua")

------------------------------------------------
--Start of Tile Adder. Copy this code to your modworldgenmain.lua for use.
--See tiledescription.lua and tileadder.lua for more details.
AddMinimap()
--End if Tile Adder.
------------------volcano-------------------
modimport("scripts/tools/waffles1")
--[[
AddPrefabPostInit("world", function(inst)
    local Map = getmetatable(inst.Map).__index

    Waffles1.SequenceFn(Map, "IsPassableAtPoint", function(passable, x, y, z)
        if passable then
            return true
        end
		
local ground = GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(x, y, z))
	if (ground == GROUND.OCEAN_COASTAL or ground == GROUND.OCEAN_COASTAL_SHORE or ground == GROUND.OCEAN_SWELL or ground == GROUND.OCEAN_ROUGH or ground == GROUND.OCEAN_BRINEPOOL or ground == GROUND.OCEAN_BRINEPOOL_SHORE or ground == GROUND.OCEAN_HAZARDOUS) then		
	return true
	end
        return #TheSim:FindEntities(x, y, z, 22, { "alt_tile" }) > 0
    end)

    Waffles1.SequenceFn(Map, "GetTileCenterPoint", function(pos)
        if pos ~= nil then
            return unpack(pos)
        end
        return 0, 0, 0
    end)
end)
]]
Waffles1.GetPath(_G, "STRINGS/ACTIONS/JUMPIN").USE = Waffles1.ReturnChild(STRINGS, "ACTIONS/USEITEM") or "Use"

Waffles1.GetPath(_G, "ACTIONS/JUMPIN").strfn = function(act)
	return act.doer ~= nil and act.doer:HasTag("playerghost") and "HAUNT"
		or act.target ~= nil and act.target:HasTag("stairs") and "USE"
		or nil
end

---------------dodoy
GLOBAL.doydoy_mate_time = 2
GLOBAL.doydoy_total_limit = 20
GLOBAL.seabeach_amount = {
	doydoy = 0,
}
---------------------------- new recipe tab for obsidian tools ---------------------
local _G = GLOBAL
local require = _G.require
local TechTree = require("techtree")
table.insert(TechTree.AVAILABLE_TECH, "OBSIDIAN")
table.insert(TechTree.AVAILABLE_TECH, "CITY")
table.insert(TechTree.AVAILABLE_TECH, "HOME")
table.insert(TechTree.AVAILABLE_TECH, "GODDESS")

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
		t[v] = t[v] or 0
	end
	return t
end

_G.TECH.NONE.OBSIDIAN = 0
_G.TECH.OBSIDIAN_ONE = { OBSIDIAN = 1 }
_G.TECH.OBSIDIAN_TWO = { OBSIDIAN = 2 }

_G.TECH.NONE.CITY = 0
_G.TECH.CITY_ONE = { CITY = 1 }
_G.TECH.CITY_TWO = { CITY = 2 }

_G.TECH.NONE.HOME = 0
_G.TECH.HOME_ONE = { HOME = 1 }
_G.TECH.HOME_TWO = { HOME = 2 }

_G.TECH.NONE.GODDESS = 0
_G.TECH.GODDESS_ONE = { GODDESS = 1 }
_G.TECH.GODDESS_TWO = { GODDESS = 2 }

--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
	v.OBSIDIAN = 0
	v.CITY = 0
	v.HOME = 0
	v.GODDESS = 0
end


TUNING.PROTOTYPER_TREES.OBSIDIAN_ONE = TechTree.Create({
	OBSIDIAN = 1,
})
TUNING.PROTOTYPER_TREES.OBSIDIAN_TWO = TechTree.Create({
	OBSIDIAN = 2,
})

TUNING.PROTOTYPER_TREES.CITY_ONE = TechTree.Create({
	CITY = 1,
})
TUNING.PROTOTYPER_TREES.CITY_TWO = TechTree.Create({
	CITY = 2,
})

TUNING.PROTOTYPER_TREES.HOME_ONE = TechTree.Create({
	HOME = 1,
})
TUNING.PROTOTYPER_TREES.HOME_TWO = TechTree.Create({
	HOME = 2,
})

TUNING.PROTOTYPER_TREES.GODDESS_ONE = TechTree.Create({
	GODDESS = 1,
})
TUNING.PROTOTYPER_TREES.GODDESS_TWO = TechTree.Create({
	GODDESS = 2,
})

for i, v in pairs(_G.AllRecipes) do
	if v.level.OBSIDIAN == nil then
		v.level.OBSIDIAN = 0
	end
	if v.level.CITY == nil then
		v.level.CITY = 0
	end
	if v.level.HOME == nil then
		v.level.HOME = 0
	end
	if v.level.GODDESS == nil then
		v.level.GODDESS = 0
	end
end


GLOBAL.RECIPETABS['OBSIDIANTAB'] = {
	str = "OBSIDIANTAB",
	sort = 90,
	icon = "tab_volcano.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("obsidian_workbench",
	{
		action_str = "OBSIDIANTAB",
		icon_image = "tab_volcano.tex",
		icon_atlas = "images/tabs.xml",
		is_crafting_station = true
	})

GLOBAL.RECIPETABS['CITY'] = {
	str = "CITY",
	sort = 91,
	icon = "tab_city.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("key_to_city",
	{ action_str = "CITY", icon_image = "tab_city.tex", icon_atlas = "images/tabs.xml", is_crafting_station = true })

GLOBAL.RECIPETABS['HOME'] = {
	str = "HOME",
	sort = 92,
	icon = "tab_home_decor.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("wallrenovation",
	{ action_str = "HOME", icon_image = "tab_home_decor.tex", icon_atlas = "images/tabs.xml", is_crafting_station = true })

GLOBAL.RECIPETABS['GODDESSTAB'] = {
	str = "GODDESSTAB",
	sort = 93,
	icon = "windyfan1.tex",
	icon_atlas = "images/inventoryimages/windyfan1.xml",
	crafting_station = true
}
AddPrototyperDef("goddess_shrine",
	{
		action_str = "GODDESSTAB",
		icon_image = "windyfan1.tex",
		icon_atlas = "images/inventoryimages/windyfan1.xml",
		is_crafting_station = true
	})

modimport("scripts/recipes") --ALL RECIPES--
----------------------------
AddIngredientValues({ "limpets_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "limpets" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "coconut_cooked", "coconut_halved" }, { fruit = 1, fat = 1 }, true, false)
AddIngredientValues({ "coffeebeans" }, { fruit = .5 }, true, false)
AddIngredientValues({ "coffeebeans_cooked" }, { fruit = 1 }, true, false)
AddIngredientValues({ "sweet_potato" }, { veggie = 1 }, true, false)
AddIngredientValues({ "sweet_potatos_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "fish_med" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "dead_swordfish" }, { fish = 1.5 }, true, false)
AddIngredientValues({ "fish_raw" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish_med_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat_cooked" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "lobster_land" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead_cooked" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "fish_dogfish" }, { fish = 1 }, true, false)
AddIngredientValues({ "mussel_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "mussel" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "shark_fin" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "crab" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "seaweed" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_dried" }, { veggie = 1 }, true, false)
AddIngredientValues({ "doydoyegg" }, { egg = 1 }, true, false)
AddIngredientValues({ "dorsalfin" }, { inedible = 1 }, true, false)
AddIngredientValues({ "jellyfish" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_cooked" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_dead" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyjerky" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)

AddIngredientValues({ "fish2" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish2_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "snowitem" }, { meat = 0.5, frozen = 1 }, true, false)

AddIngredientValues({ "roe" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "roe_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_spotspice_sprig" }, { veggie = 1 }, true, false)
AddIngredientValues({ "quagmire_sap" }, { sweetener = 1 }, true, false)

AddIngredientValues({ "seataro" }, { veggie = 1, frozen = 1 }, true, false)
AddIngredientValues({ "seataro_cooked" }, { veggie = 1, frozen = 1 }, true, false)

AddIngredientValues({ "blueberries" }, { fruit = 0.5, frozen = 0.25 }, true, false)
AddIngredientValues({ "blueberries_cooked" }, { fruit = 0.75 }, true, false)

AddIngredientValues({ "seacucumber" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seacucumber_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "gooseberry" }, { veggie = 1 }, true, false)
AddIngredientValues({ "gooseberry_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "quagmire_mushrooms" }, { mushroom = 1, veggie = 0.5 }, true, false)
AddIngredientValues({ "quagmire_mushrooms_cooked" }, { mushroom = 1, veggie = 0.5 }, true, false)

AddIngredientValues({ "oceanfish_small_61_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_61_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_71_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_71_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_81_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_81_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "foliage" }, { veggie = 1 }, true, false)
AddIngredientValues({ "jellybug" }, { bug = 1 }, true, false)
AddIngredientValues({ "jellybug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "cutnettle" }, { antihistamine = 1 }, true, false)
AddIngredientValues({ "radish" }, { veggie = 1 }, true, false)
AddIngredientValues({ "radish_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "turnip" }, { veggie = 1 }, true, false)
AddIngredientValues({ "turnip_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "asparagus" }, { veggie = 1 }, true, false)
AddIngredientValues({ "asparagus_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "weevole_carapace" }, { inedible = 1 }, true, false)
AddIngredientValues({ "piko_orange" }, { filter = 1 }, true, false)
AddIngredientValues({ "snake_bone" }, { bone = 1 }, true, false)
AddIngredientValues({ "yelow_cap" }, { veggie = 0.5 }, true, false)
AddIngredientValues({ "yelow_cooked" }, { veggie = 0.5 }, true, false)

local fruityjuice =
{
	name = "fruityjuice",
	test = function(cooker, names, tags)
		return names.blueberries_cooked and names.blueberries_cooked == 2 and
			names.foliage and tags.frozen or
			names.blueberries and names.blueberries == 2 and names.foliage and tags.frozen
	end,
	priority = 1,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	sanity = TUNING.SANITY_TINY,
	cooktime = 2,
	floater = { "small", 0.05, 0.7 },
	tags = {},
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}

AddCookerRecipe("cookpot", fruityjuice)
AddCookerRecipe("portablecookpot", fruityjuice)
AddCookerRecipe("xiuyuan_cookpot", fruityjuice)


local butterflymuffin =
{
	name = "butterflymuffin",
	test = function(cooker, names, tags)
		return (names.butterflywings or names.butterfly_tropical_wings or names.moonbutterflywings) and
			not tags.meat and tags.veggie
	end,
	priority = 1,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	sanity = TUNING.SANITY_TINY,
	cooktime = 2,
	floater = { "small", 0.05, 0.7 },
	tags = {},
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}

AddCookerRecipe("cookpot", butterflymuffin)
AddCookerRecipe("portablecookpot", butterflymuffin)
AddCookerRecipe("xiuyuan_cookpot", butterflymuffin)

local coffee =
{
	name = "coffee",
	test = function(cooker, names, tags)
		return names.coffeebeans_cooked and
			(names.coffeebeans_cooked == 4 or (names.coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener)))
	end,
	priority = 30,
	weight = 1,
	foodtype = "VEGGIE",
	health = 3,
	hunger = 75 / 8,
	sanity = -5,
	cooktime = .5,
	tags = {},
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
	oneat_desc = "Speeds the body",
}
AddCookerRecipe("cookpot", coffee)
AddCookerRecipe("portablecookpot", coffee)
AddCookerRecipe("xiuyuan_cookpot", coffee)
--[[
local surfnturf =
{
    name = "surfnturf",
		test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen end,
		priority = 30,
		weight = 1,
		foodtype = "MEAT",
		health = 60,
		hunger = 75/2,
		perishtime = 10*480,
		sanity = 33,
		cooktime = 1,
}
AddCookerRecipe("cookpot",surfnturf)
AddCookerRecipe("portablecookpot",surfnturf)

local seafoodgumbo =
{
    name = "seafoodgumbo",
		test = function(cooker, names, tags) return tags.fish and tags.fish > 2 end,
		priority = 10,
		weight = 1,
		foodtype = "MEAT",
		health = 40,
		hunger = 75/2,
		perishtime = 10*480,
		sanity = 20,
		cooktime = 1,
}
AddCookerRecipe("cookpot",seafoodgumbo)
AddCookerRecipe("portablecookpot",seafoodgumbo)

local ceviche =
{
    name = "ceviche",
		test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen end,
		priority = 20,
		weight = 1,
		foodtype = "MEAT",
		health = 20,
		hunger = 75/3,
		perishtime = 10*480,
		sanity = 5,
		temperature = -40,
		temperatureduration = 10,
		cooktime = 0.5,
}
AddCookerRecipe("cookpot",ceviche)
AddCookerRecipe("portablecookpot",ceviche)

local freshfruitcrepes =
{
    name = "freshfruitcrepes",
	test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 1.5 and names.butter and names.honey end,
	priority = 30,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_HUGE,
	hunger = TUNING.CALORIES_SUPERHUGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_MED,
	cooktime = 2,	
}
AddCookerRecipe("portablecookpot",freshfruitcrepes)




local monstertartare =
	{
	name = "monstertartare",
	test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and tags.egg and tags.veggie end,
	priority = 30,
	   weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_TINY,
	cooktime = 2,
}
AddCookerRecipe("portablecookpot",monstertartare)



]]
local musselbouillabaise =
{
	name = "musselbouillabaise",
	test = function(cooker, names, tags) return names.mussel and names.mussel == 2 and tags.veggie and tags.veggie >= 2 end,
	priority = 30,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_MED,
	cooktime = 2,
	tags = { "masterfood" },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("portablecookpot", musselbouillabaise)

local sweetpotatosouffle =
{
	name = "sweetpotatosouffle",
	test = function(cooker, names, tags)
		return names.sweet_potato and names.sweet_potato == 2 and tags.egg and
			tags.egg >= 2
	end,
	priority = 30,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_MED,
	cooktime = 2,
	tags = { "masterfood" },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("portablecookpot", sweetpotatosouffle)

local sharkfinsoup =
{
	name = "sharkfinsoup",
	test = function(cooker, names, tags) return names.shark_fin end,
	priority = 20,
	weight = 1,
	foodtype = "MEAT",
	health = 40,
	hunger = 75 / 6,
	perishtime = 10 * 480,
	sanity = -10,
	naughtiness = 10,
	cooktime = 1,
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", sharkfinsoup)
AddCookerRecipe("portablecookpot", sharkfinsoup)
AddCookerRecipe("xiuyuan_cookpot", sharkfinsoup)

local lobsterdinner =
{
	name = "lobsterdinner",
	test = function(cooker, names, tags)
		return (names.lobster_dead or names.wobster_sheller_land or names.lobster_dead_cooked or names.lobster_land) and
			names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen
	end,
	priority = 25,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_HUGE,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_SLOW,
	sanity = TUNING.SANITY_HUGE,
	cooktime = 1,
	overridebuild = "cook_pot_food3",
	potlevel = "high",
	floater = { "med", 0.05, { 0.65, 0.6, 0.65 } },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", lobsterdinner)
AddCookerRecipe("portablecookpot", lobsterdinner)
AddCookerRecipe("xiuyuan_cookpot", lobsterdinner)

local lobsterbisque =
{
	name = "lobsterbisque",
	test = function(cooker, names, tags)
		return (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land or names.wobster_sheller_land) and
			tags.frozen
	end,
	priority = 30,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_HUGE,
	hunger = TUNING.CALORIES_MED,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_SMALL,
	cooktime = 0.5,
	overridebuild = "cook_pot_food3",
	potlevel = "high",
	floater = { "med", 0.05, { 0.65, 0.6, 0.65 } },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", lobsterbisque)
AddCookerRecipe("portablecookpot", lobsterbisque)
AddCookerRecipe("xiuyuan_cookpot", lobsterdinner)

local jellyopop =
{
	name = "jellyopop",
	test = function(cooker, names, tags) return tags.jellyfish and tags.frozen and tags.inedible end,
	priority = 20,
	weight = 1,
	foodtype = "MEAT",
	health = 20,
	hunger = 75 / 6,
	perishtime = 3 * 480,
	sanity = 0,
	temperature = -40,
	temperatureduration = 10,
	cooktime = 0.5,
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", jellyopop)
AddCookerRecipe("portablecookpot", jellyopop)
AddCookerRecipe("xiuyuan_cookpot", jellyopop)

local californiaroll =
{
	name = "californiaroll",
	test = function(cooker, names, tags)
		return ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0) + (names.seaweed or 0) + (names.kelp_dried or 0)) ==
			2 and (tags.fish and tags.fish >= 1)
	end,
	priority = 20,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_SMALL,
	cooktime = .5,
	overridebuild = "cook_pot_food2",
	potlevel = "high",
	floater = { "med", 0.05, { 0.65, 0.6, 0.65 } },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", californiaroll)
AddCookerRecipe("portablecookpot", californiaroll)
AddCookerRecipe("xiuyuan_cookpot", californiaroll)

local bisque =
{
	name = "bisque",
	test = function(cooker, names, tags) return names.limpets and names.limpets == 3 and tags.frozen end,
	priority = 30,
	weight = 1,
	foodtype = "MEAT",
	health = 60,
	hunger = 75 / 4,
	perishtime = 10 * 480,
	sanity = 5,
	cooktime = 1,
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", bisque)
AddCookerRecipe("portablecookpot", bisque)
AddCookerRecipe("xiuyuan_cookpot", bisque)

local bananapop =
{
	name = "bananapop",
	test = function(cooker, names, tags)
		return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and
			(tags.inedible or names.twigs) and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2)
	end,
	priority = 20,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_SMALL,
	perishtime = TUNING.PERISH_SUPERFAST,
	sanity = TUNING.SANITY_LARGE,
	temperature = TUNING.COLD_FOOD_BONUS_TEMP,
	temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
	cooktime = 0.5,
	potlevel = "low",
	floater = { nil, 0.05, 0.95 },
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", bananapop)
AddCookerRecipe("portablecookpot", bananapop)
AddCookerRecipe("xiuyuan_cookpot", bananapop)


local caviar =
{
	name = "caviar",
	test = function(cooker, names, tags) return (names.roe or names.roe_cooked == 3) and tags.veggie end,
	priority = 20,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_SMAL,
	hunger = TUNING.CALORIES_SMALL,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_LARGE,
	cooktime = 2,
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", caviar)
AddCookerRecipe("portablecookpot", caviar)
AddCookerRecipe("xiuyuan_cookpot", caviar)

local tropicalbouillabaisse =
{
	name = "tropicalbouillabaisse",
	test = function(cooker, names, tags)
		return (names.fish3 or names.fish3_cooked) and
			(names.fish4 or names.fish4_cooked) and (names.fish5 or names.fish5_cooked) and tags.veggie
	end,
	priority = 35,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_MED,
	cooktime = 2,
	cookbook_atlas = "images/inventoryimages/volcanoinventory.xml"
}
AddCookerRecipe("cookpot", tropicalbouillabaisse)
AddCookerRecipe("portablecookpot", tropicalbouillabaisse)
AddCookerRecipe("xiuyuan_cookpot", tropicalbouillabaisse)

local spicyvegstinger =
{
	name = "spicyvegstinger",
	test = function(cooker, names, tags)
		return (names.asparagus or names.asparagus_cooked or names.radish or names.radish_cooked) and
			tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat
	end,
	priority = 15,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_MED,
	perishtime = TUNING.PERISH_SLOW,
	sanity = TUNING.SANITY_LARGE,
	cooktime = 0.5,
}
AddCookerRecipe("cookpot", spicyvegstinger)
AddCookerRecipe("portablecookpot", spicyvegstinger)
AddCookerRecipe("xiuyuan_cookpot", spicyvegstinger)

local feijoada =
{
	name = "feijoada",
	test = function(cooker, names, tags)
		return tags.meat and (names.jellybug == 3) or (names.jellybug_cooked == 3) or
			(names.jellybug and names.jellybug_cooked and names.jellybug + names.jellybug_cooked == 3)
	end,
	priority = 30,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_HUGE,
	perishtime = TUNING.PERISH_FASTISH,
	sanity = TUNING.SANITY_MED,
	cooktime = 3.5,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", feijoada)
AddCookerRecipe("portablecookpot", feijoada)
AddCookerRecipe("xiuyuan_cookpot", feijoada)

local steamedhamsandwich =
{
	name = "steamedhamsandwich",
	test = function(cooker, names, tags)
		return (names.meat or names.meat_cooked) and (tags.veggie and tags.veggie >= 2) and
			names.foliage
	end,
	priority = 5,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_LARGE,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_FAST,
	sanity = TUNING.SANITY_MED,
	cooktime = 2,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", steamedhamsandwich)
AddCookerRecipe("portablecookpot", steamedhamsandwich)
AddCookerRecipe("xiuyuan_cookpot", steamedhamsandwich)

local hardshell_tacos =
{
	name = "hardshell_tacos",
	test = function(cooker, names, tags) return (names.weevole_carapace == 2) and tags.veggie end,
	priority = 1,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_SLOW,
	sanity = TUNING.SANITY_TINY,
	cooktime = 1,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", hardshell_tacos)
AddCookerRecipe("portablecookpot", hardshell_tacos)
AddCookerRecipe("xiuyuan_cookpot", hardshell_tacos)

local gummy_cake =
{
	name = "gummy_cake",
	test = function(cooker, names, tags) return (names.slugbug or names.slugbug_cooked) and tags.sweetener end,
	priority = 1,
	weight = 1,
	foodtype = "MEAT",
	health = -TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SUPERHUGE,
	perishtime = TUNING.PERISH_PRESERVED,
	sanity = -TUNING.SANITY_TINY,
	cooktime = 2,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", gummy_cake)
AddCookerRecipe("portablecookpot", gummy_cake)
AddCookerRecipe("xiuyuan_cookpot", gummy_cake)

local tea =
{
	name = "tea",
	test = function(cooker, names, tags)
		return tags.filter and tags.filter >= 2 and tags.sweetener and not tags.meat and
			not tags.veggie and not tags.inedible
	end,
	priority = 25,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SMALL,
	perishtime = TUNING.PERISH_ONE_DAY,
	sanity = TUNING.SANITY_LARGE,
	cooktime = 0.5,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", tea)
AddCookerRecipe("portablecookpot", tea)
AddCookerRecipe("xiuyuan_cookpot", tea)

local icedtea =
{
	name = "icedtea",
	test = function(cooker, names, tags) return tags.filter and tags.filter >= 2 and tags.sweetener and tags.frozen end,
	priority = 30,
	weight = 1,
	foodtype = "VEGGIE",
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SMALL,
	perishtime = TUNING.PERISH_FAST,
	sanity = TUNING.SANITY_LARGE,
	cooktime = 0.5,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", icedtea)
AddCookerRecipe("portablecookpot", icedtea)
AddCookerRecipe("xiuyuan_cookpot", icedtea)

local snakebonesoup =
{
	name = "snakebonesoup",
	test = function(cooker, names, tags) return tags.bone and tags.bone >= 2 and tags.meat and tags.meat >= 2 end,
	priority = 20,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_LARGE,
	hunger = TUNING.CALORIES_MED,
	perishtime = TUNING.PERISH_MED,
	sanity = TUNING.SANITY_SMALL,
	cooktime = 1,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", snakebonesoup)
AddCookerRecipe("portablecookpot", snakebonesoup)
AddCookerRecipe("xiuyuan_cookpot", snakebonesoup)

local nettlelosange =
{
	name = "nettlelosange",
	test = function(cooker, names, tags) return tags.antihistamine and tags.antihistamine >= 3 end,
	priority = 0,
	weight = 1,
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_MED,
	perishtime = TUNING.PERISH_FAST,
	sanity = TUNING.SANITY_TINY,
	antihistamine = 720,
	cooktime = .5,
	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
}
AddCookerRecipe("cookpot", nettlelosange)
AddCookerRecipe("portablecookpot", nettlelosange)
AddCookerRecipe("xiuyuan_cookpot", nettlelosange)


local meated_nettle =
{
	name = "meated_nettle",
	test = function(cooker, names, tags)
		return (tags.antihistamine and tags.antihistamine >= 2) and
			(tags.meat and tags.meat >= 1) and (not tags.monster or tags.monster <= 1) and not tags.inedible
	end,
	priority = 1,
	weight = 1,
	foodtype = "MEAT",
	health = TUNING.HEALING_MED,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_FASTISH,
	sanity = TUNING.SANITY_TINY,
	antihistamine = 600,
	cooktime = 1,
	cookbook_atlas = "images/inventoryimages/meated_nettle.xml",
}
AddCookerRecipe("cookpot", meated_nettle)
AddCookerRecipe("portablecookpot", meated_nettle)
AddCookerRecipe("xiuyuan_cookpot", meated_nettle)

----------------------posonables---------------------
modimport("scripts/postinit_poisonables")

local function AddBigFooter(inst)
	if inst.ismastersim then
		if not inst.components.bigfooter then
			inst:AddComponent("bigfooter")
		end

		if bell_statue then
			local statueglommer_fn = GLOBAL.Prefabs["statueglommer"].fn
			local OnInit, OnInit_index = DX_GetUpvalue(statueglommer_fn, "OnInit")
			local OnWorked, OnWorked_index = DX_GetUpvalue(statueglommer_fn, "OnWorked")
			local OnLoadWorked, OnLoadWorked_index = DX_GetUpvalue(statueglommer_fn, "OnLoadWorked")
			local OnIsFullmoon, OnIsFullmoon_index = DX_GetUpvalue(OnInit, "OnIsFullmoon")

			local function PlayerLearnsBell(worker)
				worker.sg:GoToState("learn_bell")
			end
			local function TeachBellToWorker(inst, data)
				local worker = data and data.worker
				local worker_builder = worker and worker.components.builder
				if worker_builder and not table.contains(worker_builder.recipes, "bell") then
					worker:DoTaskInTime(1 + 2 * math.random(), PlayerLearnsBell)
				end
			end

			local old_OnIsFullmoon = OnIsFullmoon
			local new_OnIsFullmoon = function(inst, isfullmoon)
				if isfullmoon and inst.components.workable == nil and inst.components.lootdropper == nil then
					inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_down")
					inst.AnimState:PlayAnimation("full")
					inst:AddComponent("workable")
					inst.components.workable:SetWorkAction(ACTIONS.MINE)
					inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
					inst.components.workable:SetOnWorkCallback(OnWorked)
					inst.components.workable.savestate = true
					inst.components.workable:SetOnLoadFn(OnLoadWorked)
					inst:AddComponent("lootdropper")
					inst.components.lootdropper:SetChanceLootTable("statueglommer")

					local px, py, pz = inst.Transform:GetWorldPosition()
					local fx1 = SpawnPrefab("sanity_lower")
					local fx2 = SpawnPrefab("collapse_big")
					fx1.Transform:SetPosition(px, py, pz)
					fx2.Transform:SetPosition(px, py, pz)
				end
				if inst.components.workable and not inst.bell_learning_enabled then
					inst.bell_learning_enabled = true
					inst:ListenForEvent("workfinished", TeachBellToWorker)
				end
				return old_OnIsFullmoon(inst, isfullmoon)
			end

			DX_SetUpvalue(OnInit, OnIsFullmoon_index, new_OnIsFullmoon)
		end
	end
end

AddPrefabPostInit("world", AddBigFooter)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit("forest", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("parrotspawner")
		inst:AddComponent("economy")
		inst:AddComponent("shadowmanager")
		inst:AddComponent("contador")

		if TUNING.tropical.sealnado then
			inst:AddComponent("twisterspawner")
		end

		if GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5 then
			inst:AddComponent("roottrunkinventory")
		end

		if GetModConfigData("kindofworld") ~= 10 and (GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5 and GetModConfigData("pigruins") ~= 0 and GetModConfigData("aporkalypse") == true) then
			inst:AddComponent("aporkalypse")
		end

		if GetModConfigData("kindofworld") ~= 10 and GetModConfigData("Hamlet") ~= 5 then
			inst:AddComponent("tropicalgroundspawner")
		end
		if GetModConfigData("kindofworld") == 15 or GetModConfigData("kindofworld") == 10 or GetModConfigData("kindofworld") == 20 then
			if GetModConfigData("aquaticcreatures") then
				inst:AddComponent("tropicalspawner")
				inst:AddComponent("whalehunter")
				inst:AddComponent("rainbowjellymigration")
			end
		end
		if GetModConfigData("kindofworld") == 5 then
			inst:AddComponent("shadowmanager")
			inst:AddComponent("rocmanager")
		end



		if GetModConfigData("kindofworld") ~= 10 then
			inst:AddComponent("quaker_interior")
		end

		--if TUNING.tropical.springflood or TUNING.tropical.kindofworld == 10 then	inst:AddComponent("floodspawner") end				
	end
end)


AddPrefabPostInit("world", AddBigFooter)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit("cave", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("roottrunkinventory")
		inst:AddComponent("quaker_interior")
		inst:AddComponent("economy")
		inst:AddComponent("contador")
	end
end)

-----------------------------------------------------------------------especiais para agua--------------------------------




----------------------------------------------------Thanks EvenMr for this code------------SLOT EXTRA PARA BARCO-----------------------------------------------------------------------------------------------------------------------------

GLOBAL.EQUIPSLOTS.BARCO = "barco"
GLOBAL.FUELTYPE.TAR = "TAR"
GLOBAL.FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
GLOBAL.FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"
GLOBAL.MATERIALS.SANDBAG = "sandbag"

GLOBAL.TOOLACTIONS["HACK"] = true
GLOBAL.TOOLACTIONS["SHEAR"] = true
GLOBAL.TOOLACTIONS["PAN"] = true
GLOBAL.TOOLACTIONS["INVESTIGATEGLASS"] = true
GLOBAL.FUELTYPE.CORK = "CORK"

GLOBAL.MATERIALS.LIMESTONE = "limestone"
GLOBAL.MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

--[[
AddClassPostConstruct("widgets/inventorybar", function(self)

	local OldRefresh = self.Refresh
    local OldRebuild = self.Rebuild

    function self:ScaleInv()
		slot_num = #self.equipslotinfo
		if not (TheInput:ControllerAttached() or GLOBAL.GetGameModeProperty("no_avatar_popup")) then
			slot_num = slot_num + 1
		end
		local inv_scale = 0.98 + 0.06 * slot_num
		self.bg:SetScale(inv_scale,1,1)
		self.bgcover:SetScale(inv_scale,1,1)
    end

    function self:Refresh()
        self:ScaleInv()
        OldRefresh(self)
    end

    function self:Rebuild()
        self:ScaleInv()
        OldRebuild(self)
    end
	
end)
]]


AddClassPostConstruct("widgets/crafttabs", function(self)
	local numtabs = 0

	for i, v in ipairs(self.tabs.tabs) do
		if not v.collapsed then
			numtabs = numtabs + 1
		end
	end

	if numtabs > 11 then
		self.tabs.spacing = 67

		local scalar = self.tabs.spacing * (1 - numtabs) * .5
		local offset = self.tabs.offset * scalar

		for i, v in ipairs(self.tabs.tabs) do
			if i > 1 and not v.collapsed then
				offset = offset + self.tabs.offset * self.tabs.spacing
			end
			v:SetPosition(offset)
			self.tabs.base_pos[v] = Vector3(offset:Get())
		end

		local scale = 67 * numtabs / 750.0
		self.bg:SetScale(1, scale, 1)
		self.bg_cover:SetScale(1, scale, 1)
	end
end)
-----------------------------Thanks EvenMr for this code --------TEXTURA IMPASSABLE------------------------------------------


local function getval(fn, path)
	local val = fn
	for entry in path:gmatch("[^%.]+") do
		local i = 1
		while true do
			local name, value = GLOBAL.debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	return val
end

local function setval(fn, path, new)
	local val = fn
	local prev = nil
	local i
	for entry in path:gmatch("[^%.]+") do
		i = 1
		prev = val
		while true do
			local name, value = GLOBAL.debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	GLOBAL.debug.setupvalue(prev, i, new)
end

local GROUND_OCEAN_COLOR = -- Color for the main island ground tiles
{
	primary_color = { 0, 0, 0, 25 },
	secondary_color = { 0, 20, 33, 0 },
	secondary_color_dusk = { 0, 20, 33, 80 },
	minimap_color = { 46, 32, 18, 64 },
}

local COASTAL_OCEAN_COLOR =
{
	primary_color = { 220, 255, 255, 28 },
	secondary_color = { 25, 123, 167, 100 },
	secondary_color_dusk = { 10, 120, 125, 120 },
	minimap_color = { 23, 51, 62, 102 },
}

local COASTAL_OCEAN_COLOR2 =
{
	primary_color = { 220, 255, 255, 255 },
	secondary_color = { 25, 123, 167, 100 },
	secondary_color_dusk = { 10, 120, 125, 120 },
	minimap_color = { 23, 51, 62, 102 },
}


local hackpath = "OnFilesLoaded.OnUpdatePurchaseStateComplete.DoResetAction.DoGenerateWorld.DoInitGame"
local OldLoad = GLOBAL.Profile.Load
function GLOBAL.Profile:Load(fn)
	local initfn = getval(fn, hackpath)
	setval(fn, hackpath, function(savedata, profile)
		GLOBAL.global("currentworld")
		GLOBAL.currentworld = savedata.map.prefab
		if savedata.map.prefab == "forest" then
			local tbl = getval(initfn, "GroundTiles")
			---------------BEGIN----------------
			--[[modify here to get what you want]]
			-- GROUND_PROPERTIES -> tbl.ground
			-- WALL_PROPERTIES -> tbl.wall
			-- TURF_PROPERTIES -> tbl.turf
			-- GROUND_CREEP_PROPERTIES -> tbl.creep
			-- underground_layers -> tbl.underground
			-- Remember to load the assets in modmain.lua
			--[[			
			GLOBAL.table.insert(tbl.ground, 20, {GROUND.QUAGMIRE_GATEWAY,      {
			name = "grass3",
			noise_texture = "levels/textures/quagmire_gateway_noise.tex",
			runsound="dontstarve/movement/run_woods",
			walksound="dontstarve/movement/walk_woods",
			snowsound="dontstarve/movement/run_snow",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})
			
			GLOBAL.table.insert(tbl.ground, 28, {GROUND.QUAGMIRE_CITYSTONE,    {
			name = "cave",
			noise_texture = "levels/textures/quagmire_citystone_noise.tex",
			runsound="dontstarve/movement/run_dirt",
			walksound="dontstarve/movement/walk_dirt",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})
			
			GLOBAL.table.insert(tbl.ground, 30, {GROUND.QUAGMIRE_PARKFIELD,    {
			name = "deciduous",
			noise_texture = "levels/textures/quagmire_parkfield_noise.tex",
			runsound="dontstarve/movement/run_carpet",
			walksound="dontstarve/movement/walk_carpet",
			snowsound="dontstarve/movement/run_snow",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})
			
			GLOBAL.table.insert(tbl.ground, 28, {GROUND.QUAGMIRE_PARKSTONE,    {
			name = "cave",
			noise_texture = "levels/textures/quagmire_parkstone_noise.tex",
			runsound="dontstarve/movement/run_dirt",
			walksound="dontstarve/movement/walk_dirt",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})
			
			GLOBAL.table.insert(tbl.ground, 30, {GROUND.QUAGMIRE_SOIL,         {
			name = "carpet",
			noise_texture = "levels/textures/quagmire_soil_noise.tex",
			runsound="dontstarve/movement/run_mud",
			walksound="dontstarve/movement/walk_mud",
			snowsound="dontstarve/movement/run_snow",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.QUAGMIRE_PEATFOREST,   {
			name = "grass2",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR			
			}})
]]
			--[[	
			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_COASTAL,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "SHALLOW",
			colors=COASTAL_OCEAN_COLOR2,
			wavetint = {0.8,   0.9,    1},	
			}})		
	
			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_COASTAL_SHORE,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "SHALLOW",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.8,   0.9,    1},	
			}})					
			
			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_SWELL,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "BASIC",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.65,  0.84,   0.94},	
			}})	

			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_BRINEPOOL,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "SHALLOW",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.65,  0.92,   0.94},	
			}})	
				
			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_BRINEPOOL_SHORE,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "SHALLOW",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.65,  0.92,   0.94},	
			}})	


			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_ROUGH	,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "DEEP",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.65,  0.84,   0.94},	
			}})		


			GLOBAL.table.insert(tbl.ground, 10, {GROUND.OCEAN_HAZARDOUS	,   {
			name = "water_mangrove",
			noise_texture = "levels/textures/noise_water_mangrove.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			ocean_depth = "VERY_DEEP",
			colors=COASTAL_OCEAN_COLOR,
			wavetint = {0.40,  0.50,   0.62},	
			}})				
]]
			--[[			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.MAGMAFIELD,   {
			name = "magmafield",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})			
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.JUNGLE,   {
			name = "jungle",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.ASH,   {
			name = "ash",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})					
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.VOLCANO,   {
			name = "volcano",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
			
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.TIDALMARSH,   {
			name = "tidalmarsh",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.MEADOW,   {
			name = "meadow",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
			

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.SNAKESKINFLOOR,   {
			name = "snakeskinfloor",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.PLAINS,   {
			name = "plains",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.DEEPRAINFOREST,   {
			name = "deeprainforest",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
	
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.RAINFOREST,   {
			name = "rainforest",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.PAINTED,   {
			name = "painted",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.GASJUNGLE,   {
			name = "gasjungle",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.FIELDS,   {
			name = "fields",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.CHECKEREDLAWN,   {
			name = "checkeredlawn",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})		

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.SUBURB,   {
			name = "suburb",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.BEARDRUG,   {
			name = "beardrug",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				
			
			GLOBAL.table.insert(tbl.ground, 25, {GROUND.FOUNDATION,   {
			name = "foundation",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.COBBLEROAD,   {
			name = "cobbleroad",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.ANTFLOOR,   {
			name = "antfloor",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})	

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.BATFLOOR,   {
			name = "batfloor",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})				

			GLOBAL.table.insert(tbl.ground, 25, {GROUND.PIGRUINS,   {
			name = "pigruins",
			noise_texture = "levels/textures/quagmire_peatforest_noise.tex",
			runsound="dontstarve/movement/run_marsh",
			walksound="dontstarve/movement/walk_marsh",
			snowsound="dontstarve/movement/run_ice",
			mudsound = "dontstarve/movement/run_mud",
			flashpoint_modifier = 0,
			colors=GROUND_OCEAN_COLOR
			}})					
]]

			if GetModConfigData("kindofworld") == 6 then --nunca acontece
				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_COASTAL_SHORE, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_COASTAL, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_SWELL, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_ROUGH, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_BRINEPOOL, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_BRINEPOOL_SHORE, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_HAZARDOUS, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })

				GLOBAL.table.insert(tbl.ground, 10, { GROUND.OCEAN_WATERLOG, {
					name = "water_mangrove",
					noise_texture = "levels/textures/ground_noise_water_deep.tex",
					runsound = "dontstarve/movement/run_marsh",
					walksound = "dontstarve/movement/walk_marsh",
					snowsound = "dontstarve/movement/run_ice",
					mudsound = "dontstarve/movement/run_mud",
					flashpoint_modifier = 0,
					ocean_depth = "SHALLOW",
					colors = COASTAL_OCEAN_COLOR2,
					wavetint = { 0.8, 0.9, 1 },
				} })
			end


			--			for k,v in ipairs(tbl.ground) do
			--			if v[1] == GROUND.IMPASSABLE then
			--			v[2].name = "water_mangrove"
			--			end	
			--			end
			--			if v[1] == GROUND.WATER_MEDIUM then
			--			v[2].name = "water_medium"
			--			end	
			--			end						

			-----------------END----------------
			setval(initfn, "GroundTiles", tbl)
		end
		return initfn(savedata, profile)
	end)
	return OldLoad(self, fn)
end

--[[
---------------------------------color cube by EvenMr  --------------------------------------------------------------
local resolvefilepath=GLOBAL.resolvefilepath
if 1 == 2 then --GetModConfigData("colourcube") then
	table.insert( Assets, Asset("IMAGE","images/colour_cubes/pork_cold_bloodmoon_cc.tex") )

	AddComponentPostInit("colourcube", function(self)
		if GLOBAL.currentworld == "forest" then
			for _,v in pairs(GLOBAL.TheWorld.event_listeners["playerdeactivated"][GLOBAL.TheWorld]) do
				if getval(v,"OnOverrideCCTable") then
				print("color")
					setval(v, "OnOverrideCCTable.UpdateAmbientCCTable.SEASON_COLOURCUBES",{
						autumn =
						{
							day = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							night = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							full_moon = "images/colour_cubes/pork_cold_bloodmoon_cc.tex"
						},
						winter =
						{
							day = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							night = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							full_moon = "images/colour_cubes/pork_cold_bloodmoon_cc.tex"
						},
						spring =
						{
							day = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							night = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							full_moon = "images/colour_cubes/pork_cold_bloodmoon_cc.tex"
						},
						summer =
						{
							day = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							night = resolvefilepath("images/colour_cubes/pork_cold_bloodmoon_cc.tex"),
							full_moon = "images/colour_cubes/pork_cold_bloodmoon_cc.tex"
						},
					})
					break
				end
			end
		end
	end)
end
]]
---------------------------------indicador de veneno by EvenMr---------------------------------------------------
AddClassPostConstruct("widgets/healthbadge", function(inst)
	function inst:OnUpdate(dt)
		local down =
			(self.owner.IsFreezing ~= nil and self.owner:IsFreezing()) or
			(self.owner.IsOverheating ~= nil and self.owner:IsOverheating()) or
			(self.owner.replica.hunger ~= nil and self.owner.replica.hunger:IsStarving()) or
			(self.owner.replica.health ~= nil and self.owner.replica.health:IsTakingFireDamage()) or
			(self.owner.IsBeaverStarving ~= nil and self.owner:IsBeaverStarving()) or
			GLOBAL.next(self.corrosives) ~= nil

		local small_down = self.owner.components.poisonable and self.owner.components.poisonable.dmg < 0

		-- Show the up-arrow when we're sleeping (but not in a straw roll: that doesn't heal us)
		local up = not down and
			((self.owner.player_classified ~= nil and self.owner.player_classified.issleephealing:value()) or
				GLOBAL.next(self.hots) ~= nil or
				(self.owner.replica.inventory ~= nil and self.owner.replica.inventory:EquipHasTag("regen"))
			) and
			self.owner.replica.health ~= nil and self.owner.replica.health:IsHurt()

		local anim =
			(down and "arrow_loop_decrease_most") or
			((not up and small_down) and "arrow_loop_decrease") or
			(not up and "neutral") or
			(GLOBAL.next(self.hots) ~= nil and "arrow_loop_increase_most") or
			"arrow_loop_increase"

		if self.arrowdir ~= anim then
			self.arrowdir = anim
			self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
		end
	end
end)

----------------------------Barco Slot Tweak by EvenMr-------------------------------
AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
	local tbl = getval(self.CollectActions, "COMPONENT_ACTIONS")
	if not getval(tbl.INVENTORY.equippable, "oldfn") then
		local oldfn = tbl.INVENTORY.equippable
		tbl.INVENTORY.equippable = function(inst, ...)
			if not inst:HasTag("boat") then oldfn(inst, ...) end
		end
	end
end)

local function preventpick(cmp)
	local oldfn = cmp.TakeActiveItemFromEquipSlot
	function cmp:TakeActiveItemFromEquipSlot(eslot)
		local item = self:GetEquippedItem(eslot)
		if item and item:HasTag("boat") then return end
		oldfn(self, eslot)
	end

	function cmp:IsInsulated() -- from electricity, not temperature
		for k, v in pairs(self.equipslots) do
			if v and v.components.equippable:IsInsulated() then
				return true
			end
		end
		if self.isexternallyinsulated then
			return self.isexternallyinsulated:Get()
		end
		return false
	end
end

local function preventpickclassified(cmp)
	local oldfn = cmp.TakeActiveItemFromEquipSlot
	function cmp:TakeActiveItemFromEquipSlot(eslot)
		local item = self:GetEquippedItem(eslot)
		if item and item:HasTag("boat") then return end
		oldfn(self, eslot)
	end
end

AddComponentPostInit("inventory", preventpick)
AddPrefabPostInit("inventory_classified", preventpickclassified)

------------------------------------------------------------
---------------------现在不会报错，但是仍然不能修理虚空装备
-- AddComponentPostInit("armor", function(self)
-- 	function self:SetCondition(amount)
-- 		if self.indestructible then
-- 			return
-- 		end

-- 		self.condition = math.min(amount, self.maxcondition)
-- 		self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })

-- 		if self.condition <= 0 then
-- 			self.condition = 0
-- 			GLOBAL.ProfileStatsSet("armor_broke_" .. self.inst.prefab, true)
-- 			GLOBAL.ProfileStatsSet("armor", self.inst.prefab)

-- 			if self.onfinished ~= nil then
-- 				self.onfinished()
-- 			end

-- 			if not self.dontremove then
-- 				self.inst:Remove()
-- 			end
-- 		end
-- 	end
-- end)

-----------------------------Treasure Reveal by EvenMr----------------------------
local function OnRevealTreasureDirty(inst)
	local m = math
	if inst._parent ~= nil and inst._parent.HUD and GLOBAL.TheCamera then
		inst._parent.HUD.controls:ShowMap()
		local map = GLOBAL.TheWorld.minimap.MiniMap
		local ang = GLOBAL.TheCamera:GetHeading()
		local zoom = map:GetZoom()
		local posx, _, posy = inst._parent.Transform:GetWorldPosition()
		posx = m.modf(inst.revealtreasure:value() / 65536) - 16384 - posx
		posy = inst.revealtreasure:value() % 65536 - 16384 - posy
		local x = posx * m.cos(m.rad(90 - ang)) - posy * m.sin(m.rad(90 - ang))
		local y = posx * m.sin(m.rad(90 - ang)) + posy * m.cos(m.rad(90 - ang))
		map:ResetOffset()
		map:Offset(x / zoom, y / zoom)
	end
end

AddPrefabPostInit("player_classified", function(inst)
	inst.revealtreasure = GLOBAL.net_uint(inst.GUID, "messagebottle1.reveal", "revealtreasuredirty")
	inst:ListenForEvent("revealtreasuredirty", OnRevealTreasureDirty)
end)

if GetModConfigData("kindofworld") == 20 then
	AddPrefabPostInit("rocks", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)
	AddPrefabPostInit("nitre", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)
	AddPrefabPostInit("flint", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)
	AddPrefabPostInit("goldnugget", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)

	AddPrefabPostInit("moonrocknugget", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)

	AddPrefabPostInit("moonglass", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)

	AddPrefabPostInit("moonrockseed", function(inst)
		GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.inventoryitem ~= nil then
				inst.components.inventoryitem:SetSinks(false)
			end
		end
	end)
end

-------------------------------Boat Speed by EvenMr----------------------------
local speed_bonus = {
	raft_old = 5 / 6,
	lograft_old = 4 / 6,
	rowboat = 6 / 6,
	armouredboat = 6 / 6,
	cargoboat = 5 / 6,
	encrustedboat = 4 / 6,
	surfboard = 6.5 / 6,
	woodlegsboat = 6 / 6,
	corkboat = 4 / 6,
	-- more entries here
}

local sail_bonus = {
	sail = 1.2,
	clothsail = 1.3,
	snakeskinsail = 1.25,
	feathersail = 1.4,
	ironwind = 1.5,
	woodlegssail = 1.01,
	trawlnet = 0.8,
	malbatrossail = 2,
	-- more entries here
}

local heavybonus = 0.35
local driftspeed = 2
--[[
local function getspeedbonus(inst)
local namao = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
local remo = false
local sailbonus
if namao and namao.prefab == "oar_driftwood" or namao and namao.prefab == "oar" then
remo = true
end

    local val = 1
    if inst.replica.inventory then
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        if item then
		    local bonus = speed_bonus[item.prefab] or 1
            if item.replica.container then
                local sail = item.replica.container:GetItemInSlot(1)
                sailbonus = sail and sail_bonus[sail.prefab] or 1
                val = bonus * sailbonus
            else
                val = bonus		
            end
        end
		
		print(sailbonus)
		print(remo)
		
		if sailbonus <= 1 and remo == false and item.prefab ~= "surfboard" then
		val = 0.1
		end		
		
		
        if inst.replica.inventory:IsHeavyLifting() then
            local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
            if item.replica.container and item.replica.container:GetItemInSlot(1) and
                item.replica.container:GetItemInSlot(1):HasTag("sail") then
                return val * 0.2
            else
                return 0
            end
        end
    end
    return val
end
]]
local function getspeedbonus(inst)
	local equipamentos = 1

	if 1 == 1 then
		local body = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local head = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local hands = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if head and head.prefab == "aerodynamichat" then equipamentos = equipamentos + 0.25 end
		if head and head.prefab == "icehat" then equipamentos = equipamentos - 0.10 end
		if head and head.prefab == "metalplatehat" then equipamentos = equipamentos - 0.20 end
		if hands and hands.prefab == "cane" then equipamentos = equipamentos + 0.25 end
		if hands and hands.prefab == "ruins_bat" then equipamentos = equipamentos + 0.10 end
		if hands and hands.prefab == "walkingstick" then equipamentos = equipamentos + 0.30 end
		if body and body.prefab == "piggyback" then equipamentos = equipamentos - 0.20 end
		if body and body.prefab == "armorlimestone" then equipamentos = equipamentos - 0.10 end
		if body and body.prefab == "yellowamulet" then equipamentos = equipamentos + 0.20 end
		if body and body.prefab == "armor_metalplate" then equipamentos = equipamentos - 0.20 end
	end





	local wind_speed = 1
	local vento = GLOBAL.GetClosestInstWithTag("vento", inst, 10)
	if vento then
		local wind = vento.Transform:GetRotation() + 180
		local windangle = inst.Transform:GetRotation() - wind
		local windproofness = 1.0
		local velocidadedovento = 1.5

		if inst.replica.inventory then
			local corpo = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			local cabeca = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if cabeca and cabeca.prefab == "aerodynamichat" then
				windproofness = 0.5
			end
			if corpo and corpo.prefab == "armor_windbreaker" then
				windproofness = 0
			end
		end
		local windfactor = 0.4 * windproofness * velocidadedovento * math.cos(windangle * GLOBAL.DEGREES) + 1.0
		wind_speed = math.max(0.1, windfactor)
	end

	local val = 1 * wind_speed * equipamentos
	if inst.replica.inventory then
		local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
		if item then
			local bonus = speed_bonus[item.prefab] or 1
			if item.replica.container then
				local sail = item.replica.container:GetItemInSlot(1)
				local sailbonus = sail and sail_bonus[sail.prefab] or 1
				val = bonus * sailbonus * wind_speed * equipamentos
			else
				val = bonus * wind_speed * equipamentos
			end
		end
		if inst.replica.inventory:IsHeavyLifting() then
			local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
			if item.replica.container and item.replica.container:GetItemInSlot(1) and
				item.replica.container:GetItemInSlot(1):HasTag("sail") then
				return val * 0.2
			else
				return 0
			end
		end
	end
	return val
end

--------------------这里控制水上的速度-------------------------
------------------为什么function不能加local啊
----------------在船上关闭保存世界就会传送至出生门
AddComponentPostInit("locomotor", function(self)
	local OldGetSpeedMultiplier = self.GetSpeedMultiplier
	function self:GetSpeedMultiplier()
		return (self.inst:HasTag("aquatic") and self.inst:HasTag("player")) and getspeedbonus(self.inst) or
			OldGetSpeedMultiplier(self)
	end

	local OldUpdate = self.OnUpdate
	function self:OnUpdate(dt)
		OldUpdate(self, dt)
		local math = GLOBAL.math

		if self.inst:HasTag("aquatic") and self.inst:HasTag("player") and self.inst.replica.inventory
			and self.inst.replica.inventory:IsHeavyLifting() and not self.driftangle then
			local item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
			if item.replica.container and item.replica.container:GetItemInSlot(1) and
				item.replica.container:GetItemInSlot(1):HasTag("sail") then
				if self.inst.Physics:GetMotorSpeed() > 0 then
					local desired_speed = self.isrunning and self:RunSpeed() or self.walkspeed
					local speed_mult = self:GetSpeedMultiplier()
					if self.dest and self.dest:IsValid() then
						local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
						local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
						local dsq = GLOBAL.distsq(destpos_x, destpos_z, mypos_x, mypos_z)
						if dsq <= .25 then
							speed_mult = math.max(.33, math.sqrt(dsq))
						end
					end

					self.inst.Physics:SetMotorVel(desired_speed * speed_mult * heavybonus, 0, 0)
				end
			else
				self.inst.Physics:SetMotorVel(0, 0, 0)
				self:Stop()
			end
		elseif self.driftangle and self.inst:HasTag("player") and self.inst:HasTag("aquatic") then
			local speed_mult = self:GetSpeedMultiplier()
			local desired_speed = self.isrunning and self:RunSpeed() or self.walkspeed
			if self.dest and self.dest:IsValid() then
				local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
				local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
				local dsq = GLOBAL.distsq(destpos_x, destpos_z, mypos_x, mypos_z)
				if dsq <= .25 then
					speed_mult = math.max(.33, math.sqrt(dsq))
				end
			end
			if not self.dest then
				desired_speed = 0
			end
			local angle = self.inst.Transform:GetRotation()
			local driftx = math.cos(math.rad(-self.driftangle + angle + 180)) * 1.5
			local drifty = math.sin(math.rad(-self.driftangle + angle + 180)) * 1.5

			local extramult = 1

			if self.inst.replica.inventory and self.inst.replica.inventory:IsHeavyLifting() then
				extramult = heavybonus
			end

			self.inst.Physics:SetMotorVel((desired_speed * speed_mult + driftx) * extramult, 0, drifty * extramult)
			if GLOBAL.StopUpdatingComponents[self] == self.inst then
				self:StartUpdatingInternal()
			end
		end
	end

	local OldStop = self.Stop
	function self:Stop(sgparam)
		OldStop(self, sgparam)
		if self.driftangle and self.inst:HasTag("aquatic") and self.inst:HasTag("player") and GLOBAL.StopUpdatingComponents[self] == self.inst then
			self:StartUpdatingInternal()
		end
	end
end)
------------------------------------------configura os slots imagem------------------------------------------------------------
local boat_health =
{
	cargoboat = 300,
	encrustedboat = 800,
	rowboat = 250,
	armouredboat = 500,
	raft_old = 150,
	lograft_old = 150,
	woodlegsboat = 500,
	surfboard = 100,
}

AddClassPostConstruct("widgets/containerwidget", function(self)
	local BoatBadge = require("widgets/boatbadge")
	self.boatbadge = self:AddChild(BoatBadge(self.owner))
	self.boatbadge:SetPosition(0, 45, 0)
	self.boatbadge:Hide()

	local function BoatState(inst, data)
		self.boatbadge:SetPercent(data.percent, boat_health[inst.prefab] or 150)

		if self.boathealth then
			if data.percent > self.boathealth then
				self.boatbadge:PulseGreen()
			elseif data.percent < self.boathealth - 0.015 then
				self.boatbadge:PulseRed()
			end
		end

		self.boathealth = data.percent

		if data.percent <= .25 then
			self.boatbadge:StartWarning()
		else
			self.boatbadge:StopWarning()
		end
	end


	local OldOpen = self.Open
	function self:Open(container, doer)
		OldOpen(self, container, doer)
		local widget = container.replica.container:GetWidget()
		if widget and widget.slotbg and type(widget.slotbg) == "table" and widget.isboat then
			for i, v in ipairs(widget.slotbg) do
				if self.inv[i] then
					self.inv[i].bgimage:SetTexture(v.atlas, v.texture)
				end
			end
		end
		if widget and widget.isboat then
			self.isboat = true
			self.boatbadge:Show()
			self.inst:ListenForEvent("percentusedchange", BoatState, container)
			if GLOBAL.TheWorld.ismastersim then
				container:PushEvent("percentusedchange",
					{ percent = container.replica.inventoryitem.classified.percentused:value() / 100 })
			else
				container.replica.inventoryitem:DeserializeUsage()
			end
		end
	end

	local OldClose = self.Close
	function self:Close()
		OldClose(self)
		if self.isboat then
			self.inst:RemoveEventCallback("percentusedchange", BoatState, self.contanier)
		end
	end
end)
---------------------------------------configura os slots--------------------------------------------------------------------
--local params = getval(containers.widgetsetup, "params")


local function deepval(fn, name, member, depth)
	depth = depth or 20
	local i = 1
	while true do
		local n, v = GLOBAL.debug.getupvalue(fn, i)
		if v == nil then
			return
		elseif n == name and (not member or v[member]) then
			return v
		elseif type(v) == "function" and depth > 0 then
			local temp = deepval(v, name, member, depth - 1)
			if temp then return temp end
		end
		i = i + 1
	end
end

local params
if containers.smartercrockpot_old_widgetsetup then
	params = deepval(containers.smartercrockpot_old_widgetsetup, "params", "icepack")
else
	params = deepval(containers.widgetsetup, "params", "icepack")
end



local smelter =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),

		},

		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(80, 80, 0),
		--	isboat = true,
	},
	issidewidget = false,
	type = "cookpot",
}

local corkchest =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),

		},

		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(80, 80, 0),
		--	isboat = true,
	},
	issidewidget = false,
	type = "cookpot",
}

local thatchpack =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),

		},

		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(-60, -60, 0),
		--	isboat = true,
	},
	issidewidget = true,
	type = "cookpot",
}

local cargoboatslot =
{
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			Vector3(-250, 45, 0),
			Vector3(-330, 45, 0),
			Vector3(-410, 45, 0),
			Vector3(-490, 45, 0),
			Vector3(-570, 45, 0),
			Vector3(-650, 45, 0),
		},

		slotbg =
		{
			-- for 1st slot
			{
				atlas = "images/barco.xml",
				texture = "barco.tex",
			},
			-- for 2nd
			{
				atlas = "images/barco.xml",
				texture = "luz.tex",
			},
			-- and so on
		},

		animbank = "boat_hud_cargo",
		animbuild = "boat_hud_cargo",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, 80 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

local rowboatslot =
{
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			--    Vector3(65, 45, 0),

		},

		slotbg =
		{
			-- for 1st slot
			{
				atlas = "images/barco.xml",
				texture = "barco.tex",
			},
			-- for 2nd
			{
				atlas = "images/barco.xml",
				texture = "luz.tex",
			},
			-- and so on
		},

		animbank = "boat_hud_row",
		animbuild = "boat_hud_row",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, 80 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

local pirateslot =
{
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			Vector3(-300, 45, 0),

		},

		slotbg =
		{
			-- for 1st slot
			{
				atlas = "images/barco.xml",
				texture = "barco.tex",
			},
			-- for 2nd
			{
				atlas = "images/barco.xml",
				texture = "luz.tex",
			},
			-- and so on
		},

		animbank = "boat_hud_encrusted",
		animbuild = "boat_hud_encrusted",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, 80 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

local encrustedslot =
{
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			Vector3(-250, 45, 0),
			Vector3(-330, 45, 0),

		},

		slotbg =
		{
			-- for 1st slot
			{
				atlas = "images/barco.xml",
				texture = "barco.tex",
			},
			-- for 2nd
			{
				atlas = "images/barco.xml",
				texture = "luz.tex",
			},
			-- and so on
		},

		animbank = "boat_hud_encrusted",
		animbuild = "boat_hud_encrusted",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, 80 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

local raftslot =
{
	widget =
	{
		slotpos =
		{
			--    Vector3(-80, 45, 0),

		},

		animbank = "boat_hud_raft",
		animbuild = "boat_hud_raft",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, 80 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

local trawlnetdroppedslot =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, -75, 0),
			Vector3(-75, -75, 0),
			Vector3(75, -75, 0),
			Vector3(0, 75, 0),
			Vector3(-75, 75, 0),
			Vector3(75, 75, 0),
			Vector3(0, 0, 0),
			Vector3(-75, 0, 0),
			Vector3(75, 0, 0),
		},


		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(0, 200, 0)
	},
	issidewidget = false,
	type = "chest",
}

params["cargoboat"] = cargoboatslot
params["encrustedboat"] = encrustedslot
params["rowboat"] = rowboatslot
params["armouredboat"] = rowboatslot
params["raft_old"] = raftslot
params["lograft_old"] = raftslot
params["woodlegsboat"] = pirateslot
params["surfboard"] = raftslot
params["trawlnetdropped"] = trawlnetdroppedslot
params["corkboat"] = rowboatslot
params["smelter"] = smelter
params["corkchest"] = corkchest
params["thatchpack"] = thatchpack

function params.thatchpack.itemtestfn(container, item, slot)
	if slot == 1 then
		return true
	elseif slot == 2 then
		return true
	elseif slot == 3 then
		return true
	elseif slot == 4 then
		return true
	else
		return false
	end
end

function params.corkchest.itemtestfn(container, item, slot)
	if slot == 1 then
		return true
	elseif slot == 2 then
		return true
	elseif slot == 3 then
		return true
	elseif slot == 4 then
		return true
	else
		return false
	end
end

function params.smelter.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
		return true
	elseif slot == 2 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
		return true
	elseif slot == 3 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
		return true
	elseif slot == 4 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
		return true
	else
		return false
	end
end

function params.cargoboat.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	elseif slot == 3 then
		return true
	elseif slot == 4 then
		return true
	elseif slot == 5 then
		return true
	elseif slot == 6 then
		return true
	elseif slot == 7 then
		return true
	elseif slot == 8 then
		return true
	else
		return false
	end
end

function params.encrustedboat.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	elseif slot == 3 then
		return true
	elseif slot == 4 then
		return true
	else
		return false
	end
end

function params.rowboat.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.armouredboat.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.raft_old.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.raft_old.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.lograft_old.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.woodlegsboat.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	elseif slot == 3 then
		return true
	else
		return false
	end
end

function params.surfboard.itemtestfn(container, item, slot)
	if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
		return true
	elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
		return true
	else
		return false
	end
end

function params.trawlnetdropped.itemtestfn(container, item, slot)
	return true
end

---------------------------------------------------------------------tira a neve----------------------------------------------------------------------------------------
if GetModConfigData("disable_snow_effects") == true then
	AddComponentPostInit("weather",
		function(self, inst)
			inst:ListenForEvent(
				"weathertick",
				function(inst, data)
					if data and data.snowlevel
					then
						local newlevel = data.snowlevel <= 0 and data.snowlevel or 0
						GLOBAL.TheWorld.Map:SetOverlayLerp(newlevel)
					end
				end,
				GLOBAL.TheWorld
			)
		end
	)
end
-------------------------------------------------------------------------
--AddPlayerPostInit(function(inst)
--	inst.AnimState:AddOverrideBuild("player_portal_shipwrecked")
--end)
-------------------------lock for woodlegs boat by EvenMr-------------------------
local container_handler =
{
	"PutOneOfActiveItemInSlot",
	"PutAllOfActiveItemInSlot",
	"TakeActiveItemFromHalfOfSlot",
	"TakeActiveItemFromAllOfSlot",
	"AddOneOfActiveItemToSlot",
	"AddAllOfActiveItemToSlot",
	"SwapActiveItemWithSlot",
	"MoveItemFromAllOfSlot",
	"MoveItemFromHalfOfSlot",
}

local function containerhack(inst)
	local function lock(self, fname)
		local oldfn = self[fname]
		self[fname] = function(self, slot, ...)
			if (self._parent or self.inst).prefab == "woodlegsboat" and slot == 1 then
				return
			else
				oldfn(self, slot, ...)
			end
		end
	end
	for _, v in ipairs(container_handler) do
		lock(inst, v)
	end
end
AddComponentPostInit("container", containerhack)
AddPrefabPostInit("container_classified", containerhack)

-------------------------boat container sizing tweak by EvenMr-------------------------
AddClassPostConstruct("widgets/controls", function(self)
	local Widget = require("widgets/widget")
	self.containerroot_bottom = self:AddChild(Widget(""))
	self.containerroot_bottom:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
	self.containerroot_bottom:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
	self.containerroot_bottom:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
	self.containerroot_bottom:SetMaxPropUpscale(GLOBAL.MAX_HUD_SCALE)
	self.containerroot_bottom:MoveToBack()
	self.containerroot_bottom = self.containerroot_bottom:AddChild(Widget("contaierroot_bottom"))
	local scale = GLOBAL.TheFrontEnd:GetHUDScale()
	self.containerroot_bottom:SetScale(scale, scale, scale)
	self.containerroot_bottom:Hide()

	local OldSetHUDSize = self.SetHUDSize
	function self:SetHUDSize()
		OldSetHUDSize(self)
		local scale = GLOBAL.TheFrontEnd:GetHUDScale()
		self.containerroot_bottom:SetScale(scale, scale, scale)
	end

	local OldShowCraftingAndInventory = self.ShowCraftingAndInventory
	function self:ShowCraftingAndInventory()
		OldShowCraftingAndInventory(self)
		self.containerroot_bottom:Show()
	end

	local OldHideCraftingAndInventory = self.HideCraftingAndInventory
	function self:HideCraftingAndInventory()
		OldHideCraftingAndInventory(self)
		self.containerroot_bottom:Hide()
	end
end)

AddClassPostConstruct("screens/playerhud", function(self)
	local ContainerWidget = require("widgets/containerwidget")
	local oldopen = self.OpenContainer
	function self:OpenContainer(container, side)
		if container.replica.container and container.replica.container:GetWidget() and container.replica.container:GetWidget().isboat then
			local containerwidget = ContainerWidget(self.owner)
			self.controls.containerroot_bottom:AddChild(containerwidget)
			containerwidget:Open(container, self.owner)
			self.controls.containers[container] = containerwidget
		else
			oldopen(self, container, side)
		end
	end
end)

--------------------mapwrapper by EvenMr--------------------------
if GetModConfigData("kindofworld") == 10 then
	AddPlayerPostInit(function(inst)
		inst:AddComponent("mapwrapper")
	end)
end
-----------------------by EvenMr----------------------------------------------------------
--[[
AddComponentPostInit("frograin",function(self)
local function GetSpawnPoint(pt)
local function TestSpawnPoint(offset)
local spawnpoint = pt + offset
return GLOBAL.TheWorld.Map:IsPassableAtPoint(spawnpoint:Get())
and GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
end

local theta = GLOBAL.math.random() * 2 * GLOBAL.PI
local radius = GLOBAL.math.random() * TUNING.FROG_RAIN_SPAWN_RADIUS
local resultoffset = GLOBAL.FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

if resultoffset ~= nil then
return pt + resultoffset
end
end
setval(self.SetSpawnTimes,"ToggleUpdate.ScheduleSpawn.SpawnFrogForPlayer.GetSpawnPoint", GetSpawnPoint)
end)
]]
---------------------by EvenMr----------------------------------------------------------------

AddClassPostConstruct("screens/playerhud", function(inst)
	local PoisonOver = require("widgets/poisonover")
	local fn = inst.CreateOverlays
	function inst:CreateOverlays(owner)
		fn(self, owner)
		self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
	end
end)

local function OnPoisonOverDirty(inst)
	if inst._parent and inst._parent.HUD then
		if inst.poisonover:value() then
			inst._parent.HUD.poisonover:Flash()
		end
	end
end

AddPrefabPostInit("player_classified", function(inst)
	inst.poisonover = GLOBAL.net_bool(inst.GUID, "poison.poisonover", "poisonoverdirty")
	inst:ListenForEvent("poisonoverdirty", OnPoisonOverDirty)
end)
--[[
local function CraftMonkeyString()
    local function NumInRange(num, min, max)
        return (num <= max) and (num > min)
    end

    local STRING_STATE = "START"

    local string_start = function()
        local str = "O"
        if STRING_STATE == "START" then
            str = string.upper(str)
        end
        local l = math.random(2, 4)
        for i = 2, l do
            local nextletter = (math.random() > 0.3 and "o") or "a"
            str = str..nextletter
        end
        return str
    end

    local endings =
    {
        "",
        "e",
        "h",
    }

    local string_end = function()
        return endings[math.random(#endings)]
    end

    local string_space = function()
        local c = math.random()
        local str =
        (NumInRange(c, 0.4, 1) and " ") or
        (NumInRange(c, 0.3, 0.4) and ", ") or
        (NumInRange(c, 0.2, 0.3) and "? ") or
        (NumInRange(c, 0.1, 0.2) and ". ") or
        (NumInRange(c, 0, 0.1) and "! ")
        if c <= 0.3 then
            STRING_STATE = "START"
        else
            STRING_STATE = "MID"
        end
        return str
    end

    local length = math.random(6)
    local str = ""
    for i = 1, length do
        str = str..string_start()..string_end()
        if i ~= length then
            str = str..string_space()
        end
    end

    local punc = {".", "?", "!"}

    str = str..punc[math.random(#punc)]

    return str
end

local CraftOooh = getval(GLOBAL.GetSpecialCharacterString, "CraftOooh")
local wilton_sayings = getval(GLOBAL.GetSpecialCharacterString, "wilton_sayings")
GLOBAL.GetSpecialCharacterString = function(character)
    if character == nil then
        return nil
    end

    character = character:lower()

    return (character == "mime" and "")
        or (character == "ghost" and CraftOooh())
        or (character == "wilton" and wilton_sayings[math.random(#wilton_sayings)])
        or (character == "wilbur" and CraftMonkeyString())
        or nil
end

]]
AddPrefabPostInitAny(function(inst)
	if inst.prefab == "skeleton" or inst.prefab == "skeleton_player" then
		local function ondropped(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

				if (ground == GROUND.OCEAN_COASTAL or ground == GROUND.OCEAN_COASTAL_SHORE or ground == GROUND.OCEAN_SWELL or ground == GROUND.OCEAN_ROUGH or ground == GROUND.OCEAN_BRINEPOOL or ground == GROUND.OCEAN_BRINEPOOL_SHORE or ground == GROUND.OCEAN_HAZARDOUS or ground == GROUND.OCEAN_WATERLOG) then
					inst:DoTaskInTime(0.5, function(inst)
						local bolha = SpawnPrefab("frogsplash")
						if bolha then
							bolha.Transform:SetPosition(x, y, z)
						end
						inst:Remove()
					end)
				end
			end
		end
		--inst.components.inventoryitem:SetOnDroppedFn(ondropped)
		inst:DoTaskInTime(0, ondropped)
	end

	if inst.prefab == "ash" then
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("fertilizecoffee")
		end
	end
	------------------------
	if inst.prefab == "anchor" then
		inst:AddTag("ancora")
	end
	------------------------
	if inst.prefab == "gogglesnormalhat" or
		inst.prefab == "gogglesheathat" or
		inst.prefab == "gogglesarmorhat" or
		inst.prefab == "gogglesshoothat" or
		inst.prefab == "bathat" or
		inst.prefab == "pithhat" or
		inst.prefab == "armor_weevole" then
		inst:AddTag("velocidadenormal")
	end
	------------------------para a onda quebrar--------------
	if inst.prefab == "cave_entrance_open" or inst.prefab == "cave_entrance_vulcao" then
		inst:AddTag("teleportapracaverna")
	end

	if inst.prefab == "cave_exit" or inst.prefab == "cave_exit_vulcao" then
		inst:AddTag("teleportaprafloresta")
	end


	if inst.prefab == "seastack" or inst.prefab == "coralreef" or inst.prefab == "wreck" or inst.prefab == "waterygrave" or inst.prefab == "octopusking" or inst.prefab == "kraken" or inst.prefab == "ballphinhouse" or inst.prefab == "coral_brain_rock" or inst.prefab == "saltstackthen" or inst.prefab == "wall_enforcedlimestone" or inst.prefab == "kraken_tentacle" or inst.prefab == "sea_chiminea" or inst.prefab == "sea_yard" or inst.prefab == "buoy" then
		inst:AddTag("quebraonda")
	end

	if inst.prefab == "window_round_light" or inst.prefab == "window_round_light_backwall" then
		inst:AddTag("FX")
		inst:AddTag("NOCLICK")
		inst:AddTag("DECOR")
		inst:AddTag("NOBLOCK")
	end

	if inst.prefab == "saplingnova" or inst.prefab == "sapling" then
		inst.entity:AddSoundEmitter()
		inst:AddTag("saplingsw")
	end

	if inst.prefab == "sewing_tape" then
		inst:AddTag("boatrepairkit")
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("interactions")
		end
	end

	if inst.prefab == "wurt" then

	end


	if inst.prefab == "spider_warrior" then
		inst:DoTaskInTime(0.5, function(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
				if ground == GROUND.MAGMAFIELD or ground == GROUND.JUNGLE or ground == GROUND.ASH or ground == GROUND.VOLCANO or ground == GROUND.TIDALMARSH or ground == GROUND.MEADOW or ground == GROUND.BEAH then
					local bolha = SpawnPrefab("spider_tropical")
					if bolha then
						bolha.Transform:SetPosition(x, y, z)
					end
					inst:Remove()
				end
			end
		end)
	end


	-----mostra neve--------------
	if inst:HasTag("SnowCovered") then
		local function mostraneve(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
				if ground == GROUND.WATER_MANGROVE or ground == GROUND.ANTFLOOR then
					inst:AddTag("mostraneve")
				end
			end
		end
		inst:DoTaskInTime(0.5, mostraneve)
	end

	--------------negocia com porcos------------------
	if inst.prefab == "houndstooth" or inst.prefab == "gunpowder" or inst.prefab == "boards" or inst.prefab == "mosquitosack" or inst.prefab == "nightmarefuel" or inst.prefab == "stinger" or inst.prefab == "spear" or inst.prefab == "spear_wathgrithr" then
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("tradable")
		end
	end

	--------------mod rangers------------------
	if inst.prefab == "levelx_vest" then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("krampus_sack")
		end
	end
	------------------------koalefant_summer se transforma no chao de neve-----------------
	if inst.prefab == "koalefant_summer" then
		local function ondropped(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

				if (ground == GROUND.WATER_MANGROVE) or (ground == GROUND.ANTFLOOR) then
					inst:DoTaskInTime(0.5, function(inst)
						local bolha = SpawnPrefab("koalefant_winter")
						if bolha then
							bolha.Transform:SetPosition(x, y, z)
						end
						inst:Remove()
					end)
				end
			end
		end

		inst:DoTaskInTime(0, ondropped)
	end

	------------------------hound se transforma no chao de neve-----------------
	--[[
if inst.prefab == "firehound" or inst.prefab == "hound" or inst.prefab == "icehound" then
local function ondropped(inst)
if GLOBAL.TheWorld.components.aporkalypse and GLOBAL.TheWorld.components.aporkalypse.aporkalypse_active == true then
inst:DoTaskInTime(0.5, function(inst)
inst:SetPrefabName("mutatedhound")
--inst:Remove()
--inst.AnimState:SetBank("hound")
--inst.AnimState:SetBuild("hound_mutated")
end)
else
local map = GLOBAL.TheWorld.Map
local x, y, z = inst.Transform:GetWorldPosition()
for i, node in ipairs(GLOBAL.TheWorld.topology.nodes) do
if TheSim:WorldPointInPoly(x, z, node.poly) then


if node.tags ~= nil and table.contains(node.tags, "hamlet") then
local bolha = SpawnPrefab("vampirebat")
if bolha then
bolha.Transform:SetPosition(x, y, z)
local atacado = GLOBAL.GetClosestInstWithTag("player", bolha, 40)
if atacado then
bolha.components.combat:SuggestTarget(atacado)
end
end
inst:Remove()
end


if node.tags ~= nil and table.contains(node.tags, "frost") and inst.prefab ~= "icehound" then
local bolha = SpawnPrefab("icehound")
if bolha then
bolha.Transform:SetPosition(x, y, z)
local atacado = GLOBAL.GetClosestInstWithTag("player", bolha, 40)
if atacado then
bolha.components.combat:SuggestTarget(atacado)
end
end
inst:Remove()
end

if node.tags ~= nil and table.contains(node.tags, "tropical") then


if inst.prefab == "hound" then
local bolha = SpawnPrefab("icehound")
if bolha then
bolha.Transform:SetPosition(x, y, z)
local atacado = GLOBAL.GetClosestInstWithTag("player", bolha, 40)
if atacado then
bolha.components.combat:SuggestTarget(atacado)
end
end
inst:Remove()
end

if inst.prefab == "firehound" then
local bolha = SpawnPrefab("poisoncrocodog")
if bolha then
bolha.Transform:SetPosition(x, y, z)
local atacado = GLOBAL.GetClosestInstWithTag("player", bolha, 40)
if atacado then
bolha.components.combat:SuggestTarget(atacado)
end
end
inst:Remove()
end


if inst.prefab == "icehound" then
local bolha = SpawnPrefab("watercrocodog")
if bolha then
bolha.Transform:SetPosition(x, y, z)
local atacado = GLOBAL.GetClosestInstWithTag("player", bolha, 40)
if atacado then
bolha.components.combat:SuggestTarget(atacado)
end
end
inst:Remove()
end
end
end
end
end
end

inst:DoTaskInTime(0, ondropped)
end
]]
	------------------------------------------------------
	if inst.prefab == "mole" or inst.prefab == "rabbit" then
		local function ondropped(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

				if (ground == GROUND.UNDERWATER_ROCKY) or (ground == GROUND.UNDERWATER_SANDY) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then
					inst:DoTaskInTime(0.1, function(inst)
						inst:Remove()
					end)
				end
			end
		end

		inst:DoTaskInTime(0.1, ondropped)
	end


	if inst.prefab == "worm" then
		local function ondropped(inst)
			local map = GLOBAL.TheWorld.Map
			local x, y, z = inst.Transform:GetWorldPosition()
			if x and y and z then
				local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

				if (ground == GROUND.UNDERWATER_ROCKY) or (ground == GROUND.UNDERWATER_SANDY) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then
					inst:DoTaskInTime(0.1, function(inst)
						local bolha = SpawnPrefab("seatentacle")
						if bolha then
							bolha.Transform:SetPosition(x, y, z)
						end
						inst:Remove()
					end)
				end
			end
		end

		inst:DoTaskInTime(0.1, ondropped)
	end
	--------------------------apaga depois de um tempo----------------------

	if inst.prefab == "snake_amphibious"
		or inst.prefab == "bat"
		or inst.prefab == "scorpion"
		or inst.prefab == "ghost"
		or inst.prefab == "antman_warrior"
		or inst.prefab == "antman"
		or inst.prefab == "hanging_vine"
		or inst.prefab == "grabbing_vine"
		or inst.prefab == "hanging_vine_patch"
		or inst.prefab == "mean_flytrap"
		or inst.prefab == "adult_flytrap"
		or inst.prefab == "lightrays_jungle"
		or inst.prefab == "pog"
		or inst.prefab == "zeb"
		or inst.prefab == "lightrays" then
		local function OnTimerDone(inst, data)
			if data.name == "vaiembora" then
				local invader = GLOBAL.GetClosestInstWithTag("player", inst, 25)
				if not invader then
					inst:Remove()
				else
					inst.components.timer:StartTimer("vaiembora", 10)
				end
			end
		end

		inst:AddTag("tropicalspawner")

		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("timer")
			inst:ListenForEvent("timerdone", OnTimerDone)
			inst.components.timer:StartTimer("vaiembora", 80 + math.random() * 80)
		end
	end
end)


AddPrefabPostInitAny(function(inst)
	if inst:HasTag("player") then
		if inst.components.shopper == nil then
			inst:AddComponent("shopper")
		end

		if inst.components.infestable == nil then
			inst:AddComponent("infestable")
		end


		if inst.components.drownable == nil then
			inst:AddComponent("drownable")
		end
	end
end)

--------------------------------- camera------------------------------

local function OnDirtyEventCameraStuff(inst) -- this is called on client, if the server does inst.mynetvarCameraMode:set(...)
	local val = inst.mynetvarCameraMode:value()
	local fasedodia = "night"
	if GLOBAL.TheWorld.state.isday then fasedodia = "day" end
	if GLOBAL.TheWorld.state.isdusk then fasedodia = "dusk" end
	if GLOBAL.TheWorld.state.isnight then fasedodia = "night" end
	if val == 1 then -- for jumping(OnActive) function
		GLOBAL.TheCamera.controllable = false
		GLOBAL.TheCamera.cutscene = true
		GLOBAL.TheCamera.headingtarget = 0
		GLOBAL.TheCamera.distancetarget = 20 + GetModConfigData("housewallajust")
		GLOBAL.TheCamera.targetoffset = Vector3(-2.3, 1.7, 0)
	elseif val == 2 then
		GLOBAL.TheCamera:SetDistance(12)
	elseif val == 3 then
		GLOBAL.TheCamera:SetDefault()
		GLOBAL.TheCamera:SetTarget(GLOBAL.TheFocalPoint)
	elseif val == 4 then --for player prox
		GLOBAL.TheCamera.controllable = false
		GLOBAL.TheCamera.cutscene = true
		GLOBAL.TheCamera.headingtarget = 0
		GLOBAL.TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
		GLOBAL.TheCamera:SetTarget(GLOBAL.GetClosestInstWithTag("shopinterior", inst, 30))
		GLOBAL.TheCamera.targetoffset = Vector3(2, 1.5, 0)
		GLOBAL.TheWorld:PushEvent("underwatercave", "night")
		if not GLOBAL.GetClosestInstWithTag("casadojogador", inst, 30) then
			GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/store", "storemusic")
		end
	elseif val == 5 then --for player prox
		GLOBAL.TheCamera.controllable = false
		GLOBAL.TheCamera.cutscene = true
		GLOBAL.TheCamera.headingtarget = 0
		local alvodacamera = GLOBAL.GetClosestInstWithTag("caveinterior", inst, 30)
		if alvodacamera then
			GLOBAL.TheCamera:SetTarget(alvodacamera)
		end
		if alvodacamera and alvodacamera:HasTag("pisodaruina") then
			GLOBAL.TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
			GLOBAL.TheCamera.targetoffset = Vector3(6, 1.5, 0)
			GLOBAL.TheWorld:PushEvent("underwatercave", "night")
			GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/ruins", "storemusic")
		elseif alvodacamera and alvodacamera:HasTag("pisogalleryinteriorpalace") then
			GLOBAL.TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
			GLOBAL.TheCamera.targetoffset = Vector3(3, 1.5, 0)
		elseif alvodacamera and alvodacamera:HasTag("pisoanthill") then
			GLOBAL.TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
			GLOBAL.TheCamera.targetoffset = Vector3(5, 1.5, 0)
			GLOBAL.TheWorld:PushEvent("underwatercave", "night")
		else
			GLOBAL.TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
			GLOBAL.TheCamera.targetoffset = Vector3(5, 1.5, 0)
			GLOBAL.TheWorld:PushEvent("underwatercave", "night")
		end
	elseif val == 6 then --for player prox
		GLOBAL.TheCamera:SetDefault()
		GLOBAL.TheCamera:SetTarget(GLOBAL.TheFocalPoint)

		local fasedodia = "night"
		if GLOBAL.TheWorld.state.isday then fasedodia = "day" end
		if GLOBAL.TheWorld.state.isdusk then fasedodia = "dusk" end
		if GLOBAL.TheWorld.state.isnight then fasedodia = "night" end
		GLOBAL.TheWorld:PushEvent("underwatercaveexit", fasedodia)
		GLOBAL.TheFocalPoint.SoundEmitter:KillSound("storemusic")
	elseif val == 7 then --for player prox
		GLOBAL.TheCamera.controllable = false
		GLOBAL.TheCamera.cutscene = true
		GLOBAL.TheCamera.headingtarget = 0
		GLOBAL.TheCamera.distancetarget = 28 + GetModConfigData("housewallajust")
		GLOBAL.TheCamera:SetTarget(GLOBAL.GetClosestInstWithTag("pisointeriorpalace", inst, 30))
		GLOBAL.TheCamera.targetoffset = Vector3(5, 1.5, 0)
	elseif val == 8 then --for player prox
		GLOBAL.TheCamera.controllable = false
		GLOBAL.TheCamera.cutscene = true
		GLOBAL.TheCamera.headingtarget = 0
		GLOBAL.TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
		GLOBAL.TheCamera:SetTarget(GLOBAL.GetClosestInstWithTag("pisointerioruins", inst, 30)) --inst = GLOBAL.ThePlayer
		GLOBAL.TheCamera.targetoffset = Vector3(6, 1.5, 0)
	end
	-- Use val and do client related stuff
end



--TheWorld:PushEvent("underwatercave", "night")
--TheWorld:PushEvent("underwatercaveexit", "night")


local function RegisterListenersCameraStuff(inst)
	-- check that the entity is the playing player
	if inst.HUD ~= nil then
		inst:ListenForEvent("DirtyEventCameraStuff", OnDirtyEventCameraStuff)
	end
end



local function OnPlayerSpawn(inst)
	inst.mynetvarCameraMode = GLOBAL.net_tinybyte(inst.GUID, "BakuStuffNetStuff", "DirtyEventCameraStuff")
	inst.mynetvarCameraMode:set(0)
	inst:DoTaskInTime(0, RegisterListenersCameraStuff)

	inst:DoTaskInTime(0.5, function(inst)
		if GLOBAL.GetClosestInstWithTag("shopinterior", inst, 30) then
			inst.mynetvarCameraMode:set(4)
		elseif GLOBAL.GetClosestInstWithTag("caveinterior", inst, 30) then
			inst.mynetvarCameraMode:set(5)
		elseif GLOBAL.GetClosestInstWithTag("pisointeriorpalace", inst, 30) then
			inst.mynetvarCameraMode:set(7)
		else
			inst.mynetvarCameraMode:set(6)
		end
	end)
end

AddPlayerPostInit(OnPlayerSpawn)


AddClassPostConstruct("cameras/followcamera", function(Camera)
	--Camera.old = Camera.SetDefault
	function Camera:PushScreenHOffset(ref, xoffset)
		if not self.controllable then
		else
			self:PopScreenHOffset(ref)
			table.insert(self.screenoffsetstack, 1, { ref = ref, xoffset = xoffset })
		end
	end
end)
--[[
AddComponentPostInit("focalpoint",function(self)
    local old_CameraUpdate = self.CameraUpdate
    local function new_CameraUpdate(self,dt,...)
   local parent = self.inst.entity:GetParent()
    if parent ~= nil and GLOBAL.next(self.targets) ~= nil then
        local toremove2 = {}
        for source, sourcetbl in pairs(self.targets) do
            if not source:IsNear(self.inst, 50) and source:HasTag("blows_air")  then--if not source:IsNear(self.inst, 50) and source:HasTag("interiorcamera")  then--and not source:HasTag("centerroomglow") then
                table.insert(toremove2, source)
            end
        end
         for i, v in ipairs(toremove2) do
            self:StopFocusSource(GLOBAL.unpack(toremove2))
        end

    end
        if old_CameraUpdate~=nil then
            return old_CameraUpdate(self,dt,...)
        end
    end
    self.CameraUpdate = new_CameraUpdate
end)
]]
----umidade interior------

local Sheltered = GLOBAL.require("components/sheltered")
local SHELTERED_MUST_TAGS = { "shelter" }
local SHELTERED_CANT_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "stump", "burnt" }
local SHADECANOPY_MUST_TAGS = { "shadecanopy" }
local SHADECANOPY_SMALL_MUST_TAGS = { "shadecanopysmall" }
function Sheltered:OnUpdate(dt)
	local sheltered = false
	local level = 1
	self.waterproofness = TUNING.WATERPROOFNESS_SMALLMED --adicionado
	self.announcecooldown = math.max(0, self.announcecooldown - dt)
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2, SHELTERED_MUST_TAGS, SHELTERED_CANT_TAGS)
	local blowsent = TheSim:FindEntities(x, y, z, 40, { "blows_air" })


	if #blowsent > 0 then
		self:SetSheltered(#blowsent > 0)
		for _, v in ipairs(blowsent) do
			--if v:HasTag("dryshelter") then
			self.waterproofness = TUNING.WATERPROOFNESS_ABSOLUTE
			break
			--end
		end
	else
		if #ents > 0 then
			sheltered = true
		end

		local canopy = TheSim:FindEntities(x, y, z, TUNING.SHADE_CANOPY_RANGE, SHADECANOPY_MUST_TAGS)
		local canopy_small = TheSim:FindEntities(x, y, z, TUNING.SHADE_CANOPY_RANGE_SMALL, SHADECANOPY_SMALL_MUST_TAGS)
		if #canopy > 0 or #canopy_small > 0 then
			sheltered = true
			level = 2
		end

		self:SetSheltered(sheltered, level)
	end
end

------rain effect---------------
AddSimPostInit(function()
	GLOBAL.EmitterManager.old_updatefuncs = { snow = nil, rain = nil, pollen = nil }
	local old_PostUpdate = GLOBAL.EmitterManager.PostUpdate
	local function new_PostUpdate(self, ...)
		for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
			if inst.prefab == "pollen" or inst.prefab == "snow" or inst.prefab == "rain" then
				if self.old_updatefuncs[inst.prefab] == nil then
					self.old_updatefuncs[inst.prefab] = data.updateFunc
				end
				local pt = inst:GetPosition()
				local ents = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, 40, { "blows_air" })
				if #ents > 0 then
					data.updateFunc = function() end -- empty function
				else
					data.updateFunc = self.old_updatefuncs[inst.prefab] ~= nil and self.old_updatefuncs[inst.prefab] or
						function() end -- the original one
				end
			end
		end
		if old_PostUpdate ~= nil then
			return old_PostUpdate(self, ...)
		end
	end
	GLOBAL.EmitterManager.PostUpdate = new_PostUpdate
end)


---------------------
GLOBAL.STRINGS.ACTIONS.JUMPIN = {
	HAMLET = "Enter",
	GENERIC = "Jump In",
}

local Oldstrfnjumpin = ACTIONS.JUMPIN.strfn
GLOBAL.ACTIONS.JUMPIN.strfn = function(act)
	if act.target ~= nil and act.target:HasTag("hamletteleport") then
		return "HAMLET"
	end
	return Oldstrfnjumpin(act)
end

------darkness---------------
AddPlayerPostInit(function(inst)
	if GLOBAL.TheNet:GetIsServer() then
		inst.findpigruinstask = inst:DoPeriodicTask(2, function()
			local pt = inst:GetPosition()
			local interior = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, 40, { "pisodaruina" })
			if #interior > 0 and inst.LightWatcher ~= nil then
				local thresh = GLOBAL.TheSim:GetLightAtPoint(10000, 10000, 10000)
				inst.LightWatcher:SetLightThresh(0.075 + thresh)
				inst.LightWatcher:SetDarkThresh(0.05 + thresh)
			else
				inst.LightWatcher:SetLightThresh(0.075)
				inst.LightWatcher:SetDarkThresh(0.05)
			end
		end)
	end
end)
------------------------------------bloodmoon ----------------------------------------------

if GetModConfigData("aporkalypse") == true then
	local function bloodmoon(self)
		local luavermelha = GLOBAL.require "widgets/bloodmoon"
		self.luadesangue = self:AddChild(luavermelha(self.owner))
		--	local badge_brain = self.brain:GetPosition()
		local AlwaysOnStatus = false
		for k, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
			local Mod = GLOBAL.KnownModIndex:GetModInfo(v).name
			if Mod == "Combined Status" then
				AlwaysOnStatus = true
			end
		end
		if AlwaysOnStatus then
			self.luadesangue:SetPosition(0, 0, 0)
		else
			self.luadesangue:SetPosition(0, 0, 0)
		end
	end

	AddClassPostConstruct("widgets/uiclock", bloodmoon)
end

------------------------------------coofee badge ----------------------------------------------

local function bloodmoon(self)
	local luavermelha = GLOBAL.require "widgets/bloodmoon"
	self.luadesangue = self:AddChild(luavermelha(self.owner))
	--	local badge_brain = self.brain:GetPosition()
	local AlwaysOnStatus = false
	for k, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
		local Mod = GLOBAL.KnownModIndex:GetModInfo(v).name
		if Mod == "Combined Status" then
			AlwaysOnStatus = true
		end
	end
	if AlwaysOnStatus then
		self.luadesangue:SetPosition(0, 0, 0)
	else
		self.luadesangue:SetPosition(0, 0, 0)
	end
end

AddClassPostConstruct("widgets/uiclock", bloodmoon)


local function speedicon(self)
	local iconedevelocidade = GLOBAL.require "widgets/speedicon"
	self.velocidadeativa = self:AddChild(iconedevelocidade(self.owner))
	self.owner.velocidadeativa = self.velocidadeativa

	-- local badge_brain = self.brain:GetPosition()
	local AlwaysOnStatus = false
	for k, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
		local Mod = GLOBAL.KnownModIndex:GetModInfo(v).name
		if Mod == "Combined Status" then
			AlwaysOnStatus = true
		end
	end
	if AlwaysOnStatus then
		self.velocidadeativa:SetPosition(-85, 6, 0)
	else
		self.velocidadeativa:SetPosition(-65.5, -9.5, 0)
	end
end

AddClassPostConstruct("widgets/statusdisplays", speedicon)



---------------------------------------------------------------------------------------Raft and logboat---------------------------------------------------
STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
DEPLOYSPACING = GLOBAL.DEPLOYSPACING
DEPLOYSPACING_RADIUS = GLOBAL.DEPLOYSPACING_RADIUS
TheSim = GLOBAL.TheSim
--[[
AddComponentPostInit("boatphysics",function(self,inst)
    self.sizespeedmultiplier=1
    local oaf=self.ApplyForce
    function self:ApplyForce(dir_x, dir_z, force)
        local force=(force and force or 0)*self.sizespeedmultiplier
        oaf(self,dir_x, dir_z, force)
    end
    local oam=self.AddMast
    function self:AddMast(mast)
        mast.sail_force=mast.sail_force*self.sizespeedmultiplier
        oam(self, mast)
    end
end)

AddSimPostInit(function()
    local WALKABLE_PLATFORM_TAGS={"walkableplatform"}
    GLOBAL.Map.GetPlatformAtPoint=function(self,pos_x,pos_y, pos_z)
        if pos_z == nil then
            pos_z = pos_y
            pos_y = 0
        end
        local entities = TheSim:FindEntities(pos_x, pos_y, pos_z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*10, WALKABLE_PLATFORM_TAGS)
        for i, v in ipairs(entities) do
			if v.components.walkableplatform~=nil and v.components.walkableplatform.radius == nil then v.components.walkableplatform.radius = 4 end
            if v.components.walkableplatform~=nil and math.sqrt(v:GetDistanceSqToPoint(pos_x, 0, pos_z))<=v.components.walkableplatform.radius then
                return v
            end
        end
        return nil
    end
    GLOBAL.Map.IsPassableAtPointWithPlatformRadiusBias=function(self,x, y, z, allow_water, exclude_boats, platform_radius_bias, ignore_land_overhang)
        local valid_tile = self:IsAboveGroundAtPoint(x, y, z, allow_water) or ((not ignore_land_overhang) and self:IsVisualGroundAtPoint(x,y,z) or false)
        if not allow_water and not valid_tile then
            if not exclude_boats then
                local entities = TheSim:FindEntities(x, 0, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*10 + platform_radius_bias, WALKABLE_PLATFORM_TAGS)
                for i, v in ipairs(entities) do
                    local walkable_platform = v.components.walkableplatform
					if v.components.walkableplatform~=nil and v.components.walkableplatform.radius == nil then v.components.walkableplatform.radius = 4 end
                    if walkable_platform~=nil and math.sqrt(v:GetDistanceSqToPoint(x, 0, z))<=(walkable_platform.radius+platform_radius_bias) then
                        local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
                        local distance_sq = GLOBAL.VecUtil_LengthSq(x - platform_x, z - platform_z)
                        return distance_sq <= walkable_platform.radius * walkable_platform.radius
                    end
                end
            end
            return false
        end
        return valid_tile
    end
    GLOBAL.Map.CanDeployAtPointInWater=function(self,pt, inst, mouseover, data)
        local tile = self:GetTileAtPoint(pt.x, pt.y, pt.z)
        if tile == GROUND.IMPASSABLE or tile == GROUND.INVALID then
            return false
        end

        -- check if there's a boat in the way
        local min_distance_from_boat = (data and data.boat) or 0
        local radius = (data and data.radius) or 0
        local entities = TheSim:FindEntities(pt.x, 0, pt.z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*10 + radius + min_distance_from_boat, WALKABLE_PLATFORM_TAGS)
        for i, v in ipairs(entities) do
            if v.components.walkableplatform~=nil and math.sqrt(v:GetDistanceSqToPoint(pt.x, 0, pt.z))<=(v.components.walkableplatform.radius+radius+min_distance_from_boat) then
                return false
            end
        end

        local min_distance_from_land = (data and data.land) or 0

        return (mouseover == nil or mouseover:HasTag("player"))
            and self:IsDeployPointClear(pt, nil, min_distance_from_boat + radius)
            and self:IsSurroundedByWater(pt.x, pt.y, pt.z, min_distance_from_land + radius)
    end
end)

local lastfree=0
for k,v in pairs(DEPLOYSPACING) do
    if v+1>lastfree then
        lastfree=v+1
    end
end

if lastfree<=7 then
    DEPLOYSPACING.LARGEBOATS=lastfree
    DEPLOYSPACING_RADIUS[DEPLOYSPACING.LARGEBOATS]=8
else
    for k,v in pairs(DEPLOYSPACING) do
        if DEPLOYSPACING_RADIUS[v]>7 and DEPLOYSPACING_RADIUS[v]<10 then
            DEPLOYSPACING.LARGEBOATS=v
            break
        end
    end
end
]]
---------------------------------------------modded farms-------------------------------
local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time     = {}

	-- germination time
	grow_time.seed      = { germination_min, germination_max }

	-- grow time
	grow_time.sprout    = { full_grow_min * 0.5, full_grow_max * 0.5 }
	grow_time.small     = { full_grow_min * 0.3, full_grow_max * 0.3 }
	grow_time.med       = { full_grow_min * 0.2, full_grow_max * 0.2 }

	-- harvestable perish time
	grow_time.full      = 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized = 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow    = { 4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME } -- min, max	

	return grow_time
end

local PLANT_DEFS                               = require("prefabs/farm_plant_defs").PLANT_DEFS

local drink_low                                = TUNING.FARM_PLANT_DRINK_LOW
local drink_med                                = TUNING.FARM_PLANT_DRINK_MED
local drink_high                               = TUNING.FARM_PLANT_DRINK_HIGH

local S                                        = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M                                        = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L                                        = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

PLANT_DEFS.aloe                                = { build = "farm_plant_aloeplant", bank = "farm_plant_asparagus" }
PLANT_DEFS.radish                              = { build = "farm_plant_radish", bank = "farm_plant_carrot" }
PLANT_DEFS.sweet_potato                        = { build = "farm_plant_sweett", bank = "farm_plant_carrot" }
PLANT_DEFS.wheat                               = { build = "farm_plant_wheataaaa", bank = "farm_plant_asparagus" }
PLANT_DEFS.turnip                              = { build = "farm_plant_turnip", bank = "farm_plant_carrot" }

PLANT_DEFS.sweet_potato.grow_time              = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
	4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.aloe.grow_time                      = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
	4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.radish.grow_time                    = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
	4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.wheat.grow_time                     = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
	4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.turnip.grow_time                    = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
	4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)

PLANT_DEFS.sweet_potato.moisture               = {
	drink_rate = drink_low,
	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.aloe.moisture                       = {
	drink_rate = drink_low,
	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.radish.moisture                     = {
	drink_rate = drink_low,
	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.wheat.moisture                      = {
	drink_rate = drink_low,
	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.turnip.moisture                     = {
	drink_rate = drink_low,
	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}

PLANT_DEFS.sweet_potato.good_seasons           = { autumn = true, winter = true, spring = true }
PLANT_DEFS.aloe.good_seasons                   = { autumn = true, winter = true, spring = true }
PLANT_DEFS.radish.good_seasons                 = { autumn = true, winter = true, spring = true }
PLANT_DEFS.wheat.good_seasons                  = { autumn = true, winter = true, spring = true }
PLANT_DEFS.turnip.good_seasons                 = { autumn = true, winter = true, spring = true }

PLANT_DEFS.sweet_potato.nutrient_consumption   = { M, 0, 0 }
PLANT_DEFS.aloe.nutrient_consumption           = { M, 0, 0 }
PLANT_DEFS.radish.nutrient_consumption         = { M, 0, 0 }
PLANT_DEFS.wheat.nutrient_consumption          = { M, 0, 0 }
PLANT_DEFS.turnip.nutrient_consumption         = { M, 0, 0 }

PLANT_DEFS.sweet_potato.max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.aloe.max_killjoys_tolerance         = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.radish.max_killjoys_tolerance       = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.wheat.max_killjoys_tolerance        = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.turnip.max_killjoys_tolerance       = TUNING.FARM_PLANT_KILLJOY_TOLERANCE

PLANT_DEFS.sweet_potato.weight_data            = { 0, 0, 0 }
PLANT_DEFS.aloe.weight_data                    = { 0, 0, 0 }
PLANT_DEFS.radish.weight_data                  = { 0, 0, 0 }
PLANT_DEFS.wheat.weight_data                   = { 0, 0, 0 }
PLANT_DEFS.turnip.weight_data                  = { 0, 0, 0 }
PLANT_DEFS.carrot.weight_data                  = { 0, 0, 0 }

-- PLANT_DEFS.sweet_potato.weight_data            = { 361.51, 506.04, .28 }
-- PLANT_DEFS.aloe.weight_data                    = { 361.51, 506.04, .28 }
-- PLANT_DEFS.radish.weight_data                  = { 361.51, 506.04, .28 }
-- PLANT_DEFS.wheat.weight_data                   = { 361.51, 506.04, .28 }
-- PLANT_DEFS.turnip.weight_data                  = { 361.51, 506.04, .28 }

PLANT_DEFS.sweet_potato.pictureframeanim       = { anim = "emote_happycheer", time = 12 * GLOBAL.FRAMES }
PLANT_DEFS.aloe.pictureframeanim               = { anim = "emote_happycheer", time = 12 * GLOBAL.FRAMES }
PLANT_DEFS.radish.pictureframeanim             = { anim = "emote_happycheer", time = 12 * GLOBAL.FRAMES }
PLANT_DEFS.wheat.pictureframeanim              = { anim = "emote_happycheer", time = 12 * GLOBAL.FRAMES }
PLANT_DEFS.turnip.pictureframeanim             = { anim = "emote_happycheer", time = 12 * GLOBAL.FRAMES }

PLANT_DEFS.sweet_potato.prefab                 = "farm_plant_sweet_potato"
PLANT_DEFS.aloe.prefab                         = "farm_plant_aloe"
PLANT_DEFS.radish.prefab                       = "farm_plant_radish"
PLANT_DEFS.wheat.prefab                        = "farm_plant_wheat"
PLANT_DEFS.turnip.prefab                       = "farm_plant_turnip"

PLANT_DEFS.sweet_potato.product                = "sweet_potato"
PLANT_DEFS.aloe.product                        = "aloe"
PLANT_DEFS.radish.product                      = "radish"
PLANT_DEFS.wheat.product                       = "wheat"
PLANT_DEFS.turnip.product                      = "turnip"

PLANT_DEFS.sweet_potato.product_oversized      = "sweet_potato_oversized"
PLANT_DEFS.aloe.product_oversized              = "aloe_oversized"
PLANT_DEFS.radish.product_oversized            = "radish_oversized"
PLANT_DEFS.wheat.product_oversized             = "wheat_oversized"
PLANT_DEFS.turnip.product_oversized            = "turnip_oversized"

PLANT_DEFS.sweet_potato.seed                   = "sweet_potato_seeds"
PLANT_DEFS.aloe.seed                           = "aloe_seeds"
PLANT_DEFS.radish.seed                         = "radish_seeds"
PLANT_DEFS.wheat.seed                          = "wheat_seeds"
PLANT_DEFS.turnip.seed                         = "turnip_seeds"

PLANT_DEFS.sweet_potato.plant_type_tag         = "farm_plant_sweet_potato"
PLANT_DEFS.aloe.plant_type_tag                 = "farm_plant_aloe"
PLANT_DEFS.radish.plant_type_tag               = "farm_plant_radish"
PLANT_DEFS.wheat.plant_type_tag                = "farm_plant_wheat"
PLANT_DEFS.turnip.plant_type_tag               = "farm_plant_turnip"

PLANT_DEFS.sweet_potato.loot_oversized_rot     = { "spoiled_food", "spoiled_food", "spoiled_food", "sweet_potato_seeds",
	"fruitfly", "fruitfly" }
PLANT_DEFS.aloe.loot_oversized_rot             = { "spoiled_food", "spoiled_food", "spoiled_food", "aloe_seeds",
	"fruitfly", "fruitfly" }
PLANT_DEFS.radish.loot_oversized_rot           = { "spoiled_food", "spoiled_food", "spoiled_food", "radish_seeds",
	"fruitfly", "fruitfly" }
PLANT_DEFS.wheat.loot_oversized_rot            = { "spoiled_food", "spoiled_food", "spoiled_food", "wheat_seeds",
	"fruitfly", "fruitfly" }
PLANT_DEFS.turnip.loot_oversized_rot           = { "spoiled_food", "spoiled_food", "spoiled_food", "turnip_seeds",
	"fruitfly", "fruitfly" }

PLANT_DEFS.sweet_potato.family_min_count       = TUNING.FARM_PLANT_SAME_FAMILY_MIN
PLANT_DEFS.aloe.family_min_count               = TUNING.FARM_PLANT_SAME_FAMILY_MIN
PLANT_DEFS.radish.family_min_count             = TUNING.FARM_PLANT_SAME_FAMILY_MIN
PLANT_DEFS.wheat.family_min_count              = TUNING.FARM_PLANT_SAME_FAMILY_MIN
PLANT_DEFS.turnip.family_min_count             = TUNING.FARM_PLANT_SAME_FAMILY_MIN

PLANT_DEFS.sweet_potato.family_check_dist      = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS
PLANT_DEFS.aloe.family_check_dist              = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS
PLANT_DEFS.radish.family_check_dist            = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS
PLANT_DEFS.wheat.family_check_dist             = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS
PLANT_DEFS.turnip.family_check_dist            = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS

PLANT_DEFS.sweet_potato.stage_netvar           = net_tinybyte
PLANT_DEFS.aloe.stage_netvar                   = net_tinybyte
PLANT_DEFS.radish.stage_netvar                 = net_tinybyte
PLANT_DEFS.wheat.stage_netvar                  = net_tinybyte
PLANT_DEFS.turnip.stage_netvar                 = net_tinybyte

PLANT_DEFS.sweet_potato.sounds                 = PLANT_DEFS.pumpkin.sounds
PLANT_DEFS.aloe.sounds                         = PLANT_DEFS.pumpkin.sounds
PLANT_DEFS.radish.sounds                       = PLANT_DEFS.pumpkin.sounds
PLANT_DEFS.wheat.sounds                        = PLANT_DEFS.pumpkin.sounds
PLANT_DEFS.turnip.sounds                       = PLANT_DEFS.pumpkin.sounds


PLANT_DEFS.sweet_potato.plantregistryinfo = {
	{
		text = "seed",
		anim = "crop_seed",
		grow_anim = "grow_seed",
		learnseed = true,
		growing = true,
	},
	{
		text = "sprout",
		anim = "crop_sprout",
		grow_anim = "grow_sprout",
		growing = true,
	},
	{
		text = "small",
		anim = "crop_small",
		grow_anim = "grow_small",
		growing = true,
	},
	{
		text = "medium",
		anim = "crop_med",
		grow_anim = "grow_med",
		growing = true,
	},
	{
		text = "grown",
		anim = "crop_full",
		grow_anim = "grow_full",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "oversized",
		anim = "crop_oversized",
		grow_anim = "grow_oversized",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "rotting",
		anim = "crop_rot",
		grow_anim = "grow_rot",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
	{
		text = "oversized_rotting",
		anim = "crop_rot_oversized",
		grow_anim = "grow_rot_oversized",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
}
PLANT_DEFS.sweet_potato.plantregistrywidget = "widgets/redux/farmplantpage"
PLANT_DEFS.sweet_potato.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.sweet_potato.pictureframeanim = { anim = "emoteXL_happycheer", time = 0.5 }

PLANT_DEFS.aloe.plantregistryinfo = {
	{
		text = "seed",
		anim = "crop_seed",
		grow_anim = "grow_seed",
		learnseed = true,
		growing = true,
	},
	{
		text = "sprout",
		anim = "crop_sprout",
		grow_anim = "grow_sprout",
		growing = true,
	},
	{
		text = "small",
		anim = "crop_small",
		grow_anim = "grow_small",
		growing = true,
	},
	{
		text = "medium",
		anim = "crop_med",
		grow_anim = "grow_med",
		growing = true,
	},
	{
		text = "grown",
		anim = "crop_full",
		grow_anim = "grow_full",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "oversized",
		anim = "crop_oversized",
		grow_anim = "grow_oversized",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "rotting",
		anim = "crop_rot",
		grow_anim = "grow_rot",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
	{
		text = "oversized_rotting",
		anim = "crop_rot_oversized",
		grow_anim = "grow_rot_oversized",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
}
PLANT_DEFS.aloe.plantregistrywidget = "widgets/redux/farmplantpage"
PLANT_DEFS.aloe.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.aloe.pictureframeanim = { anim = "emoteXL_happycheer", time = 0.5 }

PLANT_DEFS.radish.plantregistryinfo = {
	{
		text = "seed",
		anim = "crop_seed",
		grow_anim = "grow_seed",
		learnseed = true,
		growing = true,
	},
	{
		text = "sprout",
		anim = "crop_sprout",
		grow_anim = "grow_sprout",
		growing = true,
	},
	{
		text = "small",
		anim = "crop_small",
		grow_anim = "grow_small",
		growing = true,
	},
	{
		text = "medium",
		anim = "crop_med",
		grow_anim = "grow_med",
		growing = true,
	},
	{
		text = "grown",
		anim = "crop_full",
		grow_anim = "grow_full",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "oversized",
		anim = "crop_oversized",
		grow_anim = "grow_oversized",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "rotting",
		anim = "crop_rot",
		grow_anim = "grow_rot",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
	{
		text = "oversized_rotting",
		anim = "crop_rot_oversized",
		grow_anim = "grow_rot_oversized",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
}
PLANT_DEFS.radish.plantregistrywidget = "widgets/redux/farmplantpage"
PLANT_DEFS.radish.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.radish.pictureframeanim = { anim = "emoteXL_happycheer", time = 0.5 }

PLANT_DEFS.turnip.plantregistryinfo = {
	{
		text = "seed",
		anim = "crop_seed",
		grow_anim = "grow_seed",
		learnseed = true,
		growing = true,
	},
	{
		text = "sprout",
		anim = "crop_sprout",
		grow_anim = "grow_sprout",
		growing = true,
	},
	{
		text = "small",
		anim = "crop_small",
		grow_anim = "grow_small",
		growing = true,
	},
	{
		text = "medium",
		anim = "crop_med",
		grow_anim = "grow_med",
		growing = true,
	},
	{
		text = "grown",
		anim = "crop_full",
		grow_anim = "grow_full",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "oversized",
		anim = "crop_oversized",
		grow_anim = "grow_oversized",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "rotting",
		anim = "crop_rot",
		grow_anim = "grow_rot",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
	{
		text = "oversized_rotting",
		anim = "crop_rot_oversized",
		grow_anim = "grow_rot_oversized",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
}
PLANT_DEFS.turnip.plantregistrywidget = "widgets/redux/farmplantpage"
PLANT_DEFS.turnip.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.turnip.pictureframeanim = { anim = "emoteXL_happycheer", time = 0.5 }

PLANT_DEFS.wheat.plantregistryinfo = {
	{
		text = "seed",
		anim = "crop_seed",
		grow_anim = "grow_seed",
		learnseed = true,
		growing = true,
	},
	{
		text = "sprout",
		anim = "crop_sprout",
		grow_anim = "grow_sprout",
		growing = true,
	},
	{
		text = "small",
		anim = "crop_small",
		grow_anim = "grow_small",
		growing = true,
	},
	{
		text = "medium",
		anim = "crop_med",
		grow_anim = "grow_med",
		growing = true,
	},
	{
		text = "grown",
		anim = "crop_full",
		grow_anim = "grow_full",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "oversized",
		anim = "crop_oversized",
		grow_anim = "grow_oversized",
		revealplantname = true,
		fullgrown = true,
	},
	{
		text = "rotting",
		anim = "crop_rot",
		grow_anim = "grow_rot",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
	{
		text = "oversized_rotting",
		anim = "crop_rot_oversized",
		grow_anim = "grow_rot_oversized",
		stagepriority = -100,
		is_rotten = true,
		hidden = true,
	},
}
PLANT_DEFS.wheat.plantregistrywidget = "widgets/redux/farmplantpage"
PLANT_DEFS.wheat.plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.wheat.pictureframeanim = { anim = "emoteXL_happycheer", time = 0.5 }
-----------------------------------------------------------------------------------
-- Adds the ability to remove health triggers for the healthtrigger component
AddComponentPostInit("healthtrigger", function(self)
	self.AddTrigger = function(self, amount, fn, override)
		if self.triggers[amount] and not override then
			local _oldTriggerFN = self.triggers[amount]
			self.triggers[amount] = function(inst)
				_oldTriggerFN(inst)
				fn(inst)
			end
		else
			self.triggers[amount] = fn
		end
	end
	self.RemoveTrigger = function(self, amount)
		self.triggers[amount] = nil
	end
end)

modimport("scripts/complementos.lua")

if GetModConfigData("windyplains") then
	modimport("scripts/windy.lua")
end

if GetModConfigData("underwater") then
	modimport("scripts/creeps.lua")
end

if GetModConfigData("greenworld") then
	modimport("scripts/greenworld.lua")
end

------------inicio builder----------------
function RoundBiasedUp(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

AddComponentPostInit("builder", function(self)
	function self:GetMoney(inventory)
		local money = 0

		local hasoincs, oincamount = inventory:Has("oinc", 0)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0)

		money = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
		return money
	end

	function self:PayMoney(inventory, cost)
		local hasoincs, oincamount = inventory:Has("oinc", 0, true)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0, true)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0, true)
		local debt = cost

		local oincused = 0
		local oinc10used = 0
		local oinc100used = 0
		local oincgained = 0
		local oinc10gained = 0
		while debt > 0 do
			while debt > 0 and oincamount > 0 do
				oincamount = oincamount - 1
				debt = debt - 1
				oincused = oincused + 1
			end
			if debt > 0 then
				if oinc10amount > 0 then
					oinc10amount = oinc10amount - 1
					oinc10used = oinc10used + 1
					for i = 1, 10 do
						oincamount = oincamount + 1
						oincgained = oincgained + 1
					end
				elseif oinc100amount > 0 then
					oinc100amount = oinc100amount - 1
					oinc100used = oinc100used + 1
					for i = 1, 10 do
						oinc10amount = oinc10amount + 1
						oinc10gained = oinc10gained + 1
					end
				end
			end
		end
		local oincresult = oincgained - oincused
		if oincresult > 0 then
			for i = 1, oincresult do
				local coin = SpawnPrefab("oinc")
				inventory:GiveItem(coin)
			end
		end
		if oincresult < 0 then
			for i = 1, math.abs(oincresult) do
				--				inventory:ConsumeByName("oinc", 1 )	
				local item = next(inventory:GetItemByName("oinc", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
		local oinc10result = oinc10gained - oinc10used
		if oinc10result > 0 then
			for i = 1, oinc10result do
				local coin = SpawnPrefab("oinc10")
				inventory:GiveItem(coin)
			end
		end
		if oinc10result < 0 then
			for i = 1, math.abs(oinc10result) do
				--				inventory:ConsumeByName("oinc10", 1 )
				local item = next(inventory:GetItemByName("oinc10", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
		local oinc100result = 0 - oinc100used
		if oinc100result < 0 then
			for i = 1, math.abs(oinc100result) do
				--				inventory:ConsumeByName("oinc100", 1)
				local item = next(inventory:GetItemByName("oinc100", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
	end

	function self:RemoveIngredients(ingredients, recname)
		local recipe = GetValidRecipe(recname)
		if recipe == nil then return false end

		for i, v in ipairs(recipe.ingredients) do
			if v.type == "oinc" and not self.freebuildmode then
				self:PayMoney(self.inst.components.inventory, v.amount)
			end
		end

		for item, ents in pairs(ingredients) do
			for k, v in pairs(ents) do
				for i = 1, v do
					if item ~= "oinc" then
						local item = self.inst.components.inventory:RemoveItem(k, false)

						-- If the item we're crafting with is a container,
						-- drop the contained items onto the ground.
						if item.components.container ~= nil then
							item.components.container:DropEverything(self.inst:GetPosition())
						end

						item:Remove()
					end
				end
			end
		end

		local recipe = AllRecipes[recname]
		if recipe then
			for k, v in pairs(recipe.character_ingredients) do
				if v.type == GLOBAL.CHARACTER_INGREDIENT.HEALTH then
					--Don't die from crafting!
					local delta = math.min(math.max(0, self.inst.components.health.currenthealth - 1), v.amount)
					self.inst:PushEvent("consumehealthcost")
					self.inst.components.health:DoDelta(-delta, false, "builder", true, nil, true)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_HEALTH then
					self.inst:PushEvent("consumehealthcost")
					self.inst.components.health:DeltaPenalty(v.amount)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.SANITY then
					self.inst.components.sanity:DoDelta(-v.amount)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY then
					--[[
                    Because we don't have any maxsanity restoring items we want to be more careful
                    with how we remove max sanity. Because of that, this is not handled here.
                    Removal of sanity is actually managed by the entity that is created.
                    See maxwell's pet leash on spawn and pet on death functions for examples.
                --]]
				end
			end
		end
		self.inst:PushEvent("consumeingredients")
	end

	local function GiveOrDropItem(self, recipe, item, pt)
		if recipe.dropitem then
			local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
			local r = item:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
			item.Transform:SetPosition(pt.x + r * math.cos(angle), pt.y, pt.z - r * math.sin(angle))
			item.components.inventoryitem:OnDropped()
		else
			self.inst.components.inventory:GiveItem(item, nil, pt)
		end
	end


	function self:DoBuild(recname, pt, rotation, skin)
		local recipe = GetValidRecipe(recname)
		if recipe ~= nil and (self:IsBuildBuffered(recname) or self:HasIngredients(recipe)) then
			if recipe.placer ~= nil and
				self.inst.components.rider ~= nil and
				self.inst.components.rider:IsRiding() then
				return false, "MOUNTED"
			elseif recipe.level.ORPHANAGE > 0 and (
					self.inst.components.petleash == nil or
					self.inst.components.petleash:IsFull() or
					self.inst.components.petleash:HasPetWithTag("critter")
				) then
				return false, "HASPET"
			elseif recipe.manufactured and (
					self.current_prototyper == nil or
					not self.current_prototyper:IsValid() or
					self.current_prototyper.components.prototyper == nil or
					not CanPrototypeRecipe(recipe.level, self.current_prototyper.components.prototyper.trees)
				) then
				-- manufacturing stations requires the current active protyper in order to work
				return false
			end

			if recipe.canbuild ~= nil then
				local success, msg = recipe.canbuild(recipe, self.inst, pt, rotation)
				if not success then
					return false, msg
				end
			end

			local is_buffered_build = self.buffered_builds[recname] ~= nil
			if is_buffered_build then
				self.buffered_builds[recname] = nil
				self.inst.replica.builder:SetIsBuildBuffered(recname, false)
			end

			if self.inst:HasTag("hungrybuilder") and not self.inst.sg:HasStateTag("slowaction") then
				local t = GetTime()
				if self.last_hungry_build == nil or t > self.last_hungry_build + TUNING.HUNGRY_BUILDER_RESET_TIME then
					self.inst.components.hunger:DoDelta(TUNING.HUNGRY_BUILDER_DELTA)
					self.inst:PushEvent("hungrybuild")
				end
				self.last_hungry_build = t
			end

			self.inst:PushEvent("refreshcrafting")

			if recipe.manufactured then
				local materials = self:GetIngredients(recname)
				self:RemoveIngredients(materials, recname)
				-- its up to the prototyper to implement onactivate and handle spawning the prefab
				return true
			end

			if self.inst and self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("brainjelly") then
				if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses then
					self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses:Use(1)
				end
			end

			local prod = SpawnPrefab(recipe.product, recipe.chooseskin or skin, nil, self.inst.userid) or nil
			if prod ~= nil then
				pt = pt or self.inst:GetPosition()

				if prod.components.inventoryitem ~= nil then
					if self.inst.components.inventory ~= nil then
						local materials = self:GetIngredients(recname)

						local wetlevel = self:GetIngredientWetness(materials)
						if wetlevel > 0 and prod.components.inventoryitem ~= nil then
							prod.components.inventoryitem:InheritMoisture(wetlevel, self.inst:GetIsWet())
						end

						if prod.onPreBuilt ~= nil then
							prod:onPreBuilt(self.inst, materials, recipe)
						end

						self:RemoveIngredients(materials, recname)

						--self.inst.components.inventory:GiveItem(prod)
						self.inst:PushEvent("builditem",
							{ item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper })
						if self.current_prototyper ~= nil and self.current_prototyper:IsValid() then
							self.current_prototyper:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin }) -- added this back for the gorge.
						end
						ProfileStatsAdd("build_" .. prod.prefab)

						if prod.components.equippable ~= nil
							and not recipe.dropitem
							and self.inst.components.inventory:GetEquippedItem(prod.components.equippable.equipslot) == nil
							and not prod.components.equippable:IsRestricted(self.inst) then
							if recipe.numtogive <= 1 then
								--The item is equippable. Equip it.
								self.inst.components.inventory:Equip(prod)
							elseif prod.components.stackable ~= nil then
								--The item is stackable. Just increase the stack size of the original item.
								prod.components.stackable:SetStackSize(recipe.numtogive)
								self.inst.components.inventory:Equip(prod)
							else
								--We still need to equip the original product that was spawned, so do that.
								self.inst.components.inventory:Equip(prod)
								--Now spawn in the rest of the items and give them to the player.
								for i = 2, recipe.numtogive do
									local addt_prod = SpawnPrefab(recipe.product)
									self.inst.components.inventory:GiveItem(addt_prod, nil, pt)
								end
							end
						elseif recipe.numtogive <= 1 then
							--Only the original item is being received.
							GiveOrDropItem(self, recipe, prod, pt)
						elseif prod.components.stackable ~= nil then
							--The item is stackable. Just increase the stack size of the original item.
							prod.components.stackable:SetStackSize(recipe.numtogive)
							GiveOrDropItem(self, recipe, prod, pt)
						else
							--We still need to give the player the original product that was spawned, so do that.
							GiveOrDropItem(self, recipe, prod, pt)
							--Now spawn in the rest of the items and give them to the player.
							for i = 2, recipe.numtogive do
								local addt_prod = SpawnPrefab(recipe.product)
								GiveOrDropItem(self, recipe, addt_prod, pt)
							end
						end

						NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

						if self.onBuild ~= nil then
							self.onBuild(self.inst, prod)
						end
						prod:OnBuilt(self.inst)

						return true
					else
						prod:Remove()
						prod = nil
					end
				else
					if not is_buffered_build then -- items that have intermediate build items (like statues)
						local materials = self:GetIngredients(recname)
						self:RemoveIngredients(materials, recname)
					end

					local spawn_pos = pt

					-- If a non-inventoryitem recipe specifies dropitem, position the created object
					-- away from the builder so that they don't overlap.
					if recipe.dropitem then
						local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
						local r = prod:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
						spawn_pos = Vector3(
							spawn_pos.x + r * math.cos(angle),
							spawn_pos.y,
							spawn_pos.z - r * math.sin(angle)
						)
					end

					prod.Transform:SetPosition(spawn_pos:Get())
					--V2C: or 0 check added for backward compatibility with mods that
					--     have not been updated to support placement rotation yet
					prod.Transform:SetRotation(rotation or 0)
					self.inst:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
					prod:PushEvent("onbuilt", { builder = self.inst, pos = pt })
					ProfileStatsAdd("build_" .. prod.prefab)
					NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

					if self.onBuild ~= nil then
						self.onBuild(self.inst, prod)
					end

					prod:OnBuilt(self.inst)

					return true
				end
			end
		end
	end

	function self:KnowsRecipe(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if recipe == nil then
			return false
		end
		if self.freebuildmode or self.inst:HasTag("brainjelly") then
			return true
		elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag cehck is require due to character swapping
			return false
		elseif self.station_recipes[recipe.name] or table.contains(self.recipes, recipe.name) then
			return true
		end

		local has_tech = true
		for i, v in ipairs(TechTree.AVAILABLE_TECH) do
			if recipe.level[v] > (self[string.lower(v) .. "_bonus"] or 0) then
				return false
			end
		end
		return true
	end

	function self:HasIngredients(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end
		if recipe ~= nil then
			if self.freebuildmode then
				return true
			end
			for i, v in ipairs(recipe.ingredients) do
				if v.type == "oinc" then
					if self:GetMoney(self.inst.components.inventory) >= v.amount then
						return true
					end
				end

				if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self.ingredientmod)), true) then
					return false
				end
			end
			for i, v in ipairs(recipe.character_ingredients) do
				if not self:HasCharacterIngredient(v) then
					return false
				end
			end
			for i, v in ipairs(recipe.tech_ingredients) do
				if not self:HasTechIngredient(v) then
					return false
				end
			end
			return true
		end

		return false
	end

	function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
		----------------------------------------------------------
		if recipe.product == "sprinkler1" and (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then
			return
				self:MakeRecipe(recipe, pt, rot, skin)
		end
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if recipe.placer ~= nil and
			--        self:KnowsRecipe(recipe.name) and
			self:IsBuildBuffered(recipe.name) and
			GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
			self:MakeRecipe(recipe, pt, rot, skin)
		end
	end
end)


AddClassPostConstruct("components/builder_replica", function(self)
	function self:KnowsRecipe(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:KnowsRecipe(recipe)
		elseif self.classified ~= nil then
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value() or self.inst:HasTag("brainjelly") then
					return true
				elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag check is require due to character swapping
					return false
				elseif self.classified.recipes[recipe.name] ~= nil and self.classified.recipes[recipe.name]:value() then
					return true
				end

				local has_tech = true
				for i, v in ipairs(TechTree.AVAILABLE_TECH) do
					local bonus = self.classified[string.lower(v) .. "bonus"]
					if recipe.level[v] > (bonus ~= nil and bonus:value() or 0) then
						return false
					end
				end

				return true
			end
		end
		return false
	end

	function self:GetMoney(inventory)
		local money = 0

		local hasoincs, oincamount = inventory:Has("oinc", 0)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0)

		money = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
		return money
	end

	function self:HasIngredients(recipe)
		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:HasIngredients(recipe)
		elseif self.classified ~= nil then
			if type(recipe) == "string" then
				recipe = GetValidRecipe(recipe)
			end
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value() then
					return true
				end
				for i, v in ipairs(recipe.ingredients) do
					if v.type == "oinc" then
						if self:GetMoney(self.inst.replica.inventory) >= v.amount then
							return true
						end
					end
					if not self.inst.replica.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self:IngredientMod())), true) then
						return false
					end
				end
				for i, v in ipairs(recipe.character_ingredients) do
					if not self:HasCharacterIngredient(v) then
						return false
					end
				end
				for i, v in ipairs(recipe.tech_ingredients) do
					if not self:HasTechIngredient(v) then
						return false
					end
				end
				return true
			end
		end

		return false
	end

	function self:CanBuildAtPoint(pt, recipe, rot)
		if recipe.product == "sprinkler1" and (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then return true end

		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		return GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot)
	end
end)

AddComponentPostInit("inventoryitem", function(self)
	self.inst:AddTag("isinventoryitem")

	self.inst:ListenForEvent("onremove", function()
		if self.inst.onshelf then
			local shelf = self.inst.onshelf
			local item = shelf.components.shelfer:GetGift()
			-- doing this check to save players from a bug that was fixed, but some items may still suffer from it
			if item and item.GUID == self.inst.GUID then
				shelf.components.shelfer:GiveGift()
			end
		end
	end)

	function self:OnPickup(pickupguy, src_pos)
		-- not only the player can have inventory!

		self:SetLanded(false, false)

		if self.isnew and self.inst.prefab and pickupguy:HasTag("player") then
			ProfileStatsAdd("collect_" .. self.inst.prefab)
			self.isnew = false
		end

		if self.inst.components.burnable and self.inst.components.burnable:IsSmoldering() then
			self.inst.components.burnable:StopSmoldering()
			if pickupguy.components.health ~= nil then
				pickupguy.components.health:DoFireDamage(TUNING.SMOTHER_DAMAGE, nil, true)
				pickupguy:PushEvent("burnt")
			end
		end

		if self.inst.bookshelf then
			self:TakeOffShelf()
		end

		self.inst:PushEvent("onpickup", { owner = pickupguy })
		return self.onpickupfn and self.onpickupfn(self.inst, pickupguy, src_pos)
	end

	function self:TakeOffShelf()
		local shelf_slot = SpawnPrefab("shelf_slot")
		shelf_slot.components.inventoryitem:PutOnShelf(self.inst.bookshelf, self.inst.bookshelfslot)
		shelf_slot.components.shelfer:SetShelf(self.inst.bookshelf, self.inst.bookshelfslot)

		self.inst:RemoveTag("bookshelfed")
		self.inst.bookshelfslot = nil
		self.inst.bookshelf = nil
		self.inst.follower:FollowSymbol(0, "dumb", 0, 0, 0)
		if self.inst.Physics then
			self.inst.Physics:SetActive(true)
		end
	end

	function self:PutOnShelf(shelf, slot)
		self.inst:AddTag("bookshelfed")
		self.inst.bookshelfslot = slot
		self.inst.bookshelf = shelf
		if self.inst.Physics then
			self.inst.Physics:SetActive(false)
		end
		local follower = self.inst.entity:AddFollower()
		follower:FollowSymbol(shelf.GUID, slot, 10, 0, 0.6)
		self.inst.follower = follower
	end

	function self:OnSave()
		local data = {}
		local refs = {}

		if self.inst:HasTag("bookshelfed") and self.inst.bookshelf then
			data.bookshelfGUID = self.inst.bookshelf.GUID
			data.bookshelfslot = self.inst.bookshelfslot
			table.insert(refs, self.inst.bookshelf.GUID)
		end

		if self.canbepickedup then
			data.canbepickedup = self.canbepickedup
		end

		if self.inst.onshelf then
			data.onshelf = self.inst.onshelf.GUID
			table.insert(refs, self.inst.onshelf.GUID)
		end

		return data, refs
	end

	function self:OnLoad(data)
		if data.canbepickedup then
			self.canbepickedup = data.canbepickedup
		end
	end

	function self:LoadPostPass(newents, data)
		if data and data.bookshelfGUID then
			if newents[data.bookshelfGUID] then
				local bookshelf = newents[data.bookshelfGUID].entity
				self:PutOnShelf(bookshelf, data.bookshelfslot)
			end
		end
		if data and data.onshelf then
			if newents[data.onshelf] and newents[data.onshelf].entity:IsValid() then
				self.inst.onshelf = newents[data.onshelf].entity
				-- fixup for items that misremembered they were on a shelf.
				self.inst:DoTaskInTime(1, function()
					if self.inst.onshelf then
						local shelfitem = self.inst.onshelf and self.inst.onshelf.components and
							self.inst.onshelf.components.shelfer and self.inst.onshelf.components.shelfer:GetGift()
						if self.inst ~= shelfitem then
							-- we thought we were on a shelf. Alas, we were not
							self.inst.onshelf = nil
						end
					end
				end)
			end
		end
	end
end)

----- desembarque automatico resto do código dentro de locomotor ----------------
AddClassPostConstruct("components/playercontroller", function(self)
	local RUBBER_BAND_PING_TOLERANCE_IN_SECONDS = 0.7
	local RUBBER_BAND_DISTANCE = 4

	function self:OnRemoteStartHop(x, z, platform)
		if not self.ismastersim then return end
		if not self:IsEnabled() then return end
		if not self.handler == nil then return end

		local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
		local target_x, target_y, target_z = x, 0, z
		local platform_for_velocity_calculation = platform

		if platform ~= nil then
			target_x, target_z = platform.components.walkableplatform:GetEmbarkPosition(my_x, my_z)
		else
			platform_for_velocity_calculation = self.inst:GetCurrentPlatform()
			--		if TUNING.tropical.disembarkation then platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or GetClosestInstWithTag("barcoapto", self.inst, 0.5) end
			platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or
				GetClosestInstWithTag("barcoapto", self.inst, 0.5)
		end

		if platform == nil and (platform_for_velocity_calculation == nil or GLOBAL.TheWorld.Map:IsOceanAtPoint(target_x, 0, target_z)) then
			return
		end

		local hop_dir_x, hop_dir_z = target_x - my_x, target_z - my_z
		local hop_distance_sq = hop_dir_x * hop_dir_x + hop_dir_z * hop_dir_z

		local target_velocity_rubber_band_distance = 0
		local platform_velocity_x, platform_velocity_z = 0, 0
		if platform_for_velocity_calculation ~= nil then
			local platform_physics = platform_for_velocity_calculation.Physics
			if platform_physics ~= nil then
				platform_velocity_x, platform_velocity_z = platform_physics:GetVelocity()
				if platform_velocity_x ~= 0 or platform_velocity_z ~= 0 then
					local hop_distance = math.sqrt(hop_distance_sq)
					local normalized_hop_dir_x, normalized_hop_dir_z = hop_dir_x / hop_distance, hop_dir_z / hop_distance
					local velocity = math.sqrt(platform_velocity_x * platform_velocity_x +
						platform_velocity_z * platform_velocity_z)
					local normalized_platform_velocity_x, normalized_platform_velocity_z = platform_velocity_x / velocity,
						platform_velocity_z / velocity
					local hop_dir_dot_platform_velocity = normalized_platform_velocity_x * normalized_hop_dir_x +
						normalized_platform_velocity_z * normalized_hop_dir_z
					if hop_dir_dot_platform_velocity > 0 then
						target_velocity_rubber_band_distance = RUBBER_BAND_PING_TOLERANCE_IN_SECONDS * velocity *
							hop_dir_dot_platform_velocity
					end
				end
			end
		end

		local locomotor = self.inst.components.locomotor
		local hop_rubber_band_distance = RUBBER_BAND_DISTANCE + target_velocity_rubber_band_distance +
			locomotor:GetHopDistance()
		local hop_rubber_band_distance_sq = hop_rubber_band_distance * hop_rubber_band_distance

		if hop_distance_sq > hop_rubber_band_distance_sq then
			print("Hop discarded:", "\ntarget_velocity_rubber_band_distance", target_velocity_rubber_band_distance,
				"\nplatform_velocity_x", platform_velocity_x, "\nplatform_velocity_z", platform_velocity_z,
				"\nhop_distance", math.sqrt(hop_distance_sq), "\nhop_rubber_band_distance",
				math.sqrt(hop_rubber_band_distance_sq))
			return
		end

		self.remote_vector.y = 6
		self.inst.components.locomotor:StartHopping(x, z, platform)
	end
end)

----- sai pulando automaticamente do barco cliente outra parte dentro de locomotor ----------------
AddClassPostConstruct("components/embarker", function(self)
	function self:GetEmbarkPosition()
		if self.embarkable ~= nil and self.embarkable:IsValid() then
			local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
			if self.embarkable.components.walkableplatform then
				return self.embarkable.components.walkableplatform:GetEmbarkPosition(my_x, my_z, self.embarker_min_dist)
			end
			local embarker_x, embarker_y, embarker_z = self.inst.Transform:GetWorldPosition()
			local embarkable_radius = 0.1
			local alvo = GetClosestInstWithTag("barcoapto", self.inst, 6) or self.inst.Transform:GetWorldPosition()
			local embarkable_x, embarkable_y, embarkable_z = alvo.Transform:GetWorldPosition()
			local embark_x, embark_z = GLOBAL.VecUtil_Normalize(embarker_x - embarkable_x, embarker_z - embarkable_z)
			return embarkable_x + embark_x * embarkable_radius, embarkable_z + embark_z * embarkable_radius
		else
			local x, z = (self.disembark_x or self.last_embark_x), (self.disembark_z or self.last_embark_z)
			if x == nil or z == nil then
				local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
				x, z = my_x, my_z
			end
			return x, z
		end
	end
end)

--[[
AddPrefabPostInitAny(function(inst)

if inst:HasTag("player") then

local function OnObjGotOnPlatform(inst)

if inst.components.walkableplatformplayer and inst.components.walkableplatformplayer.platform and inst.components.walkableplatformplayer.platform.prefab == "rowboat" then

inst:AddComponent("driver")
inst.components.driver.mountdata = inst.components.walkableplatformplayer.platform
inst.components.driver:OnMount(inst.components.driver.mountdata)
inst.components.talker:Say(inst.components.walkableplatformplayer.platform.prefab)
end
end

local function OnObjGotOffPlatform(inst)
inst.components.talker:Say("sai")
end


if inst.ismastersim then


end



inst:ListenForEvent("got_on_platform", OnObjGotOnPlatform)
inst:ListenForEvent("got_off_platform", OnObjGotOffPlatform)

end
end)
]]

local wx78_moduledefs = require("wx78_moduledefs")
local module_definitions = wx78_moduledefs.module_definitions
local AddCreatureScanDataDefinition = wx78_moduledefs.AddCreatureScanDataDefinition
AddCreatureScanDataDefinition("crab", "movespeed", 2)
AddCreatureScanDataDefinition("piko", "movespeed", 2)

AddCreatureScanDataDefinition("twister", "movespeed2", 6)
AddCreatureScanDataDefinition("rookwater", "movespeed2", 3)
AddCreatureScanDataDefinition("pangolden", "movespeed2", 1)
AddCreatureScanDataDefinition("wildbore", "movespeed2", 1)

AddCreatureScanDataDefinition("butterfly_tropical", "maxsanity1", 1)
--AddCreatureScanDataDefinition("glowfly", "maxsanity1", 1)

AddCreatureScanDataDefinition("ancient_herald", "maxsanity", 6)

AddCreatureScanDataDefinition("crocodog", "maxhunger1", 2)
AddCreatureScanDataDefinition("pog", "maxhunger1", 2)

AddCreatureScanDataDefinition("tigershark", "maxhunger", 6)
AddCreatureScanDataDefinition("spider_monkey", "maxhunger", 3)

AddCreatureScanDataDefinition("glowfly", "light", 1)
AddCreatureScanDataDefinition("bioluminescenc", "light", 1)

AddCreatureScanDataDefinition("dragoon", "heat", 2)
AddCreatureScanDataDefinition("scorpion", "heat", 1)

AddCreatureScanDataDefinition("watercrocodog", "cold", 4)
AddCreatureScanDataDefinition("hippopotamoose", "cold", 4)

AddCreatureScanDataDefinition("bioluminescence", "nightvision", 1)
AddCreatureScanDataDefinition("vampirebat", "nightvision", 2)

AddCreatureScanDataDefinition("antqueen", "bee", 10)

AddCreatureScanDataDefinition("mandrakeman", "music", 2)
AddCreatureScanDataDefinition("whale_blue", "music", 4)
AddCreatureScanDataDefinition("whale_blue", "whale_white", 8)

AddCreatureScanDataDefinition("jellyfish_planted", "taser", 1)
AddCreatureScanDataDefinition("thunderbird", "taser", 2)

---------------------
--[[
if GetModConfigData("kindofworld") == 5 then
function HamletcloudPostInit()
if not TheNet:IsDedicated() and GLOBAL.TheWorld and GLOBAL.TheWorld.WaveComponent then
GLOBAL.TheWorld.Map:SetUndergroundFadeHeight(0)
GLOBAL.TheWorld.Map:SetTransparentOcean(false)
GLOBAL.TheWorld.Map:AlwaysDrawWaves(true)
GLOBAL.TheWorld.WaveComponent:SetWaveTexture(GLOBAL.resolvefilepath("images/fog_cloud.tex"))	
local scale = 1
local map_width, map_height = GLOBAL.TheWorld.Map:GetSize()
GLOBAL.TheWorld.WaveComponent:SetWaveParams(13.5, 2.5, -1)
GLOBAL.TheWorld.WaveComponent:Init(map_width, map_height)
GLOBAL.TheWorld.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
GLOBAL.TheWorld.WaveComponent:SetWaveMotion(3, 0.5, 0.25)

if GLOBAL.TheWorld.ismastersim then
GLOBAL.TheWorld:AddComponent("cloudpuffmanager")
end

end
end

AddSimPostInit(HamletcloudPostInit)

end
]]


if GetModConfigData("kindofworld") == 5 then
	function HamletcloudPostInit()
		local World = GLOBAL.TheWorld
		if not TheNet:IsDedicated() and World and World.WaveComponent then
			World.Map:SetUndergroundFadeHeight(0)
			World.Map:AlwaysDrawWaves(true)
			World.WaveComponent:SetWaveTexture(GLOBAL.resolvefilepath("images/fog_cloud.tex"))
			local scale = 1
			local map_width, map_height = World.Map:GetSize()
			World.WaveComponent:SetWaveParams(13.5, 2.5, -1)
			World.WaveComponent:Init(map_width, map_height)
			World.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
			World.WaveComponent:SetWaveMotion(0.3, 0.5, 0.35)

			local map = World.Map
			local tuning = TUNING.OCEAN_SHADER
			map:SetOceanEnabled(true)
			map:SetOceanTextureBlurParameters(tuning.TEXTURE_BLUR_PASS_SIZE, tuning.TEXTURE_BLUR_PASS_COUNT)
			map:SetOceanNoiseParameters0(tuning.NOISE[1].ANGLE, tuning.NOISE[1].SPEED, tuning.NOISE[1].SCALE,
				tuning.NOISE[1].FREQUENCY)
			map:SetOceanNoiseParameters1(tuning.NOISE[2].ANGLE, tuning.NOISE[2].SPEED, tuning.NOISE[2].SCALE,
				tuning.NOISE[2].FREQUENCY)
			map:SetOceanNoiseParameters2(tuning.NOISE[3].ANGLE, tuning.NOISE[3].SPEED, tuning.NOISE[3].SCALE,
				tuning.NOISE[3].FREQUENCY)

			local waterfall_tuning = TUNING.WATERFALL_SHADER.NOISE
			map:SetWaterfallFadeParameters(TUNING.WATERFALL_SHADER.FADE_COLOR[1] / 255,
				TUNING.WATERFALL_SHADER.FADE_COLOR[2] / 255, TUNING.WATERFALL_SHADER.FADE_COLOR[3] / 255,
				TUNING.WATERFALL_SHADER.FADE_START)
			map:SetWaterfallNoiseParameters0(waterfall_tuning[1].SCALE, waterfall_tuning[1].SPEED,
				waterfall_tuning[1].OPACITY, waterfall_tuning[1].FADE_START)
			map:SetWaterfallNoiseParameters1(waterfall_tuning[2].SCALE, waterfall_tuning[2].SPEED,
				waterfall_tuning[2].OPACITY, waterfall_tuning[2].FADE_START)

			local minimap_ocean_tuning = TUNING.OCEAN_MINIMAP_SHADER
			map:SetMinimapOceanEdgeColor0(minimap_ocean_tuning.EDGE_COLOR0[1] / 255,
				minimap_ocean_tuning.EDGE_COLOR0[2] / 255, minimap_ocean_tuning.EDGE_COLOR0[3] / 255)
			map:SetMinimapOceanEdgeParams0(minimap_ocean_tuning.EDGE_PARAMS0.THRESHOLD,
				minimap_ocean_tuning.EDGE_PARAMS0.HALF_THRESHOLD_RANGE)

			map:SetMinimapOceanEdgeColor1(minimap_ocean_tuning.EDGE_COLOR1[1] / 255,
				minimap_ocean_tuning.EDGE_COLOR1[2] / 255, minimap_ocean_tuning.EDGE_COLOR1[3] / 255)
			map:SetMinimapOceanEdgeParams1(minimap_ocean_tuning.EDGE_PARAMS1.THRESHOLD,
				minimap_ocean_tuning.EDGE_PARAMS1.HALF_THRESHOLD_RANGE)

			map:SetMinimapOceanEdgeShadowColor(minimap_ocean_tuning.EDGE_SHADOW_COLOR[1] / 255,
				minimap_ocean_tuning.EDGE_SHADOW_COLOR[2] / 255, minimap_ocean_tuning.EDGE_SHADOW_COLOR[3] / 255)
			map:SetMinimapOceanEdgeShadowParams(minimap_ocean_tuning.EDGE_SHADOW_PARAMS.THRESHOLD,
				minimap_ocean_tuning.EDGE_SHADOW_PARAMS.HALF_THRESHOLD_RANGE,
				minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_X, minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_Y)

			map:SetMinimapOceanEdgeFadeParams(minimap_ocean_tuning.EDGE_FADE_PARAMS.THRESHOLD,
				minimap_ocean_tuning.EDGE_FADE_PARAMS.HALF_THRESHOLD_RANGE,
				minimap_ocean_tuning.EDGE_FADE_PARAMS.MASK_INSET)

			map:SetMinimapOceanEdgeNoiseParams(minimap_ocean_tuning.EDGE_NOISE_PARAMS.UV_SCALE)

			map:SetMinimapOceanTextureBlurParameters(minimap_ocean_tuning.TEXTURE_BLUR_SIZE,
				minimap_ocean_tuning.TEXTURE_BLUR_PASS_COUNT, minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_SIZE,
				minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_PASS_COUNT)
			map:SetMinimapOceanMaskBlurParameters(minimap_ocean_tuning.MASK_BLUR_SIZE,
				minimap_ocean_tuning.MASK_BLUR_PASS_COUNT)

			if World.ismastersim then World:AddComponent("cloudpuffmanager") end
		end
	end

	AddSimPostInit(HamletcloudPostInit)
end


local function GetBuild(inst)
	local strnn = ""
	local str = inst.entity:GetDebugString()

	if not str then
		return nil
	end
	local bank, build, anim = str:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")

	if bank ~= nil and build ~= nil then
		strnn = strnn .. "动画: anim/" .. bank .. ".zip"
		strnn = strnn .. "\n" .. "贴图: anim/" .. build .. ".zip"
	end
	return strnn
end

AddClassPostConstruct("widgets/hoverer", function(self)
	local old_SetString = self.text.SetString
	self.text.SetString = function(text, str)
		local target = TheInput:GetHUDEntityUnderMouse()
		if target ~= nil then
			target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
		else
			target = TheInput:GetWorldEntityUnderMouse()
		end
		if target and target.entity ~= nil then
			if target.prefab ~= nil then
				str = str .. "\n" .. "代码:" .. target.prefab
			end
			local build = GetBuild(target)
			if build ~= nil then
				str = str .. "\n" .. build
			end
		end
		return old_SetString(text, str)
	end
end)
