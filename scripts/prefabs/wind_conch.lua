local assets =
{
    Asset("ANIM", "anim/wind_conch.zip"),
    Asset("ANIM", "anim/swap_wind_conch.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local function OnPlayed(inst, musician)
    if musician then
        local a, b, c = musician.Transform:GetWorldPosition()
        local casa = GetClosestInstWithTag("interior_center", musician, 30)
        if not casa then
            local vento = SpawnPrefab("ventania")
            vento.Transform:SetPosition(a, b, c)
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("horn2")

    inst.AnimState:SetBank("wind_conch")
    inst.AnimState:SetBuild("wind_conch")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.onplayed = OnPlayed

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)

    inst:AddComponent("inventoryitem")



    inst.hornbuild = "swap_wind_conch"
    inst.hornsymbol = "swap_horn"

    return inst
end

return Prefab("wind_conch", fn, assets)
