# 世界生成相关设置

世界设置项通过worldservercreationmain.lua进行配置

通过 `local Customize = require("map/customize")` 导入相关数据


比较关键的问题是这些内容是怎么影响世界生成的

`world_gen_data = json.decode(GEN_PARAMETERS)`获取世界设置信息？
`local level = Level(world_gen_data.level_data)` 将设置信息整合到level.override中