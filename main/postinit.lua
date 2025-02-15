local modimport = modimport

if TA_CONFIG.testmode then --开发人员测试时才可以使用,mod文件夹名称为tropical-adventures
    modimport("postinit/seafork")
    modimport("postinit/opengift")
    modimport("postinit/widgets/hoverer_info")
else
    modimport("postinit/safeapi") --这些函数是env里的，仅对这个mod有效
end



--目前仍然有暴力覆盖的组件
--hounded
--penguinspawner
--weather


modimport("postinit/world_map")    --theworld.map相关
modimport("postinit/entityscript") --修改entity相关


modimport("postinit/actionrelated")
modimport("postinit/tropical_climate")    --热带气候
modimport("postinit/ham_room")            --新的room
modimport("postinit/room_camera")         --房间镜头
modimport("postinit/boat")                --单人船相关修改
modimport("postinit/natureskin_variants") --和自然皮肤切换相关的所有内容
modimport("postinit/player_vision_post") --四眼镜、蝙蝠帽所用
modimport("postinit/tile_post") --特殊地皮挖起


-- do not know how to sort
modimport("postinit/postinit_poisonables") --posonables--and loot dropper--
modimport("postinit/camera")               --旧的房间镜头，但是现在不能删
modimport("postinit/sim_rain_effect")
modimport("postinit/player_darkness")
modimport("postinit/farm")    --种植相关  --通过veggies改变随机种子权重
modimport("postinit/wx78_module")
modimport("postinit/sim_ham") --ham cloud

modimport("postinit/entity")  --不知道这个是干啥的
modimport("postinit/naughty") --淘气值？


--components
modimport("postinit/components/actionqueuer")
modimport("postinit/components/armor")
modimport("postinit/components/builder")
modimport("postinit/components/birdspawner")
modimport("postinit/components/combat")
modimport("postinit/components/curseditem")
modimport("postinit/components/flotsamgenerator") --漂浮物刷新，TODO可能不生效
modimport("postinit/components/hatchable")
modimport("postinit/components/healthtrigger")
modimport("postinit/components/embarker")
modimport("postinit/components/groundpounder") --这个组件拍地板的？
modimport("postinit/components/inventory_prevent_pick")
modimport("postinit/components/inventoryitem")
modimport("postinit/components/locomotor") --这两个内容需要整合一下
modimport("postinit/components/locomotor_boat")
modimport("postinit/components/playercontroller")
modimport("postinit/components/playerspawner")

-- modimport("postinit/components/plantgrowth")  --黄蘑菇生长速度，之后或许可以加进来
-- modimport("postinit/components/spooked")  --黄蘑菇孢子
modimport("postinit/components/snowtile") -- disable snow effeccts
-- modimport("postinit/components/trap")
modimport("postinit/components/thief")
modimport("postinit/components/wavemanager")
modimport("postinit/components/map")
modimport("postinit/components/boatphysics")

modimport("postinit/components/animstate")
modimport("postinit/components/soundemitter")
modimport("postinit/components/worldstate")



modimport("postinit/components/ambientlighting")
modimport("postinit/components/colourcube")
-- modimport("postinit/components/playervision")
modimport("postinit/components/ambientsound")
modimport("postinit/components/dynamicmusic")
-- modimport("postinit/components/oceancolor")

--prefabs

-- modimport("postinit/prefabs/image_minisign") --会影响到其他mod
modimport("postinit/prefabs/gears")
modimport("postinit/prefabs/warningshadow")
modimport("postinit/prefabs/world")
-- modimport("postinit/prefabs/forest")
-- modimport("postinit/prefabs/cave")
modimport("postinit/prefabs/player_classified")
modimport("postinit/prefabs/floatable_items")
modimport("postinit/prefabs/blueprints")
modimport("postinit/prefabs/lots_of_things")
modimport("postinit/prefabs/player") --shopper, drownable, infestable
modimport("postinit/prefabs/player_hayfever")
-- modimport("postinit/prefabs/farm_plants")--目前不太需要
modimport("postinit/prefabs/dock_kit") --甲板相关
modimport("postinit/prefabs/wobster")
modimport("postinit/prefabs/meatrack")
modimport("postinit/prefabs/mosquitosack")
modimport("postinit/prefabs/trinket_1")
modimport("postinit/prefabs/mushroom_farm")

--widgets

modimport("postinit/widgets/crafttabs")
modimport("postinit/widgets/healthbadge")
modimport("postinit/widgets/uiclock_bloodmoon")
modimport("postinit/widgets/statusdisplays_speed")
modimport("postinit/widgets/container_widget_boat")
modimport("postinit/widgets/container_woodleg_boat")
modimport("postinit/widgets/container_boat")     -- boat container sizing tweak by EvenMr
modimport("postinit/widgets/containers")         --new containers
modimport("postinit/widgets/seasonsdisplay.lua") --雾和花粉症,还有树荫



--stagegraph
modimport("postinit/stategraphs/stagegraph_wilson") --需要整理
modimport("postinit/stategraphs/SGwilson")
modimport("postinit/stategraphs/SGwilson_client")
