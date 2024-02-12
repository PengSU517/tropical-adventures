if --[[GetModConfigData("kindofworld") == 20]] false then
    AddPrefabPostInit("rocks", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)
    AddPrefabPostInit("nitre", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)
    AddPrefabPostInit("flint", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)
    AddPrefabPostInit("goldnugget", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)

    AddPrefabPostInit("moonrocknugget", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)

    AddPrefabPostInit("moonglass", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)

    AddPrefabPostInit("moonrockseed", function(inst)
        GLOBAL.MakeInventoryFloatable(inst, "small", 0.15)
        if GLOBAL.TheWorld.ismastersim then
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end
    end)
end
