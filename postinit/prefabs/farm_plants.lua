-- 用于屏蔽随机种子种出三合一作物
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local WEIGHTED_SEED_TABLE = require("prefabs/weed_defs").weighted_seed_table

local NOTINCLUDE = { wheat = true, }

local function pickfarmplant()
    if math.random() < TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE then
        return weighted_random_choice(WEIGHTED_SEED_TABLE)
    else
        local season = TheWorld.state.season
        local weights = {}
        local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD
		
        for k, v in pairs(VEGGIES) do
            weights[k] = v.seed_weight * ((PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[season]) and season_mod or 1)
        end

        for k, _ in ipairs(NOTINCLUDE) do
            weights[k] = 0
        end

        return "farm_plant_"..weighted_random_choice(weights)
    end
    return "weed_forgetmelots"
end

AddPrefabPostInit("farm_plant_randomseed", function(inst)
	if not TheWorld.ismastersim then return end
	inst:ListenForEvent("on_planted", function(inst, data)
		local old_changefn = inst.components.growable.stages[2].fn
		inst.components.growable.stages[2].fn = function(inst, stage)
            inst._identified_plant_type = old_changefn and old_changefn(inst, stage)
            if not inst._identified_plant_type or NOTINCLUDE[inst._identified_plant_type] then
			    inst._identified_plant_type = pickfarmplant()
            end
		end
	end)
end)