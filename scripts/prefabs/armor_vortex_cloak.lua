local DEBUG_MODE = BRANCH == "dev"

local assets=
{
	Asset("ANIM", "anim/armor_vortex_cloak.zip"),
    Asset("ANIM", "anim/cloak_fx.zip"),
}

local ARMORVORTEX = 150*6 -- 联机版护甲应该翻倍
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
    inst.components.container:Open(owner)    
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

--    inst.SoundEmitter:KillSound("vortex")
end

local function nofuel(inst)

end

local function ontakefuel(inst)
    if inst.components.armor.condition and inst.components.armor.condition < 0 then
        inst.components.armor:SetCondition(0)
    end
    inst.components.armor:SetCondition( math.min( inst.components.armor.condition + (inst.components.armor.maxcondition/10), inst.components.armor.maxcondition) )
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

local function _MakeForgeRepairable(inst, material, _onbroken, onrepaired)
    local function __onbroken(inst)
        if _onbroken ~= nil then
            _onbroken(inst)
        end		
    end
    if inst.components.armor ~= nil then
    assert(not (DEBUG_MODE and inst.components.armor.onfinished ~= nil))
    inst.components.armor:SetKeepOnFinished(true)
    inst.components.armor:SetOnFinished(__onbroken)
    elseif inst.components.finiteuses ~= nil then
    assert(not (DEBUG_MODE and inst.components.finiteuses.onfinished ~= nil))
    inst.components.finiteuses:SetOnFinished(__onbroken)
    elseif inst.components.fueled ~= nil then
    assert(not (DEBUG_MODE and inst.components.fueled.depleted ~= nil))
    inst.components.fueled:SetDepletedFn(__onbroken)
    end
    inst:AddComponent("forgerepairable")
	inst.components.forgerepairable:SetRepairMaterial(material)
	inst.components.forgerepairable:SetOnRepaired(onrepaired)
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
	
    inst:AddTag("vortex_cloak")	
	inst:AddTag("shadow_item")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then	
	    inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("backpack") end	
	    return inst
	end
        
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"		
	inst.caminho = "images/inventoryimages/hamletinventory.xml"	
    inst.components.inventoryitem.cangoincontainer = false
    inst.foleysound = "dontstarve_DLC003/common/crafted/vortex_armour/foley"

    local container = inst:AddComponent("container")
	container:WidgetSetup("backpack")

    local armor = inst:AddComponent("armor")
    armor:InitCondition(ARMORVORTEX, ARMORVORTEX_ABSORPTION)
    --armor:SetImmuneTags({"shadow"})
--    inst.components.armor.bonussanitydamage = 0.3

    local fueled = inst:AddComponent("fueled")
    fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)
    fueled.fueltype = "NIGHTMARE" -- 燃料是噩梦燃料
    fueled.ontakefuelfn = ontakefuel
    fueled.accepting = true

    local planardefense = inst:AddComponent("planardefense")
    planardefense:SetBaseDefense(TUNING.ARMOR_VOIDCLOTH_PLANAR_DEF) --虚空长袍的位面防御

    local damagetyperesist = inst:AddComponent("damagetyperesist")
    damagetyperesist:AddResist("shadow_aligned", inst, TUNING.ARMOR_VOIDCLOTH_SHADOW_RESIST) --虚空长袍的10%暗影阵营减伤

    local shadowlevel = inst:AddComponent("shadowlevel")
    shadowlevel:SetDefaultLevel(TUNING.ARMOR_VOIDCLOTH_SHADOW_LEVEL) --虚空长袍的老麦3级暗影之力

    SetupEquippable(inst)
    --inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
	--采用修改后的联机版中的虚空长袍的机制
    _MakeForgeRepairable(inst, "voidcloth", OnBroken, OnRepaired)
    
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
