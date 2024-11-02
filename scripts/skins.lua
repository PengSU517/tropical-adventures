modimport("scripts/tools/skinsapi.lua") --调用皮肤api  来自穹

local MakeSkinAsset = function(data)
	data.skinname = data.skinname or data.prefabname
	data.build = data.build or data.skinname
	data.basebuild = data.basebuild or data.prefabname
	data.image = data.image or data.skinname
	data.name = data.name or STRING.NAMES[string.upper(data.skinname)] or data.skinname

	local assetname = data.assetname or data.skinname
	table.insert(Assets, Asset("ANIM", "anim/" .. assetname .. ".zip"))
	MakeItemSkin(data.prefabname, data.skinname, data)
end




local skinlist =
{
	{
		prefabname = "double_umbrellahat",
		skinname = "double_umbrellahat_palmleaf",
		assetname = "hat_double_umbrella_palm",
		build = "hat_double_umbrella_palm", --原物品scml文件名字
		-- bank = "hat_double_umbrella_palm",
		basebuild = "hat_double_umbrella",
		-- basebank = "hat_double_umbrella",
		build_name_override = "hat_double_umbrella_palm",
		rarity = "Elegant", --珍惜度:会影响皮肤名字的显示颜色
		type = "item", --类别
		name = "palmleaf", --填皮肤的名称:经典,小熊,小猫,小狗什么的
		-- atlas = "images/inventoryimages/inventory_extension.xml", --制作栏的图片
		-- image = "double_umbrellahat_palmleaf",

	},
	{
		prefabname = "double_umbrellahat",
		skinname = "double_umbrellahat_sharkitten",
		assetname = "hat_double_umbrella_sharkitten",
		build = "hat_double_umbrella_sharkitten",
		-- bank = "hat_double_umbrella_palm",
		basebuild = "hat_double_umbrella",
		-- basebank = "hat_double_umbrella",
		build_name_override = "hat_double_umbrella_sharkitten",
		rarity = "Elegant",
		type = "item",
		name = "sharkitten",
		-- atlas = "images/inventoryimages/inventory_extension.xml",
		-- image = "double_umbrellahat_sharkitten",
	},
}


for _, data in ipairs(skinlist) do
	MakeSkinAsset(data)
end
