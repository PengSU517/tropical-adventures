local assets =
{
    Asset("ANIM", "anim/plant_gem.zip"),
	Asset("ANIM", "anim/gem.zip"),
}

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder") and not inst:HasTag("magicy") and TheWorld.state.isnight
end


local function onpickedfn(inst, picker)
--local x, y, z = inst.Transform:GetWorldPosition()
--local gem_flower = SpawnPrefab("gem_flower") 
--if gem_flower then 
--gem_flower.Transform:SetPosition(x, y, z) 
--gem_flower.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
--end 
inst:Remove()
end

local function mature(inst)
	
	inst:AddTag("magicy")
	
	inst.Light:Enable(true)
	
	inst:DoTaskInTime(0, function (inst)
	inst.AnimState:PlayAnimation("grow_pst")
	end)
	
	inst:DoTaskInTime(1.6, function (inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	inst.AnimState:PlayAnimation("grow_pst")
	inst.Light:Enable(true)
	local rnd = math.random() * 100
	if rnd <= 20 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "red")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("redgem",nil,3)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("redg")
	elseif rnd <= 40 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "blue")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("bluegem",nil,3)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("blueg")
	elseif rnd <= 50 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "orange")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("orangegem",nil,2)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("orangeg")
	elseif rnd <= 60 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "green")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("greengem",nil,2)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("greeng")
	elseif rnd <= 70 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "yellow")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("yellowgem",nil,2)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("yellowg")
	elseif rnd <= 85 then
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "opal")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("mixed_gem")
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("mixedg")
	else
		inst.AnimState:OverrideSymbol("swap_grown", "gem", "purple")
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
		inst.components.pickable:SetUp("purplegem",nil,2)
		inst.components.pickable.onpickedfn = onpickedfn
		inst:AddTag("purpleg")
	end
	end)

end

local function makebarrenfn(inst)
	inst:Remove()
end

local function done(inst)
	inst:Remove()
end

local function tree_onsave(inst, data)
    data.no_banana = inst.components.pickable == nil or not inst.components.pickable.canbepicked
	if inst:HasTag("redg") then
	data.redg = inst:HasTag("redg") ~= nil
	end
	if inst:HasTag("mixedg") then
	data.mixedg = inst:HasTag("mixedg") ~= nil
	end
	if inst:HasTag("blueg") then
	data.blueg = inst:HasTag("blueg") ~= nil
	end
	if inst:HasTag("greeng") then
	data.greeng = inst:HasTag("greeng") ~= nil
	end
	if inst:HasTag("purpleg") then
	data.purpleg = inst:HasTag("purpleg") ~= nil
	end
	if inst:HasTag("yellowg") then
	data.yellowg = inst:HasTag("yellowg") ~= nil
	end
	if inst:HasTag("orangeg") then
	data.orangeg = inst:HasTag("orangeg") ~= nil
	end
	if inst:HasTag("magicy") then
	data.magicy = inst:HasTag("magicy") ~= nil
	end
end

local function tree_onload(inst, data)
    if data ~= nil then
            if data.no_banana and inst.components.pickable ~= nil then
                inst.components.pickable.canbepicked = false
			end
			
			if 	data.redg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "red")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("redgem",nil,3)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("redg")
			end
			if data.blueg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "blue")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("bluegem",nil,3)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("blueg")
			end
			if data.orangeg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "orange")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("orangegem",nil,2)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("orangeg")
			end
			if data.greeng ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "green")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("greengem",nil,2)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("greeng")
			end
			if data.purpleg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "purple")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("purplegem",nil,2)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("purpleg")
			end
			if data.yellowg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "yellow")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("yellowgem",nil,2)
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("yellowg")
			end
			if data.mixedg ~= nil then
				inst.AnimState:PlayAnimation("grow_pst")
				inst.AnimState:OverrideSymbol("swap_grown", "gem", "opal")
				inst:AddComponent("pickable")
				inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
				inst.components.pickable:SetUp("mixed_gem")
				inst.components.pickable.onpickedfn = onpickedfn
				inst.Light:Enable(true)
				inst:AddTag("mixedg")
			end
			if data.magicy ~= nil then
				inst:AddTag("magicy")
			end
    end
	
	
end

local function dig_up_common(inst, worker)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
    local x, y, z = inst.Transform:GetWorldPosition()
    local produtos = SpawnPrefab(inst.components.pickable.product)
	produtos.Transform:SetPosition(x, y+0.5, z)
    end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local gem_flower = SpawnPrefab("gem_seeds") 
	if gem_flower then 
	gem_flower.Transform:SetPosition(x, y+0.7, z)
	end
    inst:Remove()
end

local function OnRefuseItem(inst, giver, item)
giver.components.talker:Say("I should give it fertiliser at night.")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	
	inst.Light:Enable(false)
	inst.Light:SetRadius(1)
	inst.Light:SetFalloff(0.6)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)

    inst.AnimState:SetBank("plant_normal")
    inst.AnimState:SetBuild("plant_gem")
    inst.AnimState:PlayAnimation("picked")
--	inst.AnimState:SetPercent("grow", 0.1)
	
	local s = 1.25
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("gem_flower")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = mature
	inst.components.trader.onrefuse = OnRefuseItem
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up_common)		

    inst:AddComponent("inspectable")
	
	inst:ListenForEvent ("picked", makebarrenfn)	
	
	inst.OnSave = tree_onsave
    inst.OnLoad = tree_onload

    return inst
end

return Prefab("gem_flower", fn, assets)