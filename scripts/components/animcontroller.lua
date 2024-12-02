local anim_def = require("anim_ctrl_def")

local AnimController = Class(function(self, inst)
    self.inst = inst
    self.anim = inst.AnimState

    self.filter = nil

    self.isplayinganim = nil
    self.animname = nil
    self.animfn = nil -- function(animstate, time)
    self.timetotal = nil -- totalframes * FRAMES
    self.animcallback = nil -- function(animstate)
    self.loop = nil
    self.timepassed = nil

end)

--[[
function AnimController:SetHSV(hue, saturation, value)
    if self.anim then
        self.anim:SetHue(hue or 0)
        self.anim:SetSaturation(saturation or 1)
        self.anim:SetBrightness(value or 1)
    end
end

function AnimController:GetHSV()
    if self.anim then return self.anim:GetHue(), self.anim:GetSaturation(), self.anim:GetBrightness() end
end
]]

function AnimController:SetFilter(filter, ...)
    self.filter = filter
    anim_def.GetFilter(filter)(self.anim, ...)
end

function AnimController:PushAnimation(animname, loop)
    self.animname = animname
    self.loop = loop
    self.animfn, self.timetotal, self.animcallback = anim_def.GetAnim(animname)
    self.timepassed = 0
    if not self.isplayinganim then self.inst:StartUpdatingComponent(self) end
    self.isplayinganim = true
end

function AnimController:PlayAnimation(animname, loop)
    if self.isplayinganim then return end
    self:PushAnimation(animname, loop)
end

function AnimController:StopAnimation()
    if not self.isplayinganim then return end
    if self.animcallback then self.animcallback(self.anim) end
    self.animname = nil
    self.loop = nil
    self.animfn, self.timetotal, self.animcallback = nil, nil, nil
    self.timepassed = nil
    self.inst:StopUpdatingComponent(self)
    self.isplayinganim = nil
end

function AnimController:OnUpdate(dt)
    self.timepassed = self.timepassed + dt
    if self.animfn ~= nil then self.animfn(self.anim, self.timepassed) end
    if self.timepassed < self.timetotal then return end
    if self.loop then
        self.timepassed = 0
    else
        self:StopAnimation()
    end
end

--[[
function AnimController:OnSave(data)
    return {}
end

function AnimController:OnLoad(data)
    if data then end
end
]]

return AnimController
