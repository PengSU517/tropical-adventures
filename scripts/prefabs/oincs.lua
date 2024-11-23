local function shine(inst)
    inst.task = nil
end

local function MakeOinc(data)
    local suffix = data.build and "_" .. data.build or ""

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetBank("coin")
        inst.AnimState:SetBuild("pig_coin" .. suffix)
        inst.AnimState:PlayAnimation("idle")
        inst:AddTag("molebait")
        inst:AddTag("oinc")
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("bait")
        inst.oincvalue = data.value

        inst:AddComponent("edible")
        inst.components.edible.foodtype = "ELEMENTAL"
        inst.components.edible.hungervalue = 1

        inst:AddComponent("inspectable")
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("waterproofer")
        inst.components.waterproofer.effectiveness = 0

        inst:AddComponent("tradable")
        inst:AddComponent("inventoryitem")
        return inst
    end

    return Prefab("common/inventory/oinc" .. (data.build and data.value or ""), fn,
                  {Asset("ANIM", "anim/pig_coin" .. suffix .. ".zip")})
end

local oincs = {{
    value = 1,
}, {
    value = 10,
    build = "silver",
}, {
    value = 100,
    build = "jade",
}}

local prefabs = {}
for _, t in ipairs(oincs) do table.insert(prefabs, MakeOinc(t)) end
return unpack(prefabs)
