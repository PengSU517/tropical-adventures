-- 食谱
local foods_tropical = {
    butterflymuffin = {
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
        perishtime = TUNING.PERISH_SLOW,
        cooktime = 2,
        floater = {"small", 0.05, 0.7},
        tags = {},
        cookbook_atlas = "images/cookbook_" .. "butterflymuffin" .. ".xml",
        cookbook_category = "cookpot", -- 万一生效了呢
        mod = false, -- 覆盖料理标记
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
        health = 3,
        hunger = 75 / 8,
        sanity = -5,
        perishtime = TUNING.PERISH_MED,
        cooktime = .5,
        tags = {},
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
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
        end
    },

    sharkfinsoup = {
        test = function(cooker, names, tags)
            return names.shark_fin
        end,
        priority = 20,
        weight = 1,
        foodtype = "MEAT",
        health = 40,
        hunger = 75 / 6,
        perishtime = 10 * 480,
        sanity = -10,
        -- naughtiness = 10, -- 无效
        cooktime = 1,
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
    },

    lobsterdinner = {
        test = function(cooker, names, tags)
            return
                (names.lobster_dead or names.wobster_sheller_land or names.lobster_dead_cooked or names.lobster_land) and
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
        floater = {"med", 0.05, {0.65, 0.6, 0.65}},
        cookbook_atlas = "images/cookbook_" .. "lobsterdinner" .. ".xml",
        cookbook_category = "cookpot",
        mod = false,
    },

    lobsterbisque = {
        test = function(cooker, names, tags)
            return
                (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land or names.wobster_sheller_land) and
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
        floater = {"med", 0.05, {0.65, 0.6, 0.65}},
        cookbook_atlas = "images/cookbook_" .. "lobsterbisque" .. ".xml",
        cookbook_category = "cookpot",
        mod = false,
    },

    jellyopop = {
        test = function(cooker, names, tags)
            return tags.jellyfish and tags.frozen and tags.inedible
        end,
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
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
    },

    californiaroll = {
        test = function(cooker, names, tags)
            return
                ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0) + (names.seaweed or 0)) == 2 and
                    (tags.fish and tags.fish >= 1)
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
        floater = {"med", 0.05, {0.65, 0.6, 0.65}},
        cookbook_category = "cookpot",
        cookbook_atlas = "images/cookbook_" .. "californiaroll" .. ".xml",
        mod = false,
    },

    bisque = {
        test = function(cooker, names, tags)
            return names.limpets and names.limpets == 3 and tags.frozen
        end,
        priority = 30,
        weight = 1,
        foodtype = "MEAT",
        health = 60,
        hunger = 75 / 4,
        perishtime = 10 * 480,
        sanity = 5,
        cooktime = 1,
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
    },

    caviar = {
        test = function(cooker, names, tags)
            return (names.roe or names.roe_cooked == 3) and tags.veggie
        end,
        priority = 20,
        weight = 1,
        foodtype = "MEAT",
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_LARGE,
        cooktime = 2,
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
    },

    tropicalbouillabaisse = {
        test = function(cooker, names, tags)
            return (names.fish3 or names.fish3_cooked) and (names.fish4 or names.fish4_cooked) and
                       (names.fish5 or names.fish5_cooked) and tags.veggie
        end,
        priority = 35,
        weight = 1,
        foodtype = "MEAT",
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
        oneatenfn = function(inst, eater)
            if eater and eater.components.temperature then
                local current_temp = eater.components.temperature:GetCurrent()
                local new_temp = math.max(current_temp - 8, TUNING.STARTING_TEMP)
                eater.components.temperature:SetTemperature(new_temp)
            end
            if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
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

        end
    },

    feijoada = {
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
    },

    steamedhamsandwich = {
        test = function(cooker, names, tags)
            return (names.meat or names.meat_cooked) and (tags.veggie and tags.veggie >= 2) and names.foliage
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
    },

    hardshell_tacos = {
        test = function(cooker, names, tags)
            return (names.weevole_carapace == 2) and tags.veggie
        end,
        priority = 1,
        weight = 1,
        foodtype = "VEGGIE",
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_SLOW,
        sanity = TUNING.SANITY_TINY,
        cooktime = 1,
        cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
    },

    gummy_cake = {
        test = function(cooker, names, tags)
            return (names.slugbug or names.slugbug_cooked) and tags.sweetener
        end,
        priority = 1,
        weight = 1,
        foodtype = "MEAT",
        health = -TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SUPERHUGE,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = -TUNING.SANITY_TINY,
        cooktime = 2,
        cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
        tags = {"honeyed"},
    },

    tea = {
        test = function(cooker, names, tags)
            return tags.filter and tags.filter >= 2 and tags.sweetener and not tags.meat and not tags.veggie and
                       not tags.inedible
        end,
        priority = 25,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_ONE_DAY,
        sanity = TUNING.SANITY_LARGE,
        temperature = 40,
        temperatureduration = 10,
        cooktime = 0.5,
        cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
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
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 17/12)
            end
        end
    },

    icedtea = {
        test = function(cooker, names, tags)
            return tags.filter and tags.filter >= 2 and tags.sweetener and tags.frozen
        end,
        priority = 30,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_SMALL,
        perishtime = TUNING.PERISH_FAST,
        sanity = TUNING.SANITY_LARGE,
        temperature = -40,
        temperatureduration = 10,
        cooktime = 0.5,
        cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
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
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 23/18)
            end
        end
    },

    snakebonesoup = {
        test = function(cooker, names, tags)
            return tags.bone and tags.bone >= 2 and tags.meat and tags.meat >= 2
        end,
        priority = 20,
        weight = 1,
        foodtype = "MEAT",
        health = TUNING.HEALING_LARGE,
        hunger = TUNING.CALORIES_MED,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_SMALL,
        cooktime = 1,
    	cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
},

    nettlelosange = {
        test = function(cooker, names, tags)
            return tags.antihistamine and tags.antihistamine >= 3
        end,
        priority = 0,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_MED,
        perishtime = TUNING.PERISH_FAST,
        sanity = TUNING.SANITY_TINY,
        antihistamine = 720,
        cooktime = .5,
        cookbook_atlas = "images/inventoryimages/hamletinventory.xml",
        oneatenfn = function(inst, eater)
            if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 19000
            end
        end
    },

    meated_nettle = {
        test = function(cooker, names, tags)
            return (tags.antihistamine and tags.antihistamine >= 2) and (tags.meat and tags.meat >= 1) and
                       (not tags.monster or tags.monster <= 1) and not tags.inedible
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
        oneatenfn = function(inst, eater)
            if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 16000
            end
        end
    },

    musselbouillabaise = {
        test = function(cooker, names, tags)
            return names.mussel and names.mussel == 2 and tags.veggie and tags.veggie >= 2
        end,
        priority = 30,
        weight = 1,
        foodtype = "MEAT",
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        tags = {"masterfood"},
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
        isMasterfood = true -- Runar:热带大厨料理标记
    },

    sweetpotatosouffle = {
        test = function(cooker, names, tags)
            return names.sweet_potato and names.sweet_potato == 2 and tags.egg and tags.egg >= 2
        end,
        priority = 30,
        weight = 1,
        foodtype = "VEGGIE",
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        perishtime = TUNING.PERISH_MED,
        sanity = TUNING.SANITY_MED,
        cooktime = 2,
        tags = {"masterfood"},
        cookbook_atlas = "images/inventoryimages/volcanoinventory.xml",
        isMasterfood = true,
    }
}

for k, v in pairs(foods_tropical) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
	v.overridebuild = k
    v.floater = v.floater or {"small", 0.05, 0.7}
    if v.mod == nil then
        v.mod = true
        -- v.cookbook_tex = k..".tex" --独立贴图用这个
        -- v.cookbook_atlas = "images/inventoryimages/"..k..".xml"
    end
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_tropical
