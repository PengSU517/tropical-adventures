local assets =
{
    Asset("ANIM", "anim/goddess_staff.zip"),
    Asset("ANIM", "anim/swap_goddess_staff.zip"),
}

local prefabs =
{
    "green_rain",
}
	
local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end


local function unslow(inst)
	inst.components.locomotor.externalspeedmultiplier = 1
	inst:RemoveTag("slowed")
	if inst.magic ~= nil then
		inst.magic:Remove()
		inst.magic = nil
	end
end

local function unfast(inst)
	inst.components.locomotor.externalspeedmultiplier = 1
	inst:RemoveTag("fast")
	if inst.magic ~= nil then
		inst.magic:Remove()
		inst.magic = nil
	end
end

local function magic(inst)
	if inst.magic == nil then
		inst.magic = inst:SpawnChild("goddess_sparklefx")
		inst.magic.AnimState:PushAnimation("idle", true)
	end
end

local function spell(staff, target, pos)
	staff.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
	if not target:HasTag("slowed") then 
		-- Combo
			if staff.components.inventoryitem.owner:HasTag("windy1") and staff.components.inventoryitem.owner:HasTag("windy2") then
				if target.components.locomotor ~= nil then
					SpawnPrefab("groundpoundring_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
					local pos = target:GetPosition()
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 25, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"monster", "largecreature", "hostile", "walrus", "animal", "smallcreature", "merm", "epic"})
					for i,v in pairs(ents) do
						if not v:HasTag("player") and not v:HasTag("epic") and not v:HasTag("slowed") and v.components.locomotor ~= nil then
							v.components.locomotor.externalspeedmultiplier = 0.25
							v:AddTag("slowed")
							v:DoTaskInTime(15, unslow)
							if v.magic == nil then
								v.magic = v:SpawnChild("goddess_magicfx")
							end
						elseif not v:HasTag("player") and v:HasTag("epic") and not v:HasTag("slowed") and v.components.locomotor ~= nil then 
							v.components.locomotor.externalspeedmultiplier = 0.40
							v:AddTag("slowed")
							v:DoTaskInTime(10, unslow)
							if v.magic == nil then
								v.magic = v:SpawnChild("goddess_magicfx")
							end
						end
					end
					local ents1 = TheSim:FindEntities(pos.x, pos.y, pos.z, 25, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"player"})
					for i,v in pairs(ents1) do
						if v.components.locomotor ~= nil and not v:HasTag("fast") then
							v.components.locomotor.externalspeedmultiplier = 1.25
							v:AddTag("fast")
							v:DoTaskInTime(15, unfast)
							v:DoTaskInTime(0, magic)
						end
					end
				end
		-- No Combo
			else
				local pos = target:GetPosition()
				local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 25, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"player"})
					for i,v in pairs(ents) do
						if v.components.locomotor ~= nil and not v:HasTag("fast") then
							v.components.locomotor.externalspeedmultiplier = 1.25
							v:AddTag("fast")
							v:DoTaskInTime(10, unfast)
							v:DoTaskInTime(0, magic)
						end
					end
				staff.components.inventoryitem.owner.components.sanity:DoDelta(-10)
				if target.components.locomotor ~= nil and not target:HasTag("epic") then
					target.components.locomotor.externalspeedmultiplier = 0.40
					target:AddTag("slowed")
					target:DoTaskInTime(10, unslow)
					local pos = target:GetPosition()
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 0.1, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"monster", "largecreature", "hostile", "walrus", "animal", "smallcreature", "merm", "epic"})
					for i,v in pairs(ents) do
						if v.magic == nil then
							v.magic = v:SpawnChild("goddess_magicfx")
						end
					end
				elseif target.components.locomotor ~= nil and target:HasTag("epic") then
					target.components.locomotor.externalspeedmultiplier = 0.60
					target:AddTag("slowed")
					target:DoTaskInTime(5, unslow)
					local pos = target:GetPosition()
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 0.1, nil, {"FX", "NOCLICK","DECOR","INLIMBO"}, {"monster", "largecreature", "hostile", "walrus", "animal", "smallcreature", "merm", "epic"})
					for i,v in pairs(ents) do
						if v.magic == nil then
							v.magic = v:SpawnChild("goddess_magicfx")
						end
					end
				end
			end
		end
	if staff.components.inventoryitem.owner:HasTag("windy1") and staff.components.inventoryitem.owner:HasTag("windy2") then
		staff.components.finiteuses:Use(0.5)
	else
		staff.components.finiteuses:Use(1)
	end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_goddess_staff", "swap_ruins_bat")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
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

local function staff_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_staff")
    inst.AnimState:SetBuild("goddess_staff")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")

    --Sneak these into pristine state for optimization
    inst:AddTag("quickcast")
	
	local s = 2
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("goddess_staff")
	inst:AddTag("goddess_item")
	
	inst:AddComponent("leader")
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_staff.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster:SetSpellFn(spell)
    inst.components.spellcaster.castingstate = "castspell_tornado"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_staff", staff_fn, assets, prefabs)