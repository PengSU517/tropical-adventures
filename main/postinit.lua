local modimport = modimport


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

--components
modimport("postinit/components/armor")
modimport("postinit/components/builder") ----------试试看这个有没有问题
modimport("postinit/components/healthtrigger")
modimport("postinit/components/inventory_prevent_pick")
modimport("postinit/components/inventoryitem")
modimport("postinit/components/locomoter")
modimport("postinit/components/playerspawner")
modimport("postinit/components/snowtile") ---- disable snow effeccts
modimport("postinit/components/wavemanager")


modimport("postinit/components/playercontroller")
modimport("postinit/components/embarker")


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
