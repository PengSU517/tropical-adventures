-- 让原版坟墓也能挖出海难玩具
local trinkets_sw = { "trinket_sw_23" }
AddPrefabPostInit("trinket_1", function() -- 定义在prefab里面，延迟修改
    local PickRandomTrinket = GLOBAL.PickRandomTrinket
    GLOBAL.PickRandomTrinket = function()
        if math.random() < #trinkets_sw / (#trinkets_sw + GLOBAL.NUM_TRINKETS) then
            return trinkets_sw[math.random(1, #trinkets_sw)]
        else
            return PickRandomTrinket()
        end
    end
end)