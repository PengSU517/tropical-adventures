local assets =
{
    Asset("ANIM", "anim/goddess_statue_fire.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.AnimState:SetRayTestOnBB(true)
    
    inst:AddTag("fx")

	inst.Light:Enable(true)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(190 / 255, 250 / 255, 190 / 255)
	
    inst.AnimState:SetBank("goddess_statue_fire")
    inst.AnimState:SetBuild("goddess_statue_fire")
    inst.AnimState:PlayAnimation("idle_loop",true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "loop")

    return inst
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.AnimState:SetRayTestOnBB(true)
    
    inst:AddTag("fx")
	
	inst.Light:Enable(true)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(190 / 255, 250 / 255, 190 / 255)
	
    inst.AnimState:SetBank("goddess_statue_fire")
    inst.AnimState:SetBuild("goddess_statue_fire")
    inst.AnimState:PlayAnimation("idle_loop",true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "loop")

    return inst
end

return Prefab("goddess_statue_fire", fn, assets),
Prefab("goddess_statue_fire1", fn, assets)
