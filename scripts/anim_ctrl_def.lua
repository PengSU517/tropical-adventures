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

local animations = {
    shake = {function(animstate, time)
        local bias = .1 * math.sin(PI / 2 * time / FRAMES + PI / 8)
        animstate:SetScale(1 - bias, 1 + bias)
    end, 3 * FRAMES, function(animstate) animstate:SetScale(1, 1) end},
}

local function GetFilter(name) return filters[name] end

local function GetAnim(name)
    local anim = animations[name]
    if anim then return anim[1], anim[2], anim[3] end
end

return {
    GetFilter = GetFilter,
    GetAnim = GetAnim,
}
