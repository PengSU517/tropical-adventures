--[[
-- small fish 30 to 70ish
#	name				weight			COSTAL	SWELL	ROUGH	BRINEPOOL	HAZARDOUS		lures			Catching Behaviours
1	Runty Guppy			48.34, 60.30	++		++											SMALL_OMNI		put up an initial struggle and then very easy, slow, moves towards you when tired, pretty much a free catch
2	Needlenosed Squirt	37.54, 57.62	+++													SMALL_OMNI		fast, darting, lots of short bursts
3	Bitty Baitfish		39.66, 63.58	+		+		+									SMALL_MEAT		long bursts, low stamina drain
4	Smolt Fry			39.70, 56.26	++++												SMALL_OMNI		quick and easy catch
5	Popperfish			33.08, 47.74	+++													SMALL_VEGGIE	quick and easy catch
6   fallounder			28.87, 44.44			++											SMALL_VEGGIE
7   bloomfin tuna       53.64, 63.36    ++													SMALL_VEGGIE
8   scourching sunfish  41.14, 56.78            ++											SMALL_MEAT
9   sprinkler			31.15, 49.20	   													SMALL_VEGGIE	slow, lots of short bursts

--pond fish weight
fish	40.89, 55.28
eel		165.16, 212.12

-- medium fish 150 to 310ish
#	name				weight			COSTAL	SWELL	ROUGH	BRINEPOOL	HAZARDOUS		lures			Catching Behaviours
1	Mudfish				154.32, 214.97	++		+++											OMNI			easy-medium catch
2	Deep Bass			172.41, 228.88  		++		+++									MEAT			not a hard catch, doesn't like to fight, runs towards the fisher trying to unhook itself with line slack, a fun fight while on a boat with one sail active
3	Dandy Lionfish		246.77, 302.32					++					++++			MEAT			hard catch, short tired times and high run speed
4	Black Catfish		193.27, 278.50			++		+++									OMNI			long slow pulls, totally not worth fishing, unless you want some braging rights
5	Corn Cod			161.48, 241.80			+++		++									VEGGIE			medium catch
6	YOT Koi 1			188.88, 238.88	+-		+-		+-									OMNI			easy-medium catch
7	YOT Koi 2			188.88, 238.88	+-		+-		+-									OMNI			easy-medium catch
8   Snowy Whitefish		190.90, 270.70			++											OMNI			long pulls
9   Berryfish		    210.50, 315.14														BERRY			easy-medium catch

]]

--[[ Catching Behaviours
-- default
num		walk	run		stam.drain	stam.recover	stam.struggle_time	stam.tired_time		tired_ang_good	tired_ang_good
n/a		1.2		3		0.05		0.10			3+1		8+1			4+1		2+1			80				120

-- small fish
num		walk	run		stam.drain	stam.recover	stam.struggle_time	stam.tired_time		tired_ang_good	tired_ang_low
1		0.8		2.5		1.0			0.1				2+1		5+1			6+1		4+1			45				80
2		1.5		3.0		0.1			0.5				1+2		3+2			1+2		1+1			80				120
3		1.2		2.5		0.05		0.01			5+1		5+3			2+2		2+1			60				90
4		1.2		2.0		0.5			0.5				1+1		3+1			5+1		3+1			80				120
5		1.0		2.0		0.5			0.5				1+1		3+1			5+1		3+1			80				160
6		1.5		2.0		0.5			0.5				1+1		3+1			5+1		1+1			80				120
7		0.8		2.5		0.2			0.1				2+1		8+1			5+1		1+1			45				120
8		1.5		3.0		0.05		0.5				3+1		3+2			1+2		1+1			80				120
9		1.0		2.0		0.1			0.5				2+1		3+1			1+3		1+1			80				120


-- medium fish
num		walk	run		stam.drain	stam.recover	stam.struggle_time	stam.tired_time		tired_ang_good	tired_ang_low
1		1.2		3.0		0.05		0.10			3+1		6+1			3+1		2+1			80				120
2		2.5		2.5		0.25		0.05			2+0		2+1			4+1		2+1			15				15
3		2.2		3.5		0.1			0.25			4+2		6+2			1+1		1+0			45				90
4		1.4		2.5		0.05		0.10			5+1		12+6		4+1		2+1			60				90
5		1.3		2.8		0.05		0.10			3+1		8+1			4+1		2+1			80				120
6		1.2		3.0		0.05		0.10			2+1		6+1			3+1		2+1			80				120
7		1.2		3.0		0.05		0.10			2+1		6+1			3+1		2+1			80				120
8		1.5		3.0		0.05		0.15			7+1		10+5		3+1		2+1			90				100
9		1.2		3.0		0.05		0.10			3+1		6+1			3+1		2+1			80				120

]]

local SCHOOL_SIZE = {
	TINY = { min = 1, max = 3 },
	SMALL = { min = 2, max = 5 },
	MEDIUM = { min = 4, max = 6 },
	LARGE = { min = 6, max = 10 },
}

local SCHOOL_AREA = {
	TINY = 2,
	SMALL = 3,
	MEDIUM = 6,
	LARGE = 10,
}

local WANDER_DIST = {
	SHORT = { min = 5, max = 15 },
	MEDIUM = { min = 15, max = 30 },
	LONG = { min = 20, max = 40 },
}

local ARRIVE_DIST = {
	CLOSE = 3,
	MEDIUM = 8,
	FAR = 12,
}

local WANDER_DELAY = {
	SHORT = { min = 0, max = 10 },
	MEDIUM = { min = 10, max = 30 },
	LONG = { min = 30, max = 60 },
}

local SEG = 30
local DAY = SEG * 16

local SCHOOL_WORLD_TIME = {
	SHORT = { min = SEG * 8, max = SEG * 16 },
	MEDIUM = { min = DAY, max = DAY * 2 },
	LONG = { min = DAY * 2, max = DAY * 4 },
}

local LOOT = {
	TINY            = { "fishmeat_small" },
	SMALL           = { "fishmeat_small" },
	SMALL_COOKED    = { "fishmeat_small_cooked" },
	MEDIUM          = { "fishmeat" },
	LARGE           = { "fishmeat" },
	HUGE            = { "fishmeat" },
	CORN            = { "corn" },
	POPCORN         = { "corn_cooked" },
	ICE             = { "fishmeat", "ice", "ice" },
	PLANTMEAT       = { "plantmeat" },
	MEDIUM_YOT      = { "fishmeat", "lucky_goldnugget", "lucky_goldnugget" },
	FISH2           = { "fish2" },
	FISH3           = { "fish3" },
	FISH4           = { "fish4" },
	FISH5           = { "fish5" },
	FISH6           = { "fish6" },
	FISH7           = { "fish7" },
	COI             = { "coi" },
	SALMON          = { "salmon" },
	BALLPHIN        = { "ballphinocean" },
	MECFISH         = { "gears" },
	GOLDFISH        = { "goldnugget" },
	SWORDFISHOCEAN  = { "swordfishjocean" },
	SWORDFISHOCEAN2 = { "swordfishjocean2" },
	DOGFISHOCEAN    = { "dogfishocean" },
	WHALEBLUEOCEAN  = { "whaleblueocean" },
	SHARXOCEAN      = { "sharxocean" },
}

local PERISH = {
	TINY = "fishmeat_small",
	SMALL = "fishmeat_small",
	MEDIUM = "fishmeat",
	LARGE = "fishmeat",
	HUGE = "fishmeat",
	CORN = "corn",
	POPCORN = "corn_cooked",
	PLANTMEAT = "spoiled_food",
}

local COOKING_PRODUCT = {
	TINY = "fishmeat_small_cooked",
	SMALL = "fishmeat_small_cooked",
	MEDIUM = "fishmeat_cooked",
	LARGE = "fishmeat_cooked",
	HUGE = "fishmeat_cooked",
	CORN = "corn_cooked",
	PLANTMEAT = "plantmeat_cooked",
}

local function MEDIUM_YOT_ONCOOKED_FN(inst, cooker, chef)
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
		inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
	end
end

local DIET = {
	OMNI = { caneat = { FOODGROUP.OMNI } }, --, preferseating = { FOODGROUP.OMNI } },
	VEGGIE = { caneat = { FOODGROUP.VEGETARIAN } },
	MEAT = { caneat = { FOODTYPE.MEAT } },
	BERRY = { caneat = { FOODTYPE.BERRY } },
}

-- crokpot values
COOKER_INGREDIENT_SMALL = { meat = .5, fish = .5 }
COOKER_INGREDIENT_MEDIUM = { meat = 1, fish = 1 }
COOKER_INGREDIENT_MEDIUM_ICE = { meat = 1, fish = 1, frozen = 1 }

EDIBLE_VALUES_SMALL_MEAT = {
	health = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = 0,
	foodtype =
		FOODTYPE.MEAT
}
EDIBLE_VALUES_MEDIUM_MEAT = {
	health = TUNING.HEALING_MEDSMALL,
	hunger = TUNING.CALORIES_MED,
	sanity = 0,
	foodtype =
		FOODTYPE.MEAT
}
EDIBLE_VALUES_SMALL_VEGGIE = {
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SMALL,
	sanity = 0,
	foodtype =
		FOODTYPE.VEGGIE
}
EDIBLE_VALUES_MEDIUM_VEGGIE = {
	health = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_MED,
	sanity = 0,
	foodtype =
		FOODTYPE.VEGGIE
}
EDIBLE_VALUES_PLANTMEAT = {
	health = 0,
	hunger = TUNING.CALORIES_SMALL,
	sanity = -TUNING.SANITY_SMALL,
	foodtype =
		FOODTYPE.MEAT
}

-- how long the player has to set the hook before it escapes
local SET_HOOK_TIME_SHORT = { base = 1, var = 0.5 }
local SET_HOOK_TIME_MEDIUM = { base = 2, var = 0.5 }

local BREACH_FX_SMALL = { "ocean_splash_small1", "ocean_splash_small2" }
local BREACH_FX_MEDIUM = { "ocean_splash_med1", "ocean_splash_med2" }

local SHADOW_SMALL = { 1, .75 }
local SHADOW_MEDIUM = { 1.5, 0.75 }

local FISH_DEFS =
{
	-- Short wander distance
	-- large school
	--[[ oceanfish_small_1 = {
		prefab = "oceanfish_small_1",
		bank = "oceanfish_small",
		build = "oceanfish_small_1",
		weight_min = 48.34,
		weight_max = 60.30,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 1.0,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
			tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
			tiredout_angles = { has_tention = 45, low_tention = 80 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_2 = {
		prefab = "oceanfish_small_2",
		bank = "oceanfish_small",
		build = "oceanfish_small_2",
		weight_min = 37.54,
		weight_max = 57.62,

		walkspeed = 1.5,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.5,
			struggle_times  = { low = 1, r_low = 2, high = 3, r_high = 2 },
			tired_times     = { low = 1, r_low = 2, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_3 = {
		prefab = "oceanfish_small_3",
		bank = "oceanfish_small",
		build = "oceanfish_small_3",
		weight_min = 39.66,
		weight_max = 63.58,

		walkspeed = 1.2,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.01,
			struggle_times  = { low = 5, r_low = 1, high = 5, r_high = 3 },
			tired_times     = { low = 2, r_low = 2, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 60, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_4 = {
		prefab = "oceanfish_small_4",
		bank = "oceanfish_small",
		build = "oceanfish_small_4",
		weight_min = 39.70,
		weight_max = 56.26,

		walkspeed = 1.2,
		runspeed = 2.0,
		stamina =
		{
			drain_rate      = 0.5,
			recover_rate    = 0.5,
			struggle_times  = { low = 3, r_low = 0, high = 3, r_high = 1 },
			tired_times     = { low = 5, r_low = 1, high = 3, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_5 = {
		prefab = "oceanfish_small_5",
		bank = "oceanfish_small",
		build = "oceanfish_small_5",
		weight_min = 33.08,
		weight_max = 47.74,

		walkspeed = 1.0,
		runspeed = 2.0,
		stamina =
		{
			drain_rate      = 0.5,
			recover_rate    = 0.5,
			struggle_times  = { low = 3, r_low = 0, high = 3, r_high = 1 },
			tired_times     = { low = 5, r_low = 1, high = 3, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 160 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.POPCORN,
		cooking_product = COOKING_PRODUCT.CORN,
		perish_product = PERISH.POPCORN,
		fishtype = "veggie",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_VEGGIE,
		diet = DIET.VEGGIE,
		cooker_ingredient_value = { veggie = 1 },
		edible_values = EDIBLE_VALUES_SMALL_VEGGIE,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_6 = { -- autumn
		prefab = "oceanfish_small_6",
		bank = "oceanfish_small",
		build = "oceanfish_small_6",
		weight_min = 28.87,
		weight_max = 44.44,

		walkspeed = 1.5,
		runspeed = 2.0,
		stamina =
		{
			drain_rate      = 0.5,
			recover_rate    = 0.5,
			struggle_times  = { low = 1, r_low = 1, high = 3, r_high = 1 },
			tired_times     = { low = 5, r_low = 1, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.PLANTMEAT,
		cooking_product = COOKING_PRODUCT.PLANTMEAT,
		perish_product = PERISH.PLANTMEAT,
		fishtype = "veggie",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_VEGGIE,
		diet = DIET.VEGGIE,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL, -- plantmeat does not go in the crokpot
		edible_values = EDIBLE_VALUES_PLANTMEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_7 = { -- spring
		prefab = "oceanfish_small_7",
		bank = "oceanfish_small",
		build = "oceanfish_small_7",
		weight_min = 53.64,
		weight_max = 63.36,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.2,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 8, r_high = 1 },
			tired_times     = { low = 5, r_low = 1, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 45, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.PLANTMEAT,
		cooking_product = COOKING_PRODUCT.PLANTMEAT,
		perish_product = PERISH.PLANTMEAT,
		fishtype = "veggie",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_VEGGIE,
		diet = DIET.VEGGIE,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL, -- plantmeat does not go in the crokpot
		edible_values = EDIBLE_VALUES_PLANTMEAT,

		dynamic_shadow = SHADOW_SMALL,
	},

	oceanfish_small_8 = { -- summer
		prefab = "oceanfish_small_8",
		bank = "oceanfish_small",
		build = "oceanfish_small_8",
		weight_min = 41.14,
		weight_max = 56.78,

		walkspeed = 1.5,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.5,
			struggle_times  = { low = 3, r_low = 1, high = 3, r_high = 2 },
			tired_times     = { low = 1, r_low = 2, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL_COOKED,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		heater = { carriedheat = 70, heat = 70, carriedheatmultiplier = 2 },
		propagator = { propagaterange = 3, heatoutput = 2 },
		light = { r = 0.6, i = 0.5, f = 1, c = { 235 / 255, 165 / 255, 12 / 255 } },
	},

	oceanfish_small_9 = { -- sprinkler
		prefab = "oceanfish_small_9",
		bank = "oceanfish_small",
		build = "oceanfish_small_9",
		extra_anim_assets = { "oceanfish_small_sprinkler" },
		extra_prefabs = { "waterstreak_projectile" },

		weight_min = 31.15,
		weight_max = 49.20,

		walkspeed = 1.0,
		runspeed = 2.0,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.5,
			struggle_times  = { low = 2, r_low = 1, high = 3, r_high = 1 },
			tired_times     = { low = 1, r_low = 3, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.TINY.min,
		schoolmax = SCHOOL_SIZE.TINY.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.SHORT.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.SHORT.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.CLOSE,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SMALL,
		cooking_product = COOKING_PRODUCT.SMALL,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_VEGGIE,
		diet = DIET.VEGGIE,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		firesuppressant = true,
	},

	oceanfish_medium_1 = {
		prefab = "oceanfish_medium_1",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_1",
		weight_min = 154.32,
		weight_max = 214.97,

		walkspeed = 1.2,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_2 = {
		prefab = "oceanfish_medium_2",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_2",
		weight_min = 172.41,
		weight_max = 228.88,

		walkspeed = 2.5,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.25,
			recover_rate    = 0.05,
			struggle_times  = { low = 2, r_low = 0, high = 2, r_high = 1 },
			tired_times     = { low = 4, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 15, low_tention = 15 },
		},

		schoolmin = SCHOOL_SIZE.SMALL.min,
		schoolmax = SCHOOL_SIZE.SMALL.max,
		schoolrange = SCHOOL_AREA.MEDIUM,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.LONG.min,
		herdwandermax = WANDER_DIST.LONG.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_3 = {
		prefab = "oceanfish_medium_3",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_3",
		weight_min = 246.77,
		weight_max = 302.32,

		walkspeed = 2.2,
		runspeed = 3.5,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.25,
			struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
			tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
			tiredout_angles = { has_tention = 45, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	-- mostly found in the ROUGH water
	oceanfish_medium_4 = {
		prefab = "oceanfish_medium_4",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_4",
		weight_min = 193.27,
		weight_max = 278.50,

		walkspeed = 1.4,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.02,
			recover_rate    = 0.10,
			struggle_times  = { low = 5, r_low = 1, high = 12, r_high = 6 },
			tired_times     = { low = 4, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 60, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_5 = {
		prefab = "oceanfish_medium_5",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_5",
		weight_min = 161.48,
		weight_max = 241.80,

		walkspeed = 1.3,
		runspeed = 2.8,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 3, r_low = 1, high = 8, r_high = 1 },
			tired_times     = { low = 4, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.CORN,
		cooking_product = COOKING_PRODUCT.CORN,
		perish_product = PERISH.CORN,
		fishtype = "veggie",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.VEGGIE,
		diet = DIET.VEGGIE,
		cooker_ingredient_value = { veggie = 1 },
		edible_values = EDIBLE_VALUES_MEDIUM_VEGGIE,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_6 = {
		prefab = "oceanfish_medium_6",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_6",
		weight_min = 188.88,
		weight_max = 238.88,

		walkspeed = 1.2,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_7 = {
		prefab = "oceanfish_medium_7",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_7",
		weight_min = 188.88,
		weight_max = 238.88,

		walkspeed = 1.2,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_medium_8 = { -- winter fish
		prefab = "oceanfish_medium_8",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_8",
		weight_min = 190.90,
		weight_max = 270.70,

		walkspeed = 1.5,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.15,
			struggle_times  = { low = 7, r_low = 1, high = 10, r_high = 5 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 90, low_tention = 100 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.ICE,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM_ICE,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,

		heater = { endothermic = true, carriedheat = -5, heat = -5, carriedheatmultiplier = 2 }, -- heat radius is only 5 for this
	},

	oceanfish_medium_9 = {
		prefab = "oceanfish_medium_9",
		bank = "oceanfish_medium",
		build = "oceanfish_medium_9",
		weight_min = 210.50,
		weight_max = 315.14,

		walkspeed = 1.2,
		runspeed = 3.0,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.SMALL.min,
		schoolmax = SCHOOL_SIZE.SMALL.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MEDIUM,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.BERRY,
		diet = DIET.BERRY,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	}, ]]
	--[[
	-- large school
	oceanfish_antchovy = {
		prefab = "oceanfish_antchovy",
		bank = "antchovy",
		build = "antchovy",
	  	weight_min = WEIGHTS.TINY.min,
	  	weight_max = WEIGHTS.TINY.max,

	  	schoolmin = SCHOOL_SIZE.LARGE.min,
	  	schoolmax = SCHOOL_SIZE.LARGE.max,
	  	schoolrange = SCHOOL_AREA.MEDIUM,	
	  	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	  	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,	  	

	  	herdwandermin = WANDER_DIST.MEDIUM.min,
	  	herdwandermax = WANDER_DIST.MEDIUM.max,
	  	herdarrivedist = ARRIVE_DIST.MEDIUM,		
	  	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.TINY,
		cooking_product = COOKING_PRODUCT.TINY,
	},
]]

	oceanfish_small_61 = {
		istropicalfish = true,
		prefab = "oceanfish_small_61",
		bank = "fish2",
		build = "fish2",
		oceanbuild = "oceanfish_small_2",
		weight_min = 48.34,
		weight_max = 60.30,

		walkspeed = 1.2,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 1.0,
			recover_rate    = 0.1,
			struggle_times  = { low = 5, r_low = 1, high = 5, r_high = 3 },
			tired_times     = { low = 2, r_low = 2, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 60, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH2,
		cooking_product = "fish_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_71 = {
		istropicalfish = true,
		prefab = "oceanfish_small_71",
		bank = "fish3",
		build = "fish3",
		oceanbuild = "oceanfish_small_5",
		weight_min = 150.49,
		weight_max = 190.20,

		walkspeed = 1.2,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH3,
		cooking_product = "fish3_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_81 = {
		istropicalfish = true,
		prefab = "oceanfish_small_81",
		bank = "fish4",
		build = "fish4",
		oceanbuild = "oceanfish_small_5",
		weight_min = 30.55,
		weight_max = 57.62,

		walkspeed = 1.2,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.1,
			struggle_times  = { low = 1, r_low = 2, high = 3, r_high = 2 },
			tired_times     = { low = 1, r_low = 2, high = 1, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH4,
		cooking_product = "fish4_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_91 = {
		istropicalfish = true,
		prefab = "oceanfish_small_91",
		bank = "fish5",
		build = "fish5",
		oceanbuild = "oceanfish_small_5",
		weight_min = 40.80,
		weight_max = 64.44,

		walkspeed = 1.2,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.5,
			recover_rate    = 0.8,
			struggle_times  = { low = 3, r_low = 0, high = 3, r_high = 1 },
			tired_times     = { low = 5, r_low = 1, high = 3, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.LONG.min,
		herdwanderdelaymax = WANDER_DELAY.LONG.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH5,
		cooking_product = "fish5_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_10 = {
		istropicalfish = true,
		prefab = "oceanfish_small_10",
		bank = "coi",
		build = "coi",
		oceanbuild = "oceanfish_small_1",
		weight_min = 260.40,
		weight_max = 310.36,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.10,
			struggle_times  = { low = 3, r_low = 1, high = 8, r_high = 1 },
			tired_times     = { low = 4, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.COI,
		cooking_product = "coi_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_11 = {
		istropicalfish = true,
		prefab = "oceanfish_small_11",
		bank = "salmon",
		build = "salmon",
		oceanbuild = "oceanfish_small_5",
		weight_min = 90.71,
		weight_max = 146.25,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.05,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
			tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
			tiredout_angles = { has_tention = 80, low_tention = 120 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SALMON,
		cooking_product = "salmon_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	-- oceanfish_small_12 = {
	-- istropicalfish = true,
	-- 	prefab = "oceanfish_small_12",
	-- 	bank = "ballphinocean",
	-- 	build = "ballphinocean",
	-- 	oceanbuild = "oceanfish_small_5",
	-- 	golfinho = true,
	-- 	weight_min = 320.77,
	-- 	weight_max = 380.10,

	-- 	walkspeed = 3.0,
	-- 	runspeed = 4.0,
	-- 	stamina =
	-- 	{
	-- 		drain_rate      = 0.02,
	-- 		recover_rate    = 0.10,
	-- 		struggle_times  = { low = 8, r_low = 2, high = 9, r_high = 2 },
	-- 		tired_times     = { low = 1.8, r_low = 1, high = 1.7, r_high = 0 },
	-- 		tiredout_angles = { has_tention = 45, low_tention = 90 },
	-- 	},

	-- 	schoolmin = SCHOOL_SIZE.MEDIUM.min,
	-- 	schoolmax = SCHOOL_SIZE.MEDIUM.max,
	-- 	schoolrange = SCHOOL_AREA.SMALL,
	-- 	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	-- 	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

	-- 	herdwandermin = WANDER_DIST.MEDIUM.min,
	-- 	herdwandermax = WANDER_DIST.MEDIUM.max,
	-- 	herdarrivedist = ARRIVE_DIST.MEDIUM,
	-- 	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
	-- 	herdwanderdelaymax = WANDER_DELAY.SHORT.max,

	-- 	set_hook_time = SET_HOOK_TIME_SHORT,
	-- 	breach_fx = BREACH_FX_MEDIUM,
	-- 	loot = LOOT.BALLPHIN,
	-- 	cooking_product = COOKING_PRODUCT.MEDIUM,
	-- 	perish_product = PERISH.SMALL,
	-- 	fishtype = "meat",

	-- 	lures = { swfish = 1.00 },
	-- 	diet = DIET.OMNI,
	-- 	cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
	-- 	edible_values = EDIBLE_VALUES_SMALL_MEAT,

	-- 	dynamic_shadow = SHADOW_MEDIUM,
	-- },

	oceanfish_small_13 = {
		istropicalfish = true,
		prefab = "oceanfish_small_13",
		bank = "mecfish",
		build = "mecfish",
		oceanbuild = "oceanfish_small_5",
		weight_min = 246.77,
		weight_max = 302.32,

		walkspeed = 2.2,
		runspeed = 3.5,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.25,
			struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
			tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
			tiredout_angles = { has_tention = 45, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.MECFISH,
		cooking_product = "gears",
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_14 = {
		istropicalfish = true,
		prefab = "oceanfish_small_14",
		bank = "goldfish",
		build = "goldfish",
		oceanbuild = "oceanfish_small_5",
		weight_min = 250.77,
		weight_max = 423.32,

		walkspeed = 2.2,
		runspeed = 3.5,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.25,
			struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
			tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
			tiredout_angles = { has_tention = 45, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.GOLDFISH,
		cooking_product = "goldnugget",
		perish_product = PERISH.MEDIUM,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
		diet = DIET.MEAT,
		cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
		edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	--[[ oceanfish_small_15 = {
		istropicalfish = true,
		prefab = "oceanfish_small_15",
		bank = "whaleblueocean",
		build = "whaleblueocean",
		oceanbuild = "oceanfish_small_5",
		tamanho = 2,
		weight_min = 48.34,
		weight_max = 60.30,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 1.0,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
			tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
			tiredout_angles = { has_tention = 45, low_tention = 80 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.WHALEBLUEOCEAN,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = { swfish = 1.00 },
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	}, ]]

	--[[ oceanfish_small_16 = {
		istropicalfish = true,
		prefab = "oceanfish_small_16",
		bank = "dogfishocean",
		build = "dogfishocean",
		oceanbuild = "oceanfish_small_5",
		dogfish = true,
		weight_min = 70.11,
		weight_max = 130.99,

		walkspeed = 1.6,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 0.01,
			recover_rate    = 0.6,
			struggle_times  = { low = 5, r_low = 1, high = 12, r_high = 6 },
			tired_times     = { low = 3, r_low = 1, high = 1.7, r_high = 1 },
			tiredout_angles = { has_tention = 60, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.DOGFISHOCEAN,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = { swfish = 1.00 },
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	}, ]]

	oceanfish_small_17 = {
		istropicalfish = true,
		prefab = "oceanfish_small_17",
		bank = "fish7",
		build = "fish7",
		oceanbuild = "oceanfish_small_5",
		weight_min = 48.34,
		weight_max = 60.30,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 1.0,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
			tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
			tiredout_angles = { has_tention = 45, low_tention = 80 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH7,
		cooking_product = "fish7_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	oceanfish_small_18 = {
		istropicalfish = true,
		prefab = "oceanfish_small_18",
		bank = "fish6",
		build = "fish6",
		oceanbuild = "oceanfish_small_5",
		weight_min = 48.34,
		weight_max = 60.30,

		walkspeed = 0.8,
		runspeed = 2.5,
		stamina =
		{
			drain_rate      = 1.0,
			recover_rate    = 0.1,
			struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
			tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
			tiredout_angles = { has_tention = 45, low_tention = 80 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.FISH6,
		cooking_product = "fish6_cooked",
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},

	--[[ oceanfish_small_19 = {
		istropicalfish = true,
		prefab = "oceanfish_small_19",
		bank = "swordfishjocean",
		build = "swordfishjocean",
		oceanbuild = "oceanfish_small_5",
		peixeespada = true,
		tamanho = 1.3,
		weight_min = 270.32,
		weight_max = 320.97,

		walkspeed = 3.0,
		runspeed = 4.0,
		stamina =
		{
			drain_rate      = 0.1,
			recover_rate    = 0.8,
			struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
			tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
			tiredout_angles = { has_tention = 45, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.MEDIUM.min,
		schoolmax = SCHOOL_SIZE.MEDIUM.max,
		schoolrange = SCHOOL_AREA.SMALL,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.MEDIUM.min,
		herdwandermax = WANDER_DIST.MEDIUM.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_MEDIUM,
		loot = LOOT.SWORDFISHOCEAN,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = { swfish = 1.00 },
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},
	oceanfish_small_20 = {
		istropicalfish = true,
		prefab = "oceanfish_small_20",
		bank = "swordfishjocean2",
		build = "swordfishjocean2",
		oceanbuild = "oceanfish_small_5",
		peixeespada = true,
		tamanho = 1.3,
		weight_min = 140.74,
		weight_max = 187.52,

		walkspeed = 3.0,
		runspeed = 4.0,
		stamina =
		{
			drain_rate      = 0.02,
			recover_rate    = 0.10,
			struggle_times  = { low = 8, r_low = 2, high = 9, r_high = 2 },
			tired_times     = { low = 1.8, r_low = 1, high = 1.7, r_high = 0 },
			tiredout_angles = { has_tention = 45, low_tention = 90 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SWORDFISHOCEAN2,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	},
	oceanfish_small_21 = {
		istropicalfish = true,
		prefab = "oceanfish_small_21",
		bank = "sharxocean",
		build = "sharxocean",
		oceanbuild = "oceanfish_small_5",
		sharx = true,
		tamanho = 1.5,
		weight_min = 175.72,
		weight_max = 249.12,

		walkspeed = 3.0,
		runspeed = 4.5,
		stamina =
		{
			drain_rate      = 0.3,
			recover_rate    = 0.10,
			struggle_times  = { low = 4.6, r_low = 1, high = 4.2, r_high = 0.2 },
			tired_times     = { low = 0.3, r_low = 0.2, high = 0.7, r_high = 0.07 },
			tiredout_angles = { has_tention = 45, low_tention = 80 },
		},

		schoolmin = SCHOOL_SIZE.LARGE.min,
		schoolmax = SCHOOL_SIZE.LARGE.max,
		schoolrange = SCHOOL_AREA.TINY,
		schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin = WANDER_DIST.SHORT.min,
		herdwandermax = WANDER_DIST.SHORT.max,
		herdarrivedist = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_SHORT,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.SHARXOCEAN,
		cooking_product = COOKING_PRODUCT.MEDIUM,
		perish_product = PERISH.SMALL,
		fishtype = "meat",

		lures = { swfish = 1.00 },
		diet = DIET.OMNI,
		cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
		edible_values = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow = SHADOW_MEDIUM,
	}, ]]
}


local SCHOOL_VERY_COMMON = 4
local SCHOOL_COMMON      = 2
local SCHOOL_UNCOMMON    = 1
local SCHOOL_RARE        = 0.25

local SCHOOL_WEIGHTS     = {
	[SEASONS.AUTUMN] = {
		[WORLD_TILES.OCEAN_COASTAL] =
		{
			oceanfish_small_61 = SCHOOL_COMMON,

		},
		[WORLD_TILES.OCEAN_COASTAL_SHORE] =
		{
			oceanfish_small_61 = SCHOOL_COMMON,

		},
		[WORLD_TILES.OCEAN_SWELL] =
		{
			oceanfish_small_61 = SCHOOL_COMMON,


		},
		[WORLD_TILES.OCEAN_ROUGH] = {
			-- oceanfish_small_19 = SCHOOL_RARE,
			-- oceanfish_small_20 = SCHOOL_RARE,
			-- oceanfish_small_21 = SCHOOL_RARE,

		},
		[WORLD_TILES.OCEAN_BRINEPOOL] =
		{
			oceanfish_small_71 = SCHOOL_UNCOMMON,
			oceanfish_small_81 = SCHOOL_UNCOMMON,
			oceanfish_small_91 = SCHOOL_UNCOMMON,
		},
		[WORLD_TILES.OCEAN_BRINEPOOL_SHORE] =
		{
			oceanfish_small_71 = SCHOOL_UNCOMMON,
			oceanfish_small_81 = SCHOOL_UNCOMMON,
			oceanfish_small_91 = SCHOOL_UNCOMMON,
		},
		[WORLD_TILES.OCEAN_HAZARDOUS] =
		{
			oceanfish_small_13 = SCHOOL_UNCOMMON, -- mecfish
			oceanfish_small_14 = SCHOOL_UNCOMMON, -- goldfish
		},

		[WORLD_TILES.MANGROVE] =
		{
			oceanfish_small_61 = SCHOOL_COMMON,
			oceanfish_small_18 = SCHOOL_UNCOMMON, -- red fish
		},

		[WORLD_TILES.LILYPOND] =
		{
			oceanfish_small_10 = SCHOOL_COMMON, --coi
			oceanfish_small_17 = SCHOOL_UNCOMMON, --hutch

		},
	},
}


SCHOOL_WEIGHTS[SEASONS.WINTER] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])
SCHOOL_WEIGHTS[SEASONS.SPRING] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])
SCHOOL_WEIGHTS[SEASONS.SUMMER] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])


-- Seasonal Fish
SCHOOL_WEIGHTS[SEASONS.SPRING][WORLD_TILES.OCEAN_COASTAL_SHORE].oceanfish_small_11 = SCHOOL_COMMON
-- SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_SWELL].oceanfish_small_6 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.WINTER][WORLD_TILES.OCEAN_SWELL].oceanfish_medium_8 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.SPRING][WORLD_TILES.OCEAN_COASTAL].oceanfish_small_7 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_WATERLOG].oceanfish_small_6 = SCHOOL_COMMON
-- SCHOOL_WEIGHTS[SEASONS.SPRING][WORLD_TILES.OCEAN_WATERLOG].oceanfish_small_7 = SCHOOL_COMMON
-- SCHOOL_WEIGHTS[SEASONS.SUMMER][WORLD_TILES.OCEAN_SWELL].oceanfish_small_8 = SCHOOL_UNCOMMON

-- --------------------
-- SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_MEDIUM].oceanfish_small_6 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.WINTER][WORLD_TILES.OCEAN_MEDIUM].oceanfish_medium_8 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.SPRING][WORLD_TILES.OCEAN_SHALLOW].oceanfish_small_7 = SCHOOL_UNCOMMON
-- SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.MANGROVE].oceanfish_small_6 = SCHOOL_COMMON
-- SCHOOL_WEIGHTS[SEASONS.SPRING][WORLD_TILES.MANGROVE].oceanfish_small_7 = SCHOOL_COMMON
-- SCHOOL_WEIGHTS[SEASONS.SUMMER][WORLD_TILES.OCEAN_MEDIUM].oceanfish_small_8 = SCHOOL_UNCOMMON


local function SpecialEventSetup()
	if IsAny_YearOfThe_EventActive() then
		-- FISH_DEFS.oceanfish_medium_6.loot = LOOT.MEDIUM_YOT
		-- FISH_DEFS.oceanfish_medium_6.oncooked_fn = MEDIUM_YOT_ONCOOKED_FN
		-- FISH_DEFS.oceanfish_medium_7.loot = LOOT.MEDIUM_YOT
		-- FISH_DEFS.oceanfish_medium_7.oncooked_fn = MEDIUM_YOT_ONCOOKED_FN

		for _, season in pairs(SCHOOL_WEIGHTS) do
			-- season[WORLD_TILES.OCEAN_COASTAL].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_SWELL].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_ROUGH].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2

			-- season[WORLD_TILES.OCEAN_COASTAL].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_SWELL].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_ROUGH].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
			-- -----------------------
			-- season[WORLD_TILES.OCEAN_SHALLOW].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_MEDIUM].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_DEEP].oceanfish_medium_6 = SCHOOL_UNCOMMON / 2

			-- season[WORLD_TILES.OCEAN_SHALLOW].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_MEDIUM].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
			-- season[WORLD_TILES.OCEAN_DEEP].oceanfish_medium_7 = SCHOOL_UNCOMMON / 2
		end
	end
end


return { fish = FISH_DEFS, school = SCHOOL_WEIGHTS, SpecialEventSetup = SpecialEventSetup }


-- 			oceanfish_small_61 = SCHOOL_VERY_COMMON, --热带
-- 			oceanfish_small_71 = SCHOOL_UNCOMMON, --紫石斑鱼
-- 			oceanfish_small_81 = SCHOOL_UNCOMMON, --小丑鱼
-- 			oceanfish_small_91 = SCHOOL_UNCOMMON, --霓虹鱼

-- 			oceanfish_small_10 = SCHOOL_VERY_COMMON, --coi
-- 			oceanfish_small_11 = SCHOOL_RARE, --salmon
-- 			oceanfish_small_13 = SCHOOL_RARE, -- mecfish
-- 			oceanfish_small_14 = SCHOOL_RARE, -- goldfish

-- 			oceanfish_small_17 = SCHOOL_UNCOMMON, --hutch
-- 			oceanfish_small_18 = SCHOOL_UNCOMMON, -- red fish
