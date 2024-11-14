----需要做的内容
--  毒蜘蛛


local natureskins = {
    sapling = {
        default = {},
        sapling_green = {
            build = "sapling",
            assetname = "sapling", --这个是防止注册没有的asset
            skintype = "tropical",
            extra_init_fn = function(inst, skinname) CancelNoGrowInWinter(inst) end,
            extra_clear_fn = function(inst, skinname) MakeNoGrowInWinter(inst) end,
        },
    },

    grass = {
        default = { basebuild = "grass1", base_minimapicon = "grass.png" },
        grass_green = {
            build = "grassgreen_build",
            image = "grassGreen",
            skintype = "tropical",
            extra_init_fn = function(inst, skinname) CancelNoGrowInWinter(inst) end,
            extra_clear_fn = function(inst, skinname) MakeNoGrowInWinter(inst) end,
        },
    },

    dug_grass = {
        default = { basebuild = "grass1", },
        dug_grass_green = {
            build = "grassgreen_build",
            image = "dug_grass_green",
            skintype = "tropical",
        },
    },

    cutgrass = {
        default = {
            basebuild = "cutgrass",
        },
        cutgrass_green = {
            build = "cutgrassgreen",
            image = "cutgrass_green",
            sourceprefabs = { "grass_tall", "grassdwater" },
            skintype = "tropical",
        },
    },

    grasspartfx = {
        default = { basebuild = "grass1" },
        grasspartfx_tropical = { build = "grassgreen_build", skintype = "tropical", },
    },

    -- grasswater = {
    --     default = {
    --         base_minimapicon = "grass.png",skintype = "tropical",
    --         baseoverride = { { "grass_pieces", "grass1", "grass_pieces" }, },
    --     },
    --     grass_water_green = {
    --         build = "grassgreen_build",
    --         image = "grassGreen", skintype = "tropical",
    --         override = { { "grass_pieces", "grassgreen_build", "grass_pieces" },
    --         },

    --     },
    -- },

    krampus = {
        default = { basebuild = "krampus_build" },
        krampus_hawaiian = { build = "krampus_hawaiian_build", skintype = "tropical", },
    },

    butterfly = {
        default = { basebuild = "butterfly_basic" },
        butterfly_tropical = { build = "butterfly_tropical_basic", image = "butterfly_tropical", skintype = "tropical", },
    },

    butterflywings = {
        default = { basebuild = "butterfly_wings", basebank = "butterfly_wings", },
        butterfly_tropical_wings = {
            build = "butterfly_tropical_wings",
            bank = "butterfly_tropical_wings",
            image = "butterflywings_tropical",
            skintype = "tropical",
        },
    },

    -- butterflymuffin = {
    --     default = { basebuild = "cook_pot_food", basebank = "cook_pot_food", },
    --     butterflymuffin_sw = {
    --         build = "cook_pot_food_sw",
    --         skintype = "tropical",
    --     },
    -- },



    log = {
        default = {
            basebuild = "log",
        },
        log_tropical = {
            build = "log_tropical",
            image = "log_tropical",
            sourceprefabs = { "palmtree", "jungletree", "mangrovetree", "livingjungletree", "leif_palm", "leif_jungle", },
            skintype = "shipwrecked",

        },

        log_rainforest = {
            build = "log_rainforest",
            image = "log_rainforest",
            sourceprefabs = { "teatree", "teatree_piko_nest", "rainforesttree", },
            skintype = "hamlet",

        }
    },

    cave_banana = { --香蕉树有没有build啊
        default = {
            basebuild = "cave_banana",

        },
        bananas_tropical = {
            build = "bananas",
            image = "bananas",
            sourceprefabs = { "primeape", "primeapebarrel", "jungletree", "bananabush", "spider_ape", "rainforesttree",
                "tree_forest_deep", "tree_forest_rot", "tree_forest", }, ---三种丛林树
            skintype = "tropical",
        },
    },

    cave_banana_cooked = { ----这个为什么没动画了
        default = { basebuild = "cave_banana", },
        cave_banana_cooked_tropical = {
            build = "bananas",
            image = "bananas_cooked",
            skintype = "tropical",
        },
    },

    resurrectionstone = {
        default = { basebuild = "resurrection_stone", basebank = "resurrection_stone" },
        resurrectionstone_tropical = { build = "resurrection_stone_sw", bank = "resurrection_stone_sw", skintype = "tropical", },
    },

    snakeskin = {
        default = { basebank = "snakeskin", basebuild = "snakeskin" },
        snakeskin_scaly = { build = "snakeskin_scaly", bank = "snakeskin_scaly", image = "snakeskin_scaly", skintype = "tropical", }
    },

    pigskin = {
        default = { basebank = "pigskin", basebuild = "pigskin" },
        bat_leather = {
            build = "bat_leather",
            bank = "bat_leather",
            image = "bat_leather",
            sourceprefabs = { "circlingbat", "vampirebat" },
            -- skintype = "shipwrecked",
        }
    },

    pighead = {
        default = { basebank = "pig_head", basebuild = "pig_head" },
        wildbore_head = { build = "wildbore_head", bank = "wildbore_head", skintype = "shipwrecked", }
    },



}


local testfns = {
    tropical = IsInTropicalArea,
    shipwrecked = IsInShipwreckedArea,
    hamlet = IsInHamletArea,
}


for prefabname, prefabdata in pairs(natureskins) do
    for skinname, skindata in pairs(prefabdata) do
        if skinname ~= "default" then
            skindata = tabel.deep_merge(skindata, prefabdata.default) or skindata
            skindata.prefabname = skindata.prefabname or prefabname
            skindata.skinname = skindata.skinname or skinname

            skindata.build = skindata.build or skindata.skinname
            skindata.image = skindata.image or skindata.skinname

            --显示的字符串
            skindata.name = skindata.name or skindata.skinname
        end
    end
end

for prefabname, prefabdata in pairs(natureskins) do
    prefabdata.default = nil ----赋值给皮肤base数据之后就没啥用了
end

return { skinlist = natureskins, testfns = testfns }
