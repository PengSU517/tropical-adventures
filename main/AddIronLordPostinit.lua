local function IsIronlord(inst)
	return inst and inst:HasTag("ironlord")
end

local function RebuildIronlord(inst)
	if not inst:HasTag("ironlordvision") then return end
	inst.AnimState:SetBuild("living_suit_build")
	inst.AnimState:AddOverrideBuild("living_suit_build")
end

AddClassPostConstruct("screens/playerhud",function(self)
	local LivingArtifactOver = require "widgets/livingartifactover"
	local IronlordBadge = require "widgets/ironlordbadge"

	local old_CreateOverlays = self.CreateOverlays
	function self:CreateOverlays(owner)
		old_CreateOverlays(self, owner)
		self.livingartifactover = self.overlayroot:AddChild(LivingArtifactOver(owner))
	end

	local old_OnUpdate = self.OnUpdate
	function self:OnUpdate(dt)
		old_OnUpdate(self, dt)
		if self.livingartifactover and self.controls and self.owner and self.owner.components.playervision then
			if not self.livingartifactover.shown and self.owner:HasTag("ironlordvision") then
				self.livingartifactover:TurnOn()
				self.controls.ironlordbadge = self.controls.sidepanel:AddChild(IronlordBadge(self.owner))
				self.controls.ironlordbadge:SetPosition(0,-100,0)
				self.gogglesover.bg:SetTint(1, 1, 1, 0)	-- make "goggles frame" transparent
				self.owner.components.playervision:ForceGoggleVision(true)
			elseif self.livingartifactover.shown and not self.owner:HasTag("ironlordvision") then
				self.owner.components.playervision:ForceGoggleVision(false)
				self.gogglesover.bg:SetTint(1, 1, 1, 1)
				self.controls.ironlordbadge:Kill()
				self.controls.ironlordbadge = nil
				self.livingartifactover:TurnOff()
			end
		end
	end
end)

AddClassPostConstruct("widgets/controls", function(self)
	self.hasironlordbadge = false
	local old_OnUpdate = self.OnUpdate
	function self:OnUpdate(dt)
		old_OnUpdate(self, dt)
		if self.ironlordbadge then  -- Keep updating, can't think of better way to deal with preload process
			self.hasironlordbadge = true
			self.status:Hide()
			self:HideMap()
			self.mapcontrols.minimapBtn:Hide()
			if self.minimap_small then
				self.minimap_small:Hide()
			end
			self:HideCraftingAndInventory()
			self.inv:Show()
		elseif not self.ironlordbadge and self.hasironlordbadge then
			self.hasironlordbadge = false
			self.status:Show()
			self.mapcontrols.minimapBtn:Show()
			if self.minimap_small then
				self.minimap_small:Show()
			end
			self:ShowCraftingAndInventory()
		end
	end
end)

--------------------------------------------- Component ---------------------------------------------

AddComponentPostInit("inventory", function(self)
	local old_Equip = self.Equip
	function self:Equip(item, ...)
		local prevslot = self:GetItemSlot(item)
		if IsIronlord(self.inst) and not item:HasTag("heavy") then  -- Can't EQUIP when using Artifact
			if not prevslot then self:GiveItem(item) end
			return
		end
		return old_Equip(self, item, ...)
	end

	local old_DropItem = self.DropItem
	function self:DropItem(item, ...)
		if not (item and item.components.inventoryitem) then return end

		local owner = item.components.inventoryitem:GetGrandOwner()
		if IsIronlord(owner) and item.prefab == "living_artifact" and  -- Can't DROP activated Artifact
			item.components.ironmachine and item.components.ironmachine:IsOn() then
			return
		end
		return old_DropItem(self, item, ...)
	end

	function self:DropEquipped(keepBackpack)
		for k, v in pairs(self.equipslots) do
			if not (keepBackpack and v:HasTag("backpack")) and k ~= "beard" then  -- Wilson's beard_sack
				self:DropItem(v, true, true)
			end
		end
	end
end)

AddComponentPostInit("locomotor", function(self)
	local old_GetSpeedMultiplier = self.GetSpeedMultiplier

	local function ServerGetSpeedMultiplier(self)
		local mult = old_GetSpeedMultiplier(self)
		if IsIronlord(self.inst) then
			local is_mighty = self.inst:HasTag("mightiness_mighty")  -- Prevent double speedup for Wolfgang(mighty)
			local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if item and item:HasTag("heavy") and not is_mighty then
				local item_speed_mult = item.components.equippable:GetWalkSpeedMult()
				mult = mult / item_speed_mult
			end
		end
		return mult
	end

	local function ClientGetSpeedMultiplier(self)
		local mult = old_GetSpeedMultiplier(self)
		if IsIronlord(self.inst) then
			local is_mighty = self.inst:HasTag("mightiness_mighty")  -- Prevent double speedup for Wolfgang(mighty)
			local item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if item and item:HasTag("heavy") and not is_mighty then
				local item_speed_mult = item.replica.inventoryitem:GetWalkSpeedMult()
				mult = mult / item_speed_mult
			end
		end
		return mult
	end

	if GLOBAL.TheWorld.ismastersim then
		self.GetSpeedMultiplier = ServerGetSpeedMultiplier
	else
		self.GetSpeedMultiplier = ClientGetSpeedMultiplier
	end
end)

AddComponentPostInit("cursable", function(self)
	function self:RemoveMonkeyCurse(dropitems)
		local curse = "MONKEY"
		local tag = "monkey_token"

		while true do
			local item = self.inst.components.inventory:FindItem(function(v) return v:HasTag(tag) end)
			if not item then break end

			self.inst.components.inventory:ConsumeByName(item.prefab, 1)
			if dropitems then
				local newcurse = SpawnPrefab(item.prefab)
				newcurse.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				newcurse.components.inventoryitem:OnDropped(true)
			end
		end

		self.curses[curse] = nil

		self.inst.monkeyfeet = nil
		self.inst.monkeyhands = nil
		self.inst.monkeytail = nil
		self.inst.components.skinner:ClearMonkeyCurse()
		self.inst:RemoveTag("MONKEY_CURSE_1")
		self.inst:RemoveTag("MONKEY_CURSE_2")
		self.inst:RemoveTag("MONKEY_CURSE_3")
	end
end)

AddComponentPostInit("projectile", function(self)
	function self:ArtifactThrow(target, targetpos, attacker)
		self.start = self.inst:GetPosition()
		self.dest = target and target:GetPosition() or targetpos
		self.attacker = attacker
		self.artifacttarget = (target and not target:HasTag("NOBLOCK")) and target or nil

		self:RotateToTarget(self.dest)
		self.inst.Physics:SetMotorVel(self.speed, 0, 0)
		self.inst:StartUpdatingComponent(self)
		self.inst:AddTag("activeprojectile")
	end

	local old_OnUpdate = self.OnUpdate
	function self:OnUpdate(dt)
		if self.artifacttarget and self.artifacttarget:IsValid() and not self.artifacttarget:IsInLimbo() then
			-- For targets that won't collide
			local pos = self.inst:GetPosition()
			local targetpos = self.artifacttarget:GetPosition()
			local range = self.artifacttarget:GetPhysicsRadius(0)+self.hitdist
			if GLOBAL.distsq(pos, targetpos) < range*range then
				self.inst.collide(self.inst, self.artifacttarget)
			end
		end
		old_OnUpdate(self, dt)
	end
end)

AddComponentPostInit("grogginess", function(self)
	local old_AddGrogginess = self.AddGrogginess
	function self:AddGrogginess(...)
		if IsIronlord(self.inst) then return end
		old_AddGrogginess(self, ...)
	end
end)

----------------------------------------------- Prefab -----------------------------------------------

AddPrefabPostInit("wormwood", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end

	local old_onlevelchangedfn = inst.components.bloomness.onlevelchangedfn
	inst.components.bloomness.onlevelchangedfn = function(inst, stage)
		old_onlevelchangedfn(inst, stage)
		if IsIronlord(inst) then
			RebuildIronlord(inst)
		end
	end
end)
--[[
AddPrefabPostInit("rock_moon", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	inst.components.lootdropper:AddChanceLoot("infused_iron", 0.25)
end)

AddPrefabPostInit("opalpreciousgem", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	inst.components.tradable.rocktribute = 18
end)

AddPrefabPostInit("antlion", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end

	local old_OnGivenItem = inst.components.trader.onaccept
	inst.components.trader.onaccept = function(inst, giver, item)
		inst.pendingrewarditem_waterdrop = item.prefab == "opalpreciousgem" and "waterdrop" or nil
		old_OnGivenItem(inst, giver, item)
	end

	local old_HasRewardToGive = inst.HasRewardToGive
	inst.HasRewardToGive = function(inst)
		return old_HasRewardToGive(inst) or inst.pendingrewarditem_waterdrop ~= nil
	end

	local old_GiveReward = inst.GiveReward
	inst.GiveReward = function(inst)
		if inst.pendingrewarditem_waterdrop then
			GLOBAL.LaunchAt(SpawnPrefab(inst.pendingrewarditem_waterdrop), inst, (inst.tributer and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
			inst.pendingrewarditem_waterdrop = nil
			inst.tributer = nil
			return
		end
		old_GiveReward(inst)
	end
end)
]]
AddPrefabPostInit("player_classified", function(inst)
	local ArtifactControls = require "ArtifactControls"

	local function OnArtifactexplodeDirty(inst)
		if inst._parent and inst._parent.sg and not inst._parent.sg:HasStateTag("explode") then
			inst._parent.sg:GoToState("explode")
		end
	end

	local function OnAritfactcontrolDirty(inst)
		if inst._parent then
			if inst.artifactcontrol:value() then
				-- Keep trying until succeed, can't think of better way to deal with preload process
				inst._parent.tryoverride = inst._parent:DoPeriodicTask(0.1, function()
					ArtifactControls.toggle(inst._parent, inst.artifactcontrol:value())
					if inst.artifactoverridden:value() then
						inst.artifactoverridden:set(false)
						if inst._parent.tryoverride then
							inst._parent.tryoverride:Cancel()
							inst._parent.tryoverride = nil
						end
					end
				end)
			else
				ArtifactControls.toggle(inst._parent, inst.artifactcontrol:value())
			end
		end
	end

	inst.artifactfuel = net_ushortint(inst.GUID, "artifactfuel")
	inst.artifactexplode = net_bool(inst.GUID, "artifactexplode", "artifactexplodedirty")
	inst.artifactcontrol = net_bool(inst.GUID, "artifactcontrol", "artifactcontroldirty")
	inst.artifactoverridden = net_bool(inst.GUID, "artifactoverridden")

	-- Initial values (don't trigger event)
	--inst.artifactfuel:set_local(TUNING.IRON_LORD_TIME)
	inst.artifactoverridden:set_local(false)

	inst:ListenForEvent("artifactexplodedirty", OnArtifactexplodeDirty)
	inst:ListenForEvent("artifactcontroldirty", OnAritfactcontrolDirty)
end)

--------------------------------------------- Stategraph ---------------------------------------------

local NEW_ACTIONS =
{
	{"CHOP", "work"},
	{"HACK", "work"},
	{"MINE", "work"},
	{"DIG", "work"},
	{"HAMMER", "work"},
	{"ATTACK", "punch"},
	{"MOUNT", ""},
}

local function ChangeActionHandler(inst, act, fn)
	local old_handler = inst.actionhandlers[act].deststate
	inst.actionhandlers[act].deststate = function(inst, action)
		if IsIronlord(inst) then
			if type(fn) == "function" then
				return fn(inst, action, old_handler)
			elseif type(fn) == "string" then
				return fn
			end
		end
		return old_handler(inst, action)
	end
end

local function ChangeEventHandler(inst, event, fn)
	local old_handler = inst.events[event].fn
	inst.events[event].fn  = function(inst, data)
		if IsIronlord(inst) then
			if type(fn) == "function" then
				fn(inst, data, old_handler)
			elseif type(fn) == "string" then
				inst.sg:GoToState(fn, data)
			end
			return
		end
		old_handler(inst, data)
	end
end

local function yawn_fn(inst, data, old_fn)
	if inst.sg:HasStateTag("artifact_busy") then return end
	old_fn(inst, data)
end

local function death_fn(inst)
	inst:AddTag("preparetodie")
	if inst.sg:HasStateTag("artifact_busy") then return end
	inst.artifact.components.ironmachine:TurnOff()
end

local function powerup_wurt_fn(inst, data, old_fn)
	if inst.sg:HasStateTag("dead") then return end
	-- Skip animation
	inst.components.skinner:SetSkinMode("powerup", "wurt_stage2")
	RebuildIronlord(inst)
end

local function powerdown_wurt_fn(inst, data, old_fn)
	if inst.sg:HasStateTag("dead") then return end
	-- Skip animation
	inst.components.skinner:SetSkinMode("normal_skin", "wurt")
	RebuildIronlord(inst)
end

AddStategraphPostInit("wilson", function(inst)
	for _,v in pairs(NEW_ACTIONS) do
		local action = ACTIONS[v[1]]
		local state = v[2]
		ChangeActionHandler(inst, action, state)
	end

	ChangeEventHandler(inst, "transform_wereplayer")
	ChangeEventHandler(inst, "knockedout")
	ChangeEventHandler(inst, "yawn", yawn_fn)
	ChangeEventHandler(inst, "knockback", yawn_fn)
	ChangeEventHandler(inst, "death", death_fn)	-- Just in case (e.g. console cmd)
	ChangeEventHandler(inst, "powerup_wurt", powerup_wurt_fn)
	ChangeEventHandler(inst, "powerdown_wurt", powerdown_wurt_fn)
end)

AddStategraphPostInit("wilson_client", function(inst)
	for _,v in pairs(NEW_ACTIONS) do
		local action = ACTIONS[v[1]]
		local state = v[2]
		ChangeActionHandler(inst, action, state)
	end
end)

local function AddActionHandler(action, state)
	action = ACTIONS[action]
	AddStategraphActionHandler("wilson", ActionHandler(action, state))
	AddStategraphActionHandler("wilson_client", ActionHandler(action, state))
end

AddActionHandler("IRONTURNON", "morph")
AddActionHandler("IRONTURNOFF", "explode")
AddActionHandler("CHARGE_UP", "charge")

local function AddEventHandler(event, fn)
	AddStategraphEvent("wilson", EventHandler(event, fn))
	AddStategraphEvent("wilson_client", EventHandler(event, fn))
end

AddEventHandler("rightbuttondown", function(inst) inst.rightbuttonup = nil end)
AddEventHandler("rightbuttonup", function(inst) inst.rightbuttonup = true end)
AddEventHandler("ms_respawnedfromghost", function(inst)
	if inst:HasTag("magic_respawn") then
		inst:RemoveTag("magic_respawn")
		inst.sg:GoToState("magic_rebirth")
	end
end)