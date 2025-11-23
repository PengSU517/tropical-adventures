local sound_mapping = {
	ironwind      = "dontstarve_DLC002/common/boatpropellor_lp",
	sail          = "dontstarve_DLC002/common/sail_LP_cloth",
	clothsail     = "dontstarve_DLC002/common/sail_LP_cloth",
	snakeskinsail = "dontstarve_DLC002/common/sail_LP_snakeskin",
	feathersail   = "dontstarve_DLC002/common/sail_LP_feather",
	woodlegssail  = "dontstarve_DLC002/common/sail_LP_sealegs",
	malbatrossail = "dontstarve_DLC002/common/sail_LP_feather",
}



local Phys = require "tools/physics"
local Driver = Class(function(self, inst)
	self.inst = inst
	self.inst:ListenForEvent("death", function(inst)
		self:BoatDetached(inst)
		inst:RemoveTag("aquatic")
	end)
end)


function Driver:StartUpdating()
	self.inst:StartUpdatingComponent(self)
end

function Driver:StopUpdating()
	self.inst:StopUpdatingComponent(self)
end

function Driver:GetTail()
	return self.vehicle and self.vehicle.components.container:GetItemInSlot(1)
end

function Driver:GetHead()
	return self.vehicle and self.vehicle.components.container:GetItemInSlot(2)
end

function Driver:BoatAttached(vehicle)
	-- Phys.SetImmovable(vehicle)
	vehicle.AnimState:AddOverrideBuild("player_actions_paddle")
	self.inst:AddComponent("rowboatwakespawner")


	-------这是在身上的船
	self.inst.components.inventory:Equip(vehicle)
	self:StartUpdating()

	vehicle.components.workable.workable = false
	vehicle.components.inventoryitem.canbepickedup = false

	self.inst:RemoveTag("pulando")
end

function Driver:BoatJump(jumper, boat)
	if jumper and jumper:HasTag('player') and boat then
		jumper:AddTag("aquatic")
		boat:AddTag("boat_occupied")
		self.vehicle = boat
		jumper.Physics:ClearCollisionMask()
		jumper.Physics:CollidesWith(COLLISION.WORLD)
		jumper.Physics:CollidesWith(COLLISION.OBSTACLES)
		jumper.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		jumper.Physics:CollidesWith(COLLISION.CHARACTERS)
		jumper.Physics:CollidesWith(COLLISION.GIANTS)
		local x1, y1, z1 = boat.Transform:GetWorldPosition()
		local x2, y2, z2 = jumper.Transform:GetWorldPosition()
		local dist = math.sqrt((x1 - x2) * (x1 - x2) + (z1 - z2) * (z1 - z2))
		local speed = dist * 1.67
		jumper.Physics:SetMotorVel(speed, 0, 0)
		jumper.sg:GoToState("jumponboatstart", self.inst)
	end
end

function Driver:BoatDetached(jumper)
	if jumper and jumper:HasTag('player') and self.vehicle then
		local sailslot = self:GetTail()
		if sailslot and sailslot.components.fueled then sailslot.components.fueled:StopConsuming() end

		jumper:RemoveComponent("rowboatwakespawner")
		jumper.components.inventory:DropItem(
			jumper.components.inventory:Unequip(EQUIPSLOTS.BARCO))

		local x, y, z = self.inst.Transform:GetWorldPosition()
		self.vehicle.Transform:SetPosition(x, 0, z) ---------不加这一条的话会有一丢丢位置区别
		self:StopUpdating()

		jumper:RemoveTag("sail")
		self.vehicle:RemoveTag("boat_occupied")
		self.vehicle.components.workable.workable = true
		if self.vehicle:HasTag("pegabarco") then
			self.vehicle.components.inventoryitem.canbepickedup = true
		end
	end
end

function Driver:BoatDismount(jumper, pt)
	if jumper and jumper:HasTag('player') then
		jumper.Physics:ClearCollisionMask()
		jumper.Physics:CollidesWith(COLLISION.WORLD)
		jumper.Physics:CollidesWith(COLLISION.OBSTACLES)
		jumper.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		jumper.Physics:CollidesWith(COLLISION.CHARACTERS)
		jumper.Physics:CollidesWith(COLLISION.GIANTS)
		if jumper.components.health ~= nil then
			jumper.components.health:SetInvincible(false)
		end
		local x1, y1, z1 = pt:Get()
		local x2, y2, z2 = jumper.Transform:GetWorldPosition()
		local dist = math.sqrt((x1 - x2) * (x1 - x2) + (z1 - z2) * (z1 - z2))
		local speed = dist * 1.67
		jumper.Physics:SetMotorVel(speed, 0, 0)
		jumper.sg:GoToState("jumponboatdismount")

		self:BoatDetached(jumper)
		jumper:RemoveTag("aquatic")

		self.vehicle = nil
	end
end

function Driver:OnConsumeUses()
	local vehicle = self.vehicle
	local armor   = vehicle.components.armor
	local finite  = vehicle.components.finiteuses

	local multi   = 1
	if self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and
		self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "captainhat" then
		multi = 0.5
	end
	if self.inst.components.locomotor.isrunning then
		armor:Repair(-vehicle.useamount * multi)
	end
	finite.current = armor.condition
	finite:Use(0)
end

function Driver:OnStageGraph()
	-----这一部分相当于船的状态机
	local inst = self.inst
	local sailslot = self:GetTail()
	local sound = sailslot and sound_mapping[sailslot.prefab]
	local boat_proxy = inst.boat_proxy
	if boat_proxy and boat_proxy:IsValid() --[[ and not self.inst.sg:HasStateTag("busy") ]] then
		if self.inst.sg:HasStateTag("sailing") and sailslot and sailslot:HasTag("sail") then
			boat_proxy.AnimState:SetBank("wilson")                --把船的骨骼改成人的骨骼
			boat_proxy.AnimState:AddOverrideBuild("player_actions_paddle") ---在附加上船的动作build
			if not boat_proxy.AnimState:IsCurrentAnimation("sail_loop") then
				boat_proxy.AnimState:PlayAnimation("sail_loop", true)
			end
			if not boat_proxy.SoundEmitter:PlayingSound("sailmove") then
				boat_proxy.SoundEmitter:PlaySound(sound, "sailmove")
			end

			if sailslot and sailslot.components.fueled then sailslot.components.fueled:StartConsuming() end
		else
			boat_proxy.AnimState:SetBank(self.vehicle.banc)
			boat_proxy.AnimState:ClearOverrideBuild("player_actions_paddle")
			if not boat_proxy.AnimState:IsCurrentAnimation("run_loop") then
				boat_proxy.AnimState:PlayAnimation("run_loop", true) ---runloop其实是静止？
			end

			boat_proxy.SoundEmitter:KillSound("sailmove")

			if sailslot and sailslot.components.fueled then sailslot.components.fueled:StopConsuming() end
		end
	end
end

function Driver:OnUpdate(dt)
	local vehicle = self.vehicle
	local inst = self.inst
	if not vehicle or not inst then return end
	self:OnConsumeUses()
	if inst.components.locomotor.isrunning then
		self.inst.components.rowboatwakespawner:StartSpawning()

		if vehicle.replica.container and vehicle.replica.container.classified and not vehicle.replica.container:IsOpenedBy(self.inst) then
			vehicle.replica.container:Open(self.inst)
		end
	else
		self.inst.components.rowboatwakespawner:StopSpawning()
	end

	self:OnStageGraph()

	if vehicle.components.finiteuses.current <= 0 then
		self:BoatDetached(self.inst)
		vehicle:OnCollapse()
		self.inst:RemoveTag("aquatic")
		self.vehicle = nil
	end

	local x, y, z = self.inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsPassableAtPoint(x, y, z) then
		self:BoatDetached(self.inst)
		self.inst:RemoveTag("aquatic")
		self.vehicle:OnHammer()
		self.vehicle = nil
	end
end

return Driver
