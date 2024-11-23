local assets = {Asset("ANIM", "anim/woodlegs_key.zip")}

local function MakeKey(i)

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:SetPristine()
        inst.entity:AddSoundEmitter()
        local anim = inst.entity:AddAnimState()
        anim:SetBank("woodlegs_key")
        anim:SetBuild("woodlegs_key")
        anim:PlayAnimation("key" .. i)

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        inst:AddTag("aquatic")
        inst:AddTag("woodlegs_key")
        inst:AddTag("woodlegs_key" .. i)

        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("inspectable")
        inst:AddComponent("tradable")
        inst:AddComponent("inventoryitem")

        return inst
    end

	return Prefab("woodlegs_key" .. i, fn, assets)
end

local prefabs = {}
for i = 1, 3 do table.insert(prefabs, MakeKey(i)) end
return unpack(prefabs)