local assets =
{
	Asset("ANIM", "anim/bundled_structure.zip"),
}

local Utils = require "tools/utils"

local function ondeploy(inst, pt, deployer)
	if inst.components.bundled_structure and inst.components.bundled_structure.cave == TheWorld:HasTag("cave") then
		inst.components.bundled_structure:Unpack(pt)
		inst:Remove()
	end
end

local function get_name(inst)
    local worldstr = not inst._cave:value() and "Forest " or "Cave "
	return #inst._name:value() > 0 and "Packaged " .. worldstr .. inst._name:value() or "Packaged " .. worldstr .. "objects"
end

local function fullfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("bundled_structure")
	inst.AnimState:SetBuild("bundled_structure")
	inst.AnimState:PlayAnimation("idle")
	inst:AddTag("bundled_structure")
	inst:AddTag("nonpackable")
    inst._cave = net_bool(inst.GUID, "bundled_structure._cave")
	inst._name = net_string(inst.GUID, "bundled_structure._name")
	inst.displaynamefn = get_name

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	inst:AddComponent("inspectable")

	inst:AddComponent("bundled_structure")
	local deployable = inst:AddComponent("deployable")
    Utils.FnDecorator(deployable, "CanDeploy", function(self)
        if self.inst._cave:value() ~= TheWorld:HasTag("cave") then return {false}, true end
    end)
	deployable.ondeploy = ondeploy

	inst:AddComponent("inventoryitem")



	MakeMediumBurnable(inst)
	MakeMediumPropagator(inst)
	MakeHauntableLaunchAndSmash(inst)

	return inst
end

return Prefab("bundled_structure", fullfn, assets),
	MakePlacer("bundled_structure_placer", "bundled_structure", "bundled_structure", "idle")
