local function AddBigFooter(inst)
    if inst.ismastersim then
        if not inst.components.bigfooter then
            inst:AddComponent("bigfooter")
        end

        -- if bell_statue then
        --     local statueglommer_fn = GLOBAL.Prefabs["statueglommer"].fn
        --     local OnInit, OnInit_index = DX_GetUpvalue(statueglommer_fn, "OnInit")
        --     local OnWorked, OnWorked_index = DX_GetUpvalue(statueglommer_fn, "OnWorked")
        --     local OnLoadWorked, OnLoadWorked_index = DX_GetUpvalue(statueglommer_fn, "OnLoadWorked")
        --     local OnIsFullmoon, OnIsFullmoon_index = DX_GetUpvalue(OnInit, "OnIsFullmoon")

        --     local function PlayerLearnsBell(worker)
        --         worker.sg:GoToState("learn_bell")
        --     end
        --     local function TeachBellToWorker(inst, data)
        --         local worker = data and data.worker
        --         local worker_builder = worker and worker.components.builder
        --         if worker_builder and not table.contains(worker_builder.recipes, "bell") then
        --             worker:DoTaskInTime(1 + 2 * math.random(), PlayerLearnsBell)
        --         end
        --     end

        --     local old_OnIsFullmoon = OnIsFullmoon
        --     local new_OnIsFullmoon = function(inst, isfullmoon)
        --         if isfullmoon and inst.components.workable == nil and inst.components.lootdropper == nil then
        --             inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_down")
        --             inst.AnimState:PlayAnimation("full")
        --             inst:AddComponent("workable")
        --             inst.components.workable:SetWorkAction(ACTIONS.MINE)
        --             inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
        --             inst.components.workable:SetOnWorkCallback(OnWorked)
        --             inst.components.workable.savestate = true
        --             inst.components.workable:SetOnLoadFn(OnLoadWorked)
        --             inst:AddComponent("lootdropper")
        --             inst.components.lootdropper:SetChanceLootTable("statueglommer")

        --             local px, py, pz = inst.Transform:GetWorldPosition()
        --             local fx1 = SpawnPrefab("sanity_lower")
        --             local fx2 = SpawnPrefab("collapse_big")
        --             fx1.Transform:SetPosition(px, py, pz)
        --             fx2.Transform:SetPosition(px, py, pz)
        --         end
        --         if inst.components.workable and not inst.bell_learning_enabled then
        --             inst.bell_learning_enabled = true
        --             inst:ListenForEvent("workfinished", TeachBellToWorker)
        --         end
        --         return old_OnIsFullmoon(inst, isfullmoon)
        --     end

        --     DX_SetUpvalue(OnInit, OnIsFullmoon_index, new_OnIsFullmoon)
        -- end
    end
end

AddPrefabPostInit("world", AddBigFooter)
