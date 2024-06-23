local assets =
{
    Asset("ANIM", "anim/des_shard_sword_ground.zip"),
    Asset("ANIM", "anim/swap_des_shard_sword.zip"),	
    Asset("ANIM", "anim/des_shard_beak_ground.zip"),
    Asset("ANIM", "anim/swap_des_shard_beak.zip"),
	Asset("ANIM", "anim/des_glass_shards.zip"),	
}

local day_time = 60 * 8
local total_day_time = day_time
local wilson_attack = 34
local wilson_health = 150
local calories_per_day = 75



---spear damage = 34
---ham bat damage = 60
---nightsword damage = 68

------------GLASS BEAK--------------
DES_GLASS_BEAK_DAMAGE = 34
DES_GLASS_BEAK_DAMAGE_VS_STRUCTURE = DES_GLASS_BEAK_DAMAGE * 5
DES_GLASS_BEAK_DURABILITY = 100 --- it has crow in it hard to craft -- Runar: DST哪个版本时做的碎裂喙？难做是什么意思

------------GLASS SWORD--------------
DES_GLASS_SWORD_THRONS = math.random(1, 5)
DES_GLASS_SWORD_DAMAGE = 50
DES_GLASS_SWORD_DAMAGE_MAX = 400
DES_GLASS_SWORD_DAMAGE_VS_SHADOW = 100 -- Runar: 原本的斩杀线
DES_GLASS_SWORD_DURABILITY = 50 



local function shine(inst)
    inst.task = nil
    inst.AnimState:PlayAnimation("sparkle")
    inst.AnimState:PushAnimation("idle")
    inst.task = inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function onequip1(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_des_shard_sword", "swap_des_shard_sword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip1(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function onattack1(inst, owner, target)
    if target.components.combat and target.components.health then
        if target:HasTag("shadow") then
            if target.components.health.currenthealth <= DES_GLASS_SWORD_DAMAGE_MAX then
                target.components.combat:GetAttacked(owner, math.max(DES_GLASS_SWORD_DAMAGE_VS_SHADOW, target.components.health.currenthealth - 1), inst)
            else
                target.components.combat:GetAttacked(owner, DES_GLASS_SWORD_DAMAGE_MAX, inst)
                if owner and owner.components.combat and owner.components.health and not owner.components.health:IsDead() then
                    owner.components.combat:GetAttacked(owner, DES_GLASS_SWORD_THRONS, inst)
                end
            end
        else
            target.components.combat:GetAttacked(owner, DES_GLASS_SWORD_DAMAGE, inst)
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_des_shard_beak", "swap_des_shard_beak")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, owner, target)
    if target.components.health then
        if target:HasTag("wall") or target:HasTag("structure") or target.components.childspawner then --Runar 打墙打巢都很快
            target.components.combat:GetAttacked(owner, DES_GLASS_BEAK_DAMAGE_VS_STRUCTURE, inst)
        else
            target.components.combat:GetAttacked(owner, DES_GLASS_BEAK_DAMAGE, inst)
        end
    end
end

local function fnshard_sword()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("des_shard_sword_ground")
    inst.AnimState:SetBuild("des_shard_sword_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
	MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0) -- Runar: 不知道怎么让它既显示攻击力又不造成伤害
    inst.components.weapon.onattack = onattack1

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(DES_GLASS_SWORD_DURABILITY)
    inst.components.finiteuses:SetUses(DES_GLASS_SWORD_DURABILITY)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip1)
    inst.components.equippable:SetOnUnequip(onunequip1)

    MakeHauntableLaunch(inst)

    return inst
end


local function fnshard_beak()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("des_shard_beak_ground")
    inst.AnimState:SetBuild("des_shard_beak_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0) -- Runar: 放弃多段伤害
    inst.components.weapon.onattack = onattack

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(DES_GLASS_BEAK_DURABILITY)
    inst.components.finiteuses:SetUses(DES_GLASS_BEAK_DURABILITY)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"
	
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("des_glass_shards")
    inst.AnimState:SetBuild("des_glass_shards")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")
    inst:AddTag("renewable")
    inst:AddTag("quakedebris")

	

	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
	inst.caminho = "images/inventoryimages/volcanoinventory.xml"
	
    MakeHauntableLaunchAndSmash(inst)

    inst:AddComponent("bait")
	print("COLOR CHANGE")
	local s = math.random()*0.3 + 0.9
	local r = math.random()*0.4+0.6
	local g = math.random()*0.4+0.5
	local b = math.random()*0.4+0.6
	local a = math.random()*0.3+0.7
	
	inst.AnimState:SetScale(s,s,s,s)
	inst.AnimState:SetMultColour(r,g,b,1)
	
    shine(inst)

    return inst
end

return Prefab("shard_sword", fnshard_sword, assets), Prefab("shard_beak", fnshard_beak, assets), Prefab("glass_shards", fn, assets)