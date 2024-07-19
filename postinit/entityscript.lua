local _SetOceanBlendParams = AnimState.SetOceanBlendParams
function AnimState:SetOceanBlendParams(...)
    if TUNING.tropical.ocean == "tropical" then return end
    return _SetOceanBlendParams(self, ...)
end

local _SetLayer = AnimState.SetLayer
function AnimState:SetLayer(layer, ...)
    if true and layer <= LAYER_BELOW_GROUND then
        layer = LAYER_BACKGROUND -- TODO: if sorting issues occur use ground and increase the sort
    end
    return _SetLayer(self, layer, ...)
end
