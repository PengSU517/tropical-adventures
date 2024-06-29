local function en_zh(en, zh) -- Other languages don't work
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船")


author = "Peng, 杰杰, Runar"
version = "2.6.29.1"
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

Update 2.6.29:

1. Fixed an issue with inaccurate plot center points.
2. Fixed a crash issue when riding a bull inside buildings/caves.
3. Fixed an error that occurred when equipping headgear (e.g., Ant-Man helmet) directly after crafting.
4. Optimized terrain generation: now Terraria, marble statues, stages, junkyards, and similar terrains will (almost) always spawn in the starting area.

Update 2.6.28:

1. Fixed bugs related to the update
2. update researchlab 3
3. Added several new cook recipes.
4. Updated the Bermuda Triangle (needs optimization).

2.6.26 Updates:

1. Fix flashing snowtiles
2. fix windows and doors placement in room
3. fix lunar hail in room

2.6.25 Updates:

1. Update fish herds in mangrove, lilypond and oceans.
Including tropical fish, clownfish, grouper, neon fish, gearfish, goldfish, red fish, hatchfish, salmon, and more.


2.6.24 Updates:

1. adjust tiledef, compatible with architect pack

2.6.23 Updates:

1. fix overrided prefabs

2.6.21 Update:

	1. Changed the Ancient Herald's loot
	2. Added item "Dark Tatters (Ancient Remnant)"
	3. Reset the Vortex Cloak, now the Vortex Cloak properties are the same as the original Vortex Cloak
	4. Vortex Cloak now has Shadow Magic Tier 2
	5. When there is no item in Vortex Cloak's inventory slots, you can add the Vortex Cloak to the inventory
	6. New equipment "Void Cloak" :
		Craft at the Shadowcraft Plinth
		Durability 855, Protection 100%, Planar Defense +10, 10% reduced damage taken from Shadow-aligned mobs
		Shadow Magic Tier 3, Decreases Sanity by 10% of total damage taken,	Refueled with Nightmare fuels to restore durability
		Restore full durability with the Void Repair Kit, Has 12 inventory slots
	7. Adjusted the Damage of Shard Sword and Shard Beak
	8. Date dependent version numbers are used later

2.6.17 (7.10.5):

    1. Fixed an issue where Tea Trees could not generate Orange Picoes correctly
    2. Fixed an issue where Picoes would steal items such as backpacks and giant crops
    3. Fixed an issue where the name of the Pig Queen "Queen Malfalfa" could not be displayed correctly
    4. Fixed an issue where Mechanic Pigman would drop hammers
	5. Temporarily removed the option to generate a new world with tropical ocean

]]

local updatech = [[

2.6.29 更新:

1. 修复地皮中心点不准的问题
2. 修复室内/洞穴骑牛崩档的问题
3. 修复制作头部装备(蚁人头盔等)直接佩戴时会报错的问题
4. 优化地形生成、现在泰拉瑞亚，大理石雕像、舞台、垃圾场等地形(几乎)都会刷新在出生点所在区域


2.6.28 更新:

1. 修复更新相关bug
2. 更新了海难和哈姆的魔法一本
3. 添加了新的食谱芋泥波波
4. 更新了百慕大三角(需要优化)


2.6.26 更新:

1. 完全屏蔽了地面积雪，修复积雪闪屏问题
2. 修复门窗的室内摆放问题
3. 屏蔽室内玻璃雨

2.6.25 更新:

1. 更新了红树林、莲花池塘和海洋中的鱼群，包括热带鱼，小丑鱼、石斑鱼、霓虹鱼、发条鱼、金鱼、红鱼、哈奇鱼、鲑鱼等。

2.6.24 更新:

	1. 调整tiledef,兼容architect pack

2.6.23 更新：

    1. 修正了暴力覆盖的预制件

2.6.21 更新：

	1. 更改了远古先驱的掉落
	2. 新增物品“暗影碎布（先驱碎布）”
	3. 重置了漩涡斗篷，现在漩涡斗篷属性与原版漩涡斗篷一致
	4. 漩涡斗篷现在具有2级暗影魔法等级
	5. 漩涡斗篷内没有物品时，可以将漩涡斗篷收入物品栏
	6. 新增装备“虚空斗篷”：
		在暗影术基座处制作
	    耐久855，物理防御 100%，位面防御 +10，暗影阵营物理伤害减免 10%
	    暗影魔法 等级3，受击扣除10%所承受伤害的san值，使用噩梦燃料类燃料恢复耐久
		使用虚空修补套件恢复全部耐久，有12个格子
	7. 调整了碎裂剑和碎裂喙的伤害值
	8. 往后采用日期相关的版本号

2.6.17 (7.10.5)：

    1. 修复了茶树不能正确生成橙色异食松鼠的问题
	2. 修复了异食松鼠会偷背包、巨大作物等物件的问题
	3. 修复了猪女王“玛法拉法女王”名称不能正确显示的问题
	4. 修复了建筑猪人会掉落锤子的问题
	5. 暂时去除了新建地图生成热带风格海洋的选项

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
