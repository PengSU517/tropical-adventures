local modimport = modimport


---目前仍然有暴力覆盖的组件(都是闭包函数，似乎不太好hook)
--ambientlighting
--hounded
--penguinspawner
--weather


modimport("main/ham_room")         -----------------新的room
modimport("main/tropical_ocean")   ----------------新的海洋属性
modimport("main/tropical_boat")    ----------------单人船相关修改
modimport("main/tropical_weather") ----------------热带气候
modimport("main/seafork")

-- do not know how to sort
modimport("postinit/postinit_poisonables") ---posonables----and loot dropper----------
modimport("postinit/camera")
modimport("postinit/sim_rain_effect")
modimport("postinit/player_darkness")
modimport("postinit/farm")         -----种植相关  ---通过veggies改变随机种子权重
modimport("postinit/wx78_module")
modimport("postinit/sim_ham")      ---------ham cloud
modimport("postinit/entityscript") ----修改entity相关
modimport("postinit/entity")       ----不知道这个是干啥的
modimport("postinit/naughty")      ----淘气值？


--components
modimport("postinit/components/armor")
modimport("postinit/components/builder")
modimport("postinit/components/birdspawner")
modimport("postinit/components/curseditem")

modimport("postinit/components/healthtrigger")
modimport("postinit/components/embarker")
modimport("postinit/components/groundpounder") ----这个组件拍地板的？
modimport("postinit/components/inventory_prevent_pick")
modimport("postinit/components/inventoryitem")
modimport("postinit/components/locomotor") -----这两个内容需要整合一下
modimport("postinit/components/locomoter")
modimport("postinit/components/playercontroller")
modimport("postinit/components/playerspawner")
modimport("postinit/components/playervision")
-- modimport("postinit/components/plantgrowth")  --黄蘑菇生长速度，之后或许可以加进来
-- modimport("postinit/components/spooked")  --黄蘑菇孢子
modimport("postinit/components/snowtile") ---- disable snow effeccts
modimport("postinit/components/trap")
modimport("postinit/components/thief")
modimport("postinit/components/wavemanager")







--prefabs
modimport("postinit/prefabs/image_minisign")
modimport("postinit/prefabs/gears")
modimport("postinit/prefabs/warningshadow")
modimport("postinit/prefabs/world")
modimport("postinit/prefabs/forest")
modimport("postinit/prefabs/cave")
modimport("postinit/prefabs/player_classified")
modimport("postinit/prefabs/floatable_items")
modimport("postinit/prefabs/blueprints")
modimport("postinit/prefabs/lots_of_things")
modimport("postinit/prefabs/player") ----shopper, drownable, infestable
modimport("postinit/prefabs/player_hayfever")
modimport("postinit/prefabs/tea")

--widgets
modimport("postinit/widgets/hoverer_info") ---- show name and anim, for debugging
modimport("postinit/widgets/crafttabs")
modimport("postinit/widgets/healthbadge")
modimport("postinit/widgets/uiclock_bloodmoon")
modimport("postinit/widgets/statusdisplays_speed")
modimport("postinit/widgets/container_widget_boat")
modimport("postinit/widgets/container_woodleg_boat")
modimport("postinit/widgets/container_boat")     ---- boat container sizing tweak by EvenMr
modimport("postinit/widgets/containers")         ---new containers
modimport("postinit/widgets/seasonsdisplay.lua") --------------雾和花粉症,还有树荫
