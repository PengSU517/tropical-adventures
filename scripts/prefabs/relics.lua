NUM_RELICS = 5

local function getstatus(inst)
    --    if inst.components.sinkable and inst.components.sinkable.sunken then
    --        return "SUNKEN"
    --    end
end

local function bubble(inst)
    inst.task = nil
    -- hacky, need to force a floatable anim change
    -- inst.components.floatable:UpdateAnimations(inst.relicnum.."_water", inst.relicnum)

    --    if inst.components.sinkable.sunken then
    --        inst.components.floatable:UpdateAnimations( inst.relicnum.."_bubble", inst.relicnum)
    --    end

    --if inst.components.floatable.onwater then
    inst.AnimState:PushAnimation(inst.relicnum .. "_water")
    --else
    inst.AnimState:PushAnimation(inst.relicnum)
    -- end

    if inst.entity:IsAwake() then
        inst:DoTaskInTime(4 + math.random() * 10, function() bubble(inst) end)
    end
end


local function onwake(inst)
    --    inst.task = inst:DoTaskInTime(4+math.random()*10, function() bubble(inst) end)
end

local function MakeRelic(num)
    local name = "relic_" .. tostring(num)
    local prefabname = "common/inventory/" .. name

    local assets =
    {
        Asset("ANIM", "anim/relics.zip"),
    }

    local function fn(Sim)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.OnEntityWake = onwake

        MakeInventoryPhysics(inst)
        --        MakeInventoryFloatable(inst, tostring(num).."_water", tostring(num))

        inst.AnimState:SetBank("relic")
        inst.AnimState:SetBuild("relics")
        inst.AnimState:PlayAnimation(tostring(num))

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("tradable")

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = getstatus

        inst:AddComponent("inventoryitem")

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        --        inst:AddComponent("sinkable")
        --        inst.components.sinkable.swapbuild = "relics"
        --        inst.components.sinkable.swapsymbol = "fish0"..num

        inst.relicnum = num

        inst:AddComponent("bait")

        return inst
    end

    return Prefab(prefabname, fn, assets)
end

local ret = {}
for k = 1, NUM_RELICS do
    table.insert(ret, MakeRelic(k))
end

return unpack(ret)
