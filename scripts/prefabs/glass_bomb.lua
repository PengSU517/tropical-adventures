local assets=
{
	Asset("ANIM", "anim/glass_bomb.zip"),
	Asset("ANIM", "anim/swap_glass_bomb.zip"),
	
	Asset("ATLAS", "images/inventoryimages/glass_bomb.xml"),
	Asset("IMAGE", "images/inventoryimages/glass_bomb.tex")
}

local prefabs =
{
	"explode_small",
	"firering_fx",
}

local function begone(inst)
	inst:Remove()
end

local function explode(inst)
	inst.components.explosive:OnBurnt()
end

local function fall_explode(inst, owner)
	local x, y, z = inst.Transform:GetWorldPosition()
	local bomb = SpawnPrefab("glass_bomb")
	bomb.Transform:SetPosition(x, y, z)
	bomb.components.explosive:OnBurnt()
	inst:DoTaskInTime(0.5, begone)
end
	
local function onexplode(inst)
	local pos = inst:GetPosition()
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")

	local explode = SpawnPrefab("goddess_telefx")
	local ring = SpawnPrefab("groundpoundring_fx")
	local pos = inst:GetPosition()
	local s = 3
	local s1 = 0.7

	ring.Transform:SetPosition(pos.x, pos.y, pos.z)
	ring.Transform:SetScale(s1, 1, s1)

	explode.Transform:SetPosition(pos.x, pos.y, pos.z)
	explode.Transform:SetScale(s, s, s)
	
	inst.SoundEmitter:KillSound("hiss")
	
	inst:DoTaskInTime(0.5, begone)
end

local function ontimer(inst, data)
    if data.name == "extinguish" then
        fall_explode(inst)
    end
end

local function addfirefx(inst, owner)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
	inst.components.timer:StartTimer("extinguish", 3)
end

local function removefirefx(inst)
    if inst.fire then
        inst.fire:Remove()
        inst.fire = nil
    end
	inst.components.timer:StopTimer("extinguish", 3)
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_glass_bomb", "coconade01")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function onputininventory(inst)
	removefirefx(inst)
    inst.SoundEmitter:KillSound("hiss")
end

local function onthrown(inst)
	inst.Transform:SetFourFaced()
    inst.AnimState:PushAnimation("throw", true)
	
	
	
	
  inst._fx = SpawnPrefab("torchfire")
  inst._fx.entity:SetParent(inst.entity)
  inst._fx.entity:AddFollower()
  inst._fx.Follower:FollowSymbol(inst.GUID, "coconade01", 40,-105, 0)
  inst.AnimState:PlayAnimation("throw")
  inst:AddTag("NOCLICK")
  inst.persists = false

  inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
  inst.Physics:SetMass(1)
  inst.Physics:SetCapsule(0.2, 0.2)
  inst.Physics:SetFriction(0)
  inst.Physics:SetDamping(0)
  inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
  inst.Physics:ClearCollisionMask()
  inst.Physics:CollidesWith(COLLISION.WORLD)
  inst.Physics:CollidesWith(COLLISION.OBSTACLES)
  inst.Physics:CollidesWith(COLLISION.ITEMS)	
	
end

local function toground(inst)
	inst.SoundEmitter:KillSound("hiss")
end

local function onremove(inst)
	inst.SoundEmitter:KillSound("hiss")
	removefirefx(inst)
end

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end

local function OnHitWater(inst, attacker, target)
inst.AnimState:PlayAnimation("idle")
addfirefx(inst)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

	inst:AddTag("projectile")
	inst:AddTag("explosive")
	
	inst.AnimState:SetBank("glass_bomb")
	inst.AnimState:SetBuild("glass_bomb")
	inst.AnimState:PlayAnimation("idle")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/glass_bomb.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ontimer)

	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(12, 16)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetOnHitFn(explode)
	
	MakeSmallBurnable(inst, 3 + math.random() * 3)
	MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)
	
	inst:AddComponent("explosive")
	inst.components.explosive:SetOnExplodeFn(onexplode)
	inst.components.explosive.explosivedamage = 600
	inst.components.explosive.explosiverange = 6
	inst.components.explosive.buildingdamage = 10
	
    inst:AddComponent("complexprojectile")
	
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitWater)	
	
    inst:ListenForEvent("onthrown", onthrown)
	inst:ListenForEvent("ondropped", toground)
	
	MakeHauntableLaunchAndIgnite(inst)

    inst.OnRemoveEntity = onremove

	return inst
end

return Prefab("glass_bomb", fn, assets, prefabs)
