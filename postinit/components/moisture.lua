local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local easing = require("easing")

----------------------------------------------------------------------------------------
local Moisture = require("components/moisture")

local _GetMoistureRate = Moisture.GetMoistureRate
function Moisture:GetMoistureRate(...)
	local waterproofmult_basic =
		(self.inst.components.inventory ~= nil and
			self.inst.components.inventory:GetWaterproofness() or 0
		) +
		(self.inherentWaterproofness or 0)

	if waterproofmult_basic < 1 and TheWorld.components.flooding and TheWorld.components.flooding:OnFlood(self.inst.Transform:GetWorldPosition()) then
		return 1 - (waterproofmult_basic or 0)
		-- return 1 - (self.inherentWaterproofness or 0)
	end

	local boat = self.inst.components.sailor and self.inst.components.sailor:GetBoat() or nil
	if boat and boat.components.boathealth and boat.components.boathealth:IsLeaking() then
		return 1 - waterproofmult_basic
	end

	if IsInTropicalClimate(self.inst) then
		if TheWorld.state.islandisraining then
			--Klei should've made that a separate function at this point...
			local waterproofmult =
				(self.inst.components.sheltered ~= nil and
					self.inst.components.sheltered.sheltered and
					self.inst.components.sheltered.waterproofness or 0
				) +
				waterproofmult_basic
			if waterproofmult >= 1 then
				return 0
			end

			local rate = easing.inSine(TheWorld.state.islandprecipitationrate, self.minMoistureRate, self
				.maxMoistureRate, 1)
			return rate * (1 - waterproofmult)
		end
		return 0
	else
		return _GetMoistureRate(self, ...)
	end
end

local _GetDryingRate = Moisture.GetDryingRate
function Moisture:GetDryingRate(moisturerate, ...)
	local rate = 0

	if TheWorld.components.flooding and TheWorld.components.flooding:OnFlood(self.inst:GetPosition():Get()) then
		return rate
	end

	--need to entirely recalculate to exclude mainland rain from this
	if IsInTropicalClimate(self.inst) then
		-- Don't dry if it's raining
		if (moisturerate or self:GetMoistureRate()) <= 0 then
			local heaterPower = self.inst.components.temperature ~= nil and
				math.clamp(self.inst.components.temperature.externalheaterpower, 0, 1) or 0

			rate = self.baseDryingRate
				+ easing.linear(heaterPower, self.minPlayerTempDrying, self:GetSegs() < 3 and 2 or 5, 1)
				+
				easing.linear(TheWorld.state.islandtemperature, self.minDryingRate, self.maxDryingRate,
					self.optimalDryingTemp) --THIS is the ONE line we needed to change for temperature
				+ easing.inExpo(self:GetMoisture(), 0, 1, self.maxmoisture)

			rate = math.clamp(rate, 0, self.maxDryingRate + self.maxPlayerTempDrying)
		end
	else
		--on the mainland
		rate = _GetDryingRate(self, moisturerate, ...)
	end

	if self.inst.components.locomotor and self.inst.components.locomotor:GetExternalSpeedAdder(self.inst, "AUTODRY")
		and self.inst.components.locomotor:GetExternalSpeedAdder(self.inst, "AUTODRY") > 0 then
		rate = rate + TUNING.HYDRO_FOOD_BONUS_DRY_RATE
	end

	return rate
end
