require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pisohamlet.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	Asset("ANIM", "anim/wallhamletcity2.zip"),
}

local BASEMENT_SHADE = 0.5
local TAMANHODOMAPA = 1

local function OnSave(inst, data)
	data.entrada = inst.entrada
end


local function OnLoad(inst, data)
	if data == nil then return end
	if data.entrada then inst.entrada = data.entrada end
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

local function OnActivate(inst, doer)
	if doer:HasTag("player") then
		if doer.components.talker ~= nil then
			doer.components.talker:ShutUp()
		end
	else
		inst.SoundEmitter:PlaySound("dontstarve/cave/rope_up")
	end
end

local function OnAccept(inst, giver, item)
	inst.components.inventory:DropItem(item)
	inst.components.teleporter:Activate(item)
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

	inst.Transform:SetEightFaced()

	inst.MiniMapEntity:SetIcon("minimap_volcano_entrance.tex")

	inst:AddTag("vulcano_part")
	inst:AddTag("antlion_sinkhole_blocker")

	inst:SetDeployExtraSpacing(2.5)

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
	inst.components.teleporter.travelcameratime = 0.3
	inst.components.teleporter.travelarrivetime = 0.2

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
		local x = 0
		local y = 0
		local z = 0
		if TheWorld.components.contador then TheWorld.components.contador:Increment(1) end
		local numerounico = TheWorld.components.contador.count

		x = TheWorld.components.contador:GetX()
		y = 0
		z = TheWorld.components.contador:GetZ()

		inst.exit = SpawnPrefab("pig_shop_bank_door_saida")
		inst.exit.Transform:SetPosition(x + 5.2, 0, z + 0.5)
		---------------------------cria a parede inicio------------------------------------------------------------------	
		local tipodemuro = "wall_tigerpond"
		---------------------------cria a parede inicio -------------------------------------
		---------------------------parade dos aposento------------------------------------------------------------------	
		local y = 0

		x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
		inst.Transform:SetPosition(x, 0, z)

		local POS = {}
		for x = -5.5, 5.5 do
			for z = -8.5, 8.5 do
				if x == -5.5 or x == 5.5 or z == -8.5 or z == 8.5 then
					table.insert(POS, { x = x, z = z })
				end
			end
		end


		local count = 0
		for _, v in pairs(POS) do
			count = count + 1
			local part = SpawnPrefab(tipodemuro)
			part.Transform:SetPosition(x + v.x, 0, z + v.z)
		end


		----------------parede do fundo---------------------------------------------
		local part = SpawnPrefab("wallinteriorbank")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.8, 0, z)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		---------------------------------itens de dentro----------------------------
		local width = 15
		local depth = 10

		local part = SpawnPrefab("musac")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pigman_banker_shopkeep")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.5, 0, z)
			part.sg:GoToState("desk_pre")
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_roomglow")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_marble_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 4.99, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_marble_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 4.99, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_marble_beam")
		if part ~= nil then
			part.Transform:SetPosition(x + 4.7, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_marble_beam")
		if part ~= nil then
			part.Transform:SetPosition(x + 4.7, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock1_side")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 4, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock2_side")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock3_side")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 4, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock3_side")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 4, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock2_side")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_bank_clock1_side")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 4, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 3.3, 0, z - width / 4.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "oinc10", "oinc", 10 }
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 3.3, 0, z + width / 4.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "lucky_goldnugget", "oinc", 10 }
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.7, 0, z - width / 4.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "oinc100", "oinc", 100 }
			part.Transform:SetRotation(0)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.7, 0, z + width / 4.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "goldnugget", "oinc", 10 }
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "dubloon", "oinc", 5 }
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + 3.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "goldenbar", "oinc", 40 }
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - 3.5)
			part.startAnim = "idle_marble_dome"
			part.AnimState:PlayAnimation("idle_marble_dome")
			part.saleitem = { "nitre", "oinc", 5 }
			part.Transform:SetRotation(0)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("deco_bank_vault")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier")
		if part ~= nil then
			part.Transform:SetPosition(x - 3, 0, z - width / 4.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier")
		if part ~= nil then
			part.Transform:SetPosition(x - 3, 0, z + width / 4.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier_vert")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - 5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier_vert")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.3, 0, z - 5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier_vert")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 5)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_accademy_barrier_vert")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.3, 0, z + 5)
			part.Transform:SetRotation(0)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shelves_displaycase_metal")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - width / 2 + 0.75)
			part.Transform:SetRotation(0)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shelves_displaycase_metal")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + width / 2 - 0.75)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shelves_displaycase_metal")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.3, 0, z - width / 2 + 0.75)
			part.Transform:SetRotation(0)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shelves_displaycase_metal")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.3, 0, z + width / 2 - 0.75)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("swinging_light_bank")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.7, 0, z - width / 4.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("swinging_light_bank")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.7, 0, z + width / 4.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		------------------------portoes trancados--------------------------------
		local part = SpawnPrefab("pig_shop_bank_floor")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.7, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		----------------------------criature dentro das jaulas-------------------------------------------------------------






		inst:DoTaskInTime(0, function(inst)
			local portaentrada = SpawnPrefab("pig_shop_bank")
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

---------------------------------pisos---------------------------------------------------------------------------
local function SpawnPiso1(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisohamlet")
	inst.AnimState:SetBuild("pisohamlet")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)
	--	inst.AnimState:OverrideShade(BASEMENT_SHADE)
	--tamanho do chao
	inst.AnimState:SetScale(4.5, 4.5, 4.5)
	inst.AnimState:PlayAnimation("shop_floor_hoof_curvy")
	--inst.Transform:SetRotation(45)

	--inst.Transform:SetScale(2.82, 2.82, 2.82)

	inst:AddTag("NOCLICK")
	inst:AddTag("alt_tile")
	inst:AddTag("vulcano_part")
	inst:AddTag("shopinterior")
	inst:AddTag("interior_center")

	return inst
end

local function wall_common(build)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("wallhamletcity2")
	inst.AnimState:SetBuild("wallhamletcity2")
	inst.AnimState:PlayAnimation("shop_wall_fullwall_moulding", true)
	--    inst.AnimState:PlayAnimation("shop_wall_fullwall_moulding",true)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetScale(2.8, 2.8, 2.8)

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
	minimap:SetIcon("vamp_bat_cave.tex")

	inst.AnimState:SetBank("pig_shop_doormats")
	inst.AnimState:SetBuild("pig_shop_doormats")
	inst.AnimState:PlayAnimation("idle_antiquities")
	inst.Transform:SetRotation(90)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

	inst:AddTag("trader")
	inst:AddTag("alltrader")
	inst:AddTag("guard_entrance")
	inst:AddTag("hamletteleport")

	inst:AddTag("antlion_sinkhole_blocker")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = onaccept
	inst.components.trader.deleteitemonaccept = false

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

	inst:AddComponent("inventory")
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	return inst
end

return Prefab("pig_shop_bank_entrance", entrance),
	Prefab("pig_shop_bank_door_saida", fnescada, assets),
	Prefab("pig_shop_bank_floor", SpawnPiso1, assets),
	Prefab("wallinteriorbank", wall_common, assets)
