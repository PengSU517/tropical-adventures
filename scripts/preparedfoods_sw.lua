-- 贴图与动画
local overridebuild_sw = "cook_pot_food_sw" -- 动画
local cookbook_atlas_sw = "images/cookbook/cookbook_sw.xml" -- 物品栏贴图路径
local inventoryitems_atlas_sw = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml") -- 物品栏贴图路径

-- 食谱
local foods_sw = {
    bisque = {
        test = function(cooker, names, tags)
            return names.limpets and names.limpets == 3 and tags.frozen
        end,
        priority = 30,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_HUGE,
        hunger = TUNING.CALORIES_MEDSMALL,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_TINY,
        cooktime = 1,
        card_def = {ingredients = {{"limpets", 3}, {"ice", 1}} },
    },

    butterflymuffin_sw = {
        test = function(cooker, names, tags)
            return names.butterfly_tropical_wings and not tags.meat and tags.veggie
        end,
        priority = 1,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_SLOW,
        sanity = TUNING.SANITY_TINY,
        cooktime = 2,
        card_def = {ingredients = {{"butterfly_tropical_wings", 1}, {"carrot", 2}, {"twigs", 1}} },
    },

    -- californiaroll_sw = {
    --     test = function(cooker, names, tags)
    --         return
    --             (names.seaweed or 0) == 2 and (tags.fish and tags.fish >= 1)
    --     end,
    --     priority = 20,
    --     weight = 1,
    --     foodtype = FOODTYPE.MEAT,
    --     health = TUNING.HEALING_MED,
    --     hunger = TUNING.CALORIES_LARGE,
    --     perishtime = TUNING.PERISH_MED,
    --     sanity = TUNING.SANITY_SMALL,
    --     cooktime = .5,
    --     potlevel = "high",
    --     floater = {"med", 0.05, {0.65, 0.6, 0.65}},
    --     card_def = {ingredients = {{"seaweed", 2}, {"fishmeat_small", 2}} },
    -- },

    caviar = {
        test = function(cooker, names, tags)
            return (names.roe or names.roe_cooked == 3) and tags.veggie
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_LARGE,
        cooktime = 2,
        card_def = {ingredients = {{"roe", 3}, {"carrot", 1}} },
    },

    coffee = {
        test = function(cooker, names, tags)
            return names.coffeebeans_cooked and
                       (names.coffeebeans_cooked == 4 or
                           (names.coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener)))
        end,
        priority = 30,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_TINY,
        sanity = -TUNING.SANITY_TINY,
        perishtime = TUNING.PERISH_MED,
        cooktime = .5,
        tags = {},
        oneatenfn = function(inst, eater)
            if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                if eater._coffee_speedmulttask ~= nil then
                    eater._coffee_speedmulttask:Cancel()
                end
                local debuffkey = "coffee"
                eater._coffee_speedmulttask = eater:DoTaskInTime(240, function(i)
                    i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                    i._coffee_speedmulttask = nil
                end)
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 11 / 6)
            end
        end,
        card_def = {ingredients = {{"coffeebeans_cooked", 4}} },
    },

    jellyopop = {
        test = function(cooker, names, tags)
            return tags.jellyfish and tags.frozen and tags.inedible
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_SUPERFAST,
        sanity = 0,
        temperature = -40,
        temperatureduration = 10,
        cooktime = 0.5,
        card_def = {ingredients = {{"jellyfish", 1}, {"ice", 1}, {"twigs", 2}} },
    },

    -- lobsterbisque_sw = {
    --     test = function(cooker, names, tags)
    --         return
    --             (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and
    --                 tags.frozen
    --     end,
    --     priority = 30,
    --     weight = 1,
    --     foodtype = FOODTYPE.MEAT,
    --     health = TUNING.HEALING_HUGE,
    --     hunger = TUNING.CALORIES_MED,
    --     perishtime = TUNING.PERISH_MED,
    --     sanity = TUNING.SANITY_SMALL,
    --     cooktime = 0.5,
    --     potlevel = "high",
    --     floater = {"med", 0.05, {0.65, 0.6, 0.65}},
    --     card_def = {ingredients = {{"lobster_land", 1}, {"ice", 3}} },
    -- },

    -- lobsterdinner_sw = {
    --     test = function(cooker, names, tags)
    --         return
    --             (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and
    --                 names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen
    --     end,
    --     priority = 25,
    --     weight = 1,
    --     foodtype = FOODTYPE.MEAT,
    --     health = TUNING.HEALING_HUGE,
    --     hunger = TUNING.CALORIES_LARGE,
    --     perishtime = TUNING.PERISH_SLOW,
    --     sanity = TUNING.SANITY_HUGE,
    --     cooktime = 1,
    --     potlevel = "high",
    --     floater = {"med", 0.05, {0.65, 0.6, 0.65}},
    --     card_def = {ingredients = {{"lobster_land", 1}, {"butter", 1}, {"carrot", 2}} },
    -- },

    musselbouillabaise = {
        test = function(cooker, names, tags)
            return names.mussel and names.mussel == 2 and tags.veggie and tags.veggie >= 2
        end,
        priority = 30,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        tags = {"masterfood"},
        -- card_def = {ingredients = {{"mussel", 2}, {"carrot", 2}} }, -- Runar: 大厨也读不出专属食谱卡
        isMasterfood = true -- Runar:热带大厨料理标记
    },

    sharkfinsoup = {
        test = function(cooker, names, tags)
            return names.shark_fin
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_MED,
        sanity = -TUNING.SANITY_SMALL,
        -- naughtiness = 10, -- 失效 -- Runar: 让我想起了某个处心积虑的营销，遂放弃还原这个效果
        cooktime = 1,
        card_def = {ingredients = {{"shark_fin", 1}, {"ice", 2}, {"twigs", 1}} },
    },

    sweetpotatosouffle = {
        test = function(cooker, names, tags)
            return names.sweet_potato and names.sweet_potato == 2 and tags.egg and tags.egg >= 2
        end,
        priority = 30,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        tags = {"masterfood"},
        -- card_def = {ingredients = {{"sweet_potato", 2}, {"bird_egg", 2}} },
        isMasterfood = true,
    },

    tropicalbouillabaisse = {
        test = function(cooker, names, tags)
            return (names.fish3 or names.fish3_cooked) and (names.fish4 or names.fish4_cooked) and
                       (names.fish5 or names.fish5_cooked) and tags.veggie
        end,
        priority = 35,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        oneatenfn = function(inst, eater)
            eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity") --免疫潮湿
            if eater and eater.components.temperature then --瞬时降温（不确定sw是不是这个逻辑）
                local current_temp = eater.components.temperature:GetCurrent()
                local new_temp = math.max(current_temp - 8, TUNING.STARTING_TEMP)
                eater.components.temperature:SetTemperature(new_temp)
            end
            if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then --基础移速+3（设计上），不确定跟咖啡是否独立，但原本就是这么写的，以后想办法把加速搞到一个函数里面免得叠到起飞
                if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                    eater._tropicalbouillabaisse_speedmulttask:Cancel()
                end
                local debuffkey = "tropicalbouillabaisse"
                eater._tropicalbouillabaisse_speedmulttask =
                    eater:DoTaskInTime(60, function(i)
                        i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                        i._tropicalbouillabaisse_speedmulttask = nil
                    end)
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 1.5)
            end
        end,
        card_def = {ingredients = {{"fish3", 1}, {"fish4", 1}, {"fish5", 1}, {"carrot", 1}} },
    },

}

for k, v in pairs(foods_sw) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.overridebuild = overridebuild_sw
    v.floater = v.floater or {"small", 0.05, 0.7}
    v.mod = true
    -- v.cookbook_tex = k..".tex" --独立贴图用这个
    v.cookbook_atlas = cookbook_atlas_sw
    v.atlasname = inventoryitems_atlas_sw
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_sw
