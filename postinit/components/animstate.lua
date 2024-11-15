---@author: Runar 2024-11-13 16:36:57
-- AnimState 增强
-- 滤镜与色彩空间封装
local AnimState = AnimState or GLOBAL.AnimState

if not AnimState then return end

local fillters = {
    generic = function(animstate)
        animstate:SetAddColour(0, 0, 0, 0)
        animstate:SetMultColour(1, 1, 1, 1)
        animstate:SetHSV()
    end,
    withered = function(animstate)
        animstate:SetHSV(.3, .4, .5)
    end,
    shadowed = function(animstate)
        animstate:SetMultColour(0, 0, 0, .6)
    end,
}

---AnimState:SetHSV
---@param hue number @Hue(0~1)
---@param saturation number @Saturation(0~1)
---@param lightness number @Value(0~1)
function AnimState:SetHSV(hue, saturation, lightness)
    self:SetHue(hue or 0)
    self:SetSaturation(saturation or 1)
    self:SetBrightness(lightness or 1)
end
---AnimState:SetHSB
---@param hue number @Hue(0~1)
---@param saturation number @Saturation(0~1)
---@param lightness number @Brightness(0~1)
function AnimState:SetHSB(...) return self:SetHSV(...) end
---AnimState:SetHSL
---@param hue number @Hue(0~1)
---@param saturation number @Saturation(0~1)
---@param lightness number @Lightness(0~1)
function AnimState:SetHSL(hue, saturation, lightness) self:SetHSV(hue, saturation, lightness * 2) end

---AnimState:GetHSV
---@return number|nil,number|nil,number|nil @Hue(0~1),Saturation(0~1),Value(0~1)
function AnimState:GetHSV()
    return AnimState:GetHue(), self:GetSaturation(), self:GetBrightness()
end
---AnimState:GetHSB
---@return number|nil,number|nil,number|nil @Hue(0~1),Saturation(0~1),Brightness(0~1)
function AnimState:GetHSB() return self:GetHSV() end
---AnimState:GetHSL
---@return number|nil,number|nil,number|nil @Hue(0~1),Saturation(0~1),Lightness(0~1)
function AnimState:GetHSL()
    local h, s, l = self:GetHSV()
    return h, s, l / 2
end

---AnimState:SetFillter
---@param fillter string|nil @fillter name
function AnimState:SetFillter(fillter)
    assert(fillter == nil or type(fillter) == "string", string.format("AnimState Extension: fillter '%s' is not a string!\n", fillter))
    if fillters[fillter] then fillters[fillter](self) end
end

---AnimState:FillterList
---@return string[] @fillter names
function AnimState:FillterList()
    local list = {}
    for fillter in pairs(fillters) do
        table.insert(list, fillter)
    end
    return list
end

function AnimState:DoJoggle(inst)
    inst._jTask = inst:StartThread(function()
        for frame = 0, 3 do
            self:SetScale(1 - .1 * math.sin(PI / 2 * frame + PI / 8),
                          1 + .1 * math.sin(PI / 2 * frame + PI / 8))
            Sleep(FRAMES or GLOBAL.FRAMES)
        end
        self:SetScale(1, 1)
    end)
end

return {
    fillters = fillters,
}