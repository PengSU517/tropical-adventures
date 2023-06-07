local assets =
{
    Asset("ANIM", "anim/deer_fire_charge.zip"),
}

local function onkillfx(inst, anim)

end

local function KillFX(inst)
	inst:Remove()
end

local function TriggerFX(inst)
    if not inst.killed and inst.fx ~= nil then
        return
    end
    inst.fx = {}
    inst.fxcount = 0
    local function onremovefx(fx)
        OnFXKilled(inst)
    end
    for i, v in ipairs(inst.fxprefabs) do
        local fx = SpawnPrefab(v)
        fx.entity:SetParent(inst.entity)
        inst.fxcount = inst.fxcount + 1
        inst:ListenForEvent("onremove", onremovefx, fx)
        table.insert(inst.fx, fx)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst:AddTag("FX")
	
	inst.AnimState:SetBank("deer_fire_charge")
    inst.AnimState:SetBuild("deer_fire_charge")
	inst.AnimState:SetMultColour(0/255, 238/255, 0/255, 1)	
    inst.AnimState:SetRayTestOnBB(true)
	
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
	
	inst.KillFX = KillFX
    inst.OnKillFX = onkillfx
	inst.TriggerFX = TriggerFX

    return inst
end

return Prefab("goddess_deer_magic", fn, assets)
