AddPlayerPostInit(function(inst)
    if TheWorld.ismastersim then
        if not inst.components.regionaware then
            --print("Adding regionaware to player")
            inst:AddComponent("regionaware")
        end
    end

    if inst.components.infestable == nil then
        inst:AddComponent("infestable")
    end


    if inst.components.drownable == nil then
        inst:AddComponent("drownable")
    end

    if inst.components.shopper == nil then
        inst:AddComponent("shopper")
    end
end)
