local assets =
{
    Asset("ANIM", "anim/windyfan.zip"),
	Asset("ANIM", "anim/swap_windyfan.zip"),
	Asset("ATLAS", "images/inventoryimages/windyfan.xml")
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_windyfan", "swap_ruins_bat")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end


local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target, skipsanity, cooling, radius)
	SpawnPrefab("groundpoundring_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
    SpawnPrefab("green_leaves_chop").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	if attacker:HasTag("windy1") and attacker:HasTag("windy2")then
		
		if not target:IsValid() then
			--target killed or removed in combat damage phase
			return
		end

		local coolingAmount = cooling
		local pos = target:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"smolder", "fire", "player"})
		for i,v in pairs(ents) do
			if v.components.burnable then 
				-- Extinguish smoldering/fire and reset the propagator to a heat of .2
				v.components.burnable:Extinguish(true, 0) 
			end
			if v.components.temperature then
				-- cool off yourself and any other nearby players
				local coolingRange = -(v.components.temperature:GetCurrent()-TUNING.FEATHERFAN_MINIMUM_TEMP)
				local localCoolingAmount = math.clamp(coolingRange, TUNING.FEATHERFAN_COOLING, 0)
				v.components.temperature:DoDelta(localCoolingAmount)
			end
		end

		local pos = target:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"hostile", "monster", "walrus", "epic", "merm"})
		for i,v in pairs(ents) do
			if v.components.health and not v:HasTag("spiderwhisperer") then 
				v.components.health:DoDelta(-300) 
			end
		end
		target:PushEvent("attacked", { attacker = attacker, damage = 300 })
		
		local uses =  inst.components.finiteuses:GetPercent()
		inst.components.finiteuses:SetPercent(uses + 0.1)
		if uses >= 1 then
		inst.components.finiteuses:SetPercent(1)
		end
	
	else
	
		if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then
			attacker.components.sanity:DoDelta(-20)
			attacker.components.health:DoDelta(-20)
			attacker.components.hunger:DoDelta(-20)
		end

		if not target:IsValid() then
			--target killed or removed in combat damage phase
			return
		end

		local coolingAmount = cooling
		local pos = target:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"smolder", "fire", "player"})
		for i,v in pairs(ents) do
			if v.components.burnable then 
				-- Extinguish smoldering/fire and reset the propagator to a heat of .2
				v.components.burnable:Extinguish(true, 0) 
			end
			if v.components.temperature then
				-- cool off yourself and any other nearby players
				local coolingRange = -(v.components.temperature:GetCurrent()-TUNING.FEATHERFAN_MINIMUM_TEMP)
				local localCoolingAmount = math.clamp(coolingRange, TUNING.FEATHERFAN_COOLING, 0)
				v.components.temperature:DoDelta(localCoolingAmount)
			end
		end
		
		local pt = inst:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, nil, { "insect", "INLIMBO" })

		for i, v in ipairs(ents) do
			if v:IsValid() and v.components.workable ~= nil then
					v.components.workable:Destroy(inst)
			end
		end
		local pos = target:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"hostile", "monster", "epic", "walrus", "merm"})
		for i,v in pairs(ents) do
			if v.components.health and not v:HasTag("spiderwhisperer") then 
				v.components.health:DoDelta(-600) 
			end
		end
		target:PushEvent("attacked", { attacker = attacker, damage = 600 })
	end
end
    
local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local finiteuses =  inst.components.finiteuses:GetPercent()
	if giver:HasTag("windy1") and giver:HasTag("windy2") then
		inst.components.finiteuses:SetPercent(finiteuses + 0.40)
	else
		inst.components.finiteuses:SetPercent(finiteuses + 0.10)
	end
	if finiteuses >= 1 then
		inst.components.finiteuses:SetPercent(1)
	end
end
	
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ruins_bat")
    inst.AnimState:SetBuild("windyfan")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)		
	
    inst.entity:SetPristine()
	
	local s = 1.25
	inst.Transform:SetScale(s,s,s)

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	inst.components.weapon:SetRange(22, 26)
	inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/windyfan.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("windyfan", fn, assets)