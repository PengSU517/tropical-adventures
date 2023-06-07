local assets =
{
    Asset("ANIM", "anim/coloumn_angel.zip"),
}

local prefabs = {}

local toploot = {
    {"ruins_bat"},
    {"ruinshat"},
    {"cane"},
    {"slurtlehat",},

    {"firestaff",},

--    {"spellscroll_meteorfall", "spellscroll_meteorfall", "spellscroll_meteorfall", "spellscroll_meteorfall"},
--    {"spellscroll_chainlightning", "spellscroll_chainlightning", "spellscroll_chainlightning", "spellscroll_chainlightning"},
--    {"spellscroll_tranquility", "spellscroll_tranquility", "spellscroll_tranquility", "spellscroll_tranquility"},

    {"blowdart_pipe", "blowdart_pipe", "blowdart_pipe", "blowdart_pipe", "blowdart_pipe"},
}

local midloot = {
    --mats
    {"greengem"},
    {"orangegem"},
    {"yellowgem"},

    {"livinglog", "livinglog",},
    {"tentaclespots", "tentaclespots",},
    {"honeycomb", "honeycomb",},
    {"pigskin", "pigskin", "pigskin", "pigskin",},
    {"manrabbit_tail", "manrabbit_tail",},
    {"gears", "gears", "gears",},

    --equip
    {"batbat",},
    {"hambat"},

    {"ruinshat",},
--    {"wizard_hat",},
    {"footballhat", "footballhat",},
    {"armormarble", "armormarble",},

    --other
    {"dug_berrybush", "dug_berrybush",},
    {"gunpowder"},
}

local lowloot = {
    --mats
    {"cutreeds", "cutreeds", "cutreeds", "cutreeds", "cutreeds", 
        "cutreeds", "cutreeds", "cutreeds", "cutreeds", "cutreeds",},
    {"goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget",},
    {"silk", "silk", "silk", "silk", "silk", "silk", "silk", "silk", "silk", "silk", "silk",},

    --equip
    {"umbrella",},
    
    --food
    {"honey", "honey", "honey", "honey", "honey", "honey", "honey", "honey", "honey", "honey", "honey",},
    {"meat", "meat", "meat", "meat", "meat", "meat",},
    {"watermelon", "watermelon", "watermelon",},
}

local essencesLoot = {"goldnugget", "goldnugget", "goldnugget", "goldnugget"}   --{ "essence_fire", "essence_ice", "essence_poison", "essence_lightning" }

local function GFSoftColourChange(inst, fc, sc, time, step)
    if sc == nil then sc = {1, 1, 1, 1} end
    if time == nil then time = 1 end
    if step == nil or step > 1 then step = 0.1 end
    local totalSteps = math.ceil (time / step)
    inst.AnimState:SetMultColour(sc[1], sc[2], sc[3], sc[4])
    local dRed      = (fc[1] - sc[1]) / totalSteps
    local dGreen    = (fc[2] - sc[2]) / totalSteps
    local dBlue     = (fc[3] - sc[3]) / totalSteps
    local dAlpha    = (fc[4] - sc[4]) / totalSteps
    local deltaColor = {dRed, dGreen, dBlue, dAlpha}
    local currStep = 0
    if inst._softColorTask ~= nil then inst._softColorTask:Cancel() end

    inst._softColorTask = inst:DoPeriodicTask(step, function(inst)
        if currStep <= totalSteps then
            --print(time)
            inst.AnimState:SetMultColour(sc[1] + deltaColor[1] * currStep, 
                sc[2] + deltaColor[2] * currStep, 
                sc[3] + deltaColor[3] * currStep, 
                sc[4] + deltaColor[4] * currStep)
            currStep = currStep + 1
        else
            inst._softColorTask:Cancel() 
            inst._atask = nil
        end
    end, nil, deltaColor, totalSteps, currStep)
end

local function CreateShadow(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local obj = SpawnPrefab("column_angel_shadow")
    obj.Transform:SetPosition(x, y, z)
    obj.parent = inst
    inst.shadow = obj
end

local function ResetRunes(inst) 
    inst.runesDone = 0
    if #(inst.runes) == 0 then return end
    for k, v in pairs(inst.runes) do
        local x, y, z = v.Transform:GetWorldPosition()
        local fx = SpawnPrefab("maxwell_smoke")
        fx.Transform:SetPosition(x, y, z)
        v:Remove()
    end
    inst.runes = {}
    --inst.components.activatable.inactive = true
end

local function OnRuneDone(inst)

    local function SpawnItem(inst, prefab)
        local obj = SpawnPrefab(prefab)
        if obj == nil then return end
        local x, y, z = inst.Transform:GetWorldPosition()
        if obj.Physics then
            local angle = math.random(360) * DEGREES
            local halfspeed = math.random(2, 3) -- need half, because we double sin\cos later
            local xs = math.cos(angle) * 2
            local zs = -math.sin(angle) * 2
            --[[column has big collision model, so we need to teleport items from its center,
            or they will collide with column and fall in one direction]]
            obj.Physics:Teleport(x + xs, 2, z + zs) 
            obj.Physics:SetVel(halfspeed * xs, 0, halfspeed * zs)
        else
            obj.Transform:SetPosition(x , y, z)
        end  
    end

    inst.runesDone = inst.runesDone + 1
    if inst.runesDone == 3 then
        --print("All runes done")
        ResetRunes(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("lightning").Transform:SetPosition(x, y, z)

        --SpawnItem(inst, "giantsoul")

        for i = 1, math.random(3, 6) do
            SpawnItem(inst, essencesLoot[math.random(4)])
        end
        local lootline = toploot[math.random(#toploot)]
        for _, prefab in pairs(lootline) do
            SpawnItem(inst, prefab)
        end
        for i = 1, 2 do
            lootline = midloot[math.random(#midloot)]
            for _, prefab in pairs(lootline) do
                SpawnItem(inst, prefab)
            end
        end
        for i = 1, 3 do
            lootline = lowloot[math.random(#lowloot)]
            for _, prefab in pairs(lootline) do
                SpawnItem(inst, prefab)
            end
        end

    end
end

local function OnActivate(inst)
    if not inst.cooldown then 
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle = math.random(360) * DEGREES
        local pt = {}
        pt[1] =  { x = x + math.cos(angle) * 8,          z = z - math.sin(angle) * 8 }
        pt[2] =  { x = x + math.cos(angle + 2,0944) * 8, z = z - math.sin(angle + 2,0944) * 8 }
        pt[3] =  { x = x + math.cos(angle - 2,0944) * 8, z = z - math.sin(angle - 2,0944) * 8 }
        local runeTypes = {"beast", "death", "sacrifice", "rich", "magic"}
        for i = 1, 3 do
            local fx = SpawnPrefab("maxwell_smoke")
            fx.Transform:SetPosition(pt[i].x, y, pt[i].z)
            local obj = SpawnPrefab("gw_rune")
            obj.Transform:SetPosition(pt[i].x, y, pt[i].z)
            obj.Transform:SetRotation(math.random(360))
            local transparent = 0
            obj.AnimState:SetMultColour(0, 0, 0, transparent)
            GFSoftColourChange(obj, {0, 0, 0, 1}, {0, 0, 0, 0}, 1, 0.1)
            obj:SetRune(table.remove(runeTypes, math.random(#runeTypes)), inst)
            table.insert(inst.runes, obj)
        end
    end

    inst.cooldown = true
    inst.components.timer:StartTimer("cooldown", 2400)	
end

local function DeactivateOtherRunes(inst, rune)
    for k, v in pairs(inst.runes) do
        if v ~= rune then
            v:DeactivateRune()
        end
    end
end

local function fn_shadow()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBank("column_angel")
    inst.AnimState:SetBuild("coloumn_angel")
    inst.AnimState:PlayAnimation("idle_normal")
    inst.AnimState:SetMultColour(0, 0, 0, 0.3)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("object_shadow")
    inst:AddTag("fx")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    return inst
end

local function OnSave(inst, data)
    data.runesDone = inst.runesDone
    if inst.cooldown then
        data.cooldown = true
        data.runes = {}
        for k, v in pairs(inst.runes) do
            data.runes[k] = v:GetSaveRecord()
        end
    end
end

local function OnLoad(inst, data)
    if data then
        if data.runesDone then inst.runesDone = data.runesDone end
        if data.cooldown then inst.cooldown = data.cooldown end
        if data.runes then
            for k, v in pairs(data.runes) do
                inst.runes[k] = SpawnSaveRecord(v)
                inst.runes[k].owner = inst
            end
        end
    end
end

local function GetDebugString(inst)
    local str, stre = "", ""
    if inst.runes ~= nil then
        for k, v in pairs(inst.runes) do
            stre = stre .. v.GUID .. " - " .. v.prefab .. ", "
            str = str .. string.format("%s(%s), ", v.type, tostring(v.extinguished))
        end
    end
    return string.format("\nRunes: \n%s\nRunes type: %s", stre, str)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
    MakeObstaclePhysics(inst, 1)
    MakeSnowCoveredPristine(inst)	

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("column_angel_mini.tex")

    inst.AnimState:SetBank("column_angel")
    inst.AnimState:SetBuild("coloumn_angel")
    inst.AnimState:PlayAnimation("watch_normal")

    inst:AddTag("column")
    inst.entity:SetPristine()
    inst.GetActivateVerb = function() return "Touch" end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.inactive = true
    inst.components.activatable.OnActivate = OnActivate

    inst:AddComponent("timer")

    inst.cooldown = false
    inst.runes = {}
    inst.runesDone = 0

    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "cooldown" then 
            ResetRunes(inst)
            inst.cooldown = false
            inst.components.activatable.inactive = true
        end
    end)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.OnRuneDone = OnRuneDone
    inst.DeactivateOtherRunes = DeactivateOtherRunes

    inst.debugstringfn = GetDebugString

    return inst
end

return  Prefab("column_angel", fn, assets, prefabs),
        Prefab("column_angel_shadow", fn_shadow, assets, prefabs)