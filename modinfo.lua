local function en_zh(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船")


author = "Peng, 杰杰, Runar"
version = "2.8.14"
forumthread = ""
api_version = 10
priority = -10


local desen = [[
Personal modification of Tropical Experience
]]

local desch = [[
在热带体验mod的基础上,保留海难和哈姆雷特的内容并做了一些修改
QQ 群：469668062

]]

local updateen = [[

Nobody cares

]]

local updatech = [[

反正没人看这里

]]


description = en_zh(desen .. "Version " .. version .. updateen, desch .. "版本 " .. version .. updatech)

dst_compatible = true
dont_starve_compatible = false
all_clients_require_mod = true
client_only_mod = false
reign_of_giants_compatible = false
server_filter_tags = { "Shipwrecked", "Hamlet", "Economy", "House", "Home", "Boats", "Ruins" }

icon_atlas = "images/modicon/modicon.xml"
icon = "modicon.tex"




local options_enable = {
	{ description = en_zh("Disabled", "关闭"), data = false },
	{ description = en_zh("Enabled", "开启"), data = true },
}

local options_enable2 = {
	{ description = en_zh("Disabled", "关闭"), data = false },
}

local options_count = {
	{ description = en_zh("Disabled", "关闭"), data = false },
	{ description = "1", data = "1" },
	{ description = "2", data = "2" },
	{ description = "3", data = "3" },
	{ description = "4", data = "4" },
	{ description = "5", data = "5" },
}


local function Breaker(title_en, title_zh)
	return { name = en_zh(title_en, title_zh), options = { { description = "", data = false } }, default = false }
end



configuration_options =
{
	Breaker("Set Language", "选择语言"),
	{
		name = "language",
		label = en_zh("Set Language", "选择语言"),
		hover = en_zh("Change mod language...", "选择模组语言"),
		options =
		{
			-- { description = "Auto(自动)", data = (locale == "zh" or locale == "zhr" or locale == "zht") and "stringsCH" or "stringsEN" },
			{ description = "English", data = "stringsEN" },
			{ description = "中文", data = "stringsCH" },
			-- { description = "Português", data = "stringsPT" },
			-- { description = "Italian", data = "stringsIT" },
			-- { description = "Russian", data = "stringsRU" },
			-- { description = "Spanish", data = "stringsSP" },
			-- { description = "한국어", data = "stringsKO" },
			-- { description = "Magyar", data = "stringsHUN" },
			-- { description = "Français", data = "stringsFR" },
		},
		default = (locale == "zh" or locale == "zhr" or locale == "zht") and "stringsCH" or "stringsEN",
	},

	Breaker("World Generation", "世界生成"),


	{
		name = "rog",
		label = en_zh("Region of Gaints", "巨人国"),
		hover = en_zh("Mainland, MoonIslands and Together Caves", "联机大陆,月岛和联机洞穴"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default settings with 5 random tasks", "默认设置,有五个随机地形"),
				data = "default"
			},
			-- {
			-- 	description = en_zh("No Random Tasks", "无随机地形"),
			-- 	hover = en_zh("No Random Tasks", "无随机地形"),
			-- 	data = "no_random"
			-- },
			{
				description = en_zh("Fxied Random Tasks", "固定的随机地形"),
				hover = en_zh("KillerBees, Walrus, PigVillage, Frogs&Bugs, SpiderRocks", "杀人蜂,海象,小猪村,青蛙蜜蜂,蜘蛛矿"),
				data = "fixed"
			},

			{
				description = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
				hover = en_zh(
					"only works when enabling at least one another region and set it as start location",
					"需要开启至少一个其他区域并设为出生地时此项才能生效"),
				data = false
			},

		},
		default = "default",
	},

	{
		name = "shipwrecked",
		label = en_zh("Shipwrecked", "海难"),
		hover = en_zh("Shipwrecked", "海难"),
		options = options_enable,
		default = true,
	},

	{
		name = "hamlet",
		label = en_zh("Hamlet", "哈姆雷特"),
		hover = en_zh("Hamlet", "哈姆雷特"),
		options = options_enable,
		default = true,
	},



	{
		name = "startlocation",
		label = en_zh("Start location", "出生地"),
		hover = en_zh("Start location", "出生地"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default (Together Mainland)", "默认(联机大陆)"),
				data = "default"
			},
			{
				description = en_zh("Shipwrecked region", "海难区域"),
				hover = en_zh("Shipwrecked region, need corresponding region enabled", "海难区域，需开启相应地形"),
				data = "shipwrecked"
			},
			{
				description = en_zh("Hamlet region", "哈姆雷特区域"),
				hover = en_zh("Hamlet region, need corresponding region enabled", "哈姆雷特区域，需开启相应地形"),
				data = "hamlet"
			},

		},
		default = "hamlet",
	},

	{
		name = "worldsize",
		label = en_zh("World size", "世界大小"),
		hover = en_zh("World size", "世界大小"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Follow game settings, not recommended", "跟随游戏设定,不推荐"),
				data = "default"
			},
			{
				description = en_zh("Normal", "适中"),
				hover = en_zh("world generation may be slower", "世界生成可能较慢"),
				data = "normal"
			},
			{
				description = en_zh("Larger", "更大"),
				hover = en_zh(" a compromising choice", "一个折中的选择"),
				data = "large"
			},
			{
				description = en_zh("Huger", "巨大"),
				hover = en_zh("high server pressure.", "服务器压力较大"),
				data = "huge"
			},

		},
		default = "normal",
	},

	{
		name = "coastline",
		label = en_zh("Coastline", "海岸线"),
		hover = en_zh("Coastline", "海岸线"),
		options =
		{
			{
				description = en_zh("Smoother", "更平滑的海岸线"),
				hover = en_zh("Not seperating tasks", "不分离土地, 岛屿有可能粘连在一起"),
				data = true
			},
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default settings", "默认设置"),
				data = false
			},


		},
		default = true,
	},

	-- {
	-- 	name = "layout",
	-- 	label = en_zh("Layout adjustment", "布局调整"),
	-- 	hover = en_zh("Layout adjustment", "如大理石雕像、猴岛、寄居蟹岛、帝王蟹的位置调整"),
	-- 	options = options_enable,
	-- 	default = true,
	-- },




	Breaker("Weather Settings", "气候设置"),

	{
		name = "wind",
		label = en_zh("Wind", "海风"),
		hover = en_zh("Wind", "海风"),
		options = options_enable,
		default = true,
	},

	{
		name = "hail",
		label = en_zh("Hail", "冰雹"),
		hover = en_zh("Hail", "冰雹"),
		options = options_enable,
		default = true,
	},

	{
		name = "waves",
		label = en_zh("Waves", "海浪"),
		hover = en_zh("Waves", "海浪"),
		options = options_enable,
		default = true,
	},

	{
		name = "flood",
		label = en_zh("Flood", "洪水"),
		hover = en_zh("Flood", "洪水"),
		options = options_enable2,
		default = false,
	},

	{
		name = "volcano",
		label = en_zh("Volcano Eruption", "火山喷发"),
		hover = en_zh("Volcano Eruption", "火山喷发"),
		options = options_enable2,
		default = false,
	},

	{
		name = "fog",
		label = en_zh("Fog", "雾"),
		hover = en_zh("Fog", "雾"),
		options = options_enable,
		default = true,
	},

	{
		name = "hayfever",
		label = en_zh("Hayfever", "花粉过敏"),
		hover = en_zh("Hayfever", "花粉过敏"),
		options = options_enable2,
		default = false,
	},

	{
		name = "aporkalypse",
		label = en_zh("Aporkalypse", "毁灭季"),
		hover = en_zh("Aporkalypse, but in caves", "毁灭季 但是在洞穴"),
		options = options_enable,
		default = true,
	},

	--[[
	Breaker("Client Settings", "客户端调整"),
	{
		name = "ocean",
		label = en_zh("Ocean", "海洋"),
		hover = en_zh("Ocean Style", "海洋风格"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("DST ocean", "联机海洋"),
				data = "default"
			},
			{
				description = en_zh("Shipwrecked Style", "海难风格"),
				hover = en_zh("Shipwrecked stylized tropical ocean", "海难风格的热带海洋"),
				data = "tropical"
			},

			-- {
			-- 	description = en_zh("All Blue ", "碧蓝"),
			-- 	hover = en_zh("A new style", "碧蓝的联机海洋"),
			-- 	data = "blue"
			-- },


		},
		default = "default",
	},
 ]]

	Breaker("Developer Settings", "开发者选项"),

	{
		name = "testmode",
		label = en_zh("Test Mode", "测试模式"),
		hover = en_zh("A very small world only for debugging", "仅生成一块很小的地形用于测试内容"),
		options = options_enable,
		default = false,
	},

	{
		name = "prefabname",
		label = en_zh("Show Prefab Name", "显示物品代码"),
		hover = en_zh("Show Prefab Name on Cursor", "显示物品代码"),
		options = options_enable,
		default = false,
	},

	{
		name = "seafork",
		label = en_zh("Seafork", "填海叉"),
		hover = en_zh("Sea to Land", "填海造陆"),
		options = options_enable,
		default = false,
	},


}
