IsInTropicalArea = function(inst)
    -- local x, _, z = inst:GetPosition():Get()-----这个东西似乎要等待一帧
    local x, _, z = inst.Transform:GetWorldPosition() ----这个东西也取不到值
    return TheWorld.Map:IsTropicalAreaAtPoint(x, 0, z)
end

IsInShipwreckedArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z)
end

IsInHamletArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsHamletAreaAtPoint(x, 0, z)
end

IsInVolcanoArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsVolcanoAreaAtPoint(x, 0, z)
end

IsInHamRoom = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsHamRoomAtPoint(x, 0, z)
end
