local assets =
{
	Asset("ANIM", "anim/fish.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function pouch(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("goddess_pouch").Transform:SetPosition(x, y, z)
	inst:DoTaskInTime(0.1, inst:Remove())
end

local function prepouch(inst)
	inst:SpawnChild("goddess_sparklefx")
	inst:DoTaskInTime(0.35, pouch)
end
local assets =
{
    Asset("ANIM", "anim/fish.zip"),
    Asset("ANIM", "anim/fish01.zip"),
}

local prefabs =
{
    "fish_cooked",
    "spoiled_food",
}

local function stopkicking(inst)
    inst.AnimState:PlayAnimation("dead")
end

local function commonfn(build, anim, loop, dryable, cookable)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fish")
    inst.AnimState:SetBuild("fish")
    inst.AnimState:PlayAnimation(anim, loop)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.build = build --This is used within SGwilson, sent from an event in fishingrod.lua

	inst:DoTaskInTime(3, prepouch)
    MakeHauntableLaunchAndPerish(inst)
	
    inst.data = {}

    return inst
end

local function rawfn(build)
    local inst = commonfn(build, "idle", true, true, true)

    if not TheWorld.ismastersim then
        return inst
    end
    inst:DoTaskInTime(5, stopkicking)
    inst.OnLoad = stopkicking
    return inst
end

local function makefish(build)
    local function makerawfn()
        return rawfn(build)
    end
    return makerawfn
end

local function fish(name, build)
    local raw = makefish(build)
    return Prefab(name, raw, assets, prefabs)
end

return fish("goddess_fish", "fish01")
