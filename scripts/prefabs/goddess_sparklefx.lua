local assets =
{
    Asset("ANIM", "anim/wind_burst.zip"),
}

local function KillFX(inst)
    if inst.killtask ~= nil then
		inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst:AddTag("FX")
	
	inst.AnimState:SetBank("wind_burst")
    inst.AnimState:SetBuild("wind_burst")
    inst.AnimState:SetRayTestOnBB(true)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.AnimState:PlayAnimation("idle",false)
	
	inst.AnimState:SetFinalOffset(8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
    inst.KillFX = KillFX
    inst.killtask = inst:DoTaskInTime(35 * FRAMES, KillFX)

    return inst
end

return Prefab("goddess_sparklefx", fn, assets)
