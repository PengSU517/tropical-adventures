AddLevelPreInitAny(function(level)
    if level.location == "cave" then
        level.overrides.keep_disconnected_tiles = true

        level.tasks = { "MudWorld", "CaveExitTask1", "CaveExitTask2", "GreenForest" }
        -- table.insert(level.tasks, "HamMudWorld")  ---地下版的出生地，但是爪树 "HamLightPlantFieldexit"--exit1 "HamArchiveMaze"
        -- table.insert(level.tasks, "HamRockyLand") --"HamBatsAndRocky"有蚁后
        -- table.insert(level.tasks, "HamMudCave")   --同质化严重  "HamMudWithRabbitexit" 有exit2
        -- table.insert(level.tasks, "HamArchiveMaze")

        level.numoptionaltasks = 0
        level.optionaltasks = {}

        level.set_pieces = {}
        -- level.set_pieces["Waterlogged1"] = { count = 1, tasks = { "MudWorld" } }
        -- level.valid_start_tasks = { "MudWorld" }
    end


    if level.location == "forest" then
        level.tasks = { "Make a pick", "Speak to the king" }
        table.insert(level.tasks, "Mrainforest_ruins") --这才应该是出门位置
        table.insert(level.tasks, "Mplains")           --island3 高草地形，类似牛场
        -- table.insert(level.tasks, "Mpainted_sands")        --废铁机器人和铁矿区, 有cave_entrance_roc，但是太大了
        -- table.insert(level.tasks, "MEdge_of_civilization") --城郊地区
        -- table.insert(level.tasks, "MDeep_rainforest_mandrake")
        -- table.insert(level.tasks, "MDeep_lost_ruins_gas")  --毒气森林 有entrance_6
        -- -- -- table.insert(level.tasks, "MEdge_of_the_unknown_2") --这个的地形和其他地形高度重复
        -- table.insert(level.tasks, "MDeep_rainforest_2")    ----有荨麻，遗迹入口  entrance_5

        -- -- -- table.insert(level.tasks, "M_BLANK2")       --这是个空的
        -- table.insert(level.tasks, "Edge_of_the_unknownC") --pugalisk_fountain 蛇岛

        -- table.insert(level.tasks, "MPigcity")
        -- table.insert(level.tasks, "MPigcityside1")
        -- table.insert(level.tasks, "MPigcityside2")
        -- table.insert(level.tasks, "MPigcityside3")
        -- table.insert(level.tasks, "MPigcityside4")

        -- table.insert(level.tasks, "M_BLANK1")
        -- table.insert(level.tasks, "MPigcity2")
        -- table.insert(level.tasks, "MPigcity2side1")
        -- table.insert(level.tasks, "MPigcity2side2")
        -- table.insert(level.tasks, "MPigcity2side3")
        -- table.insert(level.tasks, "MPigcity2side4")
        -- table.insert(level.tasks, "MDeep_rainforest_3")

        -- table.insert(level.tasks, "pincale")

        table.insert(level.tasks, "A_MISTO6") --火山矿区
        table.insert(level.tasks, "A_MISTO7") --野猪王

        level.numoptionaltasks = 0

        level.set_pieces = {} --用新的地形但不执行这一行就会报错，因为这是要在特定地形插入彩蛋
        level.set_pieces["CaveEntrance"] = { count = 2, tasks = { "Make a pick", "Speak to the king" } }
        level.overrides.start_location = "NewStart"
        level.random_set_pieces = {}
        level.ordered_story_setpieces = {}
        level.numrandom_set_pieces = 0

        -- level.ocean_population = nil        --海洋生态 礁石 海带之类的 也就是说删除了奶奶岛 和猴岛？ 这代码逻辑太奇怪了
        -- level.ocean_prefill_setpieces = nil -- 不用这一行，海上只会生成巨树和盐矿的layout

        -- level.overrides.keep_disconnected_tiles = true
        -- level.overrides.roads = "never"
        -- level.overrides.birds = "never"  --没鸟
        -- level.overrides.has_ocean = false --false	--没海  ----如果设置了有海的话会清除所有非地面地皮然后根据规则重新生成
        level.required_prefabs = {} --温蒂更新后的修复

        -- level.set_pieces["cave_entranceham1"] = { count = 1, tasks = { "Mrainforest_ruins" } }
        level.set_pieces["start_ham"] = { count = 1, tasks = { "Mrainforest_ruins" } }

        -- table.insert(level.ocean_population, "OceanCoastal_lily")-------不管用呢

        -- level.ocean_prefill_setpieces["coralpool1"] = { count = 1 }
        -- level.ocean_prefill_setpieces["coralpool2"] = { count = 1 }
        -- level.ocean_prefill_setpieces["coralpool3"] = { count = 1 }
        -- level.ocean_prefill_setpieces["octopuskinghome"] = { count = 1 }
        -- level.ocean_prefill_setpieces["mangrove1"] = { count = 1 }
        -- level.ocean_prefill_setpieces["mangrove2"] = { count = 1 }
        -- level.ocean_prefill_setpieces["wreck"] = { count = 1 }
        -- level.ocean_prefill_setpieces["wreck2"] = { count = 1 }
        -- level.ocean_prefill_setpieces["kraken"] = { count = 1 }
        -- level.ocean_prefill_setpieces["lilypadnovo"] = { count = 3 }


        -- level.set_pieces["lilypad"] = { count = 1, tasks = { "Mplains" } }
        -- level.set_pieces["Waterlogged1"] = { count = 1, tasks = { "Make a pick" } }




        --------------------------------------水面波纹，现在只能暴力覆盖
        --------------------------------------默认的落鸟 --落在荷叶上会很小
        -----------------------------以及生成海域时不再重新铺地皮，
        -----------------------------怎么放码头,
        ----------------------------海岸线不够渐变, 水陆分界类似河堤的东西
        ----------------------------三基佬等layout的生成
        ---------------------怎么解决暴力覆盖
        ---------------------在海面上退档会传送会出生门
        ------------------水陆地皮的动画层级似乎不一样
        -----------------突然不刷新水母了
    end
end)




-- function Node:AddEntity(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data,
--                         rand_offset)
--     local tile = WorldSim:GetTile(points_x[current_pos_idx], points_y[current_pos_idx])
--     if not TileGroupManager:IsLandTile(tile) then
--         return
--     end

--     PopulateWorld_AddEntity(prefab, points_x[current_pos_idx], points_y[current_pos_idx], tile, entitiesOut, width,
--         height, prefab_list, prefab_data, rand_offset)
-- end
