local assets =
{
    Asset("ANIM", "anim/goddess_statue.zip"),
	Asset("IMAGE", "images/map_icons/goddess_statue.tex"),
	Asset("ATLAS", "images/map_icons/goddess_statue.xml")
}

local function light(inst) 
	if inst.on == true then
		inst.Light:Enable(true)
	end
end

local function extinguish(inst)
	inst.Light:Enable(false)
end

SetSharedLootTable( 'goddess_statue',
{
    {'windyfan',           			       0.01},
    {'usedfan',     					   0.25},
	{'marble',     						   1.00},
	{'marble',     						   1.00},
    {'forbidden_fruit',				       0.15},
})

local function mine_statue(inst, worker, workleft)
	if workleft <= 0 then
		local pos = inst:GetPosition()
			SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())

		local rnd = math.random() * 100
		local qty

		if 	   rnd <= 33 then
			inst.components.lootdropper:SpawnLootPrefab("windyfan")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 66 then
			inst.components.lootdropper:SpawnLootPrefab("usedfan")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 99 then
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("forbidden_fruit")
		else
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		end
		inst:Remove() 
	end
end

local function statue (inst)
		local pos = inst:GetPosition()
			SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
			
		local rnd = math.random() * 100
		local qty

		if 	   rnd <= 1 then
			inst.components.lootdropper:SpawnLootPrefab("windyfan")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 50 then
			inst.components.lootdropper:SpawnLootPrefab("usedfan")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		elseif rnd <= 85 then
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("forbidden_fruit")
		else
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
			inst.components.lootdropper:SpawnLootPrefab("marble")
		end
		inst:Remove() 
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local health = inst.components.health.currenthealth
	local uses =  inst.components.finiteuses:GetPercent()
	if giver:HasTag("windy1") and giver:HasTag("windy2") then
		inst.components.finiteuses:SetPercent(uses + 0.40)
		inst.components.health:SetCurrentHealth(health + 250)
	else
		inst.components.finiteuses:SetPercent(uses + 0.10)
		inst.components.health:SetCurrentHealth(health + 123.4)
	end
	if uses >= 1 then
		inst.components.finiteuses:SetPercent(1)
	end
	if health >= 1 then
		inst.components.health:SetCurrentHealth(1234)
	end
end

local function TurnOff(inst, instant)
    inst.on = false
	inst.Light:Enable(false)
end

local function TurnOn(inst, instant)
    inst.on = true
	inst.Light:Enable(true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddLight()
	
	inst.MiniMapEntity:SetIcon( "goddess_statue.tex" )
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	local s = 2
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("goddess_statue")
    inst.AnimState:SetBuild("goddess_statue")
    inst.AnimState:PlayAnimation("idle_loop")
	
	inst.Light:Enable(false)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("character")
	inst:AddTag("healthinfo")
	inst:AddTag("companion")
	inst:AddTag("goddess_item")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(1234)
	
	inst:AddComponent("combat")
	
	inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(TUNING.FIRE_DETECTOR_RANGE, TUNING.FIRE_DETECTOR_RANGE + 0.1)
    inst.components.playerprox:SetOnPlayerNear(light)
    inst.components.playerprox:SetOnPlayerFar(extinguish)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(50)
    inst.components.finiteuses:SetUses(50)
    inst.components.finiteuses:SetOnFinished(statue)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(mine_statue)

    inst:AddComponent("inspectable")

	inst:DoPeriodicTask(3, function(inst, target, pos, attacker)
	local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.FIRE_DETECTOR_RANGE, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"hostile", "monster", "largecreature", "walrus"})
	if inst.on == true then
		for i,v in pairs(ents) do
			if v.components.health and not v:HasTag("spiderwhisperer") and not v:HasTag("spiderden") then 
				v.components.health:DoDelta(-100)
				SpawnPrefab("groundpoundring_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.components.finiteuses:Use(1)
				v.sg:GoToState("hit")
			end
		end
	end
	end)
	
	inst:DoPeriodicTask(3, function(inst, target, pos, attacker)
	local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.FIRE_DETECTOR_RANGE, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"smolder", "fire"})
	if inst.on == true then
		for i,v in pairs(ents) do
			if v.components.burnable then 
				SpawnPrefab("groundpoundring_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				v.components.burnable:Extinguish(true, 0)
				inst.components.finiteuses:Use(1)
			end
		end
	end
	end)
	
	inst:DoPeriodicTask(0.1, function(inst, target, pos, attacker)
	local uses =  inst.components.finiteuses:GetPercent()
	if uses >= 1 then
	inst.components.finiteuses:SetPercent(1)
	end
	end)
	
	inst:DoPeriodicTask(0.2, function(inst, target, pos, attacker)
	if inst.components.finiteuses:GetPercent() <= 0.1 then
		inst.AnimState:PlayAnimation("idle")
		inst.AnimState:PushAnimation("idle")
		inst.Light:SetRadius(0.5)
		inst.Light:SetFalloff(0.3)
		inst.Light:SetIntensity(.75)
		inst.Light:SetColour(255 / 255, 200 / 255, 0 / 255)
	end 
	if inst.components.finiteuses:GetPercent() > 0.1 then
		inst.AnimState:PlayAnimation("idle_loop")
		inst.AnimState:PushAnimation("idle_loop")
		inst.Light:SetRadius(0.5)
		inst.Light:SetFalloff(0.3)
		inst.Light:SetIntensity(.75)
		inst.Light:SetColour(100 / 255, 255 / 255, 100 / 255)
	end
	end)

    return inst
end

return Prefab("goddess_statue", fn, assets)