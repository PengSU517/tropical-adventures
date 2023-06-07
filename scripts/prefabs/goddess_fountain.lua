local assets =
{
    Asset("ANIM", "anim/goddess_fountain_gem.zip"),
	Asset("IMAGE", "images/map_icons/goddess_fountain.tex"),
	Asset("ATLAS", "images/map_icons/goddess_fountain.xml")
}

local function hammer_fountain(inst, worker, workleft)
	if workleft <= 0 then
		local pos = inst:GetPosition()
			SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
			inst.components.lootdropper:SpawnLootPrefab("magicpowder")
			inst.components.lootdropper:SpawnLootPrefab("moonrocknugget")
			inst.components.lootdropper:SpawnLootPrefab("moonrocknugget")
			inst.components.lootdropper:SpawnLootPrefab("moonrocknugget")
			inst.components.lootdropper:SpawnLootPrefab("empty_bottle_green")
			inst.components.lootdropper:SpawnLootPrefab("full_bottle_green")
		inst:Remove() 
	end
end

local function ShouldAcceptItem(inst, item)
	local activated = TheSim:FindFirstEntityWithTag("activatedgf")
	return item:HasTag("magicpowder") 
	--return item:HasTag("magicpowder") and activated == nil 
end

local function OnGetItem(inst, giver, item)
	local fueled =  inst.components.fueled:GetPercent()
	inst.components.fueled:SetPercent(1)
	if inst.light == nil then
		inst.light = inst:SpawnChild("goddess_lantern_fire")
		inst.light.Transform:SetPosition(0.1, 1, 0)
	end
	inst.components.fueled:StartConsuming()
	local Gate = TheSim:FindFirstEntityWithTag("goddess_gate1")
	inst.components.teleporter.targetTeleporter = Gate
	inst:AddTag("activatedgf")
end

local function depleted(inst)
	if inst.light ~= nil then
		inst.light:Remove()
		inst.light = nil
	end
	inst.components.teleporter.targetTeleporter = nil
	inst:RemoveTag("activatedgf")
end

local function light(inst)
	local fueled =  inst.components.fueled:GetPercent()
	if fueled > 0 then
		inst.light = inst:SpawnChild("goddess_lantern_fire")
		inst.light.Transform:SetPosition(0.1, 1, 0)
		local Gate = TheSim:FindFirstEntityWithTag("goddess_gate1")
		inst.components.teleporter.targetTeleporter = Gate
		inst.components.fueled:StartConsuming()
		inst:AddTag("activatedgf")
	end
	if fueled <= 0 then
		if inst.light ~= nil then
			inst.light:Remove()
			inst.light = nil
		end
		inst.components.teleporter.targetTeleporter = nil
		inst:RemoveTag("activatedgf")
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")
end

local function donetele(inst)
	if inst.light1 ~= nil then
		inst.light1:Remove()
		inst.light1 = nil
	end
	if inst.light2 ~= nil then
		inst.light2:Remove()
		inst.light2 = nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	
	inst.MiniMapEntity:SetIcon( "goddess_fountain.tex" )
	
    MakeObstaclePhysics(inst, .90)

    inst:AddTag("structure")
	inst:AddTag("goddessportal")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("goddess_fountain")
	
	inst.SoundEmitter:PlaySound("dontstarve/common/together/moondial/full_LP", "loop")
	
    inst.AnimState:SetBank("goddess_fountain_gem")
    inst.AnimState:SetBuild("goddess_fountain_gem")
    inst.AnimState:PlayAnimation("idle", true)
	
	local s = 1.25
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnWorkCallback(hammer_fountain)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(60)
	inst.components.fueled:SetDepletedFn(depleted)
	inst.components.fueled:StartConsuming()
	
	inst:DoTaskInTime(0, light)
	
	inst:AddComponent("teleporter")
	inst.components.teleporter.offset = 2

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("goddess_fountain", fn, assets)