require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/treasure_chest_cork.zip"),
}

local prefabs =
{
	"collapse_small",
	"lavaarena_creature_teleport_small_fx",
}

local function onopencork(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open", true)
		inst.AnimState:PushAnimation("open_loop", true)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end
end

local function onclosecork(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close", true)
		inst.AnimState:PushAnimation("closed", true)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	end
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
		if inst.components.container then
			inst.components.container:DropEverything()
			inst.components.container:Close()
		end
	end
end

local function setworkable(inst)
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
end

local function onbuilt(inst)
	--	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", true)
	if inst.prefab == "antchest" then
		inst.honeyWasLoaded = true
	end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)

	inst.MiniMapEntity:SetIcon("cork_chest.png")

	inst.AnimState:SetBank("treasure_chest_cork")
	inst.AnimState:SetBuild("treasure_chest_cork")
	inst.AnimState:PlayAnimation("closed", true)

	--	inst:AddTag("structure")
	inst:AddTag("chest")
	inst:AddTag("pogproof")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("corkchest")
		end
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("corkchest")
	inst.components.container.onopenfn = onopencork
	inst.components.container.onclosefn = onclosecork

	setworkable(inst)

	inst:ListenForEvent("onbuilt", onbuilt)
	MakeSnowCovered(inst, .01)

	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("common/corkchest", fn, assets),
	MakePlacer("common/corkchest_placer", "chest", "treasure_chest_cork", "closed")
