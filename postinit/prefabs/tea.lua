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
