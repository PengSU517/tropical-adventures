AddReplicableComponent("hayfever")
AddReplicableComponent("foggroggy")

AddPlayerPostInit(function(inst)
    if TheWorld.ismastersim then
        if not inst.components.regionaware then
            inst:AddComponent("regionaware")
        end

        if TUNING.hamlet then
            if TUNING.hayfever then
                inst:AddComponent("hayfever")
            end

            if TUNING.fog then
                inst:AddComponent("foggroggy")
            end
        end
    end

    inst:AddComponent("infestable")
    inst:AddComponent("shopper")
end)
