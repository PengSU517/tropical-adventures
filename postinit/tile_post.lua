-- 添加猪镇和暴食地皮挖起的特殊掉落
local SpeciaTileDrop =
{
    [WORLD_TILES.PIGRUINS] = "cutstone",
    [WORLD_TILES.PIGRUINS_BLUE] = "cutstone",
	--[[[WORLD_TILES.HAMARCHIVE] = "cutstone",

	[WORLD_TILES.QUAGMIRE_GATEWAY] = "turf_quagmire_gateway",
	[WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_quagmire_citystone",
	[WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_quagmire_parkfield",
	[WORLD_TILES.QUAGMIRE_PARKSTONE] = "turf_quagmire_parkstone",
	[WORLD_TILES.QUAGMIRE_PEATFOREST] = "turf_quagmire_peatforest",]]

}
local old_HandleDugGround = HandleDugGround
function HandleDugGround(dug_ground, x, y, z, ...)
    if SpeciaTileDrop[dug_ground] then
        local loot = SpawnPrefab(SpeciaTileDrop[dug_ground])
        if loot.components.inventoryitem ~= nil then
            loot.components.inventoryitem:InheritWorldWetnessAtXZ(x, z)
        end
        loot.Transform:SetPosition(x, y, z)
        if loot.Physics ~= nil then
            local angle = math.random() * TWOPI
            loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
        end
    else
        return old_HandleDugGround(dug_ground, x, y, z, ...)
    end
end

-- 添加深层雨林地皮和毒瘴雨林地皮挖起的特殊效果
local old_terraform = ACTIONS.TERRAFORM.fn
ACTIONS.TERRAFORM.fn = function(act)
	if act.invobject and act.invobject.components.terraformer then
        local tile = TheWorld.Map:GetTileAtPoint(act:GetActionPoint():Get())
		if tile == GROUND.GASJUNGLE then
            if act.doer.components.talker then
			    act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TOOLCORRODED"))
            end
            local finiteuses = act.invobject.components.finiteuses
            if finiteuses then
			    finiteuses:Use(finiteuses:GetUses())
            end
			return
		elseif tile == GROUND.DEEPRAINFOREST then
            if act.doer.components.talker then
			    act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TURFTOOHARD"))
            end
			return
		end
	end
	return old_terraform(act)
end