local assets =
{
    Asset("ANIM", "anim/goddess_statue3.zip"),
	Asset("IMAGE", "images/map_icons/goddess_statue3.tex"),
	Asset("ATLAS", "images/map_icons/goddess_statue3.xml")
}

local function deer (inst)
	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 250, { "goddess_deer" })
		if #ents < 8 then
			 inst.components.childspawner:SetMaxChildren(2)	
		else
			inst.components.childspawner:SetMaxChildren(0)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	
	inst.MiniMapEntity:SetIcon( "goddess_statue3.tex" )
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	local s = 4
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("goddess_statue3")
    inst.AnimState:SetBuild("goddess_statue3")
    inst.AnimState:PlayAnimation("idle")
	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "goddess_deer"
	inst.components.childspawner:SetSpawnPeriod(math.random(TUNING.MIN_TUMBLEWEED_SPAWN_PERIOD, TUNING.MAX_TUMBLEWEED_SPAWN_PERIOD))
	inst.components.childspawner:SetRegenPeriod(TUNING.TUMBLEWEED_REGEN_PERIOD)
	inst.components.childspawner.spawnoffscreen = true
	
	inst:DoTaskInTime(0, function(inst)
	inst.components.childspawner:ReleaseAllChildren()
	inst.components.childspawner:StartSpawning()
	end)
	
	inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("goddess_butterfly")
    inst.components.periodicspawner:SetRandomTimes(480, 481)
    inst.components.periodicspawner:SetDensityInRange(30, 1)
    inst.components.periodicspawner:SetMinimumSpacing(30)
    inst.components.periodicspawner:Start()
	
	inst:DoPeriodicTask(1, deer)
	
    return inst
end

return Prefab("goddess_statue3", fn, assets)