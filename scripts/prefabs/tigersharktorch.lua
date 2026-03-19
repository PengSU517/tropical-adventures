local prefabs =
{
    "tigershark",
}

local respawndays = 30

local function OnTimerDone(inst, data)
    if data.name == "spawndelay" then
        local tigershark = SpawnPrefab("tigershark")
        tigershark.Transform:SetPosition(inst.Transform:GetWorldPosition())
        -- tigershark.sg:GoToState("spawnin")
        tigershark.entrada = 1
        inst:Remove()
    end
end



local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("spawndelay", 60 * 8 * respawndays)

    return inst
end

return Prefab("tigershark_spawner", fn, nil, prefabs)
