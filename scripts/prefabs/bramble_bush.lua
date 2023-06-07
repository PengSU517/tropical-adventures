local assets=
{
	Asset("ANIM", "anim/bramble.zip"),
	Asset("ANIM", "anim/bramble1_build.zip"),
	Asset("ANIM","anim/bramble_core.zip"),
}

local prefabs =
{
    "twigs",
    "dug_marsh_bush",
}

local function ontransplantfn(inst)
    inst.components.pickable:MakeEmpty()
end

local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("wither", false)
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("wither")
end

local function DropAsh(inst, pos)
    if inst.components.lootdropper == nil then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SpawnLootPrefab("ash", pos)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	
    inst.AnimState:SetBank("bramble_"..math.random(1,3))
    inst.AnimState:SetBuild("bramble1_build")	
	
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon("marsh_bush.png")
    inst.MiniMapEntity:SetPriority(-1)

    inst:AddTag("plant")
    inst:AddTag("thorny")
	inst:AddTag("silviculture") -- for silviculture book

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"

    inst.components.pickable:SetUp("twigs", TUNING.MARSHBUSH_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.ontransplantfn = ontransplantfn

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

local function GetVerb()
    return "TOUCH"
end

return Prefab("bramble_bush", fn, assets, prefabs)
