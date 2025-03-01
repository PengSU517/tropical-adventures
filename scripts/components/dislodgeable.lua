local activelisteners = 0

local Dislodgeable = Class(function(self, inst)
    self.inst = inst
    self.canbedislodged = nil
    self.hasbeendislodged = nil
    self.product = nil
    self.ondislodgedfn = nil
    self.caninteractwith = true
    self.numtoharvest = 1
end)
--[[
function Dislodgeable:GetDebugString()
	local time = GetTime()

	local str = ""

	str = str
	return str
end
]]
function Dislodgeable:SetUp(product, number)
    self.canbedislodged = true
    self.hasbeendislodged = false
    self.product = product
    self.numtoharvest = number
end

function Dislodgeable:SetOnDislodgedFn(fn)
    self.ondislodgedfn = fn
end

function Dislodgeable:OnSave()
    local data = {
        hasbeendislodged = self.hasbeendislodged,
        caninteractwith = self.caninteractwith,
    }

    if next(data) then
        return data
    end
end

function Dislodgeable:OnLoad(data)
    if data.caninteractwith then
        self.caninteractwith = data.caninteractwith
    end
    if data.hasbeendislodged then
        self.hasbeendislodged = data.hasbeendislodged
    end
end

function Dislodgeable:CanBeDislodged()
    if self.canbedislodgedfn then
        if not self.canbedislodgedfn(self.inst) then
            return false
        end
    end

    return self.canbedislodged
end

function Dislodgeable:SetCanBeDislodgedFn(fn)
    self.canbedislodgedfn = fn
end

function Dislodgeable:SetDropFromSymbol(symbolname)
    self.dropsymbol = symbolname
end

function Dislodgeable:SetDislodged()
    self.canbedislodged = false
    self.hasbeendislodged = true
end

function Dislodgeable:Dislodge(dislodger)
    if self.canbedislodged and self.caninteractwith then
        local pt = Vector3(self.inst.Transform:GetWorldPosition())
        for i = 1, self.numtoharvest do
            local loot = SpawnPrefab(self.product)
            loot.Transform:SetPosition(pt.x, pt.y, pt.z)
            if loot.Physics then
                local angle = math.random() * 2 * PI
                local speed = 1
                speed = speed * math.random()
                loot.Physics:SetVel(speed * math.cos(angle), GetRandomWithVariance(8, 4), speed * math.sin(angle))
                if loot and loot.Physics and self.inst and self.inst.Physics then
                    local dir = Vector3(math.cos(angle), 0, math.sin(angle))
                    pt = pt + dir * ((loot.Physics:GetRadius() or 1) + (self.inst.Physics:GetRadius() or 1))
                    loot.Transform:SetPosition(pt.x, pt.y, pt.z)
                end
            end



            if loot then
                if self.ondislodgedfn then
                    self.ondislodgedfn(self.inst, dislodger, loot)
                end

                self:SetDislodged()

                self.inst:PushEvent("dislodged", { dislodger = dislodger, loot = loot })
            end
        end
    end
end

function Dislodgeable:CollectSceneActions(doer, actions)
    if self.canbedislodged and self.caninteractwith and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("dislodger") then
        table.insert(actions, ACTIONS.DISLODGE)
    end
end

return Dislodgeable
