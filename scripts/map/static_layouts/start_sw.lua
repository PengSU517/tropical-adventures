return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 4,       --最大边界值
  height = 4,      --最大边界值，一定要设置成正方形！
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
      width = 4,  --最大边界值
      height = 4, --最大边界值
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = { --大地图生成不了世界，好奇怪啊
        0, 6, 6, 6,
        0, 0, 6, 6,
        6, 6, 6, 0,
        0, 0, 6, 6,

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
          name = "",
          type = "welcomitem",
          shape = "rectangle",
          x = 192,
          y = 80,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "welcomitem",
          shape = "rectangle",
          x = 128,
          y = 48,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "welcomitem",
          shape = "rectangle",
          x = 32,
          y = 144,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "刷新点",
          type = "spawnpoint_master", --刷新点
          shape = "rectangle",
          x = 160,                    --横坐标，64的倍数
          y = 160,                    --纵坐标，64的倍数
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "multiplayer_portal",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
