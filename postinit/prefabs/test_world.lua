if TA_CONFIG.DEVELOP.test_map then
	AddPrefabPostInit("forest", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		if inst.components.sharkboimanager then
			inst:RemoveEventCallback("worldmapsetsize", inst.components.sharkboimanager.InitializeSharkBoiManager)
		end
	end)
	-- 去掉洞穴入口的蝙蝠
	AddPrefabPostInit("cave_entrance_open", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		inst.components.childspawner.childreninside = 0
	end)
end
