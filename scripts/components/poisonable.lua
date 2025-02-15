local Poisonable = Class(function(self, inst)
	self.inst = inst
	self.dmg = 0
	self.interval = 0
	self.maxInterval = 5
	self.minInterval = 1
	self.defaultDuration = 60 * 16
	self.startDuration = 0
	self.duration = 0
    self.immuneduration = 0
	self.updating = false
	self.lastDamageTime = 0
	self:SetOnHitFn()
	self.poisonfx = nil
end)

local function SpoilLoot(inst, loot)
	if loot.components.perishable then
		local pc = 0.5 * loot.components.perishable:GetPercent()
		loot.components.perishable:SetPercent(pc)
	end
	return loot
end

function Poisonable:SetPoison(dmg, interval, duration)
    self.immuneduration = math.max(self.immuneduration - duration / 2, 0)
    if self.immuneduration > 0 then
        if self.poisonfx then self.poisonfx:Remove() end
        self.poisonfx = SpawnPrefab("poisonbubble_level1")
        self.poisonfx.AnimState:SetHSV(130 / 360, 1, .9)
        self.inst:AddChild(self.poisonfx)
        local burnable = self.inst.components.burnable
        if burnable and #burnable.fxdata > 0 then
            local symbol = burnable.fxdata[1].follow
            if symbol then
                self.poisonfx.Follower:FollowSymbol(self.inst.GUID, symbol, 0, 0, 0)
            end
        end
        self.inst:AddDebuff("poisoned_tro", "buff_poisoned_tro", {duration = self.immuneduration, debuffkey = "antitoxin"}, true)
        return
    end
    duration = duration - self.immuneduration * 2
	self.dmg = dmg or -1
	self.interval = interval or self.maxInterval
	self.startDuration = duration or self.defaultDuration
	self.duration = self.startDuration
    self.inst:AddDebuff("poisoned_tro", "buff_poisoned_tro", {duration = self.duration, debuffkey = "poisoned"}, true)
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
		if self.inst.components.lootdropper then
			self.inst.components.lootdropper:SetLootPostInit("poisoned", SpoilLoot)
		end
	end

	if self.inst.player_classified then
		self.inst.player_classified.poisonover:set_local(true)
		self.inst.player_classified.poisonover:set(true)
	end
end

function Poisonable:ResetValues()
	self.duration = 0
	self.startDuration = 0
	self.dmg = 0
	self.interval = 0
	self.lastDamageTime = 0
    self.immuneduration = 0
end

function Poisonable:WearOff(immuneduration)
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
    self.inst:RemoveDebuff("poisoned_tro")
	if self.updating and self.inst.components.lootdropper then
		self.inst.components.lootdropper:RemoveLootPostInit("poisoned")
	end
	self.updating = false

	--remove poisonfx
	if self.poisonfx then
		self.poisonfx:Remove()
		self.poisonfx = nil
	end

    if immuneduration then
        self.immuneduration = math.max(self.immuneduration, immuneduration)
        self.inst:AddDebuff("poisoned_tro", "buff_poisoned_tro", {duration = self.immuneduration, debuffkey = "antitoxin"}, true)
    	if not self.updating then
		    self.inst:StartUpdatingComponent(self)
        end
    end
end

function Poisonable:IncreaseIntensity()
	if self.duration ~= 0 and self.interval > self.minInterval then
		local progress = self.startDuration / self.duration
		self.interval = math.max(progress * self.maxInterval, self.minInterval)
	end
end

function Poisonable:OnUpdate(dt)
    self.immuneduration = self.immuneduration - dt
    if self.immuneduration < 0 then self.immuneduration = 0 end

	self.duration = self.duration - dt
	self.lastDamageTime = self.lastDamageTime - dt
	-- thanks to Swaggy for the fix
	if self.inst.components.health and self.lastDamageTime <= 0 then
		self.inst.components.health:DoDelta(self.dmg, nil, "poison")
		self:IncreaseIntensity()
		self.lastDamageTime = self.interval
		if self.inst.player_classified then
			self.inst.player_classified.poisonover:set_local(true)
			self.inst.player_classified.poisonover:set(true)
		end
	end

	-- poison bubbles fx, fixed by EvenMr
	if not self.poisonfx and self.dmg < 0 then
		self.poisonfx = SpawnPrefab("poisonbubble_level1_loop")
		self.inst:AddChild(self.poisonfx)
		local cmp = self.inst.components
		if cmp.burnable and #cmp.burnable.fxdata > 0 then
			local symbol = cmp.burnable.fxdata[1].follow
			if symbol then
				self.poisonfx.Follower:FollowSymbol(self.inst.GUID, symbol, 0, 0, 0)
			end
		end
	end

	if self.duration <= 0 and self.immuneduration <= 0 or
       self.inst:HasOneOfTags({"weremoose", "weregoose", "beaver", "playerghost"}) then
		self:WearOff()
	end
end

function Poisonable:SetOnHitFn()
	local onhit = function(inst, attacker, dmg)
		if attacker ~= nil and attacker.components.poisonous then
			attacker.components.poisonous:OnAttack(inst, dmg)
		end
	end
	if self.inst.components.combat.onhitfn ~= nil then
		local oldonhitfn = self.inst.components.combat.onhitfn
		self.inst.components.combat:SetOnHit(function(inst, attacker, dmg)
			oldonhitfn(inst, attacker, dmg)
			onhit(inst, attacker, dmg)
		end)
	else
		self.inst.components.combat:SetOnHit(onhit)
	end
end

function Poisonable:OnLoad(data)
	if data.dmg and data.startDuration and data.duration and data.interval then
		self:SetPoison(data.dmg, data.interval, data.duration)
		self.startDuration = data.startDuration
	end
	if data.lastDamageTime ~= nil then
		self.lastDamageTime = data.lastDamageTime
	end
end

function Poisonable:OnSave()
	return {
		dmg = self.dmg,
		interval = self.interval,
		duration = self.duration,
		startDuration = self.startDuration,
		lastDamageTime = self.lastDamageTime
	}
end

return Poisonable
