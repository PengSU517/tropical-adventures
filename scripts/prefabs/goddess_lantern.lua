local assets =
{
    Asset("ANIM", "anim/goddess_lantern.zip"),
	Asset("IMAGE", "images/inventoryimages/goddess_lantern.tex"),
	Asset("ATLAS", "images/inventoryimages/goddess_lantern.xml"),
	Asset("ANIM", "anim/swap_goddess_lantern.zip"),
	Asset("ANIM", "anim/swap_goddess_lantern1.zip"),
}

local function onequip(inst, owner)
	owner:AddTag("windy3")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	if inst.on == true then
		owner.AnimState:OverrideSymbol("swap_object", "swap_goddess_lantern1", "swap_goddess_lantern1")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		if inst.components.fueled ~= nil then
			inst.components.fueled:StartConsuming()
		end
		if inst.fire == nil then
			inst.fire = SpawnPrefab("goddess_lantern_fire")
			inst.fire.entity:AddFollower()
			inst.fire.Transform:SetPosition(0, 25, 0)
			inst.fire.Follower:FollowSymbol(owner.GUID, "swap_object", 0, 25, 0)
		end
	elseif inst.on == false then
		owner.AnimState:OverrideSymbol("swap_object", "swap_goddess_lantern", "swap_goddess_lantern")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
	end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner:RemoveTag("windy3")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	if inst.fire ~= nil then
        inst.fire:Remove()
        inst.fire = nil
    end
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local fueled =  inst.components.fueled:GetPercent()
	if giver:HasTag("windy1") and giver:HasTag("windy2") then
		inst.components.fueled:SetPercent(fueled + 0.40)
	else
		inst.components.fueled:SetPercent(fueled + 0.10)
	end
	if fueled >= 1 then
		inst.components.fueled:SetPercent(1)
	end
end

local function toground(inst)
	if inst.on == (true) then
		if inst.flies == nil then
			inst.flies = inst:SpawnChild("goddess_lantern_fire")
			inst.flies.Transform:SetPosition(0, 0.75, 0)
		end
		if inst.components.fueled ~= nil then
			inst.components.fueled:StartConsuming()
		end
	end
end

local function topocket(inst)
	if inst.flies ~= nil then
		inst.flies:Remove()
		inst.flies = nil
	end
	if inst.components.fueled ~= nil then
		inst.components.fueled:StopConsuming()
	end
end

local function light_reticuletargetfn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(5, 0, 0))
end

local PEACH_CHOICES =
{
    ["peach"] = 1,
	["grilled_peach"] = 1,
	["peach_smoothie"] = 0.25,
	["peach_kabobs"] = 0.25,
	["caramel_peach"] = 0.25,
	["peachy_meatloaf"] = 0.10,
	["peach_custard"] = 0.10,
	["peach_juice_bottle_green"] = 0.05,
}

local BETTER_PEACH_CHOICES =
{
    ["peach"] = 0.40,
	["grilled_peach"] = 0.60,
	["peach_smoothie"] = 0.30,
	["peach_kabobs"] = 0.30,
	["caramel_peach"] = 0.30,
	["peachy_meatloaf"] = 0.20,
	["peach_custard"] = 0.20,
	["peach_juice_bottle_green"] = 0.10,
}


local function spells(staff, target, pos)
	-- Peach Spell
	if staff.on == false then
		if staff.components.inventoryitem.owner:HasTag("windy1") and staff.components.inventoryitem.owner:HasTag("windy2") then
			local peach = SpawnPrefab(weighted_random_choice(BETTER_PEACH_CHOICES))
			peach.Transform:SetPosition(pos:Get())
			SpawnPrefab("explode_firecrackers").Transform:SetPosition(pos:Get())
		else
			local peach = SpawnPrefab(weighted_random_choice(PEACH_CHOICES))
			peach.Transform:SetPosition(pos:Get())
			SpawnPrefab("explode_firecrackers").Transform:SetPosition(pos:Get())
			staff.components.inventoryitem.owner.components.health:DoDelta(-15)
			staff.components.inventoryitem.owner.components.sanity:DoDelta(-25)
		end
		local fueled =  staff.components.fueled:GetPercent()
		staff.components.fueled:SetPercent(fueled - 0.05)
		if fueled <=0 then
			staff:Remove()
		end
	end
	-- Star Spell
	if staff.on == true then
		if staff.components.inventoryitem.owner:HasTag("windy1") and staff.components.inventoryitem.owner:HasTag("windy2") then
			local light = SpawnPrefab("goddess_star")
			light.Transform:SetPosition(pos:Get())
		else
			local light = SpawnPrefab("goddess_star")
			light.Transform:SetPosition(pos:Get())
			staff.components.inventoryitem.owner.components.health:DoDelta(-15)
			staff.components.inventoryitem.owner.components.sanity:DoDelta(-25)
		end
		local fueled =  staff.components.fueled:GetPercent()
		staff.components.fueled:SetPercent(fueled - 0.05)
		if fueled <=0 then
			staff:Remove()
		end
	end
end

local function TurnOff(inst, instant)
    inst.on = false
	inst:DoTaskInTime(0.75, function (inst)
		if inst.flies ~= nil then
			inst.flies:Remove()
			inst.flies = nil
		end
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/light_off")
	end)
	inst.AnimState:PlayAnimation("lit_post")
	inst.AnimState:PushAnimation("idle", true)
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function TurnOn(inst, instant)
    inst.on = true
	if inst.flies == nil then
        inst.flies = inst:SpawnChild("goddess_lantern_fire")
		inst.flies.Transform:SetPosition(0, 0.75, 0)
    end
	inst.AnimState:PlayAnimation("lit_pre", false)
	inst.AnimState:PushAnimation("idle_lit", true)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/light_on")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = 1.5
	inst.Transform:SetScale(s,s,s)

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_lantern")
    inst.AnimState:SetBuild("goddess_lantern")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("nopunch")
    inst:AddTag("quickcast")
	inst:AddTag("goddess_item")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_lantern.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(480*3)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
	inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = light_reticuletargetfn
    inst.components.reticule.ease = true
	
	inst:AddComponent("spellcaster")
	inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster:SetSpellFn(spells)
	
	inst:ListenForEvent("ondropped", toground)
	inst:ListenForEvent("onputininventory", topocket)
	
	inst.on = false

    return inst
end

return Prefab("goddess_lantern", fn, assets)