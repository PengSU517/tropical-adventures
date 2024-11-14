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
          type = "multiplayer_portal",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "spawnpoint_master",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_basket",
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
          type = "porkland_intro_balloon",
          shape = "rectangle",
          x = 60,
          y = 123,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_trunk",
          shape = "rectangle",
          x = 109,
          y = 197,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_suitcase",
          shape = "rectangle",
          x = 85,
          y = 187,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_sandbag",
          shape = "rectangle",
          x = 188,
          y = 123,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_flags",
          shape = "rectangle",
          x = 217,
          y = 94,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "porkland_intro_scrape",
          shape = "rectangle",
          x = 128,
          y = 49,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        -- {
        --   name = "",
        --   type = "machete",
        --   shape = "rectangle",
        --   x = 167,
        --   y = 44,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {}
        -- }
      }
    }
  }
}
