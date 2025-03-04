AddStartLocation("NewStart", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "newstart", --生成的static layout  --layout太大的话需要设置大小
    start_node = "Clearing",     --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
})

AddStartLocation("SWStart", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "start_sw",      --生成的static layout  --layout太大的话需要设置大小
    start_node = "Shipwrecked start", --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
})

AddStartLocation("HamStart", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "start_ham", --生成的static layout  --layout太大的话需要设置大小
    start_node = "Hamlet start",  --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
})
