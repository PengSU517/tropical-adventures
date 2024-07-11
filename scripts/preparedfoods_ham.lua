-- 贴图与动画
local overridebuild_ham = "cook_pot_food_ham"
local cookbook_atlas_ham = "images/cookbook/cookbook_ham.xml"
local inventoryitems_atlas_ham = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml")


-- 食谱
local foods_ham = {
    feijoada = {
        test = function(cooker, names, tags)
            return tags.meat and (names.jellybug == 3) or (names.jellybug_cooked == 3) or
                       (names.jellybug and names.jellybug_cooked and names.jellybug + names.jellybug_cooked == 3)
        end,
        priority = 30,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_HUGE,
        perishtime = TUNING.PERISH_FASTISH,
        sanity = TUNING.SANITY_MED,
        cooktime = 3.5,
        card_def = {ingredients = {{"jellybug", 3}, {"carrot", 1}} },
    },

    steamedhamsandwich = {
        test = function(cooker, names, tags)
            return (names.meat or names.meat_cooked) and (tags.veggie and tags.veggie >= 2) and names.foliage
        end,
        priority = 5,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_FAST,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        card_def = {ingredients = {{"meat", 1}, {"carrot", 2}, {"foliage", 1}} },
    },

    hardshell_tacos = {
        test = function(cooker, names, tags)
            return (names.weevole_carapace == 2) and tags.veggie
        end,
        priority = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_SLOW,
        sanity = TUNING.SANITY_TINY,
        cooktime = 1,
        card_def = {ingredients = {{"weevole_carapace", 2}, {"carrot", 2} } },
    },

    gummy_cake = {
        test = function(cooker, names, tags)
            return (names.slugbug or names.slugbug_cooked) and tags.sweetener
        end,
        priority = 1,
        foodtype = FOODTYPE.MEAT,
        health = -TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SUPERHUGE,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = -TUNING.SANITY_TINY,
        cooktime = 2,
        tags = {"honeyed"},
        card_def = {ingredients = {{"slugbug", 1}, {"honey", 1}, {"twigs", 2} } },
    },

    tea = {
        test = function(cooker, names, tags)
            return tags.filter and tags.filter >= 2 and tags.sweetener and not tags.meat and not tags.veggie and
                       not tags.inedible
        end,
        priority = 25,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_ONE_DAY,
        sanity = TUNING.SANITY_LARGE,
        temperature = 40,
        temperatureduration = 10,
        cooktime = 0.5,
        tags = {"honeyed"},
        oneatenfn = function(inst, eater)
            if eater and eater.components.temperature then
                local current_temp = eater.components.temperature:GetCurrent()
                local new_temp = math.max(current_temp + 15, TUNING.STARTING_TEMP)
                eater.components.temperature:SetTemperature(new_temp)
            end
            if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                    eater._tropicalbouillabaisse_speedmulttask:Cancel()
                end
                local debuffkey = "tropicalbouillabaisse"
                eater._tropicalbouillabaisse_speedmulttask =
                    eater:DoTaskInTime(120, function(i)
                        i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                        i._tropicalbouillabaisse_speedmulttask = nil
                    end)
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 17 / 12)
            end
        end,
        card_def = {ingredients = {{"piko_orange", 2}, {"honey", 2}} },
    },

    icedtea = {
        test = function(cooker, names, tags)
            return tags.filter and tags.filter >= 2 and tags.sweetener and tags.frozen
        end,
        priority = 30,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_FAST,
        sanity = TUNING.SANITY_LARGE,
        temperature = -40,
        temperatureduration = 10,
        cooktime = 0.5,
        tags = {"honeyed"},
        oneatenfn = function(inst, eater)
            if eater and eater.components.temperature then
                local current_temp = eater.components.temperature:GetCurrent()
                local new_temp = math.max(current_temp - 10, TUNING.STARTING_TEMP)
                eater.components.temperature:SetTemperature(new_temp)
            end
            if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                    eater._tropicalbouillabaisse_speedmulttask:Cancel()
                end
                local debuffkey = "tropicalbouillabaisse"
                eater._tropicalbouillabaisse_speedmulttask =
                    eater:DoTaskInTime(80, function(i)
                        i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                        i._tropicalbouillabaisse_speedmulttask = nil
                    end)
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 23 / 18)
            end
        end,
        card_def = {ingredients = {{"piko_orange", 2}, {"honey", 1}, {"ice", 1} } },
    },

    snakebonesoup = {
        test = function(cooker, names, tags)
            return tags.bone and tags.bone >= 2 and tags.meat and tags.meat >= 2
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_MED,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_SMALL,
        cooktime = 1,
        card_def = {ingredients = {{"snake_bone", 2}, {"meat", 2}} },
    },

    nettlelosange = {
        test = function(cooker, names, tags)
            return tags.antihistamine and tags.antihistamine >= 3
        end,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_MED,
        perishtime = TUNING.PERISH_FAST,
        sanity = TUNING.SANITY_TINY,
        antihistamine = 720,
        cooktime = .5,
        oneatenfn = function(inst, eater)
            if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 19000
            end
        end,
        card_def = {ingredients = {{"cutnettle", 3}, {"twigs", 1}} },
    },

    meated_nettle = {
        test = function(cooker, names, tags)
            return (tags.antihistamine and tags.antihistamine >= 2) and (tags.meat and tags.meat >= 1) and
                       (not tags.monster or tags.monster <= 1) and not tags.inedible
        end,
        priority = 1,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_FASTISH,
        sanity = TUNING.SANITY_TINY,
        antihistamine = 600,
        cooktime = 1,
        oneatenfn = function(inst, eater)
            if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 16000
            end
        end,
        card_def = {ingredients = {{"cutnettle", 2}, {"smallmeat", 2}} },
    },

    -- 废案重现
    bubbletea = { -- 芋泥啵啵 Bubble Tea
        test = function(cooker, names, tags)
            return (names.seataro or names.seataro_cooked) and tags.filter and tags.dairy and tags.sweetener and
                        not tags.meat and not tags.monster and not tags.fish
        end,
        priority = 1,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_HUGE,
        perishtime = TUNING.PERISH_FASTISH,
        sanity = TUNING.SANITY_HUGE,
        temperature = -40,
        temperatureduration = 10,
        cooktime = .5,
        tags = { "honeyed" },
        card_def = {ingredients = {{"seataro", 1}, {"piko_orange", 1}, {"goatmilk", 1}, {"honey", 1}} },
    },
    
    frenchonionsoup = { -- 法式洋葱汤 French Onion Soup
        test = function(cooker, names, tags)
            return tags.meat and (names.onion or names.onion_cooked) and (names.tomato or names.tomato_cooked) and
                        not tags.fish and not tags.inedible
        end,
        priority = 35, -- 比海鲜杂烩高一点
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_HUGE + TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_FASTISH,
        sanity = TUNING.SANITY_MEDLARGE,
        cooktime = .75,
        isMasterfood = true,
        tags = { "masterfood" }, -- 下次搬到TE
        card_def = {ingredients = {{"smallmeat", 1}, {"onion", 1}, {"tomato", 1}, {"twigs", 1}} },
    }, 

    lotuschips = { -- 莲藕汤 Lotus Root Soup
        test = function(cooker, names, tags)
            return ((names.lotus_flower1 and names.lotus_flower1 > 1) or (names.lotus_flower1_cooked and names.lotus_flower1_cooked > 1) or (names.lotus_flower1 and names.lotus_flower1_cooked)) and
                        not tags.fish
        end,
        priority = 5,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_MEDSMALL,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MEDLARGE * 2,
        cooktime = .5,
        card_def = {ingredients = {{"lotus_flower1", 2}, {"ice", 1}, {"twigs", 1}} },
    },

    poi = { -- 芋泥 Poi
        test = function(cooker, names, tags)
               return ((names.seataro or 0) + (names.seataro_cooked or 0)) >= 2 and 
                           ((names.seataro or 0) + (names.seataro_cooked or 0) + (names.potato or 0) + (names.potato_cooked or 0) + (names.sweet_potato or 0) + (names.sweet_potato_cooked or 0)) > 2 and
                           not tags.meat and not tags.monster and not tags.fish 
        end,
        priority = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_MEDLARGE,
        hunger = TUNING.CALORIES_LARGE + TUNING.CALORIES_MED,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_TINY,
        cooktime = 2,
        card_def = {ingredients = {{"seataro", 3}, {"ice", 1} } },
    }, 

    -- slaw = { -- 茴香沙拉 Slaw -- 游戏里获得不了茴香就先不加入
	-- 	test = function(cooker, names, tags) return (names.fennel or names.fennel_cooked) and not tags.meat and tags.veggie and tags.veggie >= 0.5 and not tags.inedible end,
	-- 	priority = 1,
	-- 	foodtype = FOODTYPE.VEGGIE,
	-- 	health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_MED,
	-- 	perishtime = TUNING.PERISH_SLOW,
	-- 	sanity = TUNING.SANITY_TINY,
	-- 	cooktime = 1,
    --     floater = {"med", nil, 0.68},
    --     card_def = {ingredients = {{"fennel", 2}, {"carrot", 2}} },
    -- },

}

for k, v in pairs(foods_ham) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.overridebuild = overridebuild_ham 
    v.floater = v.floater or {"small", 0.05, 0.7}
    v.mod = true
    -- v.cookbook_tex = k..".tex" --独立贴图用这个
    v.cookbook_atlas = cookbook_atlas_ham
    v.atlasname = v.atlasname or inventoryitems_atlas_ham
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_ham
