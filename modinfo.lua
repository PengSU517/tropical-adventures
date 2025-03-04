-----世界设置里的值不能是false,否则会用默认设置，所以modinfo最好保持同步
---全局的locale只在modinfo中存在，在servercreationmain中需要用translator
local locale = locale or LanguageTranslator.defaultlang

local function en_zh(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

local function table_insert(t, value, pos)
	if pos == nil then
		pos = #t + 1
	end

	for i = #t, pos, -1 do
		t[i + 1] = t[i]
	end

	t[pos] = value
end

local function my_ipairs(t)
	local i = 0
	local n = #t
	return function()
		i = i + 1
		if i <= n then
			return i, t[i]
		end
	end
end


folder_name = folder_name or "workshop-"

local isdev = not folder_name:find("workshop-")

local function pub_dev(pub, dev)
	return isdev and dev or pub
end

name = pub_dev(en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船"),
	en_zh(" Tropical Adventures|Dev", "热带冒险|开发版"))

author = "Peng, Runar, momo, 杰杰"
version = "3.3.2"
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

]]

local updatech = [[

]]

description = en_zh(desen .. "Version " .. version .. updateen, desch .. "版本 " .. version .. updatech)

dst_compatible = true
dont_starve_compatible = false
all_clients_require_mod = true
-- client_only_mod = false
reign_of_giants_compatible = false
server_filter_tags = { "Shipwrecked", "Hamlet", "海难", "哈姆雷特", "猪镇", "三合一" }

icon_atlas = "images/modicon/modicon.xml"
icon = "modicon.tex"

-- mod_dependencies = {
-- 	{ --GEMCORE
-- 		-- workshop = "workshop-3361402499",

-- 	},
-- }


local options_enable = {
	{ description = en_zh("Enabled", "开启"), data = "enabled" },
	{ description = en_zh("Disabled", "关闭"), data = "disabled" },

}

local options_enable2 = {
	{ description = en_zh("Disabled", "关闭"), data = "disabled" },
}

local options_count = {
	{ description = en_zh("Disabled", "关闭"), data = 0 },
	{ description = "1", data = 1 },
	{ description = "2", data = 2 },
	{ description = "3", data = 3 },
	{ description = "4", data = 4 },
	{ description = "5", data = 5 },
}

local options_key = {
	{ description = en_zh("Disabled", "关闭"), data = 0 },
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


local dstgen_atlas = "images/worldgen_customization.xml"
local dstset_atlas = "images/worldsettings_customization.xml"
local dst_atlas = "images/customisation.xml"
local sw_atlas = "images/hud/customization_shipwrecked.xml"
local ham_atlas = "images/hud/customization_porkland.xml"

worldgen_options = {
	{
		name = "rog",
		label = en_zh("Region of Gaints", "巨人国"),
		hover = en_zh("Mainland,  and Together Caves", "联机大陆,月岛和联机洞穴"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default settings with 5 random tasks", "默认设置,有五个随机地形"),
				data = "default"
			},

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
				data = "disabled"
			},

		},
		default = "fixed",

		order = 1,
		image = "deerclops.tex",
		atlas = dst_atlas,
		world = { "forest" },
	},



	{
		name = "shipwrecked",
		label = en_zh("Shipwrecked", "海难"),
		hover = en_zh("Shipwrecked", "海难"),
		options = options_enable,
		default = "enabled",

		order = 2,
		image = "birds.tex",
		atlas = sw_atlas,
		world = { "forest" }


	},

	{
		name = "hamlet",
		label = en_zh("Hamlet", "哈姆雷特"),
		hover = en_zh("Hamlet", "哈姆雷特"),
		options = options_enable,
		default = "enabled",
		order = 3,
		image = "pig_houses.tex",
		atlas = ham_atlas,
		world = { "forest" }
	},

	{
		name = "ocean_content",
		label = en_zh("DST Ocean Contents", "联机海洋内容"),
		hover = en_zh("MoonIslands, Crabs and Waterlogs, etc", "月岛，螃蟹们和水中木等等"),
		options = options_enable,

		default = "enabled",
		order = 4,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "forest" }
	},

	{
		name = "cave_content",
		label = en_zh("Together Caves", "联机洞穴内容"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default settings", "默认设置"),
				data = "default"
			},

			{
				description = en_zh("No ladder", "没有楼梯"),
				hover = en_zh("No ladder", "没有楼梯"),
				data = "part"
			},

			-- {
			-- 	description = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
			-- 	hover = en_zh("Disabled(Not Recommended)", "关闭(不推荐)"),
			-- 	data = "disabled"
			-- },

		},
		default = "default",
		order = 5,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "cave" }

	},

	{
		name = "ruins",
		label = en_zh("Pig Ruins", "猪人遗迹"),
		options = options_enable,
		default = "enabled",
		order = 5.5,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "cave" }

	},

	{
		name = "multiplayerportal",
		label = en_zh("Florid Postern location", "绚丽之门位置"),
		hover = en_zh("Florid Postern location", "绚丽之门位置"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default (Together Mainland)", "默认(联机大陆)"),
				data = "rog"
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
		order = 6,
		image = "spawnmode.tex",
		atlas = dstset_atlas,
		world = { "forest" }
	},




	{
		name = "world_size_multi",
		label = en_zh("World size multi", "世界大小乘数"),
		hover = en_zh("World size multi", "世界大小乘数"),
		options =
		{
			{
				description = en_zh("Tiny, 0.1×", "极小 , 0.1×"),
				data = 0.1
			},
			{
				description = en_zh("Smaller, 0.75×", "更小, 0.75×"),
				data = 0.75
			},
			{
				description = en_zh("Default, 1×", "默认, 1×"),
				data = 1
			},
			{
				description = en_zh("Larger, 1.25×", "更大, 1.25×"),
				data = 1.25
			},
			{
				description = en_zh("Huger, 1.5×", "巨大, 1.5×"),
				data = 1.5
			},

		},
		default = 1.25,
		order = 8,
		image = "world_size.tex",
		atlas = dst_atlas,
		world = { "forest", "cave" }
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
				data = "enabled"
			},
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Default settings", "默认设置"),
				data = "disabled"
			},

		},
		default = "enabled",
		order = 9,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "forest" }
	},

	-- {
	-- 	name = "layout",
	-- 	label = en_zh("Layout adjustment", "布局调整"),
	-- 	hover = en_zh("Layout adjustment", "如大理石雕像、猴岛、寄居蟹岛、帝王蟹的位置调整"),
	-- 	options = options_enable,
	-- 	default = "enabled",
	-- },
}


climate_options = {

	{
		name = "startlocation",
		label = en_zh("Start location", "出生地"),
		hover = en_zh("Start location", "出生地"),
		options =
		{
			{
				description = en_zh("Default", "默认"),
				hover = en_zh("Florid Postern", "绚丽之门"),
				data = "default"
			},
		},
		default = "default",
		order = 7,
		image = "spawnmode.tex",
		atlas = dstset_atlas,
		world = { "forest" }

	},

	{
		name = "wind",
		label = en_zh("Wind", "海风"),
		hover = en_zh("Wind", "海风"),
		options = options_enable,
		default = "enabled",
		order = 11,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "hail",
		label = en_zh("Hail", "冰雹"),
		hover = en_zh("Hail", "冰雹"),
		options = options_enable,
		default = "enabled",
		order = 12,
		image = "blank_world.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "waves",
		label = en_zh("Waves", "海浪"),
		hover = en_zh("Waves", "海浪"),
		options = options_enable,
		default = "enabled",
		order = 13,
		image = "waves.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "flood",
		label = en_zh("Flood", "洪水"),
		hover = en_zh("Flood", "洪水"),
		options = options_enable2,
		default = "disabled",
		order = 14,
		image = "floods.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "volcano",
		label = en_zh("Volcano Eruption", "火山喷发"),
		hover = en_zh("Volcano Eruption", "火山喷发"),
		options = options_enable2,
		default = "disabled",
		order = 15,
		image = "volcano.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "sealnado",
		label = en_zh("sealnado", "豹卷风"),
		hover = en_zh("Twister", "豹卷风"),
		options = options_enable,
		default = "enabled",
		order = 16,
		image = "twister.tex",
		atlas = sw_atlas,
		world = { "forest" },
	},

	{
		name = "fog",
		label = en_zh("Fog", "雾"),
		hover = en_zh("Fog", "雾"),
		options = options_enable,
		default = "enabled",
		order = 17,
		image = "fog.tex",
		atlas = ham_atlas,
		world = { "forest" },
	},

	{
		name = "hayfever",
		label = en_zh("Hayfever", "花粉过敏"),
		hover = en_zh("Hayfever", "花粉过敏"),
		options = options_enable2,
		default = "disabled",
		order = 18,
		image = "hayfever.tex",
		atlas = ham_atlas,
		world = { "forest" },
	},

	{
		name = "aporkalypse",
		label = en_zh("Aporkalypse", "毁灭季"),
		hover = en_zh("Aporkalypse, but in caves", "毁灭季 但是在洞穴"),
		options = options_enable,
		default = "enabled",
		order = 19,
		image = "aporkalypse.tex",
		atlas = ham_atlas,
		world = { "forest", "cave" },
	},

	{
		name = "roc",
		label = en_zh("ROC", "大鹏"),
		hover = en_zh("Big Friendly Bird", "友好大鸟"),
		options = options_enable,
		default = "enabled",
		order = 20,
		image = "roc.tex",
		atlas = ham_atlas,
		world = { "forest" },
	},


}


client_options =
{
	{
		name = "room_view_key",
		label = en_zh("Room view", "房间视角"),
		hover = en_zh("lower or higher view", "拉低/拉高视角"),
		options = options_pairedkey,
		default = "mp", ----  -/+
	},

	{
		name = "build_height_key",
		label = en_zh("Building height", "建造高度"),
		hover = en_zh("windows or hanging section while building", "窗户、悬挂型建筑高度调整"),
		options = options_pairedkey,
		default = "du", ----  "↓/↑"
	},

	{
		name = "build_rotation_key",
		label = en_zh("Building rotation", "建造角度"),
		hover = en_zh("wall sections, rugs and some decorations", "墙饰/地毯和部分装饰物的建造角度"),
		options = options_pairedkey,
		default = "qe", ----  q/e
	},

	{
		name = "boatlefthud",
		label = en_zh("Boat HUD(Vertical Adjustment)", "海难船只HUD调整"),
		hover = en_zh(
			"Here u can adjust the height of the boat HUD *Health meter",
			"在这里可以调整海难船只HUD的显示高度(原版自适应调整)"),
		options =
		{
			{ description = "0", data = 0 },
			{ description = "↑20", data = 20 },
			{ description = "↑40", data = 40 },
			{ description = "↑80", data = 80 },
		},
		default = 0,
	},

	--[[
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
}


developer_options =
{
	{
		name = "test_map",
		label = en_zh("Test Map", "测试地图"),
		hover = en_zh("a small map for testing", "用于测试用的小型地图"),
		options = options_enable,
		default = "disabled",
	},

	{
		name = "test_mode",
		label = en_zh("Test Mode", "测试模式"),
		hover = en_zh("seafork, autoskin, prefabname", "填海叉，开礼物，显示代码名"),
		options = options_enable,
		default = "disabled",
	},

	--[[ isdev and {
		name = "prefabname",
		label = en_zh("Show Prefab Name", "显示物品代码"),
		hover = en_zh("Show Prefab Name on Cursor", "显示物品代码"),
		options = options_enable,
		default = false,
	} or {},

	isdev and {
		name = "seafork",
		label = en_zh("Seafork", "填海叉"),
		hover = en_zh("Sea to Land", "填海造陆"),
		options = options_enable,
		default = false,
	} or {}, ]]
}



configuration_options = {}

table_insert(configuration_options, Breaker("Client Adjustments", "客户端调整"))
for i, v in my_ipairs(client_options) do
	table_insert(configuration_options, v)
end

-- table_insert(configuration_options, Breaker("Option Reset ", "选项重置"))
-- table_insert(configuration_options, {
-- 	name = "already_reset",
-- 	label = en_zh("Option Reset ", "选项重置"),
-- 	options = {
-- 		{ description = en_zh("Done", "已完成"), data = true },
-- 		{ description = en_zh("Not yet", "未完成"), data = false },

-- 	},
-- 	default = false,
-- })



if isdev then
	table_insert(configuration_options, Breaker("Developer Settings", "开发者选项") or nil)
	for i, v in my_ipairs(developer_options) do
		table_insert(configuration_options, v)
	end
end

table_insert(configuration_options, Breaker(" ", " "))
table_insert(configuration_options, Breaker(" ", " "))
table_insert(configuration_options, Breaker("Belows are Server Settings", "以下为服务器设置"))
table_insert(configuration_options, Breaker("DO NOT WORK WITH A CLIENT WORLD", "客户端开服无效"))
table_insert(configuration_options, Breaker("CLIENT PLEASE GOTO FOREST/CAVE SETTINGS", "客户端请调整森林/洞穴设置"))
table_insert(configuration_options, Breaker(" ", " "))

table_insert(configuration_options, Breaker("World Generation", "世界生成"))
for i, v in my_ipairs(worldgen_options) do
	table_insert(configuration_options, v)
end

table_insert(configuration_options, Breaker("Weather Settings", "气候设置"))
for i, v in my_ipairs(climate_options) do
	table_insert(configuration_options, v)
end
