local function en_zh(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船")


author = "Peng, 杰杰, Runar"
version = "2.11.2.2"
forumthread = ""
api_version = 10
priority = -100


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
server_filter_tags = { "Shipwrecked", "Hamlet", "海难", "哈姆雷特", "猪镇", "三合一" }

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

local options_key = {
	{ description = en_zh("Disabled", "关闭"), data = -1 },
	{ description = "F1", data = 282 },
	{ description = "F2", data = 283 },
	{ description = "F3", data = 284 },
	{ description = "F4", data = 285 },
	{ description = "F5", data = 286 },
	{ description = "F6", data = 287 },
	{ description = "F7", data = 288 },
	{ description = "F8", data = 289 },
	{ description = "F9", data = 290 },
	{ description = "F10", data = 291 },
	{ description = "F11", data = 292 },
	{ description = "F12", data = 293 },
	{ description = "0", data = 48 },
	{ description = "1", data = 49 },
	{ description = "2", data = 50 },
	{ description = "3", data = 51 },
	{ description = "4", data = 52 },
	{ description = "5", data = 53 },
	{ description = "6", data = 54 },
	{ description = "7", data = 55 },
	{ description = "8", data = 56 },
	{ description = "9", data = 57 },
	{ description = "A", data = 97 },
	{ description = "B", data = 98 },
	{ description = "C", data = 99 },
	{ description = "D", data = 100 },
	{ description = "E", data = 101 },
	{ description = "F", data = 102 },
	{ description = "G", data = 103 },
	{ description = "H", data = 104 },
	{ description = "I", data = 105 },
	{ description = "J", data = 106 },
	{ description = "K", data = 107 },
	{ description = "L", data = 108 },
	{ description = "M", data = 109 },
	{ description = "N", data = 110 },
	{ description = "O", data = 111 },
	{ description = "P", data = 112 },
	{ description = "Q", data = 113 },
	{ description = "R", data = 114 },
	{ description = "S", data = 115 },
	{ description = "T", data = 116 },
	{ description = "U", data = 117 },
	{ description = "V", data = 118 },
	{ description = "W", data = 119 },
	{ description = "X", data = 120 },
	{ description = "Y", data = 121 },
	{ description = "Z", data = 122 },
	{ description = "↑", data = 273 },
	{ description = "↓", data = 274 },
	{ description = "←", data = 276 },
	{ description = "→", data = 275 },
}

local options_pairedkey = {
	{ description = en_zh("Disabled", "关闭"), data = false },
	{ description = "Q/E", data = "qe" },
	{ description = "↓/↑", data = "du" },
	{ description = "←/→", data = "lr" },
	{ description = "-/+", data = "mp" },
	{ description = "pagedown/pageup", data = "pp" },
	{ description = "home/end", data = "he" },
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
			{ description = "Default(默认)", data = false },
			{ description = "中文", data = "ch" },
			-- { description = "Português", data = "stringsPT" },
			-- { description = "Italian", data = "stringsIT" },
			-- { description = "Russian", data = "stringsRU" },
			-- { description = "Spanish", data = "stringsSP" },
			-- { description = "한국어", data = "stringsKO" },
			-- { description = "Magyar", data = "stringsHUN" },
			-- { description = "Français", data = "stringsFR" },
		},
		default = nil,
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
		name = "sealnado",
		label = en_zh("sealnado", "豹卷风"),
		hover = en_zh("Twister", "豹卷风"),
		options = options_enable,
		default = true,
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

	{
		name = "roc",
		label = en_zh("ROC", "大鹏"),
		hover = en_zh("Big Friendly Bird", "友好大鸟"),
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
	Breaker("Client Adjustments", "客户端调整"),

	{
		name = "roomview",
		label = en_zh("Room view", "房间视角"),
		hover = en_zh("lower or higher view", "拉低/拉高视角"),
		options = options_pairedkey,
		default = "mp", ----  -/+
	},

	{
		name = "build_height",
		label = en_zh("Building height", "建造高度"),
		hover = en_zh("windows or hanging section while building", "窗户、悬挂型建筑高度调整"),
		options = options_pairedkey,
		default = "du", ----  "↓/↑"
	},

	{
		name = "build_rotation",
		label = en_zh("Building rotation", "建造角度"),
		hover = en_zh("wall sections, rugs and some decorations", "墙饰/地毯和部分装饰物的建造角度"),
		options = options_pairedkey,
		default = "qe", ----  q/e
	},




	Breaker("Developer Settings(only works in the test version)", "开发者选项(仅在测试版中有效)"),

	{
		name = "testmap",
		label = en_zh("Test Map", "测试地图"),
		hover = en_zh("a small map for testing", "用于测试用的小型地图"),
		options = options_enable,
		default = true,
	},

	{
		name = "testmode",
		label = en_zh("Test Mode", "测试模式"),
		hover = en_zh("seafork, autoskin, prefabname", "填海叉，开礼物，显示代码名"),
		options = options_enable,
		default = true,
	},

	--[[ {
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
	}, ]]


}
