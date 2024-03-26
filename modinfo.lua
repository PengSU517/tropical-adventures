local function en_zh(en, zh) -- Other languages don't work
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

------------------player_actions_shear.zip
-------------player_actions_bucked.zip  被扔下来的动画
-----------------修ROC SG
-----------------载入语言包
----------------------猪镇的生成设计
------------蚁穴和洞穴地皮调整
-----------------室内物品高度怎么调不了啊
----------------------海洋之椅，火山祭坛
----------------洞穴的掉落物会落入水中
----------------漂流瓶显示宝藏没有标记
---------------雨林的小地图贴图不对
-----------------relic太少了
----------------栽种房子的时候有bug------------已解决
---------------不要把东西给房子--------------已解决
---------------浮木舟不掉耐久
----------------大鸟地区不该加Hamlet标签 roc的SG也没写好
--------------waffles_plate缺少贴图
--------------直接制作帽子戴上会报错。。
------------------原MOD写的清楚积雪的效果只对主客机一体时有效



name = en_zh(" Tropical Adventure (Shipwrecked & Hamlet)", "热带冒险（海难哈姆雷特三合一）")

author = "Peng"
version = "6.96"
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
Update:

]]

local updatech = [[
更新：
1.
2.

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



-- mod_dependencies = {
-- 	{ --GEMCORE
-- 		-- workshop = "workshop-1378549454",
-- 		-- ["GemCore"] = false,
-- 		-- ["[API] Gem Core - GitLab Version"] = true,
-- 	},
-- }

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

-- Thanks to the Gorge Extender by CunningFox for making me aware of this being possible -M
local function Breaker(title_en, title_zh) --hover does not work, as this item cannot be hovered
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
		default = "stringsCH",
	},

	Breaker("World Generation", "世界生成"),


	{
		name = "together",
		label = en_zh("Region of Gaints", "巨人国"),
		hover = en_zh("Default Lands in DST", "联机默认地形"),
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

		},
		default = "fixed",
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

	{
		name = "layout",
		label = en_zh("Layout adjustment", "布局调整"),
		hover = en_zh("Layout adjustment", "如大理石雕像、猴岛、寄居蟹岛、帝王蟹的位置调整"),
		options = options_enable,
		default = true,
	},

	{
		name = "testmode",
		label = en_zh("Test Mode", "测试模式"),
		hover = en_zh("A very small world only for debugging", "仅生成一块很小的地形用于测试内容"),
		options = options_enable,
		default = false,
	},



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
		options = options_enable,
		default = true,
	},

	{
		name = "aporkalypse",
		label = en_zh("Aporkalypse", "毁灭季"),
		hover = en_zh("Aporkalypse, but in caves", "毁灭季 但是在洞穴"),
		options = options_enable,
		default = true,
	},

	Breaker("Other Settings", "其他设置"),

	{
		name = "prefabname",
		label = en_zh("Show Prefab Name", "显示物品代码"),
		hover = en_zh("Show Prefab Name on Cursor", "显示物品代码"),
		options = options_enable,
		default = false,
	},


}
