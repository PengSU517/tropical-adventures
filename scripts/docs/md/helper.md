

正则表达搜索范例： \tinst\.components\.inventoryitem\.atlasname.*$
GLOBAL.setfenv(1, GLOBAL) --这个是让所有的全局变量挂在global上
dostaticTask 一段时间之后执行函数
puff_fx_cold哈冷气的特效
"feetslipped" 滑倒的动作
通过 ambientlighting  colorcube 和 playervision调节滤镜
没有onblock标签就会被船粘上
grue 控制查理


inst:PushEvent("nightvision", self.nightvision)---跟着的是相应的 参数
inst:ListenForEvent("nightvision", OnNightVision, player)--跟着的是需要执行的函数，以及参数，pushevent传过来的参数会放到执行函数里面，排在player之后



PrefabExists  检查是否有prefab
PREFAB_SKINS_SHOULD_NOT_SELECT不可选择的skin
local task_id = "REGION_LINK_"..tostring(self.region_link_tasks)---连接地形的task