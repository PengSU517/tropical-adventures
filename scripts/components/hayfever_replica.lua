local function OnSneezetimeDirty(inst)
	local sneezetime = inst.replica.hayfever._nextsneeze:value() or 999
	-- print("sneeze time is dirty")
	inst:PushEvent("updatehayfever", { sneezetime = sneezetime })
end

local Hayfever = Class(function(self, inst)
	self.inst = inst

	-- self._level = net_tinybyte(inst.GUID, "hayfever.level", "leveldirty")
	self._nextsneeze = net_float(inst.GUID, "hayfever.nextsneeze", "nextsneezedirty")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("nextsneezedirty", OnSneezetimeDirty)
	end
end)

-- function Hayfever:SetLevel(level)
-- 	self._level:set(level)
-- end

-- function Hayfever:GetLevel()
-- 	return self._level:value()
-- end

function Hayfever:Setnextsneeze(nextsneeze)
	self._nextsneeze:set(nextsneeze)
end

function Hayfever:Getnextsneeze()
	return self._nextsneeze:value()
end

function Hayfever:OnRemoveEntity()
	if not TheNet:IsDedicated() then
		self.inst:RemoveEventCallback("nextsneezedirty", OnSneezetimeDirty)
	end
end

return Hayfever
