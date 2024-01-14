--------------------开启糖果屋之后就不能放置建筑了，应该是某些同名函数被覆盖了
require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pisohamlet.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	Asset("ANIM", "anim/wallhamletcity1.zip"),
	Asset("ANIM", "anim/wallhamletcity2.zip"),
}

local BASEMENT_SHADE = 0.5
local TAMANHODOMAPA = 1

local function OnSave(inst, data)
	data.entrada = inst.entrada
	data.wallpaper = inst.wallpaper
end


local function OnLoad(inst, data)
	if data == nil then return end
	if data.entrada then inst.entrada = data.entrada end
	if data.wallpaper then
		inst.wallpaper = data.wallpaper
		inst.AnimState:SetBank("wallhamletcity1")
		inst.AnimState:SetBuild("wallhamletcity1")
		if type(inst.wallpaper) == "string" then
			inst.AnimState:PlayAnimation(inst.wallpaper, true)
		else
			inst.AnimState:PlayAnimation("shop_wall_woodwall", true)
		end
	end
end

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

local function OnActivateByOther(inst, source, doer)
	--	if not inst.sg:HasStateTag("open") then
	--		inst.sg:GoToState("opening")
	--	end
	if doer ~= nil and doer.Physics ~= nil then
		doer.Physics:CollidesWith(COLLISION.WORLD)
	end
end

local function ExitOnActivateByOther(inst, other, doer)
	if doer ~= nil
		and doer.sg ~= nil and not doer:HasTag("playerghost") then
		doer.sg.statemem.teleportarrivestate = "idle"
	end
end

local function PlayTravelSound(inst, doer)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end

local function ReceiveItem(teleporter, item)
	if item.Transform ~= nil then
		local x, y, z = teleporter.inst.Transform:GetWorldPosition()
		local angle = math.random() * 2 * PI

		if item.Physics ~= nil then
			item.Physics:Stop()
			if teleporter.inst:IsAsleep() then
				local radius = teleporter.inst:GetPhysicsRadius(0) + math.random()
				item.Physics:Teleport(x + math.cos(angle) * radius, 0, z - math.sin(angle) * radius)
			else
				TemporarilyRemovePhysics(item, 1)
				local speed = 2 + math.random() * .5 + teleporter.inst:GetPhysicsRadius(0)
				item.Physics:Teleport(x, 4, z)
				item.Physics:SetVel(speed * math.cos(angle), -1, speed * math.sin(angle))
			end
		else
			local radius = 2 + math.random()
			item.Transform:SetPosition(x + math.cos(angle) * radius, 0, z - math.sin(angle) * radius)
		end
	end
end

local function OnMouseOver(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	inst.highlightchildren = TheSim:FindEntities(x, y, z, 0, { "DECOR" })
end

local function OnActivate(inst, doer)
	if doer:HasTag("player") then
		if doer.components.talker ~= nil then
			doer.components.talker:ShutUp()
		end
	else
		inst.SoundEmitter:PlaySound("dontstarve/cave/rope_up")
	end
end

local function TakeLightSteps(light, value)
	local function LightToggle(light)
		light.level = (light.level or 0) + value
		if (value > 0 and light.level <= 1) or (value < 0 and light.level > 0) then
			light.Light:SetRadius(light.level)
			light.lighttoggle = light:DoTaskInTime(2 * FRAMES, LightToggle)
		elseif value < 0 then
			light.Light:Enable(false)
			light:Hide()
		end
		light.AnimState:SetScale(light.level, 1)
	end
	if light.lighttoggle ~= nil then
		light.lighttoggle:Cancel()
	end
	light.lighttoggle = light:DoTaskInTime(2 * FRAMES, LightToggle)
end

local function OnAccept(inst, giver, item)
	inst.components.inventory:DropItem(item)
	inst.components.teleporter:Activate(item)
end

local function IsNearBasement(x, y, z)
	return #TheSim:FindEntities(x, 0, z, 100, { "alt_tile" }) > 0
end

local function entrance()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	--    inst.AnimState:SetBuild("palace")
	--    inst.AnimState:SetBank("palace")
	--    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetFinalOffset(2)

	inst.Transform:SetEightFaced() -------八个面是干啥呢

	-- inst.MiniMapEntity:SetIcon("minimap_volcano_entrance.tex")

	inst:AddTag("vulcano_part")
	inst:AddTag("antlion_sinkhole_blocker")

	inst:SetDeployExtraSpacing(2.5) -------------------这个难道是放置的spacing

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("mouseover", OnMouseOver)
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end


	inst:AddComponent("inspectable")
	--    inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("teleporter")
	inst.components.teleporter.onActivate = OnActivate
	inst.components.teleporter.onActivateByOther = OnActivateByOther
	inst.components.teleporter.offset = 0
	inst.components.teleporter.travelcameratime = 0.6
	inst.components.teleporter.travelarrivetime = 0.5

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = OnAccept
	inst.components.trader.deleteitemonaccept = false


	--		if inst.components.teleporter.targetTeleporter ~= nil then
	--		inst:RemoveEventCallback("onbuilt", OnBuilt)
	--		return
	--	end
	if inst.entrada == nil then
		local size = 1
		local length = 7 * size --5.5
		local width = 10 * size --8.5

		local x = 0
		local y = 0
		local z = 0

		if TheWorld.components.contador then TheWorld.components.contador:Increment(1) end
		local numerounico = TheWorld.components.contador.count

		x = TheWorld.components.contador:GetX()
		z = TheWorld.components.contador:GetZ()

		inst.exit = SpawnPrefab("playerhouse_city_door_saida")
		inst.exit.Transform:SetPosition(x + 5.5 * size, 0, z)

		-- x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
		-- inst.Transform:SetPosition(x, 0, z)

		local POS = {}
		for x = -length, length do
			for z = -width, width do
				if x == -length or x == (length) or z == -width or z == width then
					table.insert(POS, { x = x, z = z })
				end
			end
		end


		local count = 0
		for _, v in pairs(POS) do
			count = count + 1
			local part = SpawnPrefab("house_wall2")
			part.Transform:SetPosition(x + v.x, 0, z + v.z)
		end


		----------------parede do fundo---------------------------------------------

		local part = SpawnPrefab("wallinteriorplayerhouse") -----------墙纸贴图
		if part ~= nil then
			part.Transform:SetPosition(x - 3.5 * size, 0, z)
			part.Transform:SetRotation(90)
		end

		local part = SpawnPrefab("playerhouse_city_floor")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.5 * size, 0, z) -----------------怪不得，这是视角的中心
		end



		-- local part = SpawnPrefab("playerhouse_room_pedra_cima")
		-- if part ~= nil then
		-- 	part.Transform:SetPosition(x - 6.5, 0, z + 3.9)
		-- 	part.Transform:SetRotation(90)

		-- end

		-- local part = SpawnPrefab("deco_roomglow") ---这个是光亮效果？-------仍然不知道啥用
		-- if part ~= nil then
		-- 	part.Transform:SetPosition(x, 0, z)
		-- end

		local part = SpawnPrefab("shelves_cinderblocks")
		if part ~= nil then
			part.Transform:SetPosition(x - 5.5 * size, 0, z - 4 * size)
			part.Transform:SetRotation(-90)
		end

		local part = SpawnPrefab("deco_antiquities_wallfish") ---刚建的时候贴图是丢失的，重新加载之后反而没事了
		--门也是替代的这个墙纸
		if part ~= nil then
			part.Transform:SetPosition(x - 6.5 * size, 0, z + 4 * size)
			part.Transform:SetRotation(90)
		end

		local part = SpawnPrefab("deco_antiquities_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 6.5 * size, 0, z - 11 * size)
			--	part.Transform:SetRotation(180)
			part.Transform:SetScale(1, 1.3, 1) ---设置z没用
		end

		local part = SpawnPrefab("deco_antiquities_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 6.5 * size, 0, z + 11 * size)
			part.Transform:SetRotation(90)
			part.Transform:SetScale(1, 1.3, 1) ---设置z没用
		end

		local part = SpawnPrefab("deco_antiquities_cornerbeam2")
		if part ~= nil then
			part.Transform:SetPosition(x + 6.5 * size, 0, z - 11 * size)
			--	part.Transform:SetRotation(180)
			part.Transform:SetScale(1, 1.2, 1)
		end

		local part = SpawnPrefab("deco_antiquities_cornerbeam2")
		if part ~= nil then
			part.Transform:SetPosition(x + 6.5 * size, 0, z + 11 * size)
			part.Transform:SetRotation(180)
			part.Transform:SetScale(1, 1.2, 1) ---设置z没用
		end


		local part = SpawnPrefab("swinging_light_rope_1")
		if part ~= nil then
			part.Transform:SetPosition(x - 0 * size, 3, z)
			part.Transform:SetRotation(-90)
		end

		-- local part = SpawnPrefab("charcoal")
		-- if part ~= nil then
		-- 	part.Transform:SetPosition(x - 3*size, 0, z - 2*size)
		-- 	if part.components.health ~= nil then
		-- 		part.components.health:SetPercent(1)
		-- 	end
		-- end

		-- local part = SpawnPrefab("charcoal")
		-- if part ~= nil then
		-- 	part.Transform:SetPosition(x + 2*size, 0, z + 3*size)
		-- 	if part.components.health ~= nil then
		-- 		part.components.health:SetPercent(1)
		-- 	end
		-- end

		local part = SpawnPrefab("window_round_curtains_nails") -----------之前的亮度设置时通过窗户影响光亮的，反而灯没有受影响
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + 11 * size)
			part.Transform:SetRotation(90)
		end

		local part = SpawnPrefab("window_round_curtains_nails") -----------之前的亮度设置时通过窗户影响光亮的，反而灯没有受影响
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - 11 * size)
			-- part.Transform:SetRotation(90)
		end


		if inst.caverna == nil then
			inst.caverna = 1
		end


		--------------------------------------------cria o piso e itens fim -------------------------------------------------------	
		inst:DoTaskInTime(0, function(inst)
			local portaentrada = SpawnPrefab("playerhouse_city")
			local a, b, c = inst.Transform:GetWorldPosition()
			portaentrada.Transform:SetPosition(a, b, c)
			portaentrada.components.teleporter.targetTeleporter = inst.exit
			inst.exit.components.teleporter.targetTeleporter = portaentrada
			portaentrada.AnimState:PlayAnimation("place")
			portaentrada.AnimState:PushAnimation("idle")

			inst:Remove()
		end)




		inst.entrada = 1
	end

	inst.components.teleporter.targetTeleporter = inst.exit
	inst.exit.components.teleporter.targetTeleporter = inst
	inst:ListenForEvent("starttravelsound", PlayTravelSound)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

local function OnTurnOn(inst)
	inst.components.prototyper.on = true -- prototyper doesn't set this until after this function is called!!
end

local function OnTurnOff(inst)
	inst.components.prototyper.on = false -- prototyper doesn't set this until after this function is called
end

---------------------------------pisos---------------------------------------------------------------------------
local function SpawnPiso1(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	-- inst.Transform:SetScale(1, 1, 1.2)
	inst.AnimState:SetBank("pisohamlet")
	inst.AnimState:SetBuild("pisohamlet")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)

	inst.AnimState:SetScale(5, 7, 1) ---- y设置宽度，z无用

	inst.AnimState:PlayAnimation("noise_woodfloor")
	-- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	-- inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
	-- inst.AnimState:SetSortOrder(0)
	--inst.Transform:SetRotation(45)

	--inst.Transform:SetScale(2.82, 2.82, 2.82)

	-- inst:AddComponent("prototyper")
	-- inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.HOME_TWO
	-- inst.components.prototyper.onturnoff = OnTurnOff
	-- inst.components.prototyper.onturnon = OnTurnOn

	--	inst:AddTag("NOCLICK")
	inst:AddTag("alt_tile")
	inst:AddTag("vulcano_part")
	inst:AddTag("shopinterior")
	inst:AddTag("casadojogador")
	inst:AddTag("canbuild")
	inst:AddTag("pisohousehamlet")
	inst:AddTag("blows_air")

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
			prot.Transform:SetPosition(a + 2, b, c + 3)
			prot1.Transform:SetPosition(a + 2, b, c - 3)
		end
	end)

	--------------------直接用这一部分不显示图标，但是能用科技栏
	-- inst:AddTag("NOBLOCK")
	-- inst:AddTag("NOCLICK")
	-- inst:AddTag("prototyper")

	-- inst.entity:SetPristine()

	-- if not TheWorld.ismastersim then
	-- 	return inst
	-- end

	-- inst.persists = false

	-- inst:AddComponent("prototyper")
	-- inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.HOME_TWO
	-- inst.components.prototyper.onturnoff = OnTurnOff
	-- inst.components.prototyper.onturnon = OnTurnOn

	inst.OnSave = OnSave1
	inst.OnLoad = OnLoad1

	return inst
end

local function SpawnPiso2(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisohamlet")
	inst.AnimState:SetBuild("pisohamlet")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND) ----设置这一行就会放在最下层
	inst.AnimState:SetSortOrder(5)
	inst.Transform:SetScale(0, 0, 0)
	inst.AnimState:PlayAnimation("noise_woodfloor")

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

local function wall_common(build)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("wallhamletcity1")
	inst.AnimState:SetBuild("wallhamletcity1")
	inst.AnimState:PlayAnimation("shop_wall_woodwall", true)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetScale(4, 3.5, 1) ----SetScale(2.8, 2.8, 2.8) 对于墙纸，x控制宽度，y控制高度，z无用

	inst:AddTag("wallhousehamlet")
	inst:AddTag("liberado")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("interactions")


	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

----------------------------------------------------------entrada-----------------------------------------------------------------------------
local function OnDoneTeleporting(inst, obj)
	if obj and obj:HasTag("player") then
		obj.mynetvarCameraMode:set(4)
	end
end

local function OnActivate(inst, doer)
	if doer:HasTag("player") then
		ProfileStatsSet("wormhole_used", true)
		doer.mynetvarCameraMode:set(6)
		local other = inst.components.teleporter.targetTeleporter
		if other ~= nil then
			DeleteCloseEntsWithTag("WORM_DANGER", other, 15)
		end

		if doer.components.talker ~= nil then
			doer.components.talker:ShutUp()
		end

		--Sounds are triggered in player's stategraph
	elseif inst.SoundEmitter ~= nil then
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
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

local function StartTravelSound(inst, doer)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
	--    doer:PushEvent("wormholetravel", WORMHOLETYPE.WORM) --Event for playing local travel sound
end

local function onclose(inst)

end

local function onopen(inst, doer)
	doer.mynetvarCameraMode:set(4)
end

local function OnHaunt(inst, haunter)
	inst.components.teleporter:Activate(haunter)
end

local function fnescada()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vamp_bat_cave.png")

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
	inst:AddTag("guard_entrance")
	inst:AddTag("hamletteleport")
	inst:AddTag("liberado")

	inst:AddTag("antlion_sinkhole_blocker")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = onaccept
	inst.components.trader.deleteitemonaccept = false

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(10, 13)
	inst.components.playerprox:SetOnPlayerNear(onopen)
	inst.components.playerprox:SetOnPlayerFar(onclose)

	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

	inst:AddComponent("teleporter")
	inst.components.teleporter.onActivate = OnActivate
	inst.components.teleporter.onActivateByOther = OnActivateByOther
	inst.components.teleporter.offset = 0
	inst.components.teleporter.hamlet = true
	inst.components.teleporter.travelcameratime = 0.2
	inst.components.teleporter.travelarrivetime = 0.1
	inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
	inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	inst:AddComponent("inventory")

	return inst
end

return Prefab("playerhouse_city_entrance", entrance),
	Prefab("playerhouse_city_door_saida", fnescada, assets),
	Prefab("playerhouse_city_floor", SpawnPiso1, assets),
	Prefab("wallinteriorplayerhouse", wall_common, assets),
	Prefab("wallrenovation", SpawnPiso2, assets)
