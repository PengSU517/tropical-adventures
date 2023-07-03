return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,       --最大边界值
  height = 8,      --最大边界值，一定要设置成正方形！
  tilewidth = 64,  --像素点，推荐64
  tileheight = 64, --像素点，推荐64
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,  --像素点，推荐64
      tileheight = 64, --像素点，推荐64
      spacing = 0,
      margin = 0,
      image = "../../../../tools/tiled/dont_starve/tiles.png",
      imagewidth = 512,  --不要动
      imageheight = 384, --不要动
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 8,  --最大边界值
      height = 8, --最大边界值
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = { --大地图生成不了世界，好奇怪啊
        10, 6, 6, 6, 6, 6, 6, 6,
        6, 10, 6, 6, 6, 6, 6, 6,
        6, 6, 10, 6, 6, 6, 6, 6,
        6, 6, 6, 10, 6, 6, 6, 6,
        6, 6, 6, 6, 10, 6, 6, 6,
        6, 6, 6, 6, 6, 10, 6, 6,
        6, 6, 6, 6, 6, 6, 10, 6,
        10, 6, 6, 6, 6, 6, 6, 10,

      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "传送门",
          type = "multiplayer_portal", --传送门
          shape = "rectangle",
          x = 256,                     --横坐标，64的倍数
          y = 256,                     --纵坐标，64的倍数
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },

        {
          name = "哈哈哈",
          type = "welcomitem", --致查理
          shape = "rectangle",
          x = 512,             --横坐标，64的倍数就会在地皮交叉点上
          y = 512,             --纵坐标，64的倍数
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
