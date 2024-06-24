local function shrink(inst, times, startsize, endsize)
    inst.AnimState:SetMultColour(1, 1, 1, 0.33)
    inst.Transform:SetScale(startsize, startsize, startsize)
    inst.components.colourtweener:StartTween({ 1, 1, 1, 0.75 }, times)
    inst.components.sizetweener:StartTween(.5, times, inst.Remove)
end


AddPrefabPostInit("warningshadow", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("sizetweener")
    inst:AddComponent("colourtweener")
    inst.shrink = shrink
end)
