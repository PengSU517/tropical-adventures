---@author: Runar 2024-11-13 16:36:57
-- AnimState 增强 Ver 1.11.22
-- 滤镜与色彩空间封装
local AnimState = AnimState or GLOBAL.AnimState

if not AnimState then return end

local filters = {
    generic = function(animstate)
        animstate:SetAddColour(0, 0, 0, 0)
        animstate:SetMultColour(1, 1, 1, 1)
        animstate:SetHSV()
    end,
    withered = function(animstate) animstate:SetHSV(.3, .4, .5) end,
    shadowed = function(animstate) animstate:SetMultColour(0, 0, 0, .6) end,
    green = function(animstate)
        animstate:SetHSV(30 / 255 + math.random() * 0.05, .75 + math.random() * 0.05, .75 + math.random() * 0.05)
    end,

}

local filters_s = {}
setmetatable(filters, filters_s)

--[[ animations[animname] =
table{[1]FrameAction:function(self, frame),
      [2]TotalFrame:number,
      [3]Interval:nil|number|function(frame)}
]]
local animations = {
    shake = {function(animstate, frame)
        animstate:SetScale(1 - .1 * math.sin(PI / 2 * frame + PI / 8), 1 + .1 * math.sin(PI / 2 * frame + PI / 8))
    end, 3},
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
function AnimState:GetHSV() return AnimState:GetHue(), self:GetSaturation(), self:GetBrightness() end

---AnimState:GetHSB
---@return number|nil,number|nil,number|nil @Hue(0~1),Saturation(0~1),Brightness(0~1)
function AnimState:GetHSB() return self:GetHSV() end

---AnimState:GetHSL
---@return number|nil,number|nil,number|nil @Hue(0~1),Saturation(0~1),Lightness(0~1)
function AnimState:GetHSL()
    local h, s, l = self:GetHSV()
    return h, s, l / 2
end

---AnimState:SetFilter
---@param filter string|nil @filter name
function AnimState:SetFilter(filter, ...)
    assert(filter == nil or type(filter) == "string",
           string.format("AnimState Extension: filtername '%s' is not a string!\n", filter))
    if filters[filter] then filters[filter](self, ...) end
end

---AnimState:FilterList
---@return string[] @filter names
function AnimState:FilterList()
    local list = {}
    for filter in pairs(filters) do table.insert(list, filter) end
    return list
end

function AnimState:PlayExtendAnim(animname)
    assert(animname == nil or type(animname) == "string",
           string.format("AnimState Extension: animname '%s' is not a string!\n", animname))
    if not animname or not animations[animname] then return end
    local inst = CreateEntity()
    inst._animTask = inst:StartThread(function()
        for frame = 0, animations[animname][2] do
            animations[animname][1](self, frame)
            Sleep(FunctionOrValue(animations[animname][3], frame) or FRAMES or GLOBAL.FRAMES)
        end
        self:SetScale(1, 1)
        inst:Remove()
    end)
end

local function Addfilter(name, fn)
    assert(name and type(name) == "string",
           string.format("AnimState Extension: filter name '%s' is not a string!\n", name or "nil"))
    assert(fn and type(fn) == "function",
           string.format("AnimState Extension: filter '%s' is not a function!\n", fn or "nil"))
    assert(filters_s[name] == nil, string.format("AnimState Extension: filter '%s' existed!\n", name))
    filters_s[name] = function(animstate, ...) return pcall(fn, animstate, ...) end
end

local function AddExAnim(animname, animfn, totalframes, interval)
    
end

return {
    Addfilter = Addfilter,
    AddAnim = AddExAnim,
}
