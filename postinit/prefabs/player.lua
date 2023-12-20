AddPrefabPostInitAny(function(inst)
    if inst:HasTag("player") then
        if inst.components.shopper == nil then
            inst:AddComponent("shopper")
        end

        if inst.components.infestable == nil then
            inst:AddComponent("infestable")
        end


        if inst.components.drownable == nil then
            inst:AddComponent("drownable")
        end
    end
end)
