local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
local sort_order = require("prefabs/fertilizer_nutrient_defs").SORTED_FERTILIZERS

local SW_FERTILIZER_DEFS = {}

SW_FERTILIZER_DEFS.spoiled_fish_large = {nutrients = TUNING.SPOILED_FISH_LARGE_NUTRIENTS, uses = 1}
SW_FERTILIZER_DEFS.mysterymeat = {nutrients = TUNING.MYSTERYMEAT_NUTRIENTS, uses = 1}

SW_FERTILIZER_DEFS.spoiled_fish_large.inventoryimage = "spoiled_fish_large.tex"
SW_FERTILIZER_DEFS.mysterymeat.inventoryimage = "soil_amender_stale.tex"

SW_FERTILIZER_DEFS.spoiled_fish_large.name = "SPOILED_FISH_LARGE"
SW_FERTILIZER_DEFS.mysterymeat.name = "MYSTERYMEAT"

local sw_sort_order =
{
	spoiled_fish_large = "spoiled_fish",
    mysterymeat = "spoiled_fish_small",
}

for fertilizer, data in pairs(SW_FERTILIZER_DEFS) do
    if data.inventoryimage == nil then
        data.inventoryimage = fertilizer..".tex"
    end

    if data.name == nil then
        data.name = string.upper(fertilizer)
    end

    if data.uses == nil then
        data.uses  = 1
    end

    if fertilizer and data then
        FERTILIZER_DEFS[fertilizer] = data
        local sort_data = sw_sort_order[fertilizer]
        if sort_data and type(sort_data) == "string" then
            for i,name in ipairs(sort_order) do
                if name == sort_data then
                    table.insert(sort_order, i+1 , fertilizer)
                    break
                end
            end
        elseif sort_data and type(sort_data) == "number" then
            table.insert(sort_order, sort_data, fertilizer)
        else
            table.insert(sort_order, fertilizer)
        end
    end
end
