local Widget = require "widgets/widget"

local LivingArtifactOver = Class(Widget, function(self, owner)
	self.owner = owner
	Widget._ctor(self, "LivingArtifactOver")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/overlays/living_artifact.xml", "living_artifact.tex"))
	self.img:SetHAnchor(ANCHOR_MIDDLE)
	self.img:SetVAnchor(ANCHOR_MIDDLE)
	self.img:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.img:SetVRegPoint(ANCHOR_MIDDLE)
	self.img:SetHRegPoint(ANCHOR_MIDDLE)

	self.currentalpha = 0
	self.alphabaseline = 0
	self.time = 2
	self.dist = 0
	self.nextflash = 1
	self.maxfuel = TUNING.IRON_LORD_TIME
	self.currentfuel = self.maxfuel

	self:Hide()
end)

function LivingArtifactOver:TurnOn()
	self.time = 1
	self.alphabaseline = 0.3
	self.dist = 0.3
	self.nextflash = 1
	self:Show()
	self:StartUpdating()
end

function LivingArtifactOver:TurnOff()
	self.time = 0.3
	self.alphabaseline = 0
	self.dist = 0.3
	self:StopUpdating()
     self:Hide()
end

function LivingArtifactOver:Flash()
	local time = 0
	local nextflash = 0
	local intensity = 0
	local per = self.currentfuel / self.maxfuel

	if per > 0.4 then
          time = 1
          nextflash = 2
          intensity = 0
     elseif per > 0.2 then
          time = 0.5
          nextflash = 1    
          intensity = 0.25
     elseif per > 0.05 then
          time = 0.3
          nextflash = 0.6
          intensity = 0.5
     else
          time = 0.13
          nextflash = 0.26    
          intensity = 0.8
     end

	self.time = time
	self.nextflash = nextflash
	self.alphaspike = 0.5
	self.dist = math.abs(self.currentalpha - self.alphaspike)
	ThePlayer.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/pulse", {intensity=intensity})
end

function LivingArtifactOver:OnUpdate(dt)
	if TheNet:IsServerPaused() then return end

	self.currentfuel = ThePlayer.player_classified.artifactfuel:value()

	if self.nextflash > 0 then
		self.nextflash = math.max(0, self.nextflash - dt)
	else
		self:Flash()
	end

	local dir = 0
	local target = self.alphabaseline

	if self.alphaspike then
		target = self.alphaspike
	end
	if self.currentalpha ~= target then
		dir = target - self.currentalpha
	end
	if dir > 0 then
		self.currentalpha = math.min(self.currentalpha + (self.dist/(30*self.time)),target)
	else
		self.currentalpha = math.max(self.currentalpha - (self.dist/(30*self.time)),target)
	end
	if self.alphaspike and self.currentalpha == self.alphaspike then
		self.alphaspike = nil
	end

	local r, g, b = 1, 1, 1
	g = Remap(self.currentfuel, self.maxfuel, 0, 1, 0.1)
	b = Remap(self.currentfuel, self.maxfuel, 0, 1, 0)

	self.img:SetTint(r, g, b, self.currentalpha)
	
	if self.currentalpha <= 0 then
		self:Hide()
	else
		self:Show()
	end
end

return LivingArtifactOver