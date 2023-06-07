local assets =
{
    Asset("ANIM", "anim/oasis_tile.zip"),
    Asset("MINIMAP_IMAGE", "oasis"),
}

local prefabs =
{
    "fish",
    "windpouch",
	"goddess_fountain_lake"
}

local function gemmed(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")
end

local function light(inst)    
	if inst.light == nil then
		inst.light = inst:SpawnChild("goddess_lantern_fire")
		inst.light.Transform:SetPosition(0, 1, 0)
	end 
	local ents = TheSim:FindFirstEntityWithTag("goddess_deer_gem")
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.state.isfullmoon and ents == nil then
		if inst.deer1 == nil then
			inst.deer1 = SpawnPrefab("goddess_deer_gem")
			inst.deer1.Transform:SetPosition(x + 8, 0, z + 8)
		end 
		if inst.deer2 == nil then
			inst.deer2 = SpawnPrefab("goddess_deer_gem")
			inst.deer2.Transform:SetPosition(x - 8, 0, z + 8)
		end 
		if inst.deer3 == nil then
			inst.deer3 = SpawnPrefab("goddess_deer_gem")
			inst.deer3.Transform:SetPosition(x + 8, 0,  z - 8)
		end 
	end
end

local function extinguish(inst)
	if inst.light ~= nil then
		inst.light:Remove()
		inst.light = nil
	end
end

local function fountain(inst)
	if inst.fountain == nil then
		inst.fountain = inst:SpawnChild("goddess_fountain_lake")
		inst.fountain.Transform:SetPosition(0, -0.3, 0)
	end
	if inst.flowers == nil then
		inst.flowers = inst:SpawnChild("flowers_lake")
		inst.flowers.Transform:SetPosition(2.5, 0, 2.5)
	end
	if inst.flowers1 == nil then
		inst.flowers1 = inst:SpawnChild("flowers_lake")
		inst.flowers1.Transform:SetPosition(-2.5, 0, 2.5)
	end
	if inst.flowers2 == nil then
		inst.flowers2 = inst:SpawnChild("flowers_lake")
		inst.flowers2.Transform:SetPosition(2.5, 0, -2.5)
	end
	if inst.flowers3 == nil then
		inst.flowers3 = inst:SpawnChild("flowers_lake")
		inst.flowers3.Transform:SetPosition(-2.5, 0, -2.5)
	end
	if inst.flowers4 == nil then
		inst.flowers4 = inst:SpawnChild("flowers_lake")
		inst.flowers4.Transform:SetPosition(-3.25, 0, 0)
	end
	if inst.flowers5 == nil then
		inst.flowers5 = inst:SpawnChild("flowers_lake")
		inst.flowers5.Transform:SetPosition(3.25, 0, 0)
	end
	if inst.flowers6 == nil then
		inst.flowers6 = inst:SpawnChild("flowers_lake")
		inst.flowers6.Transform:SetPosition(0, 0, -3.25)
	end
	if inst.flowers7 == nil then
		inst.flowers7 = inst:SpawnChild("flowers_lake")
		inst.flowers7.Transform:SetPosition(0, 0, 3.25)
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")
end

local function GetFish(inst)
	local pos = inst:GetPosition()
	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 8, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"player"})
	for i,v in pairs(ents) do
		if v:HasTag("windy5") then
			return math.random() < 0.65 and "goddess_fish" or "eel"
		else
			return math.random() < 0.45 and "eel" or "fish"
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.Transform:SetRotation(45)

    MakeObstaclePhysics(inst, 6)

    inst.AnimState:SetBuild("oasis_tile")
    inst.AnimState:SetBank("oasis_tile")
--	inst.AnimState:SetMultColour(50/255, 238/255, 50/255, 1)		
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)
	
    inst.MiniMapEntity:SetIcon("oasis.png")

    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("goddess_fountain_gem")
	inst:AddTag("goddess_fountain")
	
	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")

	local s = 1
	inst.Transform:SetScale(s,s,s)
	
    inst.no_wet_prefix = true
    inst:SetDeployExtraSpacing(6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fishable")
    inst.components.fishable.maxfish = TUNING.OASISLAKE_MAX_FISH
    inst.components.fishable:SetRespawnTime(TUNING.OASISLAKE_FISH_RESPAWN_TIME)
    inst.components.fishable:SetGetFishFn(GetFish)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("leader")
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 14)
    inst.components.playerprox:SetOnPlayerNear(light)
    inst.components.playerprox:SetOnPlayerFar(extinguish)
	
	inst:DoTaskInTime(0, fountain)

    return inst
end

return Prefab("goddess_lake", fn, assets, prefabs)
