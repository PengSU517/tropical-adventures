local WORLD_TILES = WORLD_TILES

GLOBAL.setfenv(1, GLOBAL)

local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil

if not is_worldgen then
    TileGroups.TAOceanTiles = TileGroupManager:AddTileGroup()
end

local _color = (TUNING.ocean_style == "tropical")
local _blue = (TUNING.ocean_style == "blue")


---------------------------------------------------修改这个调整世界背景颜色
if _blue then
    TUNING.OCEAN_SHADER.OCEAN_FLOOR_COLOR      = { 0, 100, 100, 255 }
    TUNING.OCEAN_SHADER.OCEAN_FLOOR_COLOR_DUSK = { 0, 60, 60, 155 }
end


local GroundTiles = require("worldtiledefs")

local tile_tbl = {
    OCEAN_COASTAL_SHORE = "OCEAN_SHALLOW_SHORE",
    OCEAN_COASTAL = "OCEAN_SHALLOW",
    OCEAN_SWELL = "OCEAN_MEDIUM",
    OCEAN_ROUGH = "OCEAN_DEEP",
    OCEAN_WATERLOG = "MANGROVE",
    OCEAN_BRINEPOOL = "OCEAN_CORAL",
    OCEAN_BRINEPOOL_SHORE = "OCEAN_CORAL",
    OCEAN_HAZARDOUS = "OCEAN_SHIPGRAVEYARD",

    OCEAN_CORAL = "OCEAN_CORAL",
    LILYPOND = "LILYPOND",
    MANGROVE = "MANGROVE",
}



local function tile_redirect(tbl)
    -----大地图
    for k, v in pairs(GroundTiles.ground) do
        if IsOceanTile(v[1]) then
            if _color then
                v[2] = tro_tiledefs["OCEAN_SHALLOW"].ground_tile_def
                for origin, override in pairs(tbl) do
                    if v[1] == WORLD_TILES[origin] then
                        v[2] = tro_tiledefs[override].ground_tile_def
                        break
                    end
                end

                if not is_worldgen then
                    TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, v[1])
                    TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, v[1])
                end
            elseif _blue then
                for k, v in pairs(GroundTiles.ground) do
                    for origin, override in pairs(tbl) do
                        if v[1] == WORLD_TILES[origin] then
                            v[2].colors = tro_tiledefs[override].ground_tile_def.colors
                            break
                        end
                    end
                end
            end
        end
    end

    ----小地图
    for k, v in pairs(GroundTiles.minimap) do
        if IsOceanTile(v[1]) and not IsTroWaterTile(v[1]) then
            v[2] = tro_tiledefs["OCEAN_CORAL"].minimap_tile_def
            for origin, override in pairs(tbl) do
                if v[1] == WORLD_TILES[origin] then
                    v[2] = tro_tiledefs[override].minimap_tile_def
                    break
                end
            end
        end
    end
end

if TUNING.ocean_style ~= "default" and (not TheNet:IsDedicated()) then
    tile_redirect(tile_tbl)
end
