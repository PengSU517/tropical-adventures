local assets =
{
    Asset("ANIM", "anim/goddess_bell.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_bell.xml")
}

local function unproctect(inst)
        if inst:HasTag("greenforcefield") then
            inst:RemoveTag("greenforcefield")
			if inst.spell1 ~= nil then
				inst.spell1:Remove()
				inst.spell1 = nil
			end
			inst.components.health:SetAbsorptionAmount(0)
		end
end

local function protect(inst)
    if not inst:HasTag("greenforcefield") then
		inst:AddTag("greenforcefield")
		if inst.spell1 == nil then
			inst.spell1 = inst:SpawnChild("green_forcefieldfx")
			inst.spell1.Transform:SetPosition(0, 0.2, 0)
		end
        inst.components.health:SetAbsorptionAmount(0.75)
        inst:DoTaskInTime(8, unproctect)
	end
end
	
local function protect_full(inst)
	if not inst:HasTag("greenforcefield") then    
		inst:AddTag("greenforcefield")		
		if inst.spell1 == nil then
			inst.spell1 = inst:SpawnChild("green_forcefieldfx")
			inst.spell1.Transform:SetPosition(0, 0.2, 0)
		end
        inst.components.health:SetAbsorptionAmount(1)
        inst:DoTaskInTime(12, unproctect)
	end
end

local function HearBell(inst, musician, instrument)
	if not inst:HasTag("player") then
		if inst:HasTag("hostile") or inst:HasTag("monster") or inst:HasTag("largecreature") or inst:HasTag("animal") or inst:HasTag("merm") or inst:HasTag("walrus") or inst:HasTag("smallcreatue") or inst:HasTag("epic") then
			if inst.components.combat:HasTarget() then
				inst.components.combat:DropTarget()
				if inst.spell == nil then
					inst.spell = inst:SpawnChild("goddess_sparklefx")
					inst.spell.AnimState:PushAnimation("idle",true)
				end
				inst:DoTaskInTime(0.5, function(inst)
					if inst.spell ~= nil then
						inst.spell:Remove()
						inst.spell = nil
					end
				end)
			end
		end
	elseif inst:HasTag("player") or inst:HasTag("follower") or inst:HasTag("companion")then
		if musician:HasTag("windy1") and musician:HasTag("windy2") then
			if inst.components.health ~= nil then
				inst:DoTaskInTime(0, protect_full)
				inst.components.health:DoDelta(15)
			end
			if inst.components.sanity ~= nil then
				inst.components.sanity:DoDelta(25)
			end
		else 
			inst:DoTaskInTime(0, protect)
			if musician.components.health ~= nil and musician.components.sanity ~= nil  then
				musician.components.health:DoDelta(-5)
				musician.components.sanity:DoDelta(-5)
			end
		end
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
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_bell")
    inst.AnimState:SetBuild("goddess_bell")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("goddess_bell")
	inst:AddTag("goddess_item")
	
	local s = 1
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("instrument")
    inst.components.instrument.range = 30
    inst.components.instrument:SetOnHeardFn(HearBell)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_bell.xml"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_bell", fn, assets)