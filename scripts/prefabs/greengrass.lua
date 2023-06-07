local assets=
{
	Asset("ANIM", "anim/greengrass.zip"),
	
}


local prefabs =
{
    "cutgreengrass",
    "ash",
}    


local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("picked")
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



local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon( "grass.tex" )	
    
    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("greengrass")
	inst.AnimState:PlayAnimation("idle", true)
    

    if not TheWorld.ismastersim then
    return inst
end
    inst.entity:SetPristine()

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	inst.components.pickable:SetUp("cutgreengrass", 180)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn

	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable") 

    ---------------------        
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
	MakeNoGrowInWinter(inst)
	---------------------   
    inst.components.burnable:SetOnIgniteFn(startburn)
	inst.components.burnable:SetOnBurntFn(makeburnt)

	
	inst.OnSave = tree_onsave
    inst.OnLoad = tree_onload
  
    return inst
end

return Prefab("greengrass", fn, assets, prefabs)
