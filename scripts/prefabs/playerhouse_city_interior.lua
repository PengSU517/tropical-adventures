require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_house_sale.zip"),
	Asset("ANIM", "anim/pisohamlet.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	Asset("ANIM", "anim/wallhamletcity1.zip"),
	Asset("ANIM", "anim/wallhamletcity2.zip"),
}




--------------------------------room floor--------------------------------------------------------------------------

local function OnSave1(inst, data)
	data.floorpaper = inst.floorpaper
end


local function OnLoad1(inst, data)
	if data == nil then return end
	if data.floorpaper then
		inst.floorpaper = data.floorpaper

		inst.AnimState:PlayAnimation(inst.floorpaper, true)
	end
end


local function FloorFn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	-- inst.Transform:SetScale(1, 1, 1.2)
	inst.AnimState:SetBank("pisohamlet")
	inst.AnimState:SetBuild("pisohamlet")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
	-- inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(0)

	inst.AnimState:SetScale(5, 6.8, 1) ---- y设置宽度，z无用

	inst.AnimState:PlayAnimation("noise_woodfloor")
	inst:AddTag("alt_tile")
	inst:AddTag("vulcano_part")
	inst:AddTag("shopinterior")
	inst:AddTag("casadojogador")
	inst:AddTag("canbuild")
	inst:AddTag("pisohousehamlet")
	inst:AddTag("interior_center")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")



	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("interactions")

	inst:DoTaskInTime(1, function(inst)
		local prot = SpawnPrefab("wallrenovation")
		local prot1 = SpawnPrefab("wallrenovation")
		local a, b, c = inst.Transform:GetWorldPosition()
		if prot and prot1 then
			prot.Transform:SetPosition(a + 2, b, c + 4)
			prot1.Transform:SetPosition(a + 2, b, c - 4)
		end
	end)



	inst.OnSave = OnSave1
	inst.OnLoad = OnLoad1

	return inst
end







---------------------------wall protoryper-----------------------------

local function OnTurnOn(inst)
	inst.components.prototyper.on = true -- prototyper doesn't set this until after this function is called!!
end

local function OnTurnOff(inst)
	inst.components.prototyper.on = false
end

local function WallFn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	-- inst.AnimState:SetBank("pisohamlet")
	-- inst.AnimState:SetBuild("pisohamlet")
	-- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	-- inst.AnimState:SetLayer(LAYER_BACKGROUND) ----设置这一行就会放在最下层
	-- inst.AnimState:SetSortOrder(5)
	-- inst.Transform:SetScale(0, 0, 0)
	-- inst.AnimState:PlayAnimation("noise_woodfloor")

	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("prototyper")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.HOME_TWO
	inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.onturnon = OnTurnOn

	return inst
end


--------------------------------------wall--------------------------------
local function OnSave(inst, data)
	data.house = inst.house or nil
	data.wallpaper = inst.wallpaper
end


local function OnLoad(inst, data)
	if data and data.house ~= nil then
		inst.house = data.house or true
	end
	if data and data.wallpaper then
		inst.wallpaper = data.wallpaper

		local is2 = inst.wallpaper == "harlequin_panel" or inst.wallpaper == "shop_wall_fullwall_moulding" or
			inst.wallpaper == "shop_wall_floraltrim2" or inst.wallpaper == "shop_wall_upholstered"

		if is2 then
			inst.AnimState:SetBank("wallhamletcity2")
			inst.AnimState:SetBuild("wallhamletcity2")
		else
			inst.AnimState:SetBank("wallhamletcity1")
			inst.AnimState:SetBuild("wallhamletcity1")
		end

		if type(inst.wallpaper) == "string" then
			inst.AnimState:PlayAnimation(inst.wallpaper, true)
		else
			inst.AnimState:PlayAnimation("shop_wall_woodwall", true)
		end
	end
end



local function wall_common(build)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("wallhamletcity1")
	inst.AnimState:SetBuild("wallhamletcity1")
	inst.AnimState:PlayAnimation("shop_wall_woodwall", true)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetScale(4.65, 3.7, 1) ----SetScale(2.8, 2.8, 2.8) 对于墙纸，x控制宽度，y控制高度，z无用

	inst:AddTag("wallhousehamlet")
	inst:AddTag("DECOR")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("interactions")


	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

----------------------------------------------------------doormat-----------------------------------------------------------------------------
local function OnDoneTeleporting(inst, obj)
	if obj and obj:HasTag("player") then
		obj.mynetvarCameraMode:set(4)
	end

	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end

local function OnActivate(inst, doer)
	if doer and doer:HasTag("player") then
		doer.mynetvarCameraMode:set(6) ------------------这个暂时留着----------有的地方切不了视角
		if doer.SoundEmitter then
			doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
		end
	end

	if inst.SoundEmitter then
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
	end
end

local function OnActivateByOther(inst, source, doer)
	--    if not inst.sg:HasStateTag("open") then
	--        inst.sg:GoToState("opening")
	--    end
end

local function onaccept(inst, giver, item)
	inst.components.inventory:DropItem(item)
	inst.components.teleporter:Activate(item)
end



local function OnHaunt(inst, haunter)
	inst.components.teleporter:Activate(haunter)
end

local function DoorMatFn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vamp_bat_cave.tex")

	inst.AnimState:SetBank("pig_shop_doormats")
	inst.AnimState:SetBuild("pig_shop_doormats")
	inst.AnimState:PlayAnimation("idle_old")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	MakeObstaclePhysics(inst, 0) ------------不加这一行反而没有碰撞体积了
	inst.entity:AddPhysics()
	inst.Physics:ClearCollisionMask()
	inst.Physics:SetSphere(1)

	inst.Transform:SetRotation(90)

	inst:AddTag("trader")
	inst:AddTag("alltrader")
	inst:AddTag("hamletteleport")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = onaccept
	inst.components.trader.deleteitemonaccept = false

	-- inst:AddComponent("playerprox")
	-- inst.components.playerprox:SetDist(10, 13)
	-- inst.components.playerprox:SetOnPlayerNear(onopen)
	-- inst.components.playerprox:SetOnPlayerFar(onclose)

	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

	inst:AddComponent("teleporter")
	inst.components.teleporter.onActivate = OnActivate
	inst.components.teleporter.onActivateByOther = OnActivateByOther
	inst.components.teleporter.offset = 0
	inst.components.teleporter.hamlet = true
	inst.components.teleporter.travelcameratime = 0.3
	inst.components.teleporter.travelarrivetime = 0
	inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	inst:AddComponent("inventory")

	return inst
end


local function RoomCenterFn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	-- inst.AnimState:SetBank("pisohamlet")
	-- inst.AnimState:SetBuild("pisohamlet")
	-- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	-- inst.AnimState:SetLayer(LAYER_BACKGROUND) ----设置这一行就会放在最下层
	-- inst.AnimState:SetSortOrder(5)
	-- inst.Transform:SetScale(0, 0, 0)
	-- inst.AnimState:PlayAnimation("noise_woodfloor")

	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("interior_center") -----判断地皮
	-- inst:AddTag("shopinterior") ----控制视角

	inst:AddTag("alt_tile")
	inst:AddTag("vulcano_part")
	-- inst:AddTag("shopinterior")
	inst:AddTag("casadojogador")
	inst:AddTag("canbuild")
	inst:AddTag("pisohousehamlet")



	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false


	return inst
end












return Prefab("playerhouse_city_door_saida", DoorMatFn, assets),
	Prefab("playerhouse_city_floor", FloorFn, assets),
	Prefab("wallinteriorplayerhouse", wall_common, assets),
	Prefab("wallrenovation", WallFn, assets),
	Prefab("playerhouse_center", RoomCenterFn, assets)
