local assets=
{
	Asset("ANIM", "anim/machete.zip"),
	Asset("ANIM", "anim/machete_obsidian.zip"),
	Asset("ANIM", "anim/goldenmachete.zip"),
	Asset("ANIM", "anim/swap_machete.zip"),
	Asset("ANIM", "anim/swap_machete_obsidian.zip"),
	Asset("ANIM", "anim/swap_goldenmachete.zip"),
}

 
 
local function ondropped(inst)
local map = TheWorld.Map
local x, y, z = inst.Transform:GetWorldPosition()
local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))


local WALKABLE_PLATFORM_TAGS = {"walkableplatform"}
local plataforma = false
local pos_x, pos_y, pos_z = inst.Transform:GetWorldPosition()
local entities = TheSim:FindEntities(x, 0, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, WALKABLE_PLATFORM_TAGS)
for i, v in ipairs(entities) do
local walkable_platform = v.components.walkableplatform
if walkable_platform and walkable_platform.radius == nil then walkable_platform.radius = 4 end         
if walkable_platform ~= nil then  
local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
local distance_sq = VecUtil_LengthSq(x - platform_x, z - platform_z)
if distance_sq <= walkable_platform.radius * walkable_platform.radius then plataforma = true end
end
end			
		
if not plataforma and (ground == GROUND.OCEAN_COASTAL or
ground == GROUND.OCEAN_COASTAL_SHORE or
ground == GROUND.OCEAN_SWELL or
ground == GROUND.OCEAN_ROUGH or
ground == GROUND.OCEAN_BRINEPOOL or
ground == GROUND.OCEAN_BRINEPOOL_SHORE or
ground == GROUND.OCEAN_WATERLOG or
ground == GROUND.OCEAN_HAZARDOUS) then
inst.AnimState:PlayAnimation("idle_water", true)
inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")		
if not inst.replica.inventoryitem:IsHeld() then	inst.components.inventoryitem:AddMoisture(80) end
else
inst.AnimState:SetLayer(LAYER_WORLD)
inst.AnimState:PlayAnimation("idle", true)
inst.AnimState:ClearOverrideSymbol("water_ripple", "ripple_build", "water_ripple")
inst.AnimState:ClearOverrideSymbol("water_shadow", "ripple_build", "water_shadow")	
end
end
 
 
 
local function onfinished(inst)
	inst:Remove()
end

local wilson_attack = 34
local MACHETE_DAMAGE = wilson_attack* .88
local MACHETE_USES = 100 --lols why does it have 400 uses?
local OBSIDIANTOOLFACTOR = 2.5

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_machete", "swap_machete")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	anim:SetBank("machete")
	anim:SetBuild("machete")
	anim:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("machete")
	inst:AddTag("aquatic")

    if not TheWorld.ismastersim then
        return inst
    end
	inst.entity:SetPristine()
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(MACHETE_DAMAGE)

	-----
	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.HACK, 2.5)
	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MACHETE_USES)
	inst.components.finiteuses:SetUses(MACHETE_USES)
	inst.components.finiteuses:SetOnFinished( onfinished)
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / OBSIDIANTOOLFACTOR)
	-------
	inst:AddComponent("equippable")

	inst:AddComponent("inspectable")



	inst.components.equippable:SetOnEquip( onequip )

	inst.components.equippable:SetOnUnequip( onunequip)

	return inst
end

local function normal(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	anim:SetBank("machete")
	anim:SetBuild("machete")
	anim:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("machete")
	inst:AddTag("aquatic")

    if not TheWorld.ismastersim then
        return inst
    end
	inst.entity:SetPristine()
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(MACHETE_DAMAGE)

	-----
	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.HACK)
	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MACHETE_USES)
	inst.components.finiteuses:SetUses(MACHETE_USES)
	inst.components.finiteuses:SetOnFinished( onfinished)
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1)
	-------
	inst:AddComponent("equippable")

	inst:AddComponent("inspectable")



	inst.components.equippable:SetOnEquip( onequip )

	inst.components.equippable:SetOnUnequip( onunequip)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"	
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst:DoTaskInTime(0, ondropped)	
	return inst
end

local function onequipgold(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_goldenmachete", "swap_goldenmachete")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function golden(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	inst.AnimState:SetBuild("goldenmachete")
	inst.AnimState:SetBank("machete")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("machete")
	inst:AddTag("aquatic")

    if not TheWorld.ismastersim then
        return inst
    end
	inst.entity:SetPristine()
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(MACHETE_DAMAGE)

	-----
	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.HACK)
	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MACHETE_USES)
	inst.components.finiteuses:SetUses(MACHETE_USES)
	inst.components.finiteuses:SetOnFinished( onfinished)
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1)
	-------
	inst:AddComponent("equippable")

	inst:AddComponent("inspectable")



	inst.components.equippable:SetOnEquip( onequip )

	inst.components.equippable:SetOnUnequip( onunequip)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"	
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / TUNING.GOLDENTOOLFACTOR)
	inst.components.weapon.attackwear = 1 / TUNING.GOLDENTOOLFACTOR
	inst.components.equippable:SetOnEquip( onequipgold )
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst:DoTaskInTime(0, ondropped)	
	return inst
end


local OBSIDIANTOOLFACTOR = 2.5

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
	owner.AnimState:OverrideSymbol("swap_object", "swap_machete_obsidian", "swap_machete")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

	local function onunequipobsidian(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	end

	local function obsidian_custom_init(inst)
		inst:AddComponent("waterproofer")
		inst.AnimState:SetBuild("machete_obsidian")
		inst.AnimState:SetBank("machete_obsidian")
	end	
	
local function obsidian(Sim)
	local inst = fn(obsidian_custom_init)

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"	
	inst.AnimState:SetBuild("machete_obsidian")
	inst.AnimState:SetBank("machete_obsidian")

	inst.components.weapon.attackwear = 1 / OBSIDIANTOOLFACTOR
	inst.components.equippable:SetOnEquip(onequipobsidian)
	inst.components.equippable:SetOnUnequip(onunequipobsidian)

	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst:DoTaskInTime(0, ondropped)	
	
	inst:AddComponent("obsidiantool")
    inst.components.obsidiantool.tool_type = "machete"
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

	return inst
end

return Prefab( "machete", normal, assets),
	   Prefab( "goldenmachete", golden, assets),
	   Prefab( "obsidianmachete", obsidian, assets)
