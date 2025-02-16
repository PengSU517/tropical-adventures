-- local upvaluehelper = require("tools/upvaluehelper")
require("constants")
require("mathutil")

local troadj = TA_CONFIG
local forest_map = require("map/forest_map")

local old_generatemap = forest_map.Generate
local SKIP_GEN_CHECKS = upvaluehelper.Get(old_generatemap, "SKIP_GEN_CHECKS")
if SKIP_GEN_CHECKS ~= nil and TA_CONFIG.testmap then
    print("Skipping generation checks for test map")
    local old = SKIP_GEN_CHECKS
    upvaluehelper.Set(old_generatemap, "SKIP_GEN_CHECKS", true)
end


forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    ----世界设置覆盖mod设置中的相同内容
    local worldgenset = deepcopy(level.overrides) or {}
    for i, v in pairs(troadj) do
        troadj[i] = (worldgenset[i] ~= nil) and worldgenset[i] or troadj[i]
    end

    -- local tasks = level.tasks or {}  ----哎level里面已经没有tasks了

    if GLOBAL.rawget(GLOBAL, "WorldSim") then
        local idx = GLOBAL.getmetatable(GLOBAL.WorldSim).__index

        ------世界大小调整
        local multi = troadj.world_size_multi or 1
        if multi ~= 1 then
            local OldSetWorldSize = idx.SetWorldSize
            idx.SetWorldSize = function(self, width, height)
                print("Setting world size to " .. width .. " times " .. multi)
                OldSetWorldSize(self, math.ceil(multi * width), math.ceil(multi * height))
            end

            local OldConvertToTileMap = idx.ConvertToTileMap
            idx.ConvertToTileMap = function(self, length)
                OldConvertToTileMap(self, math.ceil(multi * length))
            end
        end

        ------海岸线调整
        if worldgenset.coastline then
            idx.SeparateIslands = function(self) print("Not Seperating Islands") end
        end
    end

    -------地上世界调整
    if level.location == "forest" then
        --     if troadj.together == false then
        --         tableutil.remove_components(
        --             level.tasks,
        --             {
        --                 "Make a pick",
        --                 "Dig that rock",
        --                 "Great Plains",
        --                 "Squeltch",
        --                 "Beeeees!",
        --                 "Speak to the king",
        --                 "Forest hunters",
        --                 "Badlands",
        --                 "For a nice walk",
        --                 "Lightning Bluff",
        --             }
        --         )

        --         level.numoptionaltasks = 0
        --         tableutil.remove_indexes(
        --             level.set_pieces,
        --             {
        --                 "ResurrectionStone",
        --                 "WormholeGrass",
        --                 "MooseNest",
        --                 "CaveEntrance",
        --             }
        --         )
        --         -- level.overrides = {}
        --         -- level.overrides.layout_mode = "LinkNodesByKeys"
        --         level.required_setpieces = {}

        --         level.random_set_pieces = {}
        --         level.ordered_story_setpieces = {}
        --         level.numrandom_set_pieces = 0

        --         -- level.ocean_population = nil       --海洋生态 礁石 海带之类的 还有奶奶岛,帝王蟹和猴岛
        --         -- level.ocean_prefill_setpieces = {} -- 巨树和盐矿的layout

        --         level.overrides.keep_disconnected_tiles = true
        --         -- level.overrides.roads = "never"
        --         -- level.overrides.birds = "never"  --没鸟
        --         level.overrides.has_ocean = true --没海  ----如果设置了有海的话会清除所有非地面地皮然后根据规则重新生成
        --         level.required_prefabs = {}      -----这个是为了检测是否有必要的prefabs
        --     end

        -- if troadj.shipwrecked then
        --     table.insert(level.tasks, "HomeIsland")
        --     table.insert(level.tasks, "RockyGold")       --火山矿区  ["MagmaGold"] = 2,  ["MagmaGoldBoon"] = 1,
        --     table.insert(level.tasks, "BoreKing")        --野猪王  ["PigVillagesw"] = 1,      ["JungleDenseBerries"] = 1,  ["BeachShark"] = 1,
        --     table.insert(level.tasks, "RockyTallJungle") --火山矿  ["MagmaTallBird"] = 1,  ["MagmaGoldBoon"] = 1,
        --     table.insert(level.tasks, "BeachSkull")      --骷髅岛 ["JungleRockSkull"] = 1, random
        --     table.insert(level.tasks, "MagmaJungle")     -- 猴子 ["MagmaForest"] = 1, -- MR went from 1-3    ["JungleDense"] = 1,    ["JunglePigs"] = 1,没有猪

        --     table.insert(level.tasks, "JungleMarshy")    --热带沼泽和沙滩
        --     table.insert(level.tasks, "JungleBushy")     --沙滩和丛林，纯随机
        --     table.insert(level.tasks, "JungleBeachy")    --热带丛林+纯随机
        --     table.insert(level.tasks, "JungleMonkey")    --猴子  ["JungleMonkeyHell"] = 2,

        --     table.insert(level.tasks, "BeachMarshy")     --纯随机 沙滩和沼泽
        --     table.insert(level.tasks, "MoonRocky")       --月石矿
        --     table.insert(level.tasks, "TigerSharky")     --虎鲨+沼泽+丛林   required_prefabs = { "tigersharkpool" },好奇怪
        --     table.insert(level.tasks, "Verdent")         --绿草地  ["Beaverkinghome"] = 1,    ["Beaverkingcity"] = 1, beaver是什么东西
        --     table.insert(level.tasks, "Casino")          --["BeachPalmCasino"] = 1, 抽奖机
        --     table.insert(level.tasks, "BeachBeachy")     --随机  [salasbeach[math.random(1, 24)]] = 1,  ["BeachShark"] = 1,又是啥玩意
        --     table.insert(level.tasks, "BeachPiggy")      --猪人沙滩
        --     table.insert(level.tasks, "DoyDoyM")         ---doydoyM
        --     table.insert(level.tasks, "DoyDoyF")         ---doydoyF
        --     table.insert(level.tasks, "Volcano ground")  --火山  ["VolcanoAsh"] = 1,       ["Volcano"] = 1,    ["VolcanoObsidian"] = 1,

        --     table.insert(level.tasks, "A_BLANK1")
        --     table.insert(level.tasks, "A_BLANK2")
        --     table.insert(level.tasks, "A_BLANK3")
        --     table.insert(level.tasks, "A_BLANK4")
        --     table.insert(level.tasks, "A_BLANK5")
        --     table.insert(level.tasks, "A_BLANK6")
        --     table.insert(level.tasks, "A_BLANK7")
        --     table.insert(level.tasks, "A_BLANK8")
        --     table.insert(level.tasks, "A_BLANK9")
        --     table.insert(level.tasks, "A_BLANK10")
        --     table.insert(level.tasks, "A_BLANK11")
        --     table.insert(level.tasks, "A_BLANK12")

        --     table.insert(level.ocean_population, "OceanBrinepool")
        -- end

        -- if troadj.hamlet then
        --     table.insert(level.tasks, "Plains")               --island3 高草地形，类似牛场
        --     table.insert(level.tasks, "Rainforest_ruins")
        --     table.insert(level.tasks, "Painted_sands")        --废铁机器人和铁矿区, 有cave_entrance_roc，但是太大了
        --     table.insert(level.tasks, "Deep_rainforest")      ----有蚁穴

        --     table.insert(level.tasks, "Edge_of_civilization") --城郊地区
        --     table.insert(level.tasks, "Pigtopia")
        --     -- table.insert(level.tasks, "Pigtopia_capital")

        --     table.insert(level.tasks, "Other_edge_of_civilization")
        --     table.insert(level.tasks, "Other_pigtopia")
        --     -- table.insert(level.tasks, "Other_pigtopia_capital")
        --     table.insert(level.tasks, "Deep_rainforest_2")   ----有荨麻，遗迹入口  entrance_5  --并入曼达拉

        --     table.insert(level.tasks, "Edge_of_the_unknown") --pugalisk_fountain 蛇岛 ---大鸟岛入口？vampirebatcave_entrance_roc
        --     table.insert(level.tasks, "Deep_rainforest_3")
        --     table.insert(level.tasks, "Deep_lost_ruins_gas") --毒气森林 有entrance_6

        --     table.insert(level.tasks, "Pincale")

        --     level.set_pieces["cave_entranceham1"] = { count = 1, tasks = { "Deep_rainforest" } }
        --     level.set_pieces["cave_entranceham2"] = { count = 1, tasks = { "Deep_rainforest_2" } }
        --     level.set_pieces["cave_entranceham3"] = { count = 1, tasks = { "Deep_lost_ruins_gas" } }
        -- end
    end


    local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)

    if save == nil then return save end
    -- if level.location ~= "forest" then return save end
    -- if not TA_CONFIG.hamlet then return save end
    if not tableutil.has_all_of_component(level.tasks, { "Edge_of_civilization", "Pigtopia", "Other_edge_of_civilization", "Other_pigtopia" }) then
        return
            save
    end

    ------在这里可以获取所有信息
    -- print("Generating map for hamlet!")
    -- for i, v in pairs(level.overrides) do
    --     print("overrides", i, v)
    -- end

    --------------------building porkland cities---------------------------------------------------------------------
    local make_cities = require("map/city_builder")
    local build_porkland = function(entities, topology_save, map_width, map_height, current_gen_params)
        print("Building porkland cities!")
        make_cities(entities, topology_save, WorldSim, map_width, map_height, current_gen_params)



        local join_islands = not current_gen_params.no_joining_islands
        save.map.tiles, save.map.tiledata, save.map.nav, save.map.adj, save.map.nodeidtilemap =
            WorldSim:GetEncodedMap(join_islands) ----这是存储地形数据的关键
    end
    build_porkland(save.ents, TOPOLOGY_SAVE, save.map.width, save.map.height, deepcopy(level.overrides))
    ----mapwidth,height在其中发生过改变
    -----------------------------------------------------------------------------------------------------------------
    return save
end
