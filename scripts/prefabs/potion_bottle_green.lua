local assets =
{
    Asset("ANIM", "anim/potion_bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/potion_bottle_green.tex"),
	Asset("ATLAS", "images/inventoryimages/potion_bottle_green.xml")
}

local function EatFn(inst, eater)
	if not eater:HasTag("speedbuffed") then
		eater:AddTag("speedbuffed")
		eater.components.locomotor.isrunning = true
		eater.components.locomotor.groundspeedmultiplier = 1.25 
		eater.components.locomotor.externalspeedmultiplier = 1.25
		
		eater:ListenForEvent("ms_becameghost", function (eater)
			eater.components.locomotor.groundspeedmultiplier = 1
			eater.components.locomotor.externalspeedmultiplier = 1
			eater:RemoveTag("speedbuffed")
		end)
		
		eater:DoTaskInTime(240, function (eater) 
			if not eater:HasTag("playerghost") then
				eater.components.locomotor.groundspeedmultiplier = 1
				eater.components.locomotor.externalspeedmultiplier = 1
				eater:RemoveTag("speedbuffed")
			end
		end)
	else
	end
		if not eater:HasTag("attbuffed") then
		eater:AddTag("attbuffed")
		if eater.components.combat.damagemultiplier then
			local oldstrength = eater.components.combat.damagemultiplier
			eater.components.combat.damagemultiplier = (eater.components.combat.damagemultiplier + 0.25)
			elseif not eater.components.combat.damagemultiplier then
			eater.components.combat.damagemultiplier = 1.25 
		end	
		eater:ListenForEvent("ms_becameghost", function (eater)
			eater:RemoveTag("attbuffed")
			if 	eater.components.combat.damagemultiplier == 1.25 then
				eater.components.combat.damagemultiplier = 1
			else
				eater.components.combat.damagemultiplier = (eater.components.combat.damagemultiplier - 0.25)
			end
		end)
		eater:DoTaskInTime(240, function (eater)
			if not eater:HasTag("playerghost") then
				if eater.components.combat.damagemultiplier == 1.25 then
				eater.components.combat.damagemultiplier = 1
				else
				eater.components.combat.damagemultiplier = (eater.components.combat.damagemultiplier - 0.25)
				end
				eater:RemoveTag("attbuffed")
			end
		end)
	end
	if not eater:HasTag("defbuffed") then
		eater:AddTag("defbuffed")
		if eater.components.health then
			local olddefence = eater.components.health.absorb
			local newdefence = (olddefence + 0.25)
			eater.components.health:SetAbsorptionAmount(newdefence)
		end
		eater:ListenForEvent("ms_becameghost", function (eater)
			local olddefence = eater.components.health.absorb
			local newdefence = (olddefence - 0.25)
			eater.components.health:SetAbsorptionAmount(newdefence)
			eater:RemoveTag("defbuffed")
		end)
		eater:DoTaskInTime(240, function (eater)
			if not eater:HasTag("playerghost") then
				local olddefence = eater.components.health.absorb
				local newdefence = (olddefence - 0.25)
				eater.components.health:SetAbsorptionAmount(newdefence)
				eater:RemoveTag("defbuffed")
				end
			end)
	else	
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("I feel powerful!")
	end
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
end

local function glow(inst)
	if inst.magic == nil then
		inst.magic = inst:SpawnChild("goddess_lantern_fire")
		inst.magic.Light:Enable(false)
		local s = 0.5
		inst.magic.Transform:SetScale(s,s,s)
	end
end

local function unglow(inst)
	if inst.magic ~= nil then
		inst.magic:Remove()
		inst.magic = nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)
	
	local s = 1
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("potion_bottle_green")
    inst.AnimState:SetBuild("potion_bottle_green")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryFloatable(inst)		

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 75
	inst.components.edible.healthvalue = 75
	inst.components.edible.sanityvalue = 75
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_bottle_green.xml"
	
	inst:ListenForEvent("ondropped", glow)
	inst:ListenForEvent("onputininventory", unglow)

    return inst
end

return Prefab("potion_bottle_green", fn, assets)