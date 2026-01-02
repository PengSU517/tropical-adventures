local teatree_assets = {
    Asset("ANIM", "anim/teatree_nut.zip"),
}

local palmtree_assets = {
    Asset("ANIM", "anim/coconut.zip"),
}

local function growtree(inst)
    local grow_prefab = type(inst.growprefab) == "table" and GetRandomItem(inst.growprefab) or inst.growprefab
    local tree = SpawnPrefab(grow_prefab)
    if tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tree:growfromseed()
        inst:Remove()
    end
end

local function stopgrowing(inst)
    inst.components.timer:StopTimer("grow")
end

local function startgrowing(inst)
    if not inst.components.timer:TimerExists("grow") then
        local basetime = inst.growtimes and inst.growtimes.base or TUNING.PINECONE_GROWTIME.base
        local randomtime = inst.growtimes and inst.growtimes.random or TUNING.PINECONE_GROWTIME.random
        local growtime = GetRandomWithVariance(basetime, randomtime)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function ontimerdone(inst, data)
    if data.name == "grow" then
        growtree(inst)
    end
end

local function digup(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function sapling_fn(build, anim, growprefab, tag, fireproof, overrideloot, override_deploy_smart_radius, grow_times)
    local scrapbook_adddeps = {}

    if type(growprefab) == "table" then
        for k, prefab in pairs(growprefab) do
            table.insert(scrapbook_adddeps, prefab == tag and tag .. "_tall" or string.gsub(prefab, "short", "tall"))
        end
    else
        table.insert(scrapbook_adddeps, growprefab == tag and tag .. "_tall" or string.gsub(growprefab, "short", "tall"))
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:SetDeploySmartRadius(override_deploy_smart_radius or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT] / 2)

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim)

        if not fireproof then
            inst:AddTag("plant")
        end

        inst:AddTag(tag)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.scrapbook_anim = anim
        inst.scrapbook_adddeps = scrapbook_adddeps

        inst.growprefab = growprefab
        inst.growtimes = grow_times
        inst.StartGrowing = startgrowing

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", ontimerdone)
        startgrowing(inst)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(overrideloot or { "twigs" })

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(digup)
        inst.components.workable:SetWorkLeft(1)

        if not fireproof then
            MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
            inst:ListenForEvent("onignite", stopgrowing)
            inst:ListenForEvent("onextinguish", startgrowing)
            MakeSmallPropagator(inst)

            MakeHauntableIgnite(inst)
        else
            MakeHauntableWork(inst)
        end

        MakeWaxablePlant(inst)

        return inst
    end
    return fn
end

return Prefab("teatree_sapling", sapling_fn("teatree_nut", "idle_planted", "teatree", "teatree"), teatree_assets),
    Prefab("coconut_sapling", sapling_fn("coconut", "planted", "palmtree_short", "palmtree"), palmtree_assets)