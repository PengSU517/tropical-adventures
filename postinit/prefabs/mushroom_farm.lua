--------------------------------------------------------------------------
--[[ 让蘑菇农场能种植新东西 ]]--来自老版棱镜，感谢梧桐山大佬的无私分享！
--------------------------------------------------------------------------

local mushroom_farm_seeds = {
    cutlichen = { product = "cutlichen", produce = 4 },
    foliage = { product = "foliage", produce = 6 },
    --quagmire_mushrooms = { product = "quagmire_mushrooms", produce = 4 }
}
AddPrefabPostInit("mushroom_farm", function(inst)
    local AbleToAcceptTest_old = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(farm, item, ...)
        if item ~= nil then
            if farm.remainingharvests == 0 then
                if item.prefab == "shyerrylog" then
                    return true
                end
            elseif mushroom_farm_seeds[item.prefab] ~= nil then
                return true
            end
        end
        return AbleToAcceptTest_old(farm, item, ...)
    end)

    local OnAccept_old = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(farm, giver, item, ...)
        if farm.remainingharvests ~= 0 and mushroom_farm_seeds[item.prefab] ~= nil then
            if farm.components.harvestable ~= nil then
                local data = mushroom_farm_seeds[item.prefab]
                local max_produce = data.produce
                local grow_time = TUNING.MUSHROOMFARM_FULL_GROW_TIME
                local grower_skilltreeupdater = giver.components.skilltreeupdater
                if grower_skilltreeupdater ~= nil then
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade") then
                        max_produce = 6
                    end
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
                    elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
                    end
                end

                if item.prefab == "foliage" then
                    farm.AnimState:OverrideSymbol(
                        "swap_mushroom",
                        TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                        "swap_mushroom"
                    )
                else
                    farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                end
                farm.components.harvestable:SetProduct(data.product, max_produce)
                farm.components.harvestable:SetGrowTime(grow_time/max_produce)
                farm.components.harvestable:Grow()

                TheWorld:PushEvent("itemplanted", { doer = giver, pos = farm:GetPosition() }) --this event is pushed in other places too
            end
        else
            OnAccept_old(farm, giver, item, ...)
        end
    end

    local OnLoad_old = inst.OnLoad
    inst.OnLoad = function(farm, data)
        OnLoad_old(farm, data)
        if data ~= nil and not data.burnt and data.product ~= nil then
            for k,v in pairs(mushroom_farm_seeds) do
                if v.product == data.product then
                    if data.product == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    break
                end
            end
        end
    end
end)