return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 1,
  height = 1,
  tilewidth = 1,
  tileheight = 1,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../../tools/tiled/dont_starve/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../../tools/tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 448,
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
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0
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
          x = 160,
          y = 160,
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
          type = "goldnugget",
          shape = "rectangle",
          x = 70,
          y = 35,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },

        {
          name = "",
          type = "goldnugget",
          shape = "rectangle",
          x = 30,
          y = 75,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },		
			
        {
          name = "",
          type = "debris_2",
          shape = "rectangle",
          x = 83,
          y = 75,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "debris_3",
          shape = "rectangle",
          x = 90,
          y = 55,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "debris_1",
          shape = "rectangle",
          x = 170,
          y = 139,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
      }
    }
  }
}