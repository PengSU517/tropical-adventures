-----世界设置里的值不能是false,否则会用默认设置，所以modinfo最好保持同步
---全局的locale只在modinfo中存在，在servercreationmain中需要用translator
local locale = LanguageTranslator.defaultlang

-- local function en_zh(en, zh)
--     return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
-- end

local lang = "en"
local function en_zh(en, zh) -- Other languages don't work
    local chinese_languages =
    {
        zh = "zh",      -- Chinese for Steam
        zhr = "zh",     -- Chinese for WeGame
        ch = "zh",      -- Chinese mod
        chs = "zh",     -- Chinese mod
        chinese = "zh", -- Chinese mod
        sc = "zh",      -- simple Chinese
        zht = "zh",     -- traditional Chinese for Steam
        tc = "zh",      -- traditional Chinese
        cht = "zh",     -- Chinese mod
    }

    if chinese_languages[locale] ~= nil then
        lang = chinese_languages[locale]
    end

    return lang == "zh" and zh or en
end

local options_enable = {
    { description = en_zh("Enabled", "开启"), data = "enabled" },
    { description = en_zh("Disabled", "关闭"), data = "disabled" },

}

local options_enable2 = {
    { description = en_zh("Disabled", "关闭"), data = "disabled" },
}

local dstgen_atlas = "images/worldgen_customization.xml"
local dstset_atlas = "images/worldsettings_customization.xml"
local dst_atlas = "images/customisation.xml"
local sw_atlas = "images/hud/customization_shipwrecked.xml"
local ham_atlas = "images/hud/customization_porkland.xml"


local worldgen_options = {
    {
        name = "rog",
        label = en_zh("Region of Gaints", "巨人国"),
        hover = en_zh("Mainland,  and Together Caves", "联机大陆,月岛和联机洞穴"),
        options =
        {
            {
                description = en_zh("Default", "默认"),
                hover = en_zh("Default settings with 5 random tasks", "默认设置,有五个随机地形"),
                data = "default"
            },

            {
                description = en_zh("Fxied Random Tasks", "固定的随机地形"),
                hover = en_zh("KillerBees, Walrus, PigVillage, Frogs&Bugs, SpiderRocks", "杀人蜂,海象,小猪村,青蛙蜜蜂,蜘蛛矿"),
                data = "fixed"
            },

            {
                description = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
                hover = en_zh(
                    "only works when enabling at least one another region and set it as start location",
                    "需要开启至少一个其他区域并设为出生地时此项才能生效"),
                data = "disabled"
            },

        },
        default = "fixed",

        order = 1,
        image = "deerclops.tex",
        atlas = dst_atlas,
        world = { "forest" },
    },



    {
        name = "shipwrecked",
        label = en_zh("Shipwrecked", "海难"),
        hover = en_zh("Shipwrecked", "海难"),
        options = options_enable,
        default = "enabled",

        order = 2,
        image = "birds.tex",
        atlas = sw_atlas,
        world = { "forest" }


    },

    {
        name = "hamlet",
        label = en_zh("Hamlet", "哈姆雷特"),
        hover = en_zh("Hamlet", "哈姆雷特"),
        options = options_enable,
        default = "enabled",
        order = 3,
        image = "pig_houses.tex",
        atlas = ham_atlas,
        world = { "forest" }
    },

    {
        name = "ocean_content",
        label = en_zh("DST Ocean Contents", "联机海洋内容"),
        hover = en_zh("MoonIslands, Crabs and Waterlogs, etc", "月岛，螃蟹们和水中木等等"),
        options = options_enable,

        default = "enabled",
        order = 4,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "forest" }
    },

    -- {
    --     name = "ocean_style",
    --     label = en_zh("Ocean style", "海洋风格"),
    --     hover = en_zh("Ocean Style", "海洋风格"),
    --     options =
    --     {
    --         {
    --             description = en_zh("Default", "默认"),
    --             hover = en_zh("DST ocean", "联机海洋"),
    --             data = "default"
    --         },
    --         {
    --             description = en_zh("Shipwrecked Style", "海难风格"),
    --             hover = en_zh("Shipwrecked stylized tropical ocean", "海难风格的热带海洋"),
    --             data = "tropical"
    --         },
    --     },
    --     default = "default",
    --     order = 4.5,
    --     image = "blank_world.tex",
    --     atlas = sw_atlas,
    --     world = { "forest" }

    -- },

    {
        name = "cave_content",
        label = en_zh("Together Caves", "联机洞穴内容"),
        options =
        {
            {
                description = en_zh("Default", "默认"),
                hover = en_zh("Default settings", "默认设置"),
                data = "default"
            },

            {
                description = en_zh("No ladder", "没有楼梯"),
                hover = en_zh("No ladder", "没有楼梯"),
                data = "part"
            },

            -- {
            --     description = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
            --     hover = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
            --     data = "disabled"
            -- },

        },
        default = "default",
        order = 5,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "cave" }

    },

    {
        name = "ruins",
        label = en_zh("Pig Ruins", "猪人遗迹"),
        options = options_enable,
        default = "enabled",
        order = 5.5,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "cave" }

    },

    {
        name = "multiplayerportal",
        label = en_zh("Florid Postern location", "绚丽之门位置"),
        hover = en_zh("Florid Postern location", "绚丽之门位置"),
        options =
        {
            {
                description = en_zh("Default", "默认"),
                hover = en_zh("Default (Together Mainland)", "默认(联机大陆)"),
                data = "rog"
            },
            {
                description = en_zh("Shipwrecked region", "海难区域"),
                hover = en_zh("Shipwrecked region, need corresponding region enabled", "海难区域，需开启相应地形"),
                data = "shipwrecked"
            },
            {
                description = en_zh("Hamlet region", "哈姆雷特区域"),
                hover = en_zh("Hamlet region, need corresponding region enabled", "哈姆雷特区域，需开启相应地形"),
                data = "hamlet"
            },

        },
        default = "hamlet",
        order = 6,
        image = "spawnmode.tex",
        atlas = dstset_atlas,
        world = { "forest" }
    },




    {
        name = "world_size_multi",
        label = en_zh("World size multi", "世界大小乘数"),
        hover = en_zh("World size multi", "世界大小乘数"),
        options =
        {
            {
                description = en_zh("Tiny, 0.5×", "极小 , 0.5×"),
                data = 0.5
            },
            {
                description = en_zh("Smaller, 0.75×", "更小, 0.75×"),
                data = 0.75
            },
            {
                description = en_zh("Default, 1×", "默认, 1×"),
                data = 1
            },
            {
                description = en_zh("Larger, 1.25×", "更大, 1.25×"),
                data = 1.25
            },
            {
                description = en_zh("Huger, 1.5×", "巨大, 1.5×"),
                data = 1.5
            },

        },
        default = 1.25,
        order = 8,
        image = "world_size.tex",
        atlas = dst_atlas,
        world = { "forest", "cave" }
    },

    {
        name = "coastline",
        label = en_zh("Coastline", "海岸线"),
        hover = en_zh("Coastline", "海岸线"),
        options =
        {
            {
                description = en_zh("Smoother", "更平滑的海岸线"),
                hover = en_zh("Not seperating tasks", "不分离土地, 岛屿有可能粘连在一起"),
                data = "enabled"
            },
            {
                description = en_zh("Default", "默认"),
                hover = en_zh("Default settings", "默认设置"),
                data = "disabled"
            },

        },
        default = "enabled",
        order = 9,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "forest" }
    },

    -- {
    --     name = "layout",
    --     label = en_zh("Layout adjustment", "布局调整"),
    --     hover = en_zh("Layout adjustment", "如大理石雕像、猴岛、寄居蟹岛、帝王蟹的位置调整"),
    --     options = options_enable,
    --     default = "enabled",
    -- },
}


local climate_options = {

    -- {
    --     name = "startlocation",
    --     label = en_zh("Start location", "出生地"),
    --     hover = en_zh("Start location", "出生地"),
    --     options =
    --     {
    --         {
    --             description = en_zh("Florid Postern", "绚丽之门"),
    --             hover = en_zh("Florid Postern", "绚丽之门"),
    --             data = "default"
    --         },
    --     },
    --     default = "default",
    --     order = 7,
    --     image = "spawnmode.tex",
    --     atlas = dstset_atlas,
    --     world = { "forest" }

    -- },

    {
        name = "wind",
        label = en_zh("Wind", "海风"),
        hover = en_zh("Wind", "海风"),
        options = options_enable,
        default = "enabled",
        order = 11,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "hail",
        label = en_zh("Hail", "冰雹"),
        hover = en_zh("Hail", "冰雹"),
        options = options_enable,
        default = "enabled",
        order = 12,
        image = "blank_world.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "waves",
        label = en_zh("Waves", "海浪"),
        hover = en_zh("Waves", "海浪"),
        options = options_enable,
        default = "enabled",
        order = 13,
        image = "waves.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "flood",
        label = en_zh("Flood", "洪水"),
        hover = en_zh("Flood", "洪水"),
        options = options_enable2,
        default = "disabled",
        order = 14,
        image = "floods.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "volcano",
        label = en_zh("Volcano Eruption", "火山喷发"),
        hover = en_zh("Volcano Eruption", "火山喷发"),
        options = options_enable2,
        default = "disabled",
        order = 15,
        image = "volcano.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "sealnado",
        label = en_zh("sealnado", "豹卷风"),
        hover = en_zh("Twister", "豹卷风"),
        options = options_enable,
        default = "enabled",
        order = 16,
        image = "twister.tex",
        atlas = sw_atlas,
        world = { "forest" },
    },

    {
        name = "fog",
        label = en_zh("Fog", "雾"),
        hover = en_zh("Fog", "雾"),
        options = options_enable,
        default = "enabled",
        order = 17,
        image = "fog.tex",
        atlas = ham_atlas,
        world = { "forest" },
    },

    {
        name = "hayfever",
        label = en_zh("Hayfever", "花粉过敏"),
        hover = en_zh("Hayfever", "花粉过敏"),
        options = options_enable,
        default = "disabled",
        order = 18,
        image = "hayfever.tex",
        atlas = ham_atlas,
        world = { "forest" },
    },

    {
        name = "aporkalypse",
        label = en_zh("Aporkalypse", "毁灭季"),
        hover = en_zh("Aporkalypse, but in caves", "毁灭季 但是在洞穴"),
        options = options_enable,
        default = "enabled",
        order = 19,
        image = "aporkalypse.tex",
        atlas = ham_atlas,
        world = { "forest", "cave" },
    },

    {
        name = "roc",
        label = en_zh("ROC", "大鹏"),
        hover = en_zh("Big Friendly Bird", "友好大鸟"),
        options = options_enable,
        default = "enabled",
        order = 20,
        image = "roc.tex",
        atlas = ham_atlas,
        world = { "forest" },
    },

}


local ta_customization = {
    worldgen_options = worldgen_options,
    climate_options = climate_options,
}
for i1, v1 in pairs(ta_customization) do
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


return ta_customization
