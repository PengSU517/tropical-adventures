-- 茶在冰箱里腐烂会转化为冰茶
local function changeonperishreplacement(inst)
    local owner = inst.components.inventoryitem:GetContainer()
    inst.components.perishable.onperishreplacement = owner and owner.inst.prefab == "icebox" and "iced" .. inst.prefab or "spoiled_food"
end

AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if inst.food_basename and inst.food_basename == "tea" then
        inst.components.inventoryitem:SetOnPutInInventoryFn(changeonperishreplacement) -- 自家prefab不再嵌套hook了
        inst.components.inventoryitem:SetOnDroppedFn(changeonperishreplacement)
    end
end)

-- 海难特色料理转化
local function changeName(inst, ...)
    inst.prefab = inst.prefab:sub(1, -4)
    inst:RemoveEventCallback("onputininventory", changeName)
end
for _, v in ipairs({ "butterflymuffin_sw", "lobsterbisque_sw", "lobsterdinner_sw", }) do
    AddPrefabPostInit(v, function(inst)
        inst._old_prefab = inst.prefab
        local old_oneat = inst.components.edible.oneaten
        inst.components.edible:SetOnEatenFn(function(inst, eater, ...)
            eater:PushEvent("learncookbookstats", inst._old_prefab or inst.prefab)
            inst._old_prefab = nil
            if old_oneat then
                old_oneat(inst, eater, ...)
            end
        end)
        inst:ListenForEvent("onputininventory", changeName)
    end)
end