local TRADER = require("datadefs/pig_trade_defs").TRADER
local PRICE = require("datadefs/pig_trade_defs").PRICE

local Economy = Class(function(self, inst)
	self.inst = inst
	self.cities = {}

	self.inst:WatchWorldState("isday", function() self:processdelays() end)
	for i = 1, NUM_TRINKETS do
		table.insert(TRADER.pigman_collector.items, "trinket_" .. i)
	end
end)


function Economy:OnSave()
	local refs = {}
	local data = {}
	data.cities = self.cities

	for city, data in pairs(self.cities) do
		for item, itemdata in pairs(data) do
			for guid, guiddata in pairs(itemdata.GUIDS) do
				table.insert(refs, guid)
			end
		end
	end

	return data, refs
end

function Economy:OnLoad(data)
	if data and data.cities then
		self.cities = data.cities
	end
end

function Economy:LoadPostPass(ents, data)
	for city, data in pairs(self.cities) do
		for item, itemdata in pairs(data) do
			local newguids = {}
			for guid, guiddata in pairs(itemdata.GUIDS) do
				local child = ents[guid]
				if child then
					newguids[child.entity.GUID] = guiddata
				end
			end
			itemdata.GUIDS = newguids
		end
	end
end

function Economy:GetTradeItems(traderprefab)
	if TRADER[traderprefab] then
		return TRADER[traderprefab].items
	end
end

function Economy:GetTradeItemDesc(traderprefab)
	if not TRADER[traderprefab] then
		return nil
	end
	return TRADER[traderprefab].desc
end

function Economy:GetDelay(traderprefab, city, inst)
	return TRADER[traderprefab] and TRADER[traderprefab].delay or 0
end

function Economy:MakeTrade(traderprefab, city, inst, itemname)
	if TRADER[traderprefab] then
		return TRADER[traderprefab].reward, (itemname and PRICE[itemname] or TRADER[traderprefab].rewardqty)
	else
		return "oinc", 1
	end
end

function Economy:processdelays()
	--	print("resetting delays")

	for c, city in ipairs(self.cities) do
		for i, trader in pairs(city) do
			for guid, data in pairs(trader.GUIDS) do
				if data > 0 then
					data = data - 1
					trader.GUIDS[guid] = data
				end
			end
		end
	end
end

function Economy:AddCity(city)
	self.cities[city] = deepcopy(TRADER)

	for i, item in pairs(self.cities[city]) do
		item.GUIDS = {}
	end
end

return Economy
