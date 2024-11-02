

正则表达搜索范例： \tinst\.components\.inventoryitem\.atlasname.*$
GLOBAL.setfenv(1, GLOBAL) --这个是让所有的全局变量挂在global上
dostaticTask 一段时间之后执行函数
puff_fx_cold哈冷气的特效
"feetslipped" 滑倒的动作




-- "quest", 相关prefab  会生成一个老式对话框
-------------这两个rpc干什么用的暂时未知
AddModRPCHandler("volcanomod", "quest1", function(inst)
    local portalinvoca1 = GLOBAL.SpawnPrefab("log")
    local a, b, c = inst.Transform:GetWorldPosition()
    portalinvoca1.Transform:SetPosition(a + 4, b, c - 4)

    GLOBAL.TheFrontEnd:PopScreen()
    GLOBAL.SetPause(false)
    --inst:Remove()
end)
AddModRPCHandler("volcanomod", "quest2", function(inst)
    GLOBAL.TheFrontEnd:PopScreen()
    GLOBAL.SetPause(false)
    --inst:Remove()
end)