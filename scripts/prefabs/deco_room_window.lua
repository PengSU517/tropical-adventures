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


}

local prefabs =
{

}

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
    data.scales = Vector3(inst.Transform:GetScale())
    data.onbuilt = inst.onbuilt
end

local function onload(inst, data)
    if data then
        if data.rotation then
            inst.Transform:SetRotation(data.rotation)
        end
        if data.scales then
            inst.Transform:SetScale(data.scales.x, data.scales.y, data.scales.z)
        end
        if data.onbuilt then
            inst.onbuilt = data.onbuilt
            setPlayerUncraftable(inst)
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


local function WallSectionfn(prefabname, build, bank, animframe, data, assets, prefabs)
    if not data then
        data = {}
    end

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

        local scales = data.scales
        local iswall = false


        trans:SetTwoFaced() -----------------可能这是关键原因
        trans:SetScale(scales.x, scales.y, scales.z)

        -- inst.build = build
        -- inst.bank = bank
        anim:SetBuild(build)
        anim:SetBank(bank)
        -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
        anim:PlayAnimation("day_loop", true)
        anim:SetLayer(LAYER_WORLD_BACKGROUND)

        if inst:HasTag("room_window") then
            inst:DoTaskInTime(0, function(inst)
                local ground = TheWorld.Map
                local pt = inst:GetPosition() ---- local a, b, c = inst.Transform:GetWorldPosition()
                iswall = ground:IsHamRoomWallAtPoint(pt.x, pt.y, pt.z)
                if iswall == "right" then
                    inst.Transform:SetRotation(-180)
                    anim:SetBank(bank .. "_side")
                    -- trans:SetScale(1.5, scales.y, scales.z)
                    -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
                elseif iswall == "left" then
                    anim:SetBank(bank .. "_side")
                    -- trans:SetScale(1.5, scales.y, scales.z)
                    -- anim:SetLayer(LAYER_WORLD_BACKGROUND)
                else
                    -- trans:SetScale(1.7, scales.y, scales.z)
                end
            end)

            if not data.curtains then
                anim:Hide("curtain")
            end
        end

        if data.children then
            inst:DoTaskInTime(1, function(inst)
                for i, child in ipairs(data.children) do
                    if iswall == "back" then
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

        -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.RotatingBillboard)
        -- inst.Transform:SetTwoFaced() -----------------可能这是关键原因



        if true then
            inst:WatchWorldState("isday", timechange)
            inst:WatchWorldState("isdusk", timechange)
            inst:WatchWorldState("isnight", timechange)
            timechange(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end


        inst:ListenForEvent("onremove", function()
            onremove(inst)
        end)


        if true then
            inst:ListenForEvent("onbuilt", function()
                --------怎么合理地加入"playercrafted"这个标签呢，在makeplacer中加吗 .....监听onbuilt就可以。。。
                onBuilt(inst)
            end)
        end

        return inst
    end
    return Prefab(prefabname, fn, assets, prefabs)
end



local function MakeWallSectionPlacer(placer, build, bank, scales)
    local function placeAlign(inst)
        inst.Transform:SetScale(scales.x, scales.y, scales.z)
        local pt = inst:GetPosition()
        local ground = TheWorld.Map
        local iswall = ground:IsHamRoomWallAtPoint(pt.x, pt.y, pt.z)
        -- inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

        -- inst.Transform:SetTwoFaced() -----------------可能这是关键原因
        if iswall then
            if iswall == "right" then
                inst.AnimState:SetBank(bank .. "_side")
                inst.Transform:SetRotation(180)
            elseif iswall == "left" then
                inst.AnimState:SetBank(bank .. "_side")
                inst.Transform:SetRotation(0)
            elseif iswall == "back" then
                inst.AnimState:SetBank(bank)
                inst.Transform:SetRotation(0)
                -- inst.Transform:SetScale(1.7, scales.y, scales.z)
            end
        end
    end


    local function placefn(inst)
        inst.components.placer.onupdatetransform = placeAlign
    end

    return MakePlacer(placer, bank, build, "day_loop", false, nil, nil, nil, nil, "two", placefn)
end


return
    WallSectionfn("window_greenhouse", "interior_window_greenhouse_build", "interior_window_greenhouse", "day_loop",
        {
            curtains = true,
            children = { "window_round_light" },
            tags = { "NOBLOCK", "wallsection", "room_window" },
            scales = { x = 1.5, y = 1.3, z = 1 },
        }),
    MakeWallSectionPlacer("window_greenhouse_placer", "interior_window_greenhouse_build", "interior_window_greenhouse",
        { x = 1.5, y = 1.3, z = 1 })
