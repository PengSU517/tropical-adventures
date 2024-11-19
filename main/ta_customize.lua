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

local ta_customize_table = {
    ta_worldgen = {
        order = 1.1,
        text = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船"),
        category = LEVELCATEGORY.WORLDGEN,
        items = {
            {
                name = "rog",
                label = en_zh("Region of Gaints", "巨人国"),
                desc = {
                    { text = en_zh("Default", "默认"), data = "default" },
                    { text = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"), data = false },
                },
                value = "default",
                order = 1,
                image = "deerclops.tex",
                atlas = dst_atlas,
                world = { "forest" },
            },

            {
                name = "shipwrecked",
                label = en_zh("Shipwrecked", "海难"),
                desc = options_enable,
                value = true,
                order = 2,
                image = "birds.tex",
                atlas = sw_atlas,
                world = { "forest" }
            },

            {
                name = "hamlet",
                label = en_zh("Hamlet", "哈姆雷特"),
                desc = options_enable,
                value = true,
                order = 3,
                image = "pig_houses.tex",
                atlas = ham_atlas,
                world = { "forest" }
            },



            {
                name = "startlocation",
                label = en_zh("Florid postern location", "绚丽之门位置"),
                desc = {
                    { text = en_zh("Default", "默认"), data = "default" },
                    { text = en_zh("Shipwrecked region", "海难区域"), data = "shipwrecked" },
                    { text = en_zh("Hamlet region", "哈姆雷特区域"), data = "hamlet" },

                },
                value = "hamlet",
                order = 4,
                image = "spawnmode.tex",
                atlas = dstset_atlas,
                world = { "forest" }
            },

            {
                name = "worldsize",
                label = en_zh("World size multiplier", "世界大小乘数"),
                desc = {
                    { text = en_zh("Default, 1×", "默认, 1×"), data = 1 },
                    { text = en_zh("Larger, 1.25×", "更大, 1.25×"), data = 1.25 },
                    { text = en_zh("Huger, 1.5×", "巨大, 1.5×"), data = 1.5 },

                },
                value = 1,
                order = 5,
                image = "world_size.tex",
                atlas = dst_atlas,
                world = { "forest", "cave" }
            },

            {
                name = "coastline",
                label = en_zh("Coastline", "海岸线"),
                hover = en_zh("Coastline", "海岸线"),
                desc = {
                    { text = en_zh("Smoother", "更平滑的海岸线"), data = true },
                    { text = en_zh("Default", "默认"), data = false },

                },
                value = true,
                order = 6,
                image = "blank_world.tex",
                atlas = sw_atlas,
                world = { "forest" }
            },
        }


    },

    ta_climate = {
        order = -1,
        text = en_zh(" Tropical Adventures climate", "热带冒险气候"),
        category = LEVELCATEGORY.SETTINGS,
        items = {
            {
                name = "wind",
                label = en_zh("Wind", "海风"),
                desc = options_enable,
                value = true,
                order = 11,
                image = "blank_world.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "hail",
                label = en_zh("Hail", "冰雹"),
                desc = options_enable,
                value = true,
                order = 12,
                image = "blank_world.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "waves",
                label = en_zh("Waves", "海浪"),
                desc = options_enable,
                value = true,
                order = 13,
                image = "waves.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "flood",
                label = en_zh("Flood", "洪水"),
                desc = options_enable,
                value = false,
                order = 14,
                image = "floods.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "volcano",
                label = en_zh("Volcano Eruption", "火山喷发"),
                desc = options_enable,
                value = false,
                order = 15,
                image = "volcano.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "sealnado",
                label = en_zh("sealnado", "豹卷风"),
                desc = options_enable,
                value = true,
                order = 16,
                image = "twister.tex",
                atlas = sw_atlas,
                world = { "forest" },
            },

            {
                name = "fog",
                label = en_zh("Fog", "雾"),
                desc = options_enable,
                value = true,
                order = 17,
                image = "fog.tex",
                atlas = ham_atlas,
                world = { "forest" },
            },

            {
                name = "hayfever",
                label = en_zh("Hayfever", "花粉过敏"),
                desc = options_enable,
                value = false,
                order = 18,
                image = "hayfever.tex",
                atlas = ham_atlas,
                world = { "forest" },
            },

            {
                name = "aporkalypse",
                label = en_zh("Aporkalypse", "毁灭季"),
                desc = options_enable,
                value = true,
                order = 19,
                image = "aporkalypse.tex",
                atlas = ham_atlas,
                world = { "forest" },
            },

            {
                name = "roc",
                label = en_zh("ROC", "大鹏"),
                desc = options_enable,
                value = true,
                order = 20,
                image = "roc.tex",
                atlas = ham_atlas,
                world = { "forest" },
            },
        }
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
