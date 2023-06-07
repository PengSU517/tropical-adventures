local assets=
{
	Asset("ATLAS", "images/inventoryimages/volcanoinventory.xml"),
	Asset("ANIM", "anim/axe_obsidian.zip"),
	Asset("ANIM", "anim/swap_axe_obsidian.zip"),	
}

local OBSIDIANTOOLFACTOR = 2.5

local function onfinished(inst)
	inst:Remove()
end

local function ObsidianToolAttack(inst, attacker, target)
	inst.components.obsidiantool:Use(attacker, target)
    local charge, maxcharge = inst.components.obsidiantool:GetCharge()
    local dano = Lerp(0, 1, charge / maxcharge)
    target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, inst, dano), inst, "FIRE")

    if charge == maxcharge then
        if target.components.burnable then
            target.components.burnable:Ignite()
        end
    end
end

local function ObsidianToolHitWater(inst)
    inst.components.obsidiantool:SetCharge(0)
end

local function SpawnObsidianLight(inst)
    local owner = inst.components.inventoryitem.owner
    inst._obsidianlight = inst._obsidianlight or SpawnPrefab("obsidiantoollight")
    inst._obsidianlight.entity:SetParent((owner or inst).entity)
end

local function RemoveObsidianLight(inst)
    if inst._obsidianlight ~= nil then
        inst._obsidianlight:Remove()
        inst._obsidianlight = nil
    end
end

local function ChangeObsidianLight(inst, old, new)
    local percentage = new / inst.components.obsidiantool.maxcharge
    local rad = Lerp(1, 2.5, percentage)

    if percentage >= inst.components.obsidiantool.yellow_threshold then
        SpawnObsidianLight(inst)

        if percentage >= inst.components.obsidiantool.red_threshold then
            inst._obsidianlight.Light:SetColour(254/255,98/255,75/255)
            inst._obsidianlight.Light:SetRadius(rad)
        elseif percentage >= inst.components.obsidiantool.orange_threshold then
            inst._obsidianlight.Light:SetColour(255/255,159/255,102/255)
            inst._obsidianlight.Light:SetRadius(rad)
        else
            inst._obsidianlight.Light:SetColour(255/255,223/255,125/255)
            inst._obsidianlight.Light:SetRadius(rad)
        end
    else
        RemoveObsidianLight(inst)
    end
end

local function ManageObsidianLight(inst)
    local cur, max = inst.components.obsidiantool:GetCharge() 
    if cur / max >= inst.components.obsidiantool.yellow_threshold then
        SpawnObsidianLight(inst)
    else
        RemoveObsidianLight(inst)
    end
end

local function PercentChanged(inst)
local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
if owner ~= nil and owner.sg:HasStateTag("prechop") then
inst.components.obsidiantool:Use(owner, owner.bufferedaction.target)
end
end	

local function onequipobsidian(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.AnimState:OverrideSymbol("swap_object", "swap_axe_obsidian", "swap_axe")	
end

local function onunequipobsidian(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
 end 

 

local function obsidianfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBuild("axe_obsidian")
	inst.AnimState:SetBank("axe_obsidian")
	inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("axe")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(27)
	inst.components.weapon.attackwear = 1 / OBSIDIANTOOLFACTOR

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
	inst:AddComponent("waterproofer")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"
	
    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequipobsidian)
	inst.components.equippable:SetOnUnequip(onunequipobsidian)

    inst:AddComponent("tool")	
	inst.components.tool:SetAction(ACTIONS.CHOP, 2.5)	
		
    inst:AddComponent("obsidiantool")
    inst.components.obsidiantool.tool_type = "axe"
	inst.components.obsidiantool.maxcharge = 75
    inst.components.obsidiantool.onchargedelta = ChangeObsidianLight
    inst:ListenForEvent("equipped", ManageObsidianLight)
    inst:ListenForEvent("onputininventory", ManageObsidianLight)
    inst:ListenForEvent("ondropped", ManageObsidianLight)	
	
    if inst.components.weapon then
        if inst.components.weapon.onattack then

        else
            inst.components.weapon:SetOnAttack(ObsidianToolAttack)
        end
    end	
	
	inst:AddComponent("temperature")		
	
	inst:ListenForEvent("floater_startfloating", ObsidianToolHitWater)	
	inst:ListenForEvent("percentusedchange", PercentChanged)
	
    MakeHauntableLaunch(inst)

	return inst
end

return Prefab( "common/inventory/axeobsidian", obsidianfn, assets)