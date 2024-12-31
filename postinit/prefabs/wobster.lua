for _, v in ipairs({"wobster_sheller", "wobster_moonglass"}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("lobster")
        if not TheWorld.ismastersim then return inst end

        local lootdropper = inst:AddComponent("lootdropper")
        lootdropper.trappable = true
        lootdropper:SetLoot({v .. "_land"})

    end)
end