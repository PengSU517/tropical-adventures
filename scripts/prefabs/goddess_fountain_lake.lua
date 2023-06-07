local assets =
{
    Asset("ANIM", "anim/goddess_fountain_gem.zip"),
	Asset("IMAGE", "images/map_icons/goddess_fountain.tex"),
	Asset("ATLAS", "images/map_icons/goddess_fountain.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")
	
    inst.AnimState:SetBank("goddess_fountain_gem")
    inst.AnimState:SetBuild("goddess_fountain_gem")
    inst.AnimState:PlayAnimation("idle_moon", true)
	
	inst.Transform:SetScale(1.1,1.25,1.1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    return inst
end

return Prefab("goddess_fountain_lake", fn, assets)