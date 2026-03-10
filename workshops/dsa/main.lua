if KnownModIndex:IsModEnabled("workshop-2657513551") then
    AddPrefabPostInit("world", function(inst)
        inst:AddComponent("dsa_aporkalypse_proxy")
    end)
end
