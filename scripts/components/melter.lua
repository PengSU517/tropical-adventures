--local cooking = require("smelting")
local night_time = 60
local BASE_COOK_TIME = night_time * .3333
local melting = require("melting")

local Melter = Class(function(self, inst)
	self.inst = inst
	self.cooking = false
	self.done = false

	self.product = nil
	self.product_spoilage = nil
	self.recipes = nil
	self.default_recipe = nil
	self.spoiledproduct = "alloy"
	self.maketastyfood = nil

	self.min_num_for_cook = 4
	self.max_num_for_cook = 4

	self.cookername = nil

	-- stuff to make warly's special recipes possible
	self.specialcookername = nil -- a special cookername to check first before falling back to cookername default
	self.productcooker = nil  -- hold on to the cookername that is cooking the current product

	self.inst:AddTag("stewer")
end)

local function dospoil(inst)
	if inst.components.melter and inst.components.melter.onspoil then
		inst.components.melter.onspoil(inst)
	end

	if inst.components.melter.spoiltask then
		inst.components.melter.spoiltask:Cancel()
		inst.components.melter.spoiltask = nil
		inst.components.melter.spoiltargettime = nil
	end
end

local function dostew(inst)
	local stewercmp = inst.components.melter
	stewercmp.task = nil

	if stewercmp.ondonecooking then
		stewercmp.ondonecooking(inst)
	end
	--[[
	if stewercmp.product ~= nil then
		local cooker = stewercmp.productcooker or (stewercmp.cookername or stewercmp.inst.prefab)
		local prep_perishtime = (cooking.recipes and cooking.recipes[cooker] and cooking.recipes[cooker][stewercmp.product] and cooking.recipes[cooker][stewercmp.product].perishtime) and cooking.recipes[cooker][stewercmp.product].perishtime or TUNING.PERISH_SUPERFAST
		local prod_spoil = stewercmp.product_spoilage or 1
		stewercmp.spoiltime = prep_perishtime * prod_spoil
		stewercmp.spoiltargettime =  GetTime() + stewercmp.spoiltime
		stewercmp.spoiltask = stewercmp.inst:DoTaskInTime(stewercmp.spoiltime, function(inst)
			if inst.components.melter and inst.components.melter.onspoil then
				inst.components.melter.onspoil(inst)
			end
		end)
	end
	]]
	stewercmp.done = true
	inst:AddTag("alloydone")
	stewercmp.cooking = nil
end

function Melter:SetCookerName(_name)
	self.cookername = _name
end

function Melter:GetTimeToCook()
	if self.cooking then
		return self.targettime - GetTime()
	end
	return 0
end

function Melter:CanCook()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function Melter:StartCooking()
	if not self.done and not self.cooking then
		local container = self.inst.components.container
		if container then
			-- local _refuzetomelt = false
			-- for k, v in ipairs(container:GetAllItems()) do
			-- 	if not melting.isAttribute(v.prefab) then
			-- 		container:DropItemBySlot(k)
			-- 		_refuzetomelt = true
			-- 	end
			-- end
			-- if _refuzetomelt then
			-- 	return false
			-- end

			self.done = nil
			self.cooking = true

			if self.onstartcooking then
				self.onstartcooking(self.inst)
			end

			local spoilage_total = 0
			local spoilage_n = 0
			local ings = {}

			self.product = "ash"

			if self.inst.replica.container then
				local item1 = self.inst.replica.container:GetItemInSlot(1) and
					self.inst.replica.container:GetItemInSlot(1).prefab
				local item2 = self.inst.replica.container:GetItemInSlot(2) and
					self.inst.replica.container:GetItemInSlot(2).prefab
				local item3 = self.inst.replica.container:GetItemInSlot(3) and
					self.inst.replica.container:GetItemInSlot(3).prefab
				local item4 = self.inst.replica.container:GetItemInSlot(4) and
					self.inst.replica.container:GetItemInSlot(4).prefab

				local items = tabel.count_components({ item1, item2, item3, item4 })

				local function getcount(item)
					return items[item] and items[item] or 0
				end

				-- if getcount("iron") >= 4 then
				--     self.product = "alloy"
				-- elseif getcount("flint") >= 4 then
				--     self.product = "nitre"
				-- elseif (getcount("nitre") + getcount("obsidian")) >= 4 then
				--     self.product = "gunpowder"
				-- elseif (getcount("greengem") >= 2) and getcount("redgem") + getcount("bluegem") then
				--     self.product = "opalpreciousgem"
				-- elseif getcount("goldnugget") * 5 + getcount("dubloon") * 2 + getcount("gold_dust") >= 10 then
				--     self.product = "goldenbar"
				-- elseif getcount("gold_dust") >= 4 then
				--     self.product = "goldnugget"
				-- elseif getcount("stome") >= 4 then
				--     self.product = "stonebar"
				-- end

				self.product = melting.getMeltProd(items) or self.product
			end

			local cooktime = 0.2
			self.productcooker = self.inst.prefab

			local grow_time = BASE_COOK_TIME * cooktime
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
	end
end

function Melter:OnSave()
	local time = GetTime()
	if self.cooking then
		local data = {}
		data.cooking = true
		data.product = self.product
		data.productcooker = self.productcooker
		data.product_spoilage = self.product_spoilage
		if self.targettime and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
	elseif self.done then
		local data = {}
		data.product = self.product
		data.productcooker = self.productcooker
		data.product_spoilage = self.product_spoilage
		if self.spoiltargettime and self.spoiltargettime > time then
			data.spoiltime = self.spoiltargettime - time
		end
		data.timesincefinish = -(GetTime() - (self.targettime or 0))
		data.done = true
		return data
	end
end

function Melter:OnLoad(data)
	--self.produce = data.produce
	if data.cooking then
		self.product = data.product
		self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
		if self.oncontinuecooking then
			local time = data.time or 1
			self.product_spoilage = data.product_spoilage or 1
			self.oncontinuecooking(self.inst)
			self.cooking = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dostew, "stew")

			if self.inst.components.container then
				self.inst.components.container.canbeopened = false
			end
		end
	elseif data.done then
		self.product_spoilage = data.product_spoilage or 1
		self.done = true
		self.inst:AddTag("alloydone")
		self.targettime = data.timesincefinish
		self.product = data.product
		self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
		if self.oncontinuedone then
			self.oncontinuedone(self.inst)
		end
		self.spoiltargettime = data.spoiltime and GetTime() + data.spoiltime or nil
		if self.spoiltargettime then
			self.spoiltask = self.inst:DoTaskInTime(data.spoiltime, function(inst)
				if inst.components.melter and inst.components.melter.onspoil then
					inst.components.melter.onspoil(inst)
				end
			end)
		end
		if self.inst.components.container then
			self.inst.components.container.canbeopened = false
		end
	end
end

function Melter:GetDebugString()
	local str = nil

	if self.cooking then
		str = "COOKING"
	elseif self.done then
		str = "FULL"
	else
		str = "EMPTY"
	end
	if self.targettime then
		str = str .. " (" .. tostring(self.targettime - GetTime()) .. ")"
	end

	if self.product then
		str = str .. " " .. self.product
	end

	if self.product_spoilage then
		str = str .. "(" .. self.product_spoilage .. ")"
	end

	return str
end

function Melter:CollectSceneActions(doer, actions, right)
	if not self.inst:HasTag("burnt") then
		if self.done then
			table.insert(actions, ACTIONS.HARVEST)
		elseif right and self:CanCook() then
			table.insert(actions, ACTIONS.COOK)
		end
	end
end

function Melter:IsDone()
	return self.done
end

function Melter:StopCooking(reason)
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	if self.spoiltask then
		self.spoiltask:Cancel()
		self.spoiltask = nil
	end
	if self.product and reason and reason == "fire" then
		local prod = SpawnPrefab(self.product)
		if prod then
			prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			prod:DoTaskInTime(0, function(prod) prod.Physics:Stop() end)
		end
	end
	self.product = nil
	self.targettime = nil
end

function Melter:Harvest(harvester)
	print("HERE?")
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot = nil
				loot = SpawnPrefab(self.product)
				--[[
				if self.product ~= "spoiledfood" then
					loot = SpawnPrefab(self.product)
					if loot and loot.components.perishable then
						loot.components.perishable:SetPercent( self.product_spoilage)
						loot.components.perishable:LongUpdate(GetTime() - self.targettime)
						loot.components.perishable:StartPerishing()
					end
				else
					loot = SpawnPrefab("spoiled_food")
				end
				]]
				if loot then
					--[[
                    loot.targetMoisture = 0
					loot:DoTaskInTime(2*FRAMES, function()
						if loot.components.moisturelistener then
							loot.components.moisturelistener.moisture = loot.targetMoisture
							loot.targetMoisture = nil
							loot.components.moisturelistener:DoUpdate()
						end
					end)
					]]
					harvester.components.inventory:GiveItem(loot, nil,
						Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
					self.inst:RemoveTag("alloydone")
				end
			end
			self.product = nil
			self.spoiltargettime = nil

			if self.spoiltask then
				self.spoiltask:Cancel()
				self.spoiltask = nil
			end
		end

		if self.inst.components.container and not self.inst:HasTag("flooded") then
			self.inst.components.container.canbeopened = true
		end

		return true
	end
end

function Melter:LongUpdate(dt)
	if not self.paused and self.targettime ~= nil then
		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end

		self.targettime = self.targettime - dt

		if self.cooking then
			local time_to_wait = self.targettime - GetTime()
			if time_to_wait < 0 then
				dostew(self.inst)
			else
				self.task = self.inst:DoTaskInTime(time_to_wait, dostew, "stew")
			end
		end
	end

	if self.spoiltask ~= nil then
		self.spoiltask:Cancel()
		self.spoiltask = nil
		self.spoiltargettime = self.spoiltargettime - dt
		local time_to_wait = self.spoiltargettime - GetTime()
		if time_to_wait <= 0 then
			dospoil(self.inst)
		else
			self.spoiltask = self.inst:DoTaskInTime(time_to_wait, dospoil)
		end
	end
end

return Melter
