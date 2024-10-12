local function tile_physics_init(inst)
    inst.Map:AddTileCollisionSet(
        COLLISION.LAND_OCEAN_LIMITS,
        TileGroups.LandTiles, false,
        TileGroups.LandTiles, true,
        0.25, 64
    )

    inst.Map:AddTileCollisionSet(
        COLLISION.LAND_OCEAN_LIMITS,
        TileGroups.TAOceanTiles, false,
        TileGroups.TAOceanTiles, true,
        2, 64
    )

    inst.Map:AddTileCollisionSet(
        COLLISION.GROUND,
        TileGroups.ImpassableTiles, true,
        TileGroups.ImpassableTiles, false,
        0.25, 128
    )
end


local function CreateTilePhysics(inst)
    if inst.tile_physics_init ~= nil then
        inst:tile_physics_init()
    else
        inst.Map:AddTileCollisionSet(
            COLLISION.LAND_OCEAN_LIMITS,
            TileGroups.LandTiles, false,
            TileGroups.LandTiles, true,
            0.25, 64
        )

        inst.Map:AddTileCollisionSet(
            COLLISION.LAND_OCEAN_LIMITS,
            TileGroups.TAOceanTiles, false,
            TileGroups.TAOceanTiles, true,
            2, 64
        )

        inst.Map:AddTileCollisionSet(
            inst:CanFlyingCrossBarriers() and COLLISION.GROUND or COLLISION.LAND_OCEAN_LIMITS,
            TileGroups.ImpassableTiles, true,
            TileGroups.ImpassableTiles, false,
            0.25, 128
        )
    end
end


AddPrefabPostInit("world", function(inst)
    inst.tile_physics_init = tile_physics_init
    inst.CreateTilePhysics = CreateTilePhysics
end)
