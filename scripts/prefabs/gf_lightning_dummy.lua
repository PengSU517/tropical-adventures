local function lightningdummyfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddComponent("gflightningdrawer")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(10, inst.Remove)

    return inst
end

return Prefab( "gf_lightning_dummy", lightningdummyfn)
    
