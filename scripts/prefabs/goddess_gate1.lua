local assets =
{
    Asset("ANIM", "anim/goddess_gate.zip"),
	Asset("IMAGE", "images/map_icons/goddess_gate.tex"),
	Asset("ATLAS", "images/map_icons/goddess_gate.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddLight()
	
	inst.MiniMapEntity:SetIcon( "goddess_gate.tex" )
	
	MakeObstaclePhysics(inst, .25)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	local s = 4
	inst.Transform:SetScale(s,s,s)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("goddess_gate")
    inst.AnimState:SetBuild("goddess_gate")
    inst.AnimState:PlayAnimation("idle")
	
	inst.Light:Enable(false)
    inst.Light:SetRadius(1)
    inst.Light:SetFalloff(0.2)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(190 / 255, 250 / 255, 190 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("goddess_gate")
	inst:AddTag("goddess_gate1")
	
	inst:AddComponent("teleporter")
    inst.components.teleporter.offset = 0
	
    inst:AddComponent("inspectable")

    return inst
end

return Prefab("goddess_gate1", fn, assets)