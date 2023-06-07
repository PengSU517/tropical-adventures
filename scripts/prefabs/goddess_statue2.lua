local assets =
{
    Asset("ANIM", "anim/goddess_statue2.zip"),
	Asset("IMAGE", "images/map_icons/goddess_statue2.tex"),
	Asset("ATLAS", "images/map_icons/goddess_statue2.xml")
}

local function light(inst)    
	inst.Light:Enable(true)   
end

local function extinguish(inst)
	inst.Light:Enable(false)
end

local function mine_statue(inst, worker, workleft)
    if workleft >= 1 then
	local rnd = math.random() * 100
	if 	    rnd <= 50 then
			local pos = inst:GetPosition()
			SpawnPrefab("goddess_spider_hostile").Transform:SetPosition(pos:Get())
		end
	end
	if workleft <= 0 then
		local pos = inst:GetPosition()
			SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())

		local rnd = math.random() * 100
		local qty

		if 	   rnd <= 10 then
			inst.components.lootdropper:SpawnLootPrefab("forbidden_fruit")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 35 then
			inst.components.lootdropper:SpawnLootPrefab("usedfan")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 75 then
			inst.components.lootdropper:SpawnLootPrefab("marble")
		else
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		end
		inst:Remove() 
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddLight()
	
	inst.MiniMapEntity:SetIcon( "goddess_statue2.tex" )
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	inst.Light:Enable(false)
    inst.Light:SetRadius(0.2)
    inst.Light:SetFalloff(0.2)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(190 / 255, 250 / 255, 190 / 255)
	
	local s = 4
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("goddess_statue2")
    inst.AnimState:SetBuild("goddess_statue2")
    inst.AnimState:PlayAnimation("idle")
	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(7, 8)
    inst.components.playerprox:SetOnPlayerNear(light)
    inst.components.playerprox:SetOnPlayerFar(extinguish)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(mine_statue)

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("goddess_statue2", fn, assets)