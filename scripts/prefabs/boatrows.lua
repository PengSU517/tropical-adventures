require "prefabutil"

--The test to see if a boat can be built in a certain position is defined in the builder component Builder:CanBuildAtPoint
local assets =
{
	Asset("ANIM", "anim/boat_hud_encrusted.zip"),
	Asset("ANIM", "anim/boat_hud_cargo.zip"),
	Asset("ANIM", "anim/boat_hud_row.zip"),
	Asset("ANIM", "anim/corkboat.zip"),
	Asset("ANIM", "anim/pirate_boat_build.zip"),
	Asset("ANIM", "anim/raft_basic.zip"),
	Asset("ANIM", "anim/raft_build.zip"),
	Asset("ANIM", "anim/raft_log_build.zip"),
	Asset("ANIM", "anim/raft_surfboard_build.zip"),
	Asset("ANIM", "anim/rowboat_armored_build.zip"),
	Asset("ANIM", "anim/rowboat_basic.zip"),
	Asset("ANIM", "anim/rowboat_build.zip"),
	Asset("ANIM", "anim/rowboat_cargo_build.zip"),
	Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
	Asset("ANIM", "anim/swap_lantern_boat.zip"),
	Asset("ANIM", "anim/swap_sail.zip"),
}

local function OnSave(inst, data)
	if inst:HasTag("ocupado") then data.apaga = 1 end
end

local function OnLoad(inst, data)
	if data and data.apaga then inst:Remove() end

	inst:DoTaskInTime(0, function(inst)
		local owner = inst.components.inventoryitem.owner
		if owner ~= nil then
			owner.components.inventory:DropItem(inst)
			owner:AddComponent("driver")
			owner.components.driver:OnMount(inst)
		end
	end)
end

local function OnHammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
    SpawnAt("collapse_small", inst)
    for _, v in ipairs(inst.loottable or {}) do
        SpawnAt(v, inst)
    end
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst.components.container:DropEverything()
	inst:Remove()
end

local function OnEquipped(inst, data)
	local sailslot = inst.components.container:GetItemInSlot(1)
	if sailslot ~= nil then inst.AnimState:OverrideSymbol(sailslot.symboltooverride, sailslot.build, sailslot.symbol) end
	local luzslot = inst.components.container:GetItemInSlot(2)
	if luzslot ~= nil then inst.AnimState:OverrideSymbol(luzslot.symboltooverride, luzslot.build, luzslot.symbol) end
	if luzslot and luzslot:HasTag("boatlight") then luzslot:AddTag("nonavio") end
	if luzslot then luzslot.navio = inst end
	if sailslot then sailslot.navio = inst end
end

local function OnCollapsed(inst)
    local collapse = SpawnAt(inst.collapse, inst)
    SpawnAt("collapse_small", inst)
    if not inst.components.container or inst.components.container:IsEmpty() then
        inst:Remove()
        return
    end
    collapse:SetChest(inst)
end

local function common()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.Transform:SetFourFaced()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.banc = "rowboat"
	inst.entity:AddNetwork()
	--	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	--	inst.AnimState:SetSortOrder(0)

	MakeWaterObstaclePhysics(inst, 0.5, 2, 1.25)


	inst.AnimState:SetBank("rowboat")
	inst.AnimState:PlayAnimation("run_loop", true)

	inst.entity:AddMiniMapEntity()

	inst:AddTag("boatsw")
	inst:AddTag("barcoapto")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")

	inst.entity:AddPhysics()
	inst.Physics:SetCylinder(0.25, 2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("container")
	inst:AddComponent("interactions")
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
	inst.components.edible.hungervalue = 2
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BARCO

	inst:AddComponent("finiteuses")
	--	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1)
 
	inst:AddComponent("armor")
    inst.components.armor:SetKeepOnFinished(true)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(OnHammered)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.canbepickedup = false

	inst:ListenForEvent("itemget", OnEquipped)

    inst.OnHammer = OnHammered
    inst.OnCollapse = OnCollapsed
	inst.OnLoad = OnLoad
	inst.OnSave = OnSave

	return inst
end

local function armored()
    local inst = common()

	inst.AnimState:SetBuild("rowboat_armored_build")
	inst.overridebuild = "rowboat_armored_build"
    inst.MiniMapEntity:SetIcon("armouredboat.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("armouredboat")
	inst.components.finiteuses:SetMaxUses(500)
	inst.components.finiteuses:SetUses(500)
	inst.components.armor:InitCondition(500, 0.99)

    inst.collapse = "flotsam_armoured_build"
    inst.loottable = { "boards", "boards", "boards", "rope", "seashell",
                       "seashell", "seashell", "seashell", "seashell", }
    return inst
end

local function cargo()
    local inst = common()

	inst.AnimState:SetBuild("rowboat_cargo_build")
	inst.overridebuild = "rowboat_cargo_build"
    inst.MiniMapEntity:SetIcon("cargo.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("cargoboat")
	inst.components.finiteuses:SetMaxUses(300)
	inst.components.finiteuses:SetUses(300)
	inst.components.armor:InitCondition(300, 0.99)

    inst.collapse = "flotsam_cargo_build"
    inst.loottable = { "boards", "boards", "boards", "rope", }
    return inst
end

local function cork()
    local inst = common()

	inst.AnimState:SetBuild("coracle_boat_build")
	inst.overridebuild = "coracle_boat_build"
    inst.MiniMapEntity:SetIcon("coracle_boat.tex")

    inst:AddTag("pegabarco")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("rowboat")
	inst.components.finiteuses:SetMaxUses(80)
	inst.components.finiteuses:SetUses(80)
	inst.components.armor:InitCondition(80, 0.99)

    inst.collapse = "flotsam_lograft_build"
    inst.loottable = { "cork" }
    return inst
end

local function encrusted()
    local inst = common()

	inst.AnimState:SetBuild("rowboat_encrusted_build")
	inst.overridebuild = "rowboat_encrusted_build"
    inst.MiniMapEntity:SetIcon("encrustedboat.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("encrustedboat")
	inst.components.finiteuses:SetMaxUses(800)
	inst.components.finiteuses:SetUses(800)
	inst.components.armor:InitCondition(800, 0.99)

    inst.collapse = "flotsam_encrusted_build"
    inst.loottable = { "limestone", "limestone", "boards", "boards", "boards", }
    return inst
end

local function log_old()
    local inst = common()

	inst.AnimState:SetBank("raft")
	inst.AnimState:SetBuild("raft_log_build")
	inst.overridebuild = "raft_log_build"
	inst.banc = "raft"
    inst.MiniMapEntity:SetIcon("lograft.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("lograft_old")
	inst.components.finiteuses:SetMaxUses(150)
	inst.components.finiteuses:SetUses(150)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.armor:InitCondition(150, 0.99)

    inst.collapse = "flotsam_lograft_build"
    inst.loottable = { "log", "log", "log", "cutgrass", "cutgrass", }
    return inst
end

local function pirate()
    local inst = common()

	inst.AnimState:SetBuild("pirate_boat_build")
	inst.overridebuild = "pirate_boat_build"
    inst.MiniMapEntity:SetIcon("woodlegsboat.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("woodlegsboat")
	inst.components.finiteuses:SetMaxUses(500)
	inst.components.finiteuses:SetUses(500)
	inst.components.armor:InitCondition(500, 0.99)

    inst.collapse = "flotsam_rowboat_build"
    inst.loottable = { "boards", "boards", "dubloon", "dubloon" }
    return inst
end

local function raft_old()
    local inst = common()

	inst.AnimState:SetBank("raft")
	inst.AnimState:SetBuild("raft_build")
	inst.overridebuild = "raft_build"
	inst.banc = "raft"
    inst.MiniMapEntity:SetIcon("raft.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("raft_old")
	inst.components.finiteuses:SetMaxUses(150)
	inst.components.finiteuses:SetUses(150)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.armor:InitCondition(150, 0.99)

    inst.collapse = "flotsam_bamboo_build"
    inst.loottable = { "vine", "bamboo", "bamboo", }
    return inst
end

local function rowboat()
    local inst = common()

	inst.AnimState:SetBuild("rowboat_build")
	inst.overridebuild = "rowboat_build"
    inst.MiniMapEntity:SetIcon("rowboat.tex")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("rowboat")
	inst.components.finiteuses:SetMaxUses(250)
	inst.components.finiteuses:SetUses(250)
	inst.components.armor:InitCondition(250, 0.99)

    inst.collapse = "flotsam_rowboat_build"
    inst.loottable = { "boards", "vine", "vine" }
    return inst
end

local function surf()
    local inst = common()

	inst.AnimState:SetBank("raft")
	inst.AnimState:SetBuild("raft_surfboard_build")
	inst.overridebuild = "raft_surfboard_build"
	inst.banc = "raft"
    inst.MiniMapEntity:SetIcon("surfboard.tex")

    inst:AddTag("pegabarco")

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst.components.container:WidgetSetup("surfboard")
	inst.components.finiteuses:SetMaxUses(100)
	inst.components.finiteuses:SetUses(100)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.armor:InitCondition(100, 0.99)

    inst.collapse = "flotsam_surfboard_build"
    inst.loottable = { "seashell" }
    return inst
end

return Prefab("armouredboat", armored, assets),
       Prefab("cargoboat", cargo, assets),
       Prefab("corkboat", cork, assets),
       Prefab("encrustedboat", encrusted, assets),
       Prefab("lograft_old", log_old, assets),
       Prefab("woodlegsboat", pirate, assets),
       Prefab("raft_old", raft_old, assets),
       Prefab("rowboat", rowboat, assets),
       Prefab("surfboard", surf, assets)
       
