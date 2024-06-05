--to do list  以下为需要解决的问题
--马赛克地皮生成
--给地皮调色
--建造栏图标未解锁--已解决
--单机海水联机化
--强盗猪人
--玻璃雨
--蜘蛛网--部分解决
--中文语言包
--语言添加自动选项--已解决
--灵活调整室内摄像头
--进出房间视角
--限制玩家走到房间之外
--roominterior组件
--修ROC SG --player_actions_shear.zip --player_actions_bucked.zip  被扔下来的动画
--猪镇的生成设计
--蚁穴和洞穴地皮调整
--室内物品高度怎么调不了啊--部分解决
--海洋之椅，火山祭坛
--漂流瓶显示宝藏没有标记
--雨林的小地图贴图不对
--relic太少了
--栽种房子的时候有bug--已解决
--不要把东西给房子--已解决
--浮木舟不掉耐久
--大鸟地区不该加Hamlet标签 roc的SG也没写好
--waffles_plate缺少贴图 吴迪手杖贴图
--原MOD写的清楚积雪的效果只对主客机一体时有效
--热带生物的刷新
--城镇钥匙一元钱购买的问题
--咖啡素食属性
--小木牌贴图注册
--毁灭者不能传送
--钢铁侠机甲性能太差
--蚁穴没有清理干净
--商店猪人血量
--女王会走出屋外


local function en_zh(en, zh) -- Other languages don't work
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船")

author = "Peng"
version = "7.10.1"
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

1. fix cook recipes, coffee will be goodies instead of veggies.list
2. update logo.

Last Update:

1. Prohibited indoor placement of spider dens (if the problem can't be solved, solve the spider den) while also banning indoor placement for some other Hamlet buildings.
2. Adjusted the generation rules for tropical seas to enhance compatibility (so you can enable "Never Compromise"). Of course, players who couldn't play together before shouldn't try too hard.
3. Fixed the issue where two slot machines and a pelican would spawn.
4. Fixed world generation process.

Last Update:
1. Barely fixed the portal problem
2. Modified deck laying range, tropical shallow sea, mangrove and lotus pond can be
3. Hamlet: From outside the realm
Vortex Cloak now has new abilities: It can be repaired with Nightmare fuel, 10% at a time; It's the Shadow gear; When the durability drops to 0, it no longer has no rigidity effect and no longer falls off. The void repair kit can be used to repair 100% durability;
10% Shadow faction damage free; 100% injury free; Durability 900; Bit defense 10

Last Update:

Update tropical (shipwrecked) ocean

Last Update:
1.guess fixed a bug. fix some trivial bugs

Last Update:
1.Fixed the crash issue when encountering tropical spiders.
2.fixed climate related component.

Last Update:
1.Fixed bugs related to updates
	1.Fixed the crash issue when encountering tropical spiders.
	2.Forcefully fixed the crash issues related to the weather component.
2.Adjusted terrain generation rules
	1.Players can adjust the map size.
	2.Can choose to disable together content (including mainland, moon islands, and caves). The conditions for disabling are very strict, please read the settings instructions carefully.
	3.The area where the spawn gate is located will be recognized as the main area, with significantly increased ecological content, while content in other areas will be reduced.
3.Adjusted room-related content
	1.When building windows, wall decorations, and chandeliers, you can use the up and down keys to adjust the height.
	2.When building wall decorations, carpets, and other items, you can use the pageup and pagedown keys to adjust the direction. Carpets can be rotated at any angle.
	3.Some buildings can be rotated using fencing swords.
	4.Some indoor buildings can also be constructed outdoors after unlocking.

Last Update:
1. fix some bugs related with the latest update (locomoter and playervision only)
2. fix a bug related with the wildboreking

]]

local updatech = [[

更新：
1.修复食谱问题，咖啡不再是素食
2.更新logo

上次更新：
1.禁止蜘蛛巢室内摆放（解决不了问题就解决蜘蛛巢）同时禁止了一些其他哈姆雷特建筑的室内摆放
2.调整了热带海域的生成规则，兼容性更强（可以开永不妥协）当然之前不能一起玩的玩家就不要努力了
3.修复了会刷新两个抽奖机和鹈鹕的问题
4.修复世界生成问题，应该不会缺失重要地形了

上次更新：
1.勉强修好了穿上退出游戏会传送至出生门的问题
2.修改甲板的铺设范围，热带浅海、红树林和莲花池塘均可
3.哈姆雷特：来自域外
现在旋涡斗篷拥有了全新的能力：可用噩梦燃料修复，每次修复10%；是暗影装备；耐久掉0时不再具有无僵直效果和不再脱落可用虚空修补套件修复100%耐久；
10%暗影阵营免伤；100%免伤；耐久900；位面防御10

上次更新：
1. 更新了热带（船难）海域

上次更新：
1. 遇到热带毒蜘蛛会闪退
2. 简单调整气候组件

上次更新：
1.修复更新相关bug
	1. 遇到热带毒蜘蛛会闪退
	2. 暴力修复weather组件相关的闪退问题，我逐渐理解了事情是如何一步一步变成屎山的
2.调整了地形生成规则
	1.玩家可以调整地图大小
	2.可以选择禁用联机内容（包括联机大陆、月岛、和联机洞穴）禁用条件非常严格，请仔细阅读设置说明
	3.出生门所在区域会认定为主区域，生态内容显著增多，其他区域内容会削减
3.调整了房间相关内容
	1.建造窗户、墙饰和吊灯时，可以用 上下键 调整高度
	2.建造墙饰、地毯等物品时可以用 pageup pagedown键调整方向，地毯可旋转任意角度
	3.部分建筑可以用栅栏击剑旋转角度
	4.部分室内建筑在解锁后也可在室外建造
	5.如果室内视角有问题可以用- + 微调

上次更新：
1.修复了一部分更新相关bug (大概率还有其他问题但至少能进入游戏)
2.修复了一个野猪王相关的bug


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


		},
		default = "tropical",
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
