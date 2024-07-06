local DEBUG_MODE = BRANCH == "dev"

local assets=
{
	Asset("ANIM", "anim/armor_vortex_cloak.zip"),
    Asset("ANIM", "anim/cloak_fx.zip"),
}

local ARMORVORTEX = 450
local ARMORVORTEXFUEL = ARMORVORTEX / 45 * TUNING.LARGE_FUEL
local ARMORVORTEX_ABSORPTION = 1

local function setsoundparam(inst)
    local param = Remap(inst.components.armor.condition, 0, inst.components.armor.maxcondition,0, 1 ) 
    inst.SoundEmitter:SetParameter( "vortex", "intensity", param )
end

local function spawnwisp(owner)
if owner then
    local wisp = SpawnPrefab("armorvortexcloak_fx")
    local x,y,z = owner.Transform:GetWorldPosition()
	if x ~= nil and y ~= nil and z ~= nil then
    wisp.Transform:SetPosition(x+math.random()*0.25 -0.25/2,y,z+math.random()*0.25 -0.25/2)
	end

local armadura = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
if armadura and armadura:HasTag("vortex_cloak") and armadura.components.armor.condition <= 0 then armadura.components.armor:SetAbsorption(0) end
if armadura and armadura:HasTag("vortex_cloak") and armadura.components.armor.condition > 0 then armadura.components.armor:SetAbsorption(1) end
end
end

local function OnBlocked(owner, data, inst)
    if inst.components.armor.condition and inst.components.armor.condition > 0 then
	owner:AddChild(SpawnPrefab("vortex_cloak_fx"))  
    end        
    setsoundparam(inst)
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_vortex_cloak", "swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_off")

	
    inst:ListenForEvent("blocked",  inst.OnBlocked, owner)
    inst:ListenForEvent("attacked", inst.OnBlocked, owner)

    owner:AddTag("not_hit_stunned")
--    owner.components.inventory:SetOverflow(inst)

    if not inst.components.container then
        local container = inst:AddComponent("container")
        container:WidgetSetup("armorvortexcloak")
    end

    if inst.components.container then
        inst.components.container:Open(owner)
    end   
    inst.wisptask = inst:DoPeriodicTask(0.1,function() spawnwisp(owner, inst) end)  

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/LP","vortex") 
    setsoundparam(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/equip_on") 
    inst:RemoveEventCallback("blocked", inst.OnBlocked, owner)
    inst:RemoveEventCallback("attacked", inst.OnBlocked, owner)   
    owner:RemoveTag("not_hit_stunned")
--    owner.components.inventory:SetOverflow(nil)
    inst.components.container:Close(owner)    
    if inst.wisptask then
        inst.wisptask:Cancel()
        inst.wisptask= nil
    end
    if inst.components.container:IsEmpty() == true then
        inst:RemoveComponent("container")
        inst.components.inventoryitem.cangoincontainer = true
    else
        inst.components.inventoryitem.cangoincontainer = false
    end
--    inst.SoundEmitter:KillSound("vortex")
end

local function ondrop(inst, owner)
    if inst.components.inventoryitem.cangoincontainer == true then
        inst.components.inventoryitem.cangoincontainer = false
    end
    if not inst.components.container then
        local container = inst:AddComponent("container")
	    container:WidgetSetup("armorvortexcloak")
    end
end

local function nofuel(inst)

end

local function ontakefuel(inst)
    if inst.components.armor.condition and inst.components.armor.condition < 0 then
        inst.components.armor:SetCondition(0)
    end
    inst.components.armor:SetPercent(inst.components.fueled:GetPercent())
	local player = inst.components.inventoryitem.owner
	if player then 
    player.components.sanity:DoDelta(-TUNING.SANITY_TINY)
    player.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel")
	end	
	setsoundparam(inst)
end

local function SetupEquippable(inst)
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	if inst._equippable_restrictedtag ~= nil then
		inst.components.equippable.restrictedtag = inst._equippable_restrictedtag
	end
end

local function OnBroken(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:HasTag("not_hit_stunned") ~=nil then
        owner:RemoveTag("not_hit_stunned")
    end
end

local function OnRepaired(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:HasTag("not_hit_stunned") == nil then
        owner:AddTag("not_hit_stunned")
    end
end

local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local sanity = owner.components.sanity
        if sanity then
            local unsaneness = damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY * 3
            sanity:DoDelta(-unsaneness, false)
        end
    end
    inst.components.fueled:SetPercent(inst.components.armor:GetPercent())
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()	
    MakeInventoryPhysics(inst)
	
    
    inst.AnimState:SetBank("armor_vortex_cloak")
    inst.AnimState:SetBuild("armor_vortex_cloak")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst)  	
	
    inst:AddTag("backpack")
    inst:AddTag("vortex_cloak")	
	inst:AddTag("shadow_item")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    inst.entity:SetPristine()

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "armor_vortex_cloak.png" )	

	if not TheWorld.ismastersim then
        if inst.replica.container then
	        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("armorvortexcloak") end	
        end	
	    return inst
	end
        
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"		
	inst.caminho = "images/inventoryimages/hamletinventory.xml"	
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem:SetOnDroppedFn(ondrop)
    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    local container = inst:AddComponent("container")
	container:WidgetSetup("armorvortexcloak")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(ARMORVORTEX, ARMORVORTEX_ABSORPTION)
    armor:SetKeepOnFinished(true)
    armor:SetImmuneTags({"shadow"})
    inst.components.armor.ontakedamage = OnTakeDamage

    local fueled = inst:AddComponent("fueled")
    fueled:InitializeFuelLevel(ARMORVORTEXFUEL) -- Runar: 原来的燃值是充场面的，现在是等效燃值
    fueled.fueltype = FUELTYPE.NIGHTMARE -- 燃料是噩梦燃料
    fueled.secondaryfueltype = FUELTYPE.ANCIENT_REMNANT
    fueled.ontakefuelfn = ontakefuel
    fueled.accepting = true

    local shadowlevel = inst:AddComponent("shadowlevel")
    shadowlevel:SetDefaultLevel(TUNING.ARMOR_SANITY_SHADOW_LEVEL) -- Runar: 影甲的老麦2级暗影之力

    SetupEquippable(inst)
    
    inst.OnBlocked = function(owner, data) OnBlocked(owner, data, inst) end		
    
    return inst
end

local function fxfn()
    local inst = CreateEntity()
	inst.entity:AddNetwork()    
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("cloakfx")
    inst.AnimState:SetBuild("cloak_fx")
    inst.AnimState:PlayAnimation("idle",true)    
	
    inst:AddTag("fx")
	
    for i=1,14 do
        inst.AnimState:Hide("fx"..i)
    end
    inst.AnimState:Show("fx"..math.random(1,14))

    inst:ListenForEvent("animover", function() inst:Remove() end) 

    return inst
end

return Prefab( "common/inventory/armorvortexcloak", fn, assets),
        Prefab( "common/inventory/armorvortexcloak_fx", fxfn, assets) 
