return Prefab("collapsed_honeychest", function()
    local inst = Prefabs.collapsed_treasurechest.fn()
    inst.AnimState:SetScale(0.75, 0.75)
    inst:SetPrefabName("collapsed_honeychest")
    inst:SetPrefabNameOverride("collapsedhoneychest")
	return inst
end)