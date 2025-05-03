require "prefabutil"

local assets = {Asset("ANIM", "anim/flotsam_armoured_build.zip"), Asset("ANIM", "anim/flotsam_cargo_build.zip"),
                Asset("ANIM", "anim/flotsam_bamboo_build.zip"), Asset("ANIM", "anim/flotsam_debris_sw.zip"),
                Asset("ANIM", "anim/flotsam_lograft_build.zip"), Asset("ANIM", "anim/flotsam_rowboat_build.zip"),
                Asset("ANIM", "anim/flotsam_surfboard_build.zip")}

local function onhammered(inst)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    if inst.chest then
        inst.chest.components.container:DropEverything(inst:GetPosition())
    end
    inst:Remove()
end

local function OnPicked(inst, picker, loot)
	local empty = true
	if inst.chest and inst.chest.components.container then
		local loots = {}
		for k, v in pairs(inst.chest.components.container.slots) do
			table.insert(loots, v)
		end
		if #loots > 0 then
			local item = loots[math.random(#loots)]
			if picker and picker.components.inventory then
				item = inst.chest.components.container:RemoveItem(item, true, nil, true)
				picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
			else
				local slot = inst.chest.components.container:GetItemSlot(item)
				inst.chest.components.container:DropItemBySlot(slot, inst:GetPosition(), true)
			end
		end
		empty = inst.chest.components.container:IsEmpty()
	end
	if empty then
		local fx = SpawnAt("collapse_small", inst)
		fx:SetMaterial("wood")
        for _, v in ipairs(inst.chest and inst.chest.loottable or {}) do
            Launch(SpawnAt(v, inst), inst)
        end
        inst:Remove()
	end
end

local function SetChest(inst, chest)
    inst.chest = chest
    if chest.components.workable then
        chest.components.workable:SetWorkable(false)
    end
    chest:RemoveFromScene()
    chest.entity:SetParent(inst.entity)
    chest.Transform:SetPosition(0, 0, 0)
end

local function MakeCollapse(name, loots, buildoverride)
    local build = "flotsam_" .. (buildoverride or name) .. "_build"
    name = "flotsam_" .. name .. "_build"
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        MakeObstaclePhysics(inst, 0.3)

        inst.AnimState:SetBank("flotsam_debris_sw")
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle", true)
        local ondas = SpawnPrefab("float_fx_front")
        ondas.entity:SetParent(inst.entity)
        ondas.Transform:SetPosition(0, 0, 0)
        ondas.AnimState:PlayAnimation("idle_front_small", true)
        ondas.Transform:SetScale(0.8, 0.8, 0.8)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.WOOD
        inst.components.edible.healthvalue = 0
        inst.components.edible.hungervalue = 0

        MakeLargeBurnable(inst)
        MakeLargePropagator(inst)

        inst:AddComponent("hauntable")
        inst:AddComponent("inspectable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)

        inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_wood"
		inst.components.pickable.onpickedfn = OnPicked
		inst.components.pickable:SetUp(nil, 0)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loots)

        inst.SetChest = SetChest

        local Remove = inst.Remove
        inst.Remove = function(self, ...)
            if self.chest then
                self:RemoveChild(self.chest)
                self.chest:Remove()
            end
            Remove(self, ...)
        end

        return inst
    end
    return Prefab(name, fn, assets)
end

return MakeCollapse("armoured", {"boards"}),
       MakeCollapse("cargo", {"boards"}),
       MakeCollapse("bamboo", {"bamboo"}),
       MakeCollapse("lograft", {"log"}),
       MakeCollapse("rowboat", {"boards"}),
       MakeCollapse("surfboard", {"log"}),
       MakeCollapse("encrusted", {"limestone"}, "cargo")