local function OnDrop(prefab)
    return function(inst)
        local map = TheWorld.Map
        -- local x, y, z = inst.Transform:GetWorldPosition()
        local pt = inst:GetPosition()
        pt.y = 0
        local ground = map:GetTile(map:GetTileCoordsAtPoint(pt:Get()))

        if TileGroupManager:IsOceanTile(ground) then
            local boat = SpawnAt(prefab, pt)
            if boat then
                boat.components.finiteuses.current = inst.components.finiteuses.current
            end
            return inst:Remove()
        end

        if TileGroupManager:IsLandTile(ground) then
            inst.AnimState:PlayAnimation("idle", true)
        end
    end
end

return {
    corkboatitem = {
        prefab = "corkboat",
        bank = "corkboat",
        build = "corkboat",
        postfn = function(inst)
            inst:AddComponent("finiteuses")
            inst.components.finiteuses:SetMaxUses(80)
            inst.components.finiteuses:SetUses(80)
            inst.components.finiteuses:SetOnFinished(inst.Remove)
            inst.components.inventoryitem:SetOnDroppedFn(OnDrop("corkboat"))
        end,
        placer_bank = "rowboat",
        placer_build = "coracle_boat_build",
    },
    porto_armouredboat = {
        prefab = "armouredboat",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "seashell",
        placer_bank = "rowboat",
        placer_build = "rowboat_armored_build",
    },
    porto_cargoboat = {
        prefab = "cargoboat",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "cargo",
        placer_bank = "rowboat",
        placer_build = "rowboat_cargo_build",
    },
    porto_encrustedboat = {
        prefab = "encrustedboat",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "limestone",
        placer_bank = "rowboat",
        placer_build = "rowboat_encrusted_build",
    },
    porto_lograft_old = {
        prefab = "lograft_old",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "IDLE",
        placer_bank = "raft",
        placer_build = "raft_log_build",
    },
    porto_lograft = {
        prefab = "lograft",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "IDLE",
        placer_bank = "raft",
        placer_build = "raft_log_build",
    },
    porto_raft_old = {
        prefab = "raft_old",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "IDLE",
        placer_bank = "raft",
        placer_build = "raft_build",
    },
    porto_raft = {
        prefab = "raft",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "IDLE",
        placer_bank = "raft",
        placer_build = "raft_build",
    },
    porto_rowboat = {
        prefab = "rowboat",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "row",
        placer_bank = "rowboat",
        placer_build = "rowboat_build",
    },
    porto_woodlegsboat = {
        prefab = "woodlegsboat",
        bank = "seafarer_boatsw",
        build = "seafarer_boatsw",
        anim = "pirate",
        onplace = function(inst)
            inst.components.container:GiveItem(SpawnPrefab("woodlegssail"), 1)
            inst.components.container:GiveItem(SpawnPrefab("boatcannon"), 2)
        end,
        placer_bank = "rowboat",
        placer_build = "pirate_boat_build",
        placerpost = function(inst)
            inst.AnimState:OverrideSymbol("swap_sail", "swap_sail_pirate", "swap_sail")
            inst.AnimState:OverrideSymbol("swap_lantern", "swap_cannon", "swap_cannon")
        end,
    },
    surfboard_item = {
        prefab = "surfboard",
        bank = "surfboard",
        build = "surfboard",
        postfn = function(inst)
            inst:AddComponent("finiteuses")
            inst.components.finiteuses:SetMaxUses(100)
            inst.components.finiteuses:SetUses(100)
            inst.components.finiteuses:SetOnFinished(inst.Remove)
            inst.components.inventoryitem:SetOnDroppedFn(OnDrop("surfboard"))
        end,
        placer_bank = "raft",
        placer_build = "raft_surfboard_build",
    },
}
