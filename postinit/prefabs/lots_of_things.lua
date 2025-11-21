local AddPrefabPostInit = AddPrefabPostInit

for _, prefab in pairs({ "skeleton", "skeleton_player" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        local function ondropped(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                if (TheWorld.Map:IsOceanTileAtPoint(x, 0, z)) then
                    inst:DoTaskInTime(0.5, function(inst)
                        local bolha = SpawnPrefab("frogsplash")
                        if bolha then
                            bolha.Transform:SetPosition(x, y, z)
                        end
                        inst:Remove()
                    end)
                end
            end
        end
        inst:DoTaskInTime(0, ondropped)
    end)
end

for _, prefab in pairs({ "ash" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fertilizer")
    end)
end


for _, prefab in pairs({ "anchor" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("ancora")
    end)
end



for _, prefab in pairs({ "gogglesheathat", "bathat", "molehat" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("clearfog")
    end)
end

------------------------para a onda quebrar--------------

for _, prefab in pairs({ "cave_entrance_open", "cave_entrance_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportapracaverna")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

for _, prefab in pairs(
    { "seastack",
        "coralreef",
        "wreck",
        "waterygrave",
        "octopusking",
        "kraken",
        "ballphinhouse",
        "coral_brain_rock",
        "saltstackthen",
        "wall_enforcedlimestone",
        "kraken_tentacle",
        "sea_chiminea",
        "sea_yard",
        "buoy" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("quebraonda")
    end)
end



for _, prefab in pairs({ "saplingnova", "sapling" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst.entity:AddSoundEmitter() --ventania风相关
        inst:AddTag("saplingsw")
    end)
end


for _, prefab in pairs({ "sewing_tape" }) do
    AddPrefabPostInit(prefab, function(inst)
        inst:AddTag("boatrepairkit")
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("interactions")
    end)
end





for _, prefab in pairs(
    { "houndstooth",
        "gunpowder",
        "boards",
        "mosquitosack",
        "nightmarefuel",
        "stinger",
        "spear",
        "spear_wathgrithr" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("tradable")
    end)
end


local rocks = {
    "rock1", "rock2", "rock_flintless", "rock_flintless_med", "rock_flintless_low", "rock_moon", "rock_moon_shell",
    "moonglass_rock", "rock_petrified_tree", "rock_petrified_tree_med", "rock_petrified_tree_tall",
    "rock_petrified_tree_short", "rock_petrified_tree_old", "pig_ruins_head", "pig_ruins_pig", "pig_ruins_ant",
    "pig_ruins_idol", "pig_ruins_plaque", "pig_ruins_artichoke", "pig_ruins_truffle", "pig_ruins_sow", "antqueen_throne",
    "rock_basalt", }

for _, prefab in pairs(rocks) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end
        if not inst.components.mystery then
            inst:AddComponent("mystery")
        end
    end)
end

AddPrefabPostInit("deco_palace_throne", function(inst)
    inst.OnEntityWake = function(inst)
        local ent = TheSim:FindFirstEntityWithTag("pigqueen")
        if ent then
            inst:DoTaskInTime(0, function(inst)
                ent.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end)
        end
    end
end
)

local roomsize = TUNING.HAMROOM.roomsize
local roomtype = TUNING.HAMROOM.roomtype
-- 室内可放置建筑，物品不会掉入“水”中

local function CheckNearRoomCenter(x, z, rsize)
    if x < (-rsize.back + 0) and x > (-rsize.back - 1) and math.abs(z) <= (rsize.side + 2) then ---11
        return "back"
    elseif x < (rsize.front + 1) and x > (rsize.front + 0) and math.abs(z) <= (rsize.side + 2) then
        return "front"
    elseif z > (rsize.side + 0) and z < (rsize.side + 1) and x <= (rsize.front + 1) and x >= (-rsize.back - 1) then
        return "right"
    elseif -z > (rsize.side + 0) and -z < (rsize.side + 1) and x <= (rsize.front + 1) and x >= (-rsize.back - 1) then
        return "left"
    end

    return false
end

AddPrefabPostInitAny(function(inst)
    if inst:HasTag("interior_center") then
        inst:DoTaskInTime(2, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            x, z = math.floor(x) + 0.5, math.floor(z) + 0.5
            local rsize = roomsize[roomtype[inst.prefab] or "small"]
            local ents = TheSim:FindEntities(x, y, z, 20, { "wall_room" })
            if #ents <= 0 then
                -- print("interior_center does not have wall")
                local tipodemuro = "wall_invisible"
                for xx = -40, 40 do
                    for zz = -40, 40 do
                        if CheckNearRoomCenter(xx / 2, zz / 2, rsize) then
                            -- print("interior_center3")
                            local part = SpawnPrefab(tipodemuro)
                            part.Transform:SetPosition(x + xx / 2, 0, z + zz / 2)
                        end
                    end
                end
            else
                -- print("interior_center does have wall")
            end
        end)
    end
end)
