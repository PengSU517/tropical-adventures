local assets =
{
    Asset("ANIM", "anim/fountain_pillar.zip"),

    Asset("MINIMAP_IMAGE", "pig_ruins_pillar"),
}

local prefabs =
{

}



local function onsave(inst, data)
    local references = {}
    data.rotation = inst.Transform:GetRotation()
    return references
end

local function onload(inst, data)
    if data.rotation then
        inst.Transform:SetRotation(data.rotation)
    end
    if inst.components.workable and inst.components.workable.workleft < 1 then
        inst.AnimState:PushAnimation("pillar_collapsed", true)
    end
end

local function loadpostpass(inst, ents, data)

end

local function onremove(inst)

end


SetSharedLootTable('pugalisk_pillar',
    {
        { 'rocks',   1.00 },
        { 'rocks',   1.00 },
        { 'rocks',   1.00 },
        { 'rocks',   0.25 },
        { 'rocks',   0.25 },
        { 'relic_2', 0.05 },
    })


local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 0.5)
    inst.Transform:SetEightFaced()

    anim:SetBuild("fountain_pillar")
    anim:SetBank("fountain_pillar")
    anim:PlayAnimation("pillar", true)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pugalisk_ruins_pillar.tex")

    --   inst.OnSave = onsave
    --   inst.OnLoad = onload
    --   inst.LoadPostPass = loadpostpass

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.PUGALISK_RUINS_PILLAR_WORK)
    inst.components.workable:SetOnWorkCallback(
        function(inst, worker, workleft)

        end)
    inst.components.workable:SetOnFinishCallback(
        function(inst, worker)
            anim:PlayAnimation("pillar_collapse")
            anim:PushAnimation("pillar_collapsed")
            local pt = Point(inst.Transform:GetWorldPosition())
            inst.components.lootdropper:DropLoot(pt)
            --inst:Remove()
        end)
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('pugalisk_pillar')

    inst:DoTaskInTime(0, function()
        local pt = Point(inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, { "pugalisk_fountain" })

        if ents[1] then
            local pt2 = Point(ents[1].Transform:GetWorldPosition())
            local angle = inst:GetAngleToPoint(pt2)
            inst.Transform:SetRotation(angle)
        end
    end)
    return inst
end


return Prefab("pugalisk_ruins_pillar", fn, assets, prefabs)
