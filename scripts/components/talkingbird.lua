

local TalkingBird = Class(function(self, inst)
	self.inst = inst
	self.time_to_convo = 10

    if not (inst.prefab == "birdcage") then
        self.inst:ListenForEvent("ondropped", function() self:OnDropped() end)
    end
	--self.inst:ListenForEvent("mountboat", function() self:OnMounted() end, GetPlayer())
    --self.inst:ListenForEvent("dismountboat", function() self:OnDismounted() end, GetPlayer())

	local dt = 5 + math.random()
	self.inst:DoPeriodicTask(dt, function() self:OnUpdate(dt) end)
	self.warnlevel = 0

end)

function TalkingBird:OnDropped()
	self:Say(STRINGS.TALKINGBIRD.on_dropped)
end

local function GetBirdinCage(inst)
    return ((inst.prefab == "birdcage") and inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function GetHunger(bird)
    return (bird and bird.components.perishable and bird.components.perishable:GetPercent()) or 1
end

function TalkingBird:OnRemoveFromEntity()
    if self.talktask then
        self.talktask:Cancel()
        self.talktask = nil
    end
    if self.inst.components.talker then
        self.inst.components.talker:ShutUp()
    end
end

--[[
function TalkingBird:OnMounted()
	local grand_owner = self.inst.components.inventoryitem:GetGrandOwner()
	local owner = self.inst.components.inventoryitem.owner
	if grand_owner == GetPlayer() or owner == GetPlayer() then
		self:Say(STRINGS.TALKINGBIRD.on_mounted)
	end
end

function TalkingBird:OnDismounted()
	local grand_owner = self.inst.components.inventoryitem:GetGrandOwner()
	local owner = self.inst.components.inventoryitem.owner
	if grand_owner == GetPlayer() or owner == GetPlayer() then
		self:Say(STRINGS.TALKINGBIRD.on_dismounted)
	end
end
]]
function TalkingBird:OnUpdate(dt)
	self.time_to_convo = self.time_to_convo - dt
	if self.time_to_convo <= 0 then
		self:MakeConversation()
	end
end

function TalkingBird:Say(list, sound_override)
	self.sound_override = sound_override
	self.inst.components.talker:Say(list[math.random(#list)])
	self.time_to_convo = math.random(60, 120)
end


function TalkingBird:MakeConversation()
    if self.inst.components.freezable and self.inst.components.freezable:IsFrozen() then
        return
    end

    local grand_owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner()
    local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner
    local birdincage = GetBirdinCage(self.inst)
    local birdincage_hunger = birdincage and GetHunger(birdincage)

	local quiplist = nil
    if (owner and owner:HasTag("player")) or (birdincage_hunger and birdincage_hunger >= 0.5) then
		if self.inst.components.equippable and self.inst.components.equippable:IsEquipped() then
			--currently equipped
		else
			--in player inventory or in cage
			quiplist = STRINGS.TALKINGBIRD.in_inventory
		end
	elseif birdincage ~= nil then
			--hungry in cage
			quiplist = STRINGS.TALKINGBIRD.on_pickedup
	elseif owner == nil then
		--on the ground
		-- quiplist = STRINGS.TALKINGBIRD.on_ground
	elseif grand_owner ~= owner and grand_owner == grand_owner:HasTag("player") then
		--in a backpack
		quiplist = STRINGS.TALKINGBIRD.in_container
	elseif owner and owner.components.container then
		--in a container
		quiplist = STRINGS.TALKINGBIRD.in_container
	else
		--owned by someone else
		quiplist = STRINGS.TALKINGBIRD.other_owner
	end

	if quiplist then
		self:Say(quiplist)
	end
end

return TalkingBird
