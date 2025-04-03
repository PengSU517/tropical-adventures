AddReplicableComponent("hayfever")
AddReplicableComponent("foggroggy")

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if TUNING.hayfever then
        inst:AddComponent("hayfever")
    end

    if TUNING.fog then
        inst:AddComponent("foggroggy")
    end
end)
