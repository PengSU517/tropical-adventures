AddReplicableComponent("hayfever")

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if TUNING.hayfever then
        inst:AddComponent("hayfever")
    end
end)
