# 世界生成相关设置

世界设置项通过worldservercreationmain.lua进行配置

通过 `local Customize = require("map/customize")` 导入相关数据


比较关键的问题是这些内容是怎么影响世界生成的

`world_gen_data = json.decode(GEN_PARAMETERS)`获取世界设置信息？
`local level = Level(world_gen_data.level_data)` 将设置信息整合到level.override中


参考读取世界设置
```
GLOBAL.Sea2Land = {
        DATA = {
            Sea2landSpinnerPos = { 0, -50, 0 },
        }
    }
    local DATA_FILE = "mod_config_data/sea2land_data_save"

    GLOBAL.Sea2Land.LoadData = function()
        TheSim:GetPersistentString(DATA_FILE, function(load_success, str)
            if load_success and #str > 0 then
                local run_success, data = RunInSandboxSafe(str)
                if run_success then
                    for k, v in pairs(data) do
                        if v ~= nil then
                            GLOBAL.Sea2Land.DATA[k] = v
                        end
                    end
                end
            end
        end)
    end

    GLOBAL.Sea2Land.SaveData = function()
        SavePersistentString(DATA_FILE, DataDumper(GLOBAL.Sea2Land.DATA, nil, true), false, nil)
    end

```