# **pigman_city的主要任务是生成各种猪人的prefab --杰杰**

最顶层的函数为：

```lua
local function makepigman(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)  
	return Prefab("common/objects/" .. name, makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab), assets, prefabs)
end
```

通过调用不同参数的makepigman去生成不同类型的猪人，以下是生成的不同类型猪人的列表：

```lua
    makepigman("pigman_beautician", "pig_beautician", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_florist", "pig_florist", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_erudite", "pig_erudite", nil, nil, nil, { "emote_nohat" }, "FEMALE"),
    makepigman("pigman_hatmaker", "pig_hatmaker", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_storeowner", "pig_storeowner", nil, nil, nil, { "emote_nohat" }, "FEMALE"),
    makepigman("pigman_banker", "pig_banker", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_collector", "pig_collector", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_hunter", "pig_hunter", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mayor", "pig_mayor", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mechanic", "pig_mechanic", true, nil, nil, nil, "MALE"),
    makepigman("pigman_professor", "pig_professor", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_usher", "pig_usher", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_royalguard", "pig_royalguard", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_2", "pig_royalguard_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_farmer", "pig_farmer", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_miner", "pig_miner", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_queen", "pig_queen", nil, nil, nil, { "pigqueen", "emote_nohat" }, "FEMALE"),
    makepigman("pigman_beautician_shopkeep", "pig_beautician", nil, nil, true, nil, "FEMALE", "pigman_beautician"),
    makepigman("pigman_florist_shopkeep", "pig_florist", nil, nil, true, nil, "FEMALE", "pigman_florist"),
    makepigman("pigman_erudite_shopkeep", "pig_erudite", nil, nil, true, { "emote_nohat" }, "FEMALE", "pigman_erudite"),
    makepigman("pigman_hatmaker_shopkeep", "pig_hatmaker", nil, nil, true, nil, "FEMALE", "pigman_hatmaker"),
    makepigman("pigman_storeowner_shopkeep", "pig_storeowner", nil, nil, true, { "emote_nohat" }, "FEMALE",
        "pigman_storeowner"),
    makepigman("pigman_banker_shopkeep", "pig_banker", nil, nil, true, { "emote_nohat" }, "MALE", "pigman_banker"),
    makepigman("pigman_shopkeep", "pig_banker", nil, nil, true, nil, "MALE", "pigman_banker"), -- default
    makepigman("pigman_hunter_shopkeep", "pig_hunter", nil, nil, true, nil, "MALE", "pigman_hunter"),
    makepigman("pigman_mayor_shopkeep", "pig_mayor", nil, nil, true, nil, "MALE", "pigman_mayor"),
    makepigman("pigman_farmer_shopkeep", "pig_farmer", nil, nil, true, nil, "MALE", "pigman_farmer"),
    makepigman("pigman_miner_shopkeep", "pig_miner", nil, nil, true, nil, "MALE", "pigman_miner"),
    makepigman("pigman_collector_shopkeep", "pig_collector", nil, nil, true, nil, "MALE", "pigman_collector"),
    makepigman("pigman_professor_shopkeep", "pig_professor", nil, nil, true, { "emote_nohat" }, "MALE",
        "pigman_professor"),
    makepigman("pigman_mechanic_shopkeep", "pig_mechanic", nil, nil, true, nil, "MALE", "pigman_mechanic"),
    makepigman("pigman_eskimo_shopkeep", "pig_eskimo", nil, nil, true, nil, "MALE", "pig_eskimo"),
    makepigman("pig_shopkeeper", "pig_shopkeeper", nil, nil, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich", "pig_royalguard_rich", nil, true, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich_2", "pig_royalguard_rich_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_3", "pig_royalguard_3", nil, true, nil, nil, "MALE"),
    makepigman("pig_eskimo", "pig_eskimo", nil, true, nil, nil, "MALE")

```


## **关于出现"你有 %s吗？我可以付钱。"的问题：**

1.定位到使用该文本的代码段为函数：

```lua
local function ShouldAcceptItem(inst, item)
end
```

根据函数名推测这是一个判定给物品是否应当接受的函数。但目前游戏中城镇猪人在对视或等待时就会说出该句话。

函数传入了两个参数，inst推测是猪人自己，而item是给予的物品。

该函数首先判断inst是否在睡觉：

```lua
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        return false
    end
```

判断物品是否具有edible组件：

```lua
 if item.components.edible then
        if (item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "HORRIBLE")
            and inst.components.follower.leader
            and inst.components.follower:GetLoyaltyPercent() > 0.9 then
            return false
        end

        if (item.components.edible.foodtype == "VEGGIE" or item.components.edible.foodtype == "RAW") then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            if last_eat_time and last_eat_time < TUNING.PIG_MIN_POOP_PERIOD then
                return false
            end

            if inst.components.inventory:Has(item.prefab, 1) then
                return false
            end
        end
    end
```

判断物品是不是呼噜币：

```lua
if item.prefab == "oinc" or item.prefab == "oinc10" or item.prefab == "oinc100" then --or trinket_giftshop
        return true
    end
```

判断inst是不是守卫猪人或者esikmo猪人

```lua
if not inst:HasTag("guard") or inst.prefab == "pig_eskimo" then
```

初始化了一些局部变量：

1.一岛 city =1，二岛 city = 2

```lua
        local city = 1
        if inst:HasTag("city2") then
            city = 2
        end
```

2.拿到世界组件中的经济组件 econ

```lua
	local econ = TheWorld.components.economy
```

3.拿到猪人的预制件 econprefab，如果猪人有econprefab，用猪人的econprefab

```lua
	local econprefab = inst.prefab
        	if inst.econprefab then
            	econprefab = inst.econprefab
        	end
```

5.想要的物品wanteditems根据econ组件调用函数GetTradeItems(econprefab)获得

```lua
	local wanteditems = econ:GetTradeItems(econprefab)
```

6.desc?

```lua
	local wanteditems = econ:GetTradeItems(econprefab)
```

7.默认想要物品是false

```lua
 local wantitem = false
```

8.在想要物品列表里迭代，如果物品的预制件和想要物品相同，那么就让wantitem = true

```lua

        for i, wanted in ipairs(wanteditems) do
            if wanted == item.prefab then
                wantitem = true
                break
            end
        end
```

9.如果是女王雕像或者皇室明信片，并且在岛一，猪人没有标签recieved_trinket，wantitem =true

```lua
        if (item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3") and inst:HasTag("city1") and not inst:HasTag("recieved_trinket") then
            wantitem = true
        end
```

如果是蓝色母猪或者宝石松露，猪人没有女王标签， wantitem = false

```lua
        if (item.prefab == "relic_4" or item.prefab == "relic_5") and not inst:HasTag("pigqueen") then
            wantitem = false
        end
```

以上判定完之后判断 wantitem，如果是true，则进入

```lua
		if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" then
                return true
            end

            local delay = econ:GetDelay(econprefab, city, inst)
            if inst:HasTag("troqueihoje") and not (inst.prefab == "pigman_storeowner" or inst.prefab == "pigman_banker" or inst.prefab == "pigman_mayor" or inst.prefab == "pigman_queen" or inst.prefab == "pigman_professor" or inst.prefab == "pigman_collector" or inst.prefab == "pigman_mechanic" or inst.prefab == "pigman_storeowner_shopkeep" or inst.prefab == "pigman_banker_shopkeep" or inst.prefab == "pigman_mayor_shopkeep" or inst.prefab == "pigman_professor_shopkeep" or inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_mechanic_shopkeep") then
                if inst:HasTag("troqueihoje") then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW))
                    --inst.components.talker:Say(  getSpeechType(inst,STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW) )
                else
                    inst.sayline(inst,
                        string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay)))
                    --inst.components.talker:Say( string.format( getSpeechType(inst,STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay) ) )
                end
                return false
            else
                return true
            end
```

wantitem为false，进入

```lua
            if item:HasTag("relic") then
                if item.prefab == "relic_4" or item.prefab == "relic_5" then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_PRICELESS_GIFT))
                elseif (inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_collector") then
                    return true
                else
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_RELIC_GIFT))
                    --inst.components.talker:Say( getSpeechType(inst,STRINGS.CITY_PIG_TALK_RELIC_GIFT) )
                end
            else
                if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" and inst:HasTag("city1") then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_TRINKET_GIFT))
                else
                    --HUGO
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT))
                    --inst.components.talker:Say( string.format( getSpeechType(inst,STRINGS.CITY_PIG_TALK_REFUSE_GIFT), desc ) )
                end
            end
            return false
        end
```

也就是说，当调用ShouldAcceptItem函数时，所有的判定均失效的情况下就会说出逆天无比的话：

"你有 %s吗？我可以付钱。"

## 何时会调用ShouldAcceptItem函数呢？

在makefn函数中可以找到猪人添加了组件trader：

```lua
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem
```

mod中没有trader组件，应该是原版饥荒的trader

```lua
local Trader = Class(function(self, inst)
    self.inst = inst
    self.enabled = true
    self.deleteitemonaccept = true
    self.acceptnontradable = false
    self.test = nil
    self.abletoaccepttest = nil

    self.acceptstacks = nil

    --V2C: Recommended to explicitly add tags to prefab pristine state
    --On construciton, "trader" tag is added by default
    --If acceptnontradable will be true, then "alltrader" tag should also be added
end,
nil,
{
    enabled = onenabled,
    acceptnontradable = onacceptnontradable,
})
```


|  |  |  |  |  |
| :- | :- | :- | :- | -: |
