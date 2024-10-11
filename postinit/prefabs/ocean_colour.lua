-- 改变海洋颜色 纯客户端内容
local dp_id = {}
local ocean_tile = {} --修改对应海洋地皮的颜色
ocean_tile[GROUND.OCEAN_COASTAL_SHORE] = {1,0,0}
ocean_tile[GROUND.OCEAN_COASTAL] = {0,1,0}
ocean_tile[GROUND.OCEAN_SWELL] = {0,0,1}
ocean_tile[GROUND.OCEAN_ROUGH] = {1,1,0}
ocean_tile[GROUND.OCEAN_BRINEPOOL] = {1,0,1}
ocean_tile[GROUND.OCEAN_BRINEPOOL_SHORE] = {1,1,1}
ocean_tile[GROUND.OCEAN_HAZARDOUS] = {0,0,0}
ocean_tile[GROUND.OCEAN_WATERLOG] = {0.5,0.5,0.5}

local GroundTiles = require("worldtiledefs")
local old_Initialize = GroundTiles.Initialize
GroundTiles.Initialize = function()
    old_Initialize()
    if MapLayerManager then
        local idx = getmetatable(MapLayerManager).__index
        local old_CreateRenderLayer = idx.CreateRenderLayer
        idx.CreateRenderLayer = function(self, id, ...)
            local handle = old_CreateRenderLayer(self, id, ...)
            if TileGroupManager:IsOceanTile(id) then
                -- print("地皮", handle, type(id), id, ...)
                dp_id[handle] = id --记录海洋地皮对应的映射值
            end
            return handle
        end

        local old_SetSecondaryColorDusk = idx.SetSecondaryColorDusk --改变次要黄昏时刻的地皮颜色
        idx.SetSecondaryColorDusk = function(self, handle, ...)
            local color = dp_id[handle] and ocean_tile[dp_id[handle]] or nil
            if color then
                old_SetSecondaryColorDusk(self, handle, color[1], color[2], color[3], color[4] or 1)
            else
                old_SetSecondaryColorDusk(self, handle, ...)
            end
        end
    end
end

AddPrefabPostInit("world",function(inst)
    local idx = inst.Map and getmetatable(TheWorld.Map).__index
    if idx then
        local odl_SetOceanTextureBlendAmount = idx.SetOceanTextureBlendAmount
        idx.SetOceanTextureBlendAmount = function(self, num) --海洋地皮次要到黄昏次要
            -- print("改变值",num) --黄昏时刻 0~1 num随dt变化
            odl_SetOceanTextureBlendAmount(self, not TheWorld.ocean_colour_kg and 0 or num)
        end
    end
end)