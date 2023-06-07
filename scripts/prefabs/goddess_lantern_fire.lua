local assets =
{
    Asset("ANIM", "anim/wind_flakes.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    inst:AddTag("FX")
	
	inst.AnimState:SetBank("wind_flakes")
    inst.AnimState:SetBuild("wind_flakes")
    inst.AnimState:SetRayTestOnBB(true)
	
	inst.AnimState:PlayAnimation("pre", false)
    inst.AnimState:PushAnimation("loop", true)

    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(150 / 255, 200 / 255, 150 / 255)
    inst.Light:SetFalloff(.9)
    inst.Light:SetRadius(8)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("goddess_lantern_fire", fn, assets)
