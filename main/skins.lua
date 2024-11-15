modimport("scripts/tools/skinsapi.lua") --调用皮肤api  来自穹

GLOBAL.PREFAB_SKINS_SHOULD_NOT_CHANGE = {}

local itemskinlist = require("datadefs/skin_item_defs").skinlist

for prefabname, prefabdata in pairs(itemskinlist) do
	for skinname, skindata in pairs(prefabdata) do
		local assetname = skindata.assetname or skindata.build or skindata.skinname
		table.insert(Assets, Asset("ANIM", "anim/" .. assetname .. ".zip"))
		MakeItemSkin(skindata.prefabname, skindata.skinname, skindata)
	end
end


local natureskinlist = require("datadefs/skin_nature_defs").skinlist

for prefabname, prefabdata in pairs(natureskinlist) do
	for skinname, skindata in pairs(prefabdata) do
		-- skindata.is_nature_skin = (skindata.is_nature_skin ~= nil) and skindata.is_nature_skin or true ---是否可以从改皮肤切换
		PREFAB_SKINS_SHOULD_NOT_CHANGE[skinname] = true
		PREFAB_SKINS_SHOULD_NOT_SELECT[skinname] = true

		local assetname = skindata.assetname or skindata.build or skindata.skinname
		table.insert(Assets, Asset("ANIM", "anim/" .. assetname .. ".zip"))
		MakeItemSkin(skindata.prefabname, skindata.skinname, skindata)
	end
end
