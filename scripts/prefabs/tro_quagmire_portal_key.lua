local assets =
{
    Asset("ANIM", "anim/quagmire_portal_key.zip"),
}

local function OnTurnOn(inst)
inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_run","sound")
end

local function OnTurnOff(inst)
inst:DoTaskInTime(1.5, function() 
inst.SoundEmitter:KillSound("sound")
inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding","sound")     
end)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()	
    inst.entity:AddSoundEmitter()

    MakeInventoryFloatable(inst)
	
    inst.AnimState:SetBank("quagmire_portal_key")
    inst.AnimState:SetBuild("quagmire_portal_key")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("prototyper")
    inst:AddTag("no_interior_protoyping")
    inst:AddTag("irreplaceable")	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
    inst.components.prototyper.onturnoff = OnTurnOff    
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.GORGE_TWO

    return inst
end

return Prefab("quagmire_portal_key", fn, assets)
