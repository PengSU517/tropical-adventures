local assets = {Asset("ANIM", "anim/x_marks_spotsw.zip")}

local prefabs = {"messagebottle", "collapse_small"}

local treasures = {"healingstaff", "purplegem", "orangegem", "yellowgem", "greengem", "redgem", "bluegem",
                          "supertelescope", "spear_poison", "boat_lantern", "papyrus", "tunacan", "goldnugget", "gears",
                          "rope", "minerhat", "dubloon", "obsidianaxe", "telescope", "captainhat", "peg_leg",
                          "volcanostaff", "footballhat", "spear", "goldenaxe", "goldenshovel", "goldenpickaxe",
                          "seatrap", "compass", "boneshard", "transistor", "gunpowder", "heatrock", "antivenom",
                          "healingsalve", "blowdart_sleep", "nightsword", "amulet", "clothsail", "boatrepairkit",
                          "coconade", "boatcannon", "snakeskinhat", "armor_snakeskin", "spear_launcher", "piratehat",
                          "boomerang", "snakeskin", "strawhat", "blubbersuit", "nightmarefuel", "obsidianmachete",
                          "trap_teeth", "spear_obsidian", "armorobsidian", "goldenmachete", "obsidiancoconade",
                          "fabric", "harpoon", "umbrella", "birdtrap", "featherhat", "beehat", "bandage", "armorwood",
                          "armormarble", "blowdart_pipe", "armorgrass", "armorseashell", "cane", "icestaff",
                          "firestaff", "blowdart_fire", "yellowamulet", "armorruins", "ruins_bat", "ruinshat",
                          "cutgrass", "charcoal", "axe", "hammer", "shovel", "bugnet", "fishingrod", "spidergland",
                          "silk", "flint", "coral", "earring",}

local function onfinishcallback(inst, worker)
    -- figure out which side to drop the loot
    local pt = inst:GetPosition()
    local hispos = Vector3(worker.Transform:GetWorldPosition())

    local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

    if he_right then
        inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (math.random() + 1)))
        inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (math.random() + 1)))
    else
        inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (math.random() + 1)))
        inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (math.random() + 1)))
    end

    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/loot_reveal")

    local chest = SpawnPrefab("treasurechest")
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    chest.Transform:SetPosition(x, y, z)

    ------------------------vai vir um desses 50% de chance pra cada-------------------------

    -----pode vir até 9 moedas----------------------
    for i = 1, 9 do
        if math.random() > 0.5 then
            local single = SpawnPrefab("dubloon")
            chest.components.container:GiveItem(single)
        end
    end

    -----pode vir até 8 tesouros----------------------
    for i = 1, 8 do
        if math.random() > 0.5 then
            local single = SpawnPrefab(treasures[math.random(1, #treasures)])
            chest.components.container:GiveItem(single)
        end
    end

    -----pode vir até 3 monstros----------------------
    for i = 1, 4 do
        if math.random() > 0.5 then
            if math.random() > 0.5 then
                local single = SpawnPrefab("snake_poison")
                chest.components.container:GiveItem(single)
            else
                local single = SpawnPrefab("snake")
                chest.components.container:GiveItem(single)
            end
        else

        end
    end

    inst:Remove()
end

local function onsave(inst, data) end

local function onload(inst, data) end

local function RevealFog(inst)
    inst.entity:Show()
    inst.MiniMapEntity:SetEnabled(true)
    local x, y, z = inst.Transform:GetLocalPosition()
    local minimap = TheWorld.minimap.MiniMap
    local map = TheWorld.Map
    local cx, cy, cz = map:GetTileCenterPoint(x, 0, z)
    minimap:ShowArea(cx, cy, cz, 30)
    map:VisitTile(map:GetTileCoordsAtPoint(cx, cy, cz))
end

local function FocusMinimap(inst)
    local px, py, pz = ThePlayer.Transform:GetWorldPosition()
    local x, y, z = inst.Transform:GetLocalPosition()
    local minimap = TheWorld.minimap.MiniMap
    -- ThePlayer.HUD.controls:ToggleMap()
    -- minimap:Focus(x - px, z - pz, -minimap:GetZoom()) --Zoom in all the way
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddSoundEmitter()

    inst:AddTag("buriedtreasure")

    minimap:SetIcon("xspot.png")
    --	minimap:SetEnabled(false)

    anim:SetBank("x_marks_spotsw")
    anim:SetBuild("x_marks_spotsw")
    anim:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(3)
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"boneshard"})

    inst.components.workable:SetOnFinishCallback(onfinishcallback)

    --	inst:DoTaskInTime(1, RevealFog)
    --	inst:DoTaskInTime(0.5, FocusMinimap)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function onfinishcallback2(inst, worker)
    local chest = SpawnPrefab("treasurechest")
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    chest.Transform:SetPosition(x, y, z)

    -----pode vir até 9 moedas----------------------
    for i = 1, 9 do
        if math.random() > 0.5 then
            local single = SpawnPrefab("dubloon")
            chest.components.container:GiveItem(single)
        end
    end

    -----pode vir até 8 tesouros----------------------
    for i = 1, 8 do
        if math.random() > 0.5 then
            local single = SpawnPrefab(treasures[math.random(1, #treasures)])
            chest.components.container:GiveItem(single)
        end
    end

    inst:Remove()
end

local function fn2(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddSoundEmitter()

    inst:AddTag("buriedtreasure")

    minimap:SetIcon("xspot.png")
    --	minimap:SetEnabled(false)

    anim:SetBank("x_marks_spotsw")
    anim:SetBuild("x_marks_spotsw")
    anim:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:DoTaskInTime(1, onfinishcallback2)

    return inst
end

return Prefab("buriedtreasure", fn, assets, prefabs),
       Prefab("shipwrecked/objects/buriedtreasure2", fn2, assets, prefabs)
