local Utils = require("tools/utils")

local VOLCANO_PLANT_TILES = table.invert{
    WORLD_TILES.MAGMAFIELD,
    WORLD_TILES.ASH,
    WORLD_TILES.VOLCANO,
}

local JUNGLE_PLANT_TILES = table.invert{
    WORLD_TILES.JUNGLE,
}

function Map:CanVolcanoPlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return VOLCANO_PLANT_TILES[tile]
end

function Map:CanJunglePlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return JUNGLE_PLANT_TILES[tile]
end

Utils.FnDecorator(Map, "CanDeployPlantAtPoint", function(self, pt, inst, ...)
    if inst.prefab == "dug_elephantcactus" or inst.prefab == "dug_coffeebush" then
        return { self:CanVolcanoPlantAtPoint(pt:Get()) and self:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT]) }, true
    elseif inst.prefab == "dug_bush_vine" or inst.prefab == "dug_bambootree" then
        return { self:CanJunglePlantAtPoint(pt:Get()) and self:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT]) }, true
    end
end)