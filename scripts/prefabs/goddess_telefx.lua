local assets =
{
    Asset("ANIM", "anim/deer_fire_charge.zip"),
}

local function removal(inst)
	inst:Remove()
end

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
	inst.entity:AddSoundEmitter()
	
    inst:AddTag("FX")
	
	inst.AnimState:SetBank("deer_fire_charge")
    inst.AnimState:SetBuild("deer_fire_charge")
	inst.AnimState:SetMultColour(0/255, 238/255, 0/255, 1)	
    inst.AnimState:SetRayTestOnBB(true)
	
	inst.AnimState:PlayAnimation("loop")
	inst.AnimState:PushAnimation("pre")
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.AnimState:SetFinalOffset(8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst.KillFX = KillFX
    inst.killtask = inst:DoTaskInTime(35 * FRAMES, KillFX)
	
	inst:DoTaskInTime(0.8, removal)
	
    return inst
end

return Prefab("goddess_telefx", fn, assets)
