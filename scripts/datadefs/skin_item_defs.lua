local itemskins =
{
    double_umbrellahat = {
        default = {
            basebuild = "hat_double_umbrella",
        },
        double_umbrellahat_palmleaf = {
            assetname = "hat_double_umbrella_palm",
            build = "hat_double_umbrella_palm", --原物品scml文件名字
            build_name_override = "hat_double_umbrella_palm",
            rarity = "Eternal",                 --珍惜度:会影响皮肤名字的显示颜色
            -- type = "item",      --类别
            name = "palmleaf",                  --填皮肤的名称:经典,小熊,小猫,小狗什么的

        },
        double_umbrellahat_sharkitten = {
            assetname = "hat_double_umbrella_sharkitten",
            build = "hat_double_umbrella_sharkitten",
            build_name_override = "hat_double_umbrella_sharkitten",
            rarity = "Elegant",
            -- type = "item",
            name = "sharkitten",
        },
    },
}



for prefabname, prefabdata in pairs(itemskins) do
    for skinname, skindata in pairs(prefabdata) do
        if skinname ~= "default" then
            skindata = tableutil.deep_merge(skindata, prefabdata.default) or skindata
            skindata.prefabname = skindata.prefabname or prefabname
            skindata.skinname = skindata.skinname or skinname

            skindata.build = skindata.build or skindata.skinname
            skindata.basebuild = skindata.basebuild or skindata.prefabname
            skindata.basebank = skindata.basebank or skindata.basebuild
            skindata.image = skindata.image or skindata.skinname

            skindata.name = skindata.name or STRING.NAMES[string.upper(skindata.skinname)] or skindata.skinname
        end
    end
end

for prefabname, prefabdata in pairs(itemskins) do
    prefabdata.default = nil ----赋值给皮肤base数据之后就没啥用了
end


return { skinlist = itemskins }
