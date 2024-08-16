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

local PLANT_DEFS                             = require("prefabs/farm_plant_defs").PLANT_DEFS

local drink_low                              = TUNING.FARM_PLANT_DRINK_LOW
local drink_med                              = TUNING.FARM_PLANT_DRINK_MED
local drink_high                             = TUNING.FARM_PLANT_DRINK_HIGH

local S                                      = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M                                      = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L                                      = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

PLANT_DEFS.aloe                              = { build = "farm_plant_aloeplant", bank = "farm_plant_asparagus" }
PLANT_DEFS.radish                            = { build = "farm_plant_radish", bank = "farm_plant_carrot" }
PLANT_DEFS.sweet_potato                      = { build = "farm_plant_sweett", bank = "farm_plant_carrot" }
PLANT_DEFS.wheat                             = { build = "farm_plant_wheataaaa", bank = "farm_plant_asparagus" }
PLANT_DEFS.turnip                            = { build = "farm_plant_turnip", bank = "farm_plant_carrot" }

PLANT_DEFS.sweet_potato.grow_time            = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
    4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.aloe.grow_time                    = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
    4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.radish.grow_time                  = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
    4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.wheat.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
    4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.turnip.grow_time                  = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,
    4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)

PLANT_DEFS.sweet_potato.moisture             = {
    drink_rate = drink_low,
    min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.aloe.moisture                     = {
    drink_rate = drink_low,
    min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.radish.moisture                   = {
    drink_rate = drink_low,
    min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.wheat.moisture                    = {
    drink_rate = drink_low,
    min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}
PLANT_DEFS.turnip.moisture                   = {
    drink_rate = drink_low,
    min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE
}

PLANT_DEFS.sweet_potato.good_seasons         = { autumn = true,                spring = true, summer = true }
PLANT_DEFS.aloe.good_seasons                 = { autumn = true,                spring = true, summer = true }
PLANT_DEFS.radish.good_seasons               = { autumn = true,                spring = true                }
PLANT_DEFS.wheat.good_seasons                = {                winter = true, spring = true                }
PLANT_DEFS.turnip.good_seasons               = { autumn = true,                               summer = true }

PLANT_DEFS.sweet_potato.nutrient_consumption = { 0, 0, M }
PLANT_DEFS.aloe.nutrient_consumption         = { 0, M, 0 }
PLANT_DEFS.radish.nutrient_consumption       = { M, 0, 0 }
PLANT_DEFS.wheat.nutrient_consumption        = { 0, M, 0 }
PLANT_DEFS.turnip.nutrient_consumption       = { M, 0, 0 }


-------------------加入nutrition--------------------------------------------------
for _, data in pairs(PLANT_DEFS) do
    data.nutrient_restoration = {}
    for i = 1, #data.nutrient_consumption do
        data.nutrient_restoration[i] = data.nutrient_consumption[i] == 0 or nil
    end
end

PLANT_DEFS.sweet_potato.max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.aloe.max_killjoys_tolerance         = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.radish.max_killjoys_tolerance       = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.wheat.max_killjoys_tolerance        = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.turnip.max_killjoys_tolerance       = TUNING.FARM_PLANT_KILLJOY_TOLERANCE

-- PLANT_DEFS.sweet_potato.weight_data            = { 384.59, 662.77, .18 }
-- PLANT_DEFS.aloe.weight_data                    = { 384.59, 662.77, .18 }
-- PLANT_DEFS.radish.weight_data                  = { 384.59, 662.77, .18 }
-- PLANT_DEFS.wheat.weight_data                   = { 384.59, 662.77, .18 }
-- PLANT_DEFS.turnip.weight_data                  = { 384.59, 662.77, .18 }
-- PLANT_DEFS.carrot.weight_data                  = { 0, 0, 0 }

PLANT_DEFS.sweet_potato.weight_data            = { 361.51, 506.04, .28 }
PLANT_DEFS.aloe.weight_data                    = { 361.51, 506.04, .28 }
PLANT_DEFS.radish.weight_data                  = { 361.51, 506.04, .28 }
PLANT_DEFS.wheat.weight_data                   = { 361.51, 506.04, .28 }
PLANT_DEFS.turnip.weight_data                  = { 361.51, 506.04, .28 }

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
