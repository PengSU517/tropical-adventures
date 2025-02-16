modimport("modinfo")

local locale = LanguageTranslator.defaultlang

local function en_zh(en, zh)
    return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

local LEVELCATEGORY = LEVELCATEGORY
local dstgen_atlas = "images/worldgen_customization.xml"
local dstset_atlas = "images/worldsettings_customization.xml"
local dst_atlas = "images/customisation.xml"
local sw_atlas = "images/hud/customization_shipwrecked.xml"
local ham_atlas = "images/hud/customization_porkland.xml"


local options_enable = {
    { text = en_zh("Disabled", "关闭"), data = false },
    { text = en_zh("Enabled", "开启"), data = true },
}

local worldgen_customization = deepcopy(worldgen_options)
local climate_customization = deepcopy(climate_options)
local ta_customization = { worldgen_customization, climate_customization }
for i1, v1 in ipairs(ta_customization) do
    for i2, v2 in ipairs(v1) do
        -- print(v2.name or "can not find the name")
        v2.desc = v2.options
        v2.value = v2.default
        if v2.desc then
            for i3, v3 in ipairs(v2.desc) do
                v3.text = v3.description
            end
        end
    end
end

local ta_customize_table = {
    ta_worldgen = {
        order = 1.1,
        text = en_zh(" Tropical Adventures | Ship of Theseus", "热带冒险 | 忒修斯之船"),
        category = LEVELCATEGORY.WORLDGEN,
        items = worldgen_customization
    },

    ta_climate = {
        order = -1,
        text = en_zh(" Tropical Adventures climates", "热带冒险气候"),
        category = LEVELCATEGORY.SETTINGS,
        items = climate_customization,
    }

}



local function add_group_and_item(category, name, text, desc, atlas, order, items)
    if text then
        AddCustomizeGroup(category, name, text or "ooo", desc, atlas, order)
    end
    if items then
        for _, v in ipairs(items) do
            STRINGS.UI.CUSTOMIZATIONSCREEN[string.upper(v.name)] = v.label
            AddCustomizeItem(category, name, v.name, v)
        end
    end
end

for name, data in pairs(ta_customize_table) do
    add_group_and_item(data.category, name, data.text, data.desc, data.atlas, data.order, data.items)
end



------world setting overrides ----这个 东西是加载世界时执行的东西，对生成世界无效
-- local WSO = require("worldsettings_overrides")
-- WSO.Pre.coastline = function(difficulty)
--     TUNING.coastline = difficulty
--     print("set coastline11111111")
-- end
