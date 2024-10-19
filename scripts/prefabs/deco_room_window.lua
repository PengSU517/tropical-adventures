-- require "prefabutil"

local function MakeInteriorPhysics(inst, rad, height, width)
    height = height or 20

    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    inst.Physics:SetMass(0)
    --    inst.Physics:SetRectangle(rad,height,width)  --------没这个函数
    --    inst.Physics:SetCollisionGroup(GetWorldCollision())
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
end


local function onhit(inst, worker)

end

local function smash(inst, worker)
    if inst.components.lootdropper then
        -- local inroom = GetClosestInstWithTag("interior_center", inst, 20)----------------似乎没用啊-----------需要修改组件
        -- if inroom then
        --     local originpt = inroom:GetPosition()
        --     local x, y, z = inst.Transform:GetWorldPosition()
        --     local dropdir = Vector3(originpt.x - x, 0.0, originpt.z - z):GetNormalized()
        --     inst.components.lootdropper.dropdir = dropdir

        -- end
        inst.components.lootdropper:DropLoot()
    end

    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

    if inst.SoundEmitter then
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    end

    inst:Remove()
end


local function setPlayerUncraftable(inst)
    inst:AddComponent("lootdropper")
    inst.entity:AddSoundEmitter()
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(smash)
    inst.components.workable:SetOnWorkCallback(onhit)
    inst.onbuilt = true
end

local function onBuilt(inst)
    setPlayerUncraftable(inst)


    if inst:HasTag("wallsection") then
        local pt = inst:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 1, { "wallsection" })
        for i, ent in ipairs(ents) do
            if ent ~= inst then
                smash(ent)
            end
        end
    end
end

local function onsave(inst, data)
    data.rotation = inst.Transform:GetRotation()
    -- data.pos = inst:GetPosition()
    -- data.height = inst.height

    -- print("print pos !!!!!!!!!!!!")
    -- print(data.pos)
    -- print(data.height)
    data.scales = Vector3(inst.Transform:GetScale())
    data.onbuilt = inst.onbuilt
end

local function onload(inst, data)
    if data then
        if data.rotation then
            inst.Transform:SetRotation(data.rotation)
        end
        -- if data.pos and data.height then
        --     inst.Transform:SetPosition(data.pos.x, data.pos.y, data.pos.z)
        -- end
        if data.scales then
            inst.Transform:SetScale(data.scales.x, data.scales.y, data.scales.z)
        end
        if data.onbuilt then
            inst.onbuilt = data.onbuilt
            setPlayerUncraftable(inst)
        end
    end
end

local function loadpostpass(inst, ents, data)
    if data then
        if data.swinglight then
            local swinglight = ents[data.swinglight]
            if swinglight then
                inst.swinglight = swinglight.entity
            end
        end


        inst.decochildrenToRemove = {}
        if data.children then
            for i, child in ipairs(data.children) do
                local childent = ents[child]
                if childent then
                    table.insert(inst.decochildrenToRemove, childent.entity)
                end
            end
        end
    end
end

local function onremove(inst)
    if inst.decochildrenToRemove then
        for i, child in ipairs(inst.decochildrenToRemove) do
            child:Remove()
        end
    end
end


local function timechange(inst)
    if TheWorld.state.isday then
        inst.AnimState:PlayAnimation("to_day")
        inst.AnimState:PushAnimation("day_loop", true)
    elseif TheWorld.state.isnight then
        inst.AnimState:PlayAnimation("to_night")
        inst.AnimState:PushAnimation("night_loop", true)
    elseif TheWorld.state.isdusk then
        inst.AnimState:PlayAnimation("to_dusk")
        inst.AnimState:PushAnimation("dusk_loop", true)
    end
end

local roomsection_prefabs = {}

local function RoomSectionfn(prefabname, build, bank, animdata, data)
    local assets =
    {
        Asset("ANIM", "anim/interior_window.zip"),
        Asset("ANIM", "anim/interior_window_burlap.zip"),
        Asset("ANIM", "anim/interior_window_lightfx.zip"),
        Asset("ANIM", "anim/window_arcane_build.zip"),

        Asset("ANIM", "anim/interior_window_small.zip"),
        Asset("ANIM", "anim/interior_window_large.zip"),
        Asset("ANIM", "anim/interior_window_tall.zip"),

        Asset("ANIM", "anim/interior_window_greenhouse.zip"),
        Asset("ANIM", "anim/interior_window_greenhouse_build.zip"),
        Asset("ANIM", "anim/window_weapons_build.zip"),

        Asset("ANIM", "anim/interior_wallornament.zip"),


    }

    local prefabs = {}
    local tags = data.tags or {}

    local function fn(Sim)
        local inst = CreateEntity()
        inst.entity:AddNetwork()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()

        for i, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
        inst:AddTag("liberado")
        inst:AddTag("DECOR")

        local scales = data.scales or { x = 1, y = 1, z = 1 }
        local iswall = false

        -- local x, y, z = inst.Transform:GetWorldPosition()
        -- inst.height = data and data.height or 0
        -- inst.Transform:SetPosition(x, inst.height, z)
        -- local pt = inst:GetPosition() ----------------这两行不能放在onbuilt里
        -- inst:SetPosition(pt.x, data and data.height or 0, pt.z)
        -- print("checkheight!!!!!")
        -- print(inst.height)


        trans:SetTwoFaced() -----------------可能这是关键原因
        trans:SetScale(scales.x, scales.y, scales.z)

        -- inst.build = build
        -- inst.bank = bank
        anim:SetBuild(build)
        anim:SetBank(bank)
        -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
        anim:PlayAnimation(animdata, true)




        if inst:HasTag("wallsection") then
            inst:DoTaskInTime(0, function(inst)
                local ground = TheWorld.Map
                local pt = inst:GetPosition() ---- local a, b, c = inst.Transform:GetWorldPosition()
                iswall = ground:IsHamRoomWallAtPoint(pt.x, pt.y, pt.z)
                if iswall == "right" then
                    inst.Transform:SetRotation(-180)
                    anim:SetBank(bank .. "_side")
                    trans:SetScale(scales.x, scales.y, scales.z)
                    -- trans:SetScale(1.5, scales.y, scales.z)
                    -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
                elseif iswall == "left" then
                    anim:SetBank(bank .. "_side")
                    trans:SetScale(scales.x, scales.y, scales.z)
                    -- trans:SetScale(1.5, scales.y, scales.z)
                    -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
                else
                    -- trans:SetScale(1.7, scales.y, scales.z)
                    trans:SetScale(scales.y, scales.y, scales.z)
                end
            end)

            if data.curtains ~= nil and not data.curtains then
                anim:Hide("curtain")
            end
        end

        if inst:HasTag("room_window") then
            inst:WatchWorldState("isday", timechange)
            inst:WatchWorldState("isdusk", timechange)
            inst:WatchWorldState("isnight", timechange)
            timechange(inst)
        end

        if data and data.background then
            anim:SetLayer(LAYER_WORLD_BACKGROUND)
        end

        if data.light then
            inst:DoTaskInTime(0, function()
                inst.swinglight = SpawnPrefab("swinglightobject")
                inst.swinglight.setLightType(inst.swinglight, data.followlight)
                if data.windowlight then
                    inst.swinglight.setListenEvents(inst.swinglight)
                end
                local follower = inst.swinglight.entity:AddFollower()
                follower:FollowSymbol(inst.GUID, "light_circle", 0, 0, 0)
                inst.swinglight.followobject = { GUID = inst.GUID, symbol = "light_circle", x = 0, y = 0, z = 0 }
            end)
        end

        if data.children then
            inst:DoTaskInTime(1, function(inst)
                for i, child in ipairs(data.children) do
                    if (iswall ~= "left") and (iswall ~= "right") then
                        child = child .. "_backwall"
                    end
                    local childprop = SpawnPrefab(child)
                    if childprop then
                        childprop.entity:SetParent(inst.entity) -----------
                        childprop.Transform:SetRotation(inst.Transform:GetRotation() / 2)
                        childprop.Transform:SetPosition(0, 0, 0)
                    end

                    if not inst.decochildrenToRemove then
                        inst.decochildrenToRemove = {}
                    end
                    table.insert(inst.decochildrenToRemove, childprop)
                end
            end)
        end

        MakeInteriorPhysics(inst, 1, 2, 2)


        inst.OnSave = onsave
        inst.OnLoad = onload
        inst.LoadPostPass = loadpostpass

        -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.RotatingBillboard)
        -- inst.Transform:SetTwoFaced() -----------------可能这是关键原因





        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end


        if data.inspectable then
            inst:AddComponent("inspectable") -----------------可检测吗？---加上太乱了
        end

        if data.craftable then
            setPlayerUncraftable(inst)
        end

        inst:ListenForEvent("onremove", function()
            onremove(inst)
        end)


        inst:ListenForEvent("onbuilt", function()
            --------怎么合理地加入"playercrafted"这个标签呢，在makeplacer中加吗 .....监听onbuilt就可以。。。
            onBuilt(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.height = TUNING.BUILD_HEIGHT or 0

            inst.Transform:SetPosition(x, inst.height, z)
            -- local pt = inst:GetPosition() ----------------这两行不能放在onbuilt里
            -- inst:SetPosition(pt.x, data and data.height or 0, pt.z)
        end)

        return inst
    end
    --------------------Placer---------------------------------
    local function placeAlign(inst)
        for i, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
        local scales = data.scales or { x = 1, y = 1, z = 1 }
        -- inst.Transform:SetScale(scales.x, scales.x, scales.z)
        local pt = inst:GetPosition()

        --------------调整在墙面上的高度
        if data.height then
            local change = TheInput:IsKeyDown(KEY_UP) and data.changevalue or
                TheInput:IsKeyDown(KEY_DOWN) and -1 * data.changevalue or 0
            if change ~= 0 then
                data.height = data.height + change
                data.height = math.min(math.max(data.height, -1), 3)
                if TheNet:GetIsClient() then
                    SendModRPCToServer(MOD_RPC["ham_room"]["build_height"], data.height)
                    -- print("!!!!!!!!!!!!data" .. data.height)
                end
            end
        end
        inst.Transform:SetPosition(pt.x, data.height or 0, pt.z)


        if data.rotation then
            if TheInput:IsKeyDown(KEY_PAGEUP) then
                data.rotation = 180
            elseif TheInput:IsKeyDown(KEY_PAGEDOWN) then
                data.rotation = 0
            end

            inst.Transform:SetRotation(data.rotation)
        end


        -- inst.Transform:SetPosition(pt.x, data and data.height or 1, pt.z)


        if data.curtains ~= nil and not data.curtains then
            inst.AnimState:Hide("curtain")
        end

        if data and data.background then
            inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        end

        if inst:HasTag("wallsection") then
            local ground = TheWorld.Map
            local iswall = ground:IsHamRoomWallAtPoint(pt.x, pt.y, pt.z)
            if iswall then
                if iswall == "right" then
                    inst.AnimState:SetBank(bank .. "_side")
                    inst.Transform:SetRotation(180)
                    data.rotation = inst.Transform:GetRotation()
                    inst.Transform:SetScale(scales.x, scales.y, scales.z)
                elseif iswall == "left" then
                    inst.AnimState:SetBank(bank .. "_side")
                    inst.Transform:SetRotation(0)
                    data.rotation = inst.Transform:GetRotation()
                    inst.Transform:SetScale(scales.x, scales.y, scales.z)
                elseif iswall == "back" then
                    inst.AnimState:SetBank(bank)
                    -- inst.Transform:SetRotation(0)
                    inst.Transform:SetScale(scales.y, scales.y, scales.z)
                end
            end
        end
    end


    local function placefn(inst)
        inst.components.placer.onupdatetransform = placeAlign
    end

    table.insert(roomsection_prefabs, Prefab(prefabname, fn, assets, prefabs))
    table.insert(roomsection_prefabs,
        MakePlacer(prefabname .. "_placer", bank, build, animdata, false, nil, nil, nil, nil, "two", placefn))
end

local function Windowfn(prefabname, build, bank, animdata, data)
    local presetdata = {
        curtains = data and data.curtains or false, ------------------这里TRUE FALSE的判定逻辑要注意
        children = data and data.children or { "window_round_light" },
        tags = data and data.tags or { "NOBLOCK", "wallsection", "rotatableobject", "room_window" },
        scales = data and data.scales or { x = 1.2, y = 1, z = 1 },
        height = 0,
        changevalue = data and data.changevalue or 0.02,
        rotation = 0,
        background = data and data.background or false,
        craftable = data and data.craftable or false,
    }

    local presetanimdata = animdata or "day_loop"
    RoomSectionfn(prefabname, build, bank, presetanimdata, presetdata)
end


----------------add windows
Windowfn("window_greenhouse", "interior_window_greenhouse_build", "interior_window_greenhouse", "day_loop",
    {
        scales = { x = 1.73, y = 1.5, z = 1 },
        changevalue = 0,
        background = true
    })
-- Windowfn("window_round_burlap", "interior_window_burlap", "interior_window_burlap")

Windowfn("window_round", "interior_window", "interior_window")
Windowfn("window_round_curtains_nails", "interior_window", "interior_window", "day_loop",
    { curtains = true, craftable = true })

Windowfn("window_round_burlap", "interior_window_burlap", "interior_window_burlap", "day_loop", { curtains = true })
-- Windowfn("window_round_burlap_curtain", "interior_window_burlap", "interior_window_burlap")

Windowfn("window_small_peaked", "interior_window_small", "interior_window_small")
Windowfn("window_small_peaked_curtain", "interior_window_small", "interior_window", "day_loop", { curtains = true })

Windowfn("window_large_square", "interior_window_large", "interior_window_large")
Windowfn("window_large_square_curtain", "interior_window_large", "interior_window_large", "day_loop", { curtains = true })

Windowfn("window_tall", "interior_window_tall", "interior_window_tall")
Windowfn("window_tall_curtain", "interior_window_tall", "interior_window_tall", "day_loop", { curtains = true })

Windowfn("window_round_arcane", "window_arcane_build", "interior_window_large")
Windowfn("window_square_weapons", "window_weapons_build", "interior_window_large")



local function Ornamentfn(name, data)
    local presetdata = {
        -- curtains = data and data.curtains or false, ------------------这里TRUE FALSE的判定逻辑要注意
        -- children = { "window_round_light" },
        tags = { "NOBLOCK", "wallsection", "rotatableobject", "ornament" },
        scales = data and data.scales or { x = 1.2, y = 1, z = 1 },
        height = 0,
        changevalue = data and data.changevalue or 0.02,
        rotation = 0,
        craftable = data and data.craftable or false,
    }
    local build = "interior_wallornament"
    local bank = "interior_wallornament"

    local presetanimdata = name or "beefalo"
    local prefabname = data and data.prefabname or "deco_wallornament_" .. name
    RoomSectionfn(prefabname, build, bank, presetanimdata, presetdata)
end

-------------------add ornaments
-- Ornamentfn("deco_wallornament_axe", "interior_wallornament", "interior_wallornament", "axe")



Ornamentfn("photo")
Ornamentfn("embroidery_hoop")
Ornamentfn("mosaic")
Ornamentfn("wreath")
Ornamentfn("hunt")
Ornamentfn("axe")
Ornamentfn("periodic_table")
Ornamentfn("gears_art")
Ornamentfn("cape")
Ornamentfn("no_smoking")
Ornamentfn("black_cat")

Ornamentfn("chalkboard")
Ornamentfn("whiteboard")
Ornamentfn("fulllength_mirror")
Ornamentfn("cage")
Ornamentfn("shield03")
Ornamentfn("shield02")
Ornamentfn("shield")
Ornamentfn("spears")
Ornamentfn("violet")
Ornamentfn("beefalo", { prefabname = "deco_antiquities_beefalo" })
Ornamentfn("fish", { prefabname = "deco_antiquities_wallfish" })


local function Lightfn(prefabname, animdata, data)
    local presetdata = {
        tags = data and data.tags or { "NOBLOCK", "rotatableobject", "DECOR" },
        scales = data and data.scales or { x = 1, y = 1, z = 1 },
        height = 0,
        changevalue = data and data.changevalue or 0.02,
        rotation = 0,
        background = data and data.background or false,
        inspectable = true,
        craftable = data and data.craftable or false,
        light = true,
        followlight = "electric_1",
    }

    local presetanimdata = animdata or "light_basic_bulb"
    RoomSectionfn(prefabname, "ceiling_lights", "ceiling_lights", presetanimdata, presetdata)
end



Lightfn("swinging_light_basic_bulb", "light_basic_bulb")
Lightfn("swinging_light_floral_bloomer", "light_floral_bloomer")
Lightfn("swinging_light_basic_metal", "light_basic_metal")
Lightfn("swinging_light_chandalier_candles", "light_chandelier_candles") -------名字和贴图名字不一样。。。
Lightfn("swinging_light_rope_1", "light_rope1", { craftable = true })
Lightfn("swinging_light_rope_2", "light_rope2")
Lightfn("swinging_light_floral_bulb", "light_floral_bulb")
Lightfn("swinging_light_pendant_cherries", "light_pendant_cherries")
Lightfn("swinging_light_floral_scallop", "light_floral_scallop")
Lightfn("swinging_light_tophat", "light_tophat")
Lightfn("swinging_light_derby", "light_derby")
Lightfn("swinging_light_bank", "light_bank")


return unpack(roomsection_prefabs)
