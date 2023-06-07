local assets =
{
    Asset("ANIM", "anim/deer_ice_circle.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst:AddTag("FX")
	
	inst.AnimState:SetBank("deer_ice_circle")
    inst.AnimState:SetBuild("deer_ice_circle")
	inst.AnimState:SetMultColour(144/255, 238/255, 144/255, 1)
    inst.AnimState:SetRayTestOnBB(true)
	
	local s = 0.7
	inst.Transform:SetScale(s,s,s)
	
	inst.AnimState:PlayAnimation("pre")
	inst.AnimState:PushAnimation("loop",true)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst.AnimState:SetFinalOffset(8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("goddess_magicfx", fn, assets)
