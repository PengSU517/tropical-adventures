local WikiDesc = {
    -- 机制
    generation = {
        world = {
            name = "世界设置",
            intro = [[本mod中只保留了[海难]和[哈姆雷特]部分，
                    玩家可以在同一个世界中同时游玩联机原版内容，
                    海难和哈姆雷特的内容（[无需跳世界]）。
                    ----------------
                    世界的默认出生区域为[哈姆雷特]。
                    大理石布景会在全图随机刷新。
                    其他布景，如舞台之手，拾荒疯猪，小丑牌等内容会刷新在出生地所在的区域。
                    ----------------
                    客户端生成世界时，请通过[森林、洞穴设置界面]进行调整。
                    服务器开服时，没有相关设置，请通过[客户端生成世界]，再上传至服务器。]]
        },
        seasons = {
            name = "季节",
            intro = [[季节随着[地区变化]，巨人国地区为春夏秋冬，
                    海难地区为平风雨旱，
                    哈姆雷特为温和、雾季、繁茂季。
                    ----------------
                    [滤镜]、[音乐]等会随着地区和季节进行切换。]]
        },

        bundled_structure = {
            intro = [[将[playerhouse_city]或者其他带有内部空间的[商店]
                    通过[锤击]打包成[bundled_structure]。
                    [bundled_structure]会保存所有房屋中的物品。
                    ----------------
                    重新将[bundled_structure]放置在地上即可获得之前的房产，实现房屋搬迁。
                    注意！！！这个操作[不能跨世界]。
            ]]
        },
        volcano = {
            name = "火山",
            intro = [[火山目前作为地上世界的[独立岛屿]存在，火山的[温度]会显著高于其他地区。
                    ----------------
                    [火山喷发]机制尚未完善，目前不会自然喷发。]]
        },
        waves = {
            name = "海浪",
            intro = [[海浪会拍动[船]，但是更好的船只和[保险杠]会降低海浪的影响，
                    各种船和保险杠的破浪效率，详见[船（联机）]部分介绍。]]
        },

        floods = {
            name = "洪水",
            intro = [[洪水机制尚待完善，目前已移除。]]
        },
        ruins = {
            name = "遗迹",
            intro = [[遗迹不再是地上生成的房间迷宫，而是[生成在地下]，与远古[档案馆]类似的迷宫系统。
                    ----------------
                    遗迹附近的[CAVE_EXIT]通向[蛇岛（兼毒岛）]。通过地下的哈姆雷特地区，与联机洞穴的[绿蘑菇林]相连接。]]
        },

        anthill = {
            name = "蚁穴",
            intro = [[蚁穴不再是地上生成的房间迷宫，而是洞穴中的一片区域。
                    ----------------
                    蚁穴附近的[CAVE_EXIT]通向[皇城]。通过地下哈姆雷特地区与联机洞穴的[绿蘑菇林]相连接。]]
        },

        aporkalypse = {
            name = "毁灭季",
            intro = [[默认情况下，世界天数120天时会开启毁灭季。
                    毁灭季降临时世界都会变为血红色。
                    [地下]每过一段时间会生成[ancient_herald]和[vampirebat]，[地上]只会生成[vampirebat]。
                    ----------------
                    [aporkalypse_clock]在洞穴的[哈姆雷特遗迹迷宫]深处，通过转动[aporkalypse_clock]停止毁灭季。
                    ----------------
                    请注意毁灭季需要地上和地下协同作用，与[独行长路]存在冲突。]]
        },
    },

    -- 建筑类 (含所有商店)
    structures = {
        pugalisk_fountain = {
            intro = [[ [月圆时]如果世界中不存在存活的[pugalisk]，月光则会重新充盈[pugalisk_fountain]，
                    玩家从[pugalisk_fountain]取走[waterdrop]后，[pugalisk_fountain]会生成一只[pugalisk]。
                    ----------------
                    [waterdrop]可种植，有回复精神值效果。
                    ----------------
                    击杀[pugalisk]会掉落[pugalisk_fountain]的制作蓝图。
                    ----------------
                    人工制作的[pugalisk_fountain]有更强大的力量，效果包括降温，避雷避雨和回复精神值。]]
        },
        pig_palace = {
            intro = [[主殿内的[pigman_queen]可以进行交易换取[pedestal_key]。
                    可使用[pedestal_key]在侧殿的展柜换取一系列珍惜道具。
                    例如[key_to_city]，[city_hammer]，[TRINKET_GIFTSHOP_4]。]]
        },
        pig_shop_cityhall = {
            intro = [[[pigman_mayor]作为交易NPC，接受[goldnugget]、[oinc]、[dubloon]等材料。
                    ----------------
                    在市政厅内也可通过展柜换取[deed]、[securitycontract]等内容。]]
        },
        playerhouse_city = {
            intro = [[室内可通过[室内科技]制作物品，对房屋的内饰和外观进行升级。]]
        },
        pig_shop_deli = {
            intro = [[售卖高级料理。包括[ratatouille]、[meatballs]以及昂贵的[dragonpie]。
                    ----------------
                    是储备高性价比食物的好去处。]]
        },
        pig_shop_general = {
            intro = [[提供基础工具。售卖[axe]、[pickaxe]、[minerhat]以及[umbrella]。
                    ----------------
                    同时也出售[fabric]、[flint]等常用生活物资。]]
        },
        pig_shop_hoofspa = {
            intro = [[城镇药店。提供[healingsalve]、[bandage]和[antivenom]。
                    ----------------
                    如果你有足够的钱，甚至能买到[lifeinjector]。]]
        },
        pig_shop_produce = {
            intro = [[售卖新鲜的食材，如[meat]、[eggplant]、[pumpkin]和[watermelon]。
                    ----------------
                    适合买回营地配合烹饪锅制作料理。]]
        },
        pig_shop_florist = {
            intro = [[售卖植物种子和草木。包括[corn_seeds]、[pumpkin_seeds]和[dug_berrybush]。
                    ----------------
                    这里也提供[flowerhat]和各色装饰性植物。]]
        },
        pig_shop_antiquities = {
            intro = [[哈姆雷特最珍贵的商店。售卖[gears]、[mandrake]和[deerclops_eyeball]。
                    ----------------
                    甚至能直接买到[dragon_scales]等BOSS掉落物。]]
        },
        pig_shop_academy = {
            intro = [[学术重地。售卖[malbatross_feather]、[trunk_summer]和[shark_fin]。
                    ----------------
                    这里是研究[townportaltalisman]等高阶科技的物资来源。]]
        },
        pig_shop_arcane = {
            intro = [[售卖魔法类道具。包括[icestaff]、[firestaff]和[nightsword]。
                    ----------------
                    同时也提供[blueamulet]和关键的[livinglog]。]]
        },
        pig_shop_weapons = {
            intro = [[售卖各种武装。包括[halberd]、[cutlass]和[blowdart_pipe]。
                    ----------------
                    [coconade]和各种[trap]也是这里的畅销货。]]
        },
        pig_shop_hatshop = {
            intro = [[服饰中心。售卖[tophat]、[beefalohat]以及稀有的[walrushat]。
                    ----------------
                    [sewing_kit]是每个绅士维持体面的必备品。]]
        },
        pig_shop_bank = {
            intro = [[货币中心。负责货币兑换，也售卖部分矿物。
                    ----------------
                    [pigman_banker]负责看管所有的财富。]]
        },
        pig_shop_tinker = {
            intro = [[蓝图商店。售卖各种稀有蓝图。]]
        },
    },

    -- 生物类
    mobs = {
        firetwister = { intro = [[刷新在火山地区。是[twister]的火属性变种。]] },
        twister = { intro = [[哈姆雷特和海难地区的季节性威胁。]] },
        slipstor = { intro = [[丛林地区的奇特生物。]] },
        wildboreking = { intro = [[类似于[pigking]，可以换取金子，但具有攻击性。]] },
        ancient_herald = { intro = [[毁灭季的化身。击杀掉落[ARMORVORTEXCLOAK]的制作图纸。]] },
        pugalisk = {
            intro = [[在月圆时，会从[pugalisk_fountain]中生成。
                    ----------------
                    击杀会掉落[pugalisk_fountain]的蓝图。]]
        },
        kraken = {
            intro = [[深海巨兽。打开的第一个[messagebottle_sw]可以定位其巢穴。]]
        },

        pigman_mayor = {
            intro = [[管理者。收购[goldnugget]和[goldenbar]等金制品。]]
        },
        pigman_queen = {
            intro = [[最高统治者。对[pigcrownhat]、[pig_scepter]和[relic_4]非常感兴趣。]]
        },
        pigman_beautician = {
            intro = [[对羽毛有偏执的爱好。你可以把[peagawkfeather]和[feather_robin]卖给她。]]
        },
        pigman_florist = {
            intro = [[环保主义者。收购[petals]、[foliage]和[succulent_picked]。]]
        },
        pigman_erudite = {
            intro = [[神秘学者。专门收购[nightmarefuel]。]]
        },
        pigman_hatmaker = {
            intro = [[需要大量的[silk]来制作各种奇妙的帽子。]]
        },
        pigman_storeowner = {
            intro = [[勤俭持家。会收购你在城市修剪绿化得到的[clippings]。]]
        },
        pigman_banker = {
            intro = [[高端交易者。负责收购[redgem]、[bluegem]等各类昂贵宝石。]]
        },
        pigman_collector = {
            intro = [[喜欢收集各类[trinket_1]等玩具，以及[stinger]和[spidergland]。]]
        },
        pigman_hunter = {
            intro = [[勇猛的猎手。会收购[houndstooth]和[hippo_antler]。]]
        },
        pigman_professor = {
            intro = [[古物专家。你可以把在遗迹中挖到的[relic_1]等文物交给他。]]
        },
        pigman_usher = {
            intro = [[喜爱甜食。收购[honey]、[jammypreserves]和[waffles]。]]
        },
        pigman_farmer = {
            intro = [[基础资源收集者。收购[cutgrass]和[twigs]。]]
        },
        pigman_miner = {
            intro = [[矿石爱好者。通过卖给他[rocks]来赚取报酬。]]
        },
        pigman_mechanic = {
            intro = [[工程大师。收购加工过的[boards]、[cutstone]和[rope]。]]
        },
        pigman_royalguard = {
            intro = [[秩序维护者。可以使用[securitycontract]将其雇佣为保镖。]]
        },
    },

    -- 道具类
    items = {
        ship = {
            name = "船（单人）",
            intro = [[通过[SEAFARING_PROTOTYPER]解锁，不再通过[RESEARCHLAB2]解锁。单人航海的核心工具。]]
        },
        boat = {
            name = "船（多人）",
            intro = [[多人合作航行的载具。可以配合[保险杠]抵抗海浪冲击。
                    ----------------
                    联机版船：[boat]/[boat_pirate]/[boat_ancient]/[boatmetal] 分别能减轻海浪 30%/30%/40%/90% 的影响；
                    ----------------
                    保险杠：[BOAT_BUMPER_KELP]/[BOAT_BUMPER_SHELL]/[BOAT_BUMPER_YOTD]/[BOAT_BUMPER_CRABKING]分别能减轻安装方向 60%/80%/80%/100% 的影响。]]
        },
        smelter = {
            name = "炼钢炉",
            intro = [[用于熔炼[iron]，[goldnugget]或精炼矿石的高级设施。
                    可以通过[智能烹饪]模组查看炼金配方。]]
        },
    },
}

local WikiTerms = {
    -- 词条
    type = "类型",
    recipe = "制作配方",
    unable_to_craft = "无法制作",
    friendly = "友好",
    hostile = "敌对",
    location = "出没地点",
    desc = "介绍",
    attitude = "归属阵营",
    unknown = "未知",
    about = "通告",
    generation = "机制",
    structures = "建筑",
    mobs = "生物",
    items = "道具",
    related = "相关物品",
    -----------
    mod_background = "制作背景",
    mod_progress = "更新日志",
    mod_about = "热带冒险 | 忒修斯之船",
    mod_preview = "写在前面",
    mod_sponser = "打赏支持我们！！",
    mod_sponser_list = "赞助名单",

    -- 提示
    click_to_read = "点击查看\"热带冒险\"百科",
    drag = "拖拽",
    reset = "重置",
    zoom = "缩放",
}

return {
    WikiDesc = WikiDesc,
    WikiTerms = WikiTerms,
}
