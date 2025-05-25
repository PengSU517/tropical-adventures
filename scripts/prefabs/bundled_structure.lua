local assets =
{
	Asset("ANIM", "anim/bundled_structure.zip"),
}

local Utils = require "tools/utils"

local function ondeploy(inst, pt, deployer)
	if inst.components.bundled_structure then
		if not inst.components.bundled_structure.cave == not TheWorld:HasTag("cave") then
			inst.components.bundled_structure:Unpack(pt)
			inst:Remove()
		end
	end
end

local function get_name(inst)
    return string.format("%s %s %s",
        "Packaged",
        STRINGS.UI.SERVERCREATIONSCREEN[not inst._cave:value() and "FORESTWORLD" or "CAVEWORLD"],
        tostring(inst._name:value() or "Object"))
end

local function OnSave(inst, data)
	if inst.inv_image_bg then
		data.image = inst.components.inventoryitem.imagename
		data.bgimage = inst.inv_image_bg.image
		data.bgatlas = inst.inv_image_bg.atlas
	end
end

local function OnLoad(inst, data)
	if data.bgimage then
		inst.inv_image_bg = {
			image = data.bgimage,
			atlas = data.bgatlas,
		}
		inst.components.inventoryitem:ChangeImageName(data.image)
	end
end

local function fn()
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
    inst:AddTag("nosteal")
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
		if self.inst._cave:value() ~= TheWorld:HasTag("cave") then return { false }, true end
	end)
	deployable.ondeploy = ondeploy

	inst:AddComponent("inventoryitem")

	-- inst.OnSave = OnSave
	-- inst.OnLoad = OnLoad

	MakeMediumBurnable(inst)
	MakeMediumPropagator(inst)
	MakeHauntableLaunchAndSmash(inst)

	return inst
end

return Prefab("bundled_structure", fn, assets),
	MakePlacer("bundled_structure_placer", "bundled_structure", "bundled_structure", "idle")
