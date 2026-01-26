AddPrefabPostInit("wurt", function(inst)
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddFoodtypeAffinity("seaweed", 1.33)
        inst.components.foodaffinity:AddFoodtypeAffinity("seaweed_cooked", 1.33)
    end
end)