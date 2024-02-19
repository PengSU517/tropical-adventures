--蓝图不可点燃
AddPrefabPostInit("pugaliskfountain_made_blueprint", function(inst)
    inst.AnimState:SetBank("blueprint_rare")
    inst.AnimState:SetBuild("blueprint_rare")
	if inst.components.inventoryitem then
		inst.components.inventoryitem:ChangeImageName("blueprint_rare")
	end
	if inst.components.burnable then
		inst:RemoveComponent("burnable")
	end
	if inst.components.propagator then
		inst:RemoveComponent("propagator")
	end
end)