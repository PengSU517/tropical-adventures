require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pisohamlet.zip"),
	Asset("ANIM", "anim/wallhamletpig.zip"),
	Asset("ANIM", "anim/palace.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	Asset("ANIM", "anim/palace_door.zip"),
	Asset("ANIM", "anim/interior_wall_decals_palace.zip"),
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
	inst.SoundEmitter:PlaySound("dontstarve/cave/rope_down")
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
		local x = 0
		local y = 0
		local z = 0
		if TheWorld.components.contador then TheWorld.components.contador:Increment(1) end
		local numerounico = TheWorld.components.contador.count

		x = TheWorld.components.contador:GetX()
		y = 0
		z = TheWorld.components.contador:GetZ()

		inst.exit = SpawnPrefab("pig_shop_general_door_saida")
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
		local part = SpawnPrefab("wallinteriorgeneral")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.8, 0, z)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		---------------------------------------------------------------------------

		local part = SpawnPrefab("pigman_eskimo_shopkeep")
		if part ~= nil then
			part.Transform:SetPosition(x - 1, 0, z + 4)
			part.sg:GoToState("desk_pre")
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("musac")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
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

		local part = SpawnPrefab("shelves_wood")
		if part ~= nil then
			part.Transform:SetPosition(x - 4.5, 0, z - 4)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shelves_wood2")
		if part ~= nil then
			part.Transform:SetPosition(x - 4.5, 0, z + 4)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("rug_hedgehog")
		if part ~= nil then
			part.Transform:SetPosition(x - 0.2, 0, z + 4)
			part.Transform:SetRotation(90)
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

		local part = SpawnPrefab("deco_wood_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 5, 0, z + 15 / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_wood_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - 5, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_wood_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x + 5, 0, z + 15 / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_wood_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x + 5, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_general_hangingpans")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - 15 / 2 + 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_general_hangingscale")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 6)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("swinging_light_chandalier_candles")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.3, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_general_trough")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_general_trough")
		if part ~= nil then
			part.Transform:SetPosition(x + 3, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("window_round")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("window_round_light")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - 15 / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("window_round")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z + 15 / 2)
			part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("window_round_light")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z + 15 / 2)
			part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end



		---------------------------------------------------	

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.8, 0, z - 4.1)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.saleitem = { "swbait", "oinc", 5 }
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.8, 0, z - 1.9)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 0.3)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.1, 0, z - 4.4)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.3, 0, z - 2.2)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.1, 0, z)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z + 5)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z + 2.5)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 4, 0, z + 5)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.shoptype = "pig_shop_fishing"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 4, 0, z + 2.5)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.saleitem = { "boat_item", "oinc", 5 }
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 4, 0, z - 2.2)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.saleitem = { "oar", "oinc", 1 }
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 4, 0, z - 4.4)
			part.startAnim = "idle_barrel_dome"
			part.AnimState:PlayAnimation("idle_barrel_dome")
			part.saleitem = { "oceanfishingrod", "oinc", 5 }
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		--[[
	local part = SpawnPrefab("shop_buyer")
	if part ~= nil then
	part.Transform:SetPosition(x +0.5, 0, z +7)
	part.startAnim = "idle_barrel_dome"
	part.AnimState:PlayAnimation("idle_barrel_dome")
	part.saleitem =  {"axe","oinc",2}
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end		
	
	
	local part = SpawnPrefab("shop_buyer")
	if part ~= nil then
	part.Transform:SetPosition(x +0.5, 0, z +6)
	part.startAnim = "idle_barrel_dome"
	part.AnimState:PlayAnimation("idle_barrel_dome")
	part.saleitem =  {"machete","oinc",3}
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	

	local part = SpawnPrefab("shop_buyer")
	if part ~= nil then
	part.Transform:SetPosition(x +0.5, 0, z +6)
	part.startAnim = "idle_barrel_dome"
	part.AnimState:PlayAnimation("idle_barrel_dome")
	part.saleitem =  {"pickaxe","oinc",3}
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end		
	
	
]]
		------------------------portoes trancados--------------------------------
		local part = SpawnPrefab("pig_shop_general_floor")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.5, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		----------------------------criature dentro das jaulas-------------------------------------------------------------

		if inst.caverna == nil then
			inst.caverna = 1
		end


		--------------------------------------------cria o piso e itens fim -------------------------------------------------------	

		inst:DoTaskInTime(1, function(inst)
			local portaentrada = SpawnPrefab("pig_palace2")
			local a, b, c = inst.Transform:GetWorldPosition()
			portaentrada.Transform:SetPosition(a, b, c)
			portaentrada.components.teleporter.targetTeleporter = inst.exit
			inst.exit.components.teleporter.targetTeleporter = portaentrada

			inst:Remove()
		end)




		inst.entrada = 1
	end


	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end


return Prefab("pig_palace2_entrance", entrance)
