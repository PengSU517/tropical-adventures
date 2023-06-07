local assets=
{
	Asset("ANIM", "anim/peach_tree.zip"),
}

local prefabs =
{
    "peach",
    "ash",
    "twigs",
}    


local function onregenfn(inst)
	if inst:HasTag("peach4") then
		inst.AnimState:PlayAnimation("peach4",true)
	elseif inst:HasTag("peach3") then
		inst.AnimState:PlayAnimation("peach3",true)
	elseif inst:HasTag("peach2") then
		inst.AnimState:PlayAnimation("peach2",true)
	elseif inst:HasTag("peach1") then
		inst.AnimState:PlayAnimation("peach1",true)
	end
end

local function makefullfn(inst)
	if inst:HasTag("peach4") then
		inst.AnimState:PlayAnimation("peach4",true)
	elseif inst:HasTag("peach3") then
		inst.AnimState:PlayAnimation("peach3",true)
	elseif inst:HasTag("peach2") then
		inst.AnimState:PlayAnimation("peach2",true)
	elseif inst:HasTag("peach1") then
		inst.AnimState:PlayAnimation("peach1",true)
	end
end

local function onpickedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	if inst:HasTag("peach4") then
		inst.AnimState:PlayAnimation("peach4_pick") 
		inst.AnimState:PushAnimation("idle_loop4", true)
	elseif inst:HasTag("peach3") then
		inst.AnimState:PlayAnimation("peach3_pick") 
		inst.AnimState:PushAnimation("idle_loop3", true)
	elseif inst:HasTag("peach2") then
		inst.AnimState:PlayAnimation("peach2_pick") 
		inst.AnimState:PushAnimation("idle_loop2", true)
	elseif inst:HasTag("peach1") then
		inst.AnimState:PlayAnimation("peach1_pick") 
		inst.AnimState:PushAnimation("idle_loop1", true)
	end
end

local function makeemptyfn(inst)
	if inst:HasTag("peach4") then
		inst.AnimState:PushAnimation("idle_loop4", true)
	elseif inst:HasTag("peach3") then
		inst.AnimState:PushAnimation("idle_loop3", true)
	elseif inst:HasTag("peach2") then
		inst.AnimState:PushAnimation("idle_loop2", true)
	elseif inst:HasTag("peach1") then
		inst.AnimState:PushAnimation("idle_loop1", true)
	end
end


local function startburn(inst)
	inst.burnt = true
    if inst.components.pickable then
        inst:RemoveComponent("pickable")
    end
    
end


local function makeburnt(inst)
	inst.burnt = true
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	if math.random () * 2 >=1.2 then
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	end
	if math.random () * 2 >=1.5 then
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	end
    inst:Remove()
end


local function tree_onsave(inst, data)
        data.no_banana = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    end

local function tree_onload(inst, data)
    if data ~= nil then
            if data.no_banana and inst.components.pickable ~= nil then
                inst.components.pickable.canbepicked = false

			end
    end
end

local function dig_tree(inst)
    inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst:Remove()
end

local function makebarrenfn(inst)
	local rnd = math.random() * 100
	if inst:HasTag("peach4") then
		if rnd <= 45 then
			SpawnPrefab("peach_tree5").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("goddess_spider_hostile").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	elseif inst:HasTag("peach3") then
		if rnd <= 35 then
			SpawnPrefab("peach_tree5").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("goddess_spider_hostile").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	elseif inst:HasTag("peach2") then
		if rnd <= 25 then
			SpawnPrefab("peach_tree5").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("goddess_spider_hostile").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	elseif inst:HasTag("peach1") then
		if rnd <= 15 then
			SpawnPrefab("peach_tree5").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("goddess_spider_hostile").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	end
end

local function chopped_tree(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	inst.AnimState:PlayAnimation("fall",true)
	
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst.components.lootdropper:SpawnLootPrefab("log")
	
	local rnd = math.random() * 100

	if rnd <= 35 then
		inst.components.lootdropper:SpawnLootPrefab("peach_pit")
	elseif rnd <= 55 then
		inst.components.lootdropper:SpawnLootPrefab("peach_pit")
		inst.components.lootdropper:SpawnLootPrefab("peach_pit")
	end
	
    inst:Remove()    
end

local function OnGetItem(inst, giver, item)
	if item:HasTag("poopy") and not TheWorld.state.iswinter then
		inst.SoundEmitter:PlaySound("dontstarve/common/bush_fertilize")
		local rnd = math.random() * 100
		if rnd <= 15 then
			inst.peach = SpawnPrefab("peach_tree")
			inst.peach.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.peach.components.pickable:MakeEmpty()
			inst:Remove()
		elseif rnd <= 50 then
			inst.peach = SpawnPrefab("peach_tree2")
			inst.peach.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.peach.components.pickable:MakeEmpty()
			inst:Remove()
		elseif rnd <= 85 then
			inst.peach = SpawnPrefab("peach_tree3")
			inst.peach.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.peach.components.pickable:MakeEmpty()
			inst:Remove()
		else
			inst.peach = SpawnPrefab("peach_tree1")
			inst.peach.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.peach.components.pickable:MakeEmpty()
			inst:Remove()
		end 
	end
end

local function chop_tree(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")

	if inst.components.pickable ~= nil and inst.components.pickable.canbepicked then
		if inst:HasTag("peach4") then
			inst.AnimState:PlayAnimation("peach4_pick",true)
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
		elseif inst:HasTag("peach3") then
			inst.AnimState:PlayAnimation("peach3_pick",true)
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
		elseif inst:HasTag("peach2") then
			inst.AnimState:PlayAnimation("peach2_pick",true)
			inst.components.lootdropper:SpawnLootPrefab("peach")
			inst.components.lootdropper:SpawnLootPrefab("peach")
		elseif inst:HasTag("peach1") then
			inst.AnimState:PlayAnimation("peach1_pick",true)
			inst.components.lootdropper:SpawnLootPrefab("peach")
		end

	elseif inst:HasTag("peach5") then
		inst.AnimState:PlayAnimation("chopping",true)
	else
		inst.AnimState:PlayAnimation("chop",true)
    end
	if inst.components.pickable ~= nil then
		inst.components.pickable:MakeEmpty(true)
	end
end


local function common_fn(anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon( "peach.tex" )

	MakeObstaclePhysics(inst,.5)
	
    inst.AnimState:SetBank("peach_tree")
    inst.AnimState:SetBuild("peach_tree")
    inst.AnimState:PlayAnimation(anim,true)
    
	inst.AnimState:SetTime(math.random()*2)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.jostlepick = true
    inst.components.pickable.droppicked = true
    inst.components.pickable.dropheight = 4

	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable") 
	
	inst:AddComponent("workable")

    ---------------------        
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
	MakeNoGrowInWinter(inst)
	---------------------   
    inst.components.burnable:SetOnIgniteFn(startburn)
	inst.components.burnable:SetOnBurntFn(makeburnt)
	
	inst:ListenForEvent ("picked", makebarrenfn)
	
	inst.OnSave = tree_onsave
    inst.OnLoad = tree_onload
  
    return inst
end

local function peach4()
	local inst = common_fn("peach4")
	
	inst:AddTag("peach4")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.pickable:SetUp("peach", 480*7,4)
	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chopped_tree)
	inst.components.workable:SetWorkLeft(15)
	
	return inst
end

local function peach3()
	local inst = common_fn("peach3")
	
	inst:AddTag("peach3")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.pickable:SetUp("peach", 480*6,3)
	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chopped_tree)
	inst.components.workable:SetWorkLeft(15)
	
	return inst
end

local function peach2()
	local inst = common_fn("peach2")
	
	inst:AddTag("peach2")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.pickable:SetUp("peach", 480*4,2)
	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chopped_tree)
	inst.components.workable:SetWorkLeft(15)
	
	return inst
end

local function peach1()
	local inst = common_fn("peach1")
	
	inst:AddTag("peach1")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.pickable:SetUp("peach", 480*3)
	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chopped_tree)
	inst.components.workable:SetWorkLeft(15)
	
	return inst
end

local function peach5()
	local inst = common_fn("peach5")
	
	inst:AddTag("peach5")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveComponent("pickable")
	
	inst:AddComponent("trader")
	inst.components.trader.onaccept = OnGetItem
	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chopped_tree)
	inst.components.workable:SetWorkLeft(15)
	
	return inst
end

local function peach0()
	local inst = common_fn("peach0")
	
	inst:AddTag("peach0")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveComponent("pickable")
	
	inst:AddComponent("trader")
	inst.components.trader.onaccept = OnGetItem
	
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_tree)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

return 	Prefab("peach_tree", peach4, assets, prefabs),
		Prefab("peach_tree3", peach3, assets, prefabs),
		Prefab("peach_tree2", peach2, assets, prefabs),
		Prefab("peach_tree1", peach1, assets, prefabs),
		Prefab("peach_tree5", peach5, assets, prefabs),
		Prefab("peach_tree0", peach0, assets, prefabs)
