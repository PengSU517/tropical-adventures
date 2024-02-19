--------------------------------- camera------------------------------

local function OnDirtyEventCameraStuff(inst) -- this is called on client, if the server does inst.mynetvarCameraMode:set(...)
	-- local val = inst.mynetvarCameraMode:value()
	-- local fasedodia = "night"
	-- if TheWorld.state.isday then fasedodia = "day" end
	-- if TheWorld.state.isdusk then fasedodia = "dusk" end
	-- if TheWorld.state.isnight then fasedodia = "night" end
	-- if val == 1 then -- for jumping(OnActive) function
	-- 	TheCamera.controllable = false
	-- 	TheCamera.cutscene = true
	-- 	TheCamera.headingtarget = 0
	-- 	TheCamera.distancetarget = 20 + GetModConfigData("housewallajust")
	-- 	TheCamera.targetoffset = Vector3(-2.3, 1.7, 0)
	-- elseif val == 2 then
	-- 	TheCamera:SetDistance(12)
	-- elseif val == 3 then
	-- 	TheCamera:SetDefault()
	-- 	TheCamera:SetTarget(TheFocalPoint)
	-- elseif val == 4 then --for player prox
	-- 	TheCamera.controllable = false
	-- 	TheCamera.cutscene = true
	-- 	TheCamera.headingtarget = 0
	-- 	TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
	-- 	TheCamera:SetTarget(GetClosestInstWithTag("shopinterior", inst, 30))
	-- 	TheCamera.targetoffset = Vector3(2, 1.5, 0)
	-- 	TheWorld:PushEvent("underwatercave", "night")
	-- 	if not GetClosestInstWithTag("casadojogador", inst, 30) then
	-- 		TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/store", "storemusic")
	-- 	end
	-- elseif val == 5 then --for player prox
	-- 	TheCamera.controllable = false
	-- 	TheCamera.cutscene = true
	-- 	TheCamera.headingtarget = 0
	-- 	local alvodacamera = GetClosestInstWithTag("caveinterior", inst, 30)
	-- 	if alvodacamera then
	-- 		TheCamera:SetTarget(alvodacamera)
	-- 	end
	-- 	if alvodacamera and alvodacamera:HasTag("pisodaruina") then
	-- 		TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
	-- 		TheCamera.targetoffset = Vector3(6, 1.5, 0)
	-- 		TheWorld:PushEvent("underwatercave", "night")
	-- 		TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/ruins", "storemusic")
	-- 	elseif alvodacamera and alvodacamera:HasTag("pisogalleryinteriorpalace") then
	-- 		TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
	-- 		TheCamera.targetoffset = Vector3(3, 1.5, 0)
	-- 	elseif alvodacamera and alvodacamera:HasTag("pisoanthill") then
	-- 		TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
	-- 		TheCamera.targetoffset = Vector3(5, 1.5, 0)
	-- 		TheWorld:PushEvent("underwatercave", "night")
	-- 	else
	-- 		TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
	-- 		TheCamera.targetoffset = Vector3(5, 1.5, 0)
	-- 		TheWorld:PushEvent("underwatercave", "night")
	-- 	end
	-- elseif val == 6 then --for player prox
	TheCamera:SetDefault()
	TheCamera:SetTarget(TheFocalPoint)

	-- 	local fasedodia = "night"
	-- 	if TheWorld.state.isday then fasedodia = "day" end
	-- 	if TheWorld.state.isdusk then fasedodia = "dusk" end
	-- 	if TheWorld.state.isnight then fasedodia = "night" end
	-- 	TheWorld:PushEvent("underwatercaveexit", fasedodia)
	-- 	TheFocalPoint.SoundEmitter:KillSound("storemusic")
	-- elseif val == 7 then --for player prox
	-- 	TheCamera.controllable = false
	-- 	TheCamera.cutscene = true
	-- 	TheCamera.headingtarget = 0
	-- 	TheCamera.distancetarget = 28 + GetModConfigData("housewallajust")
	-- 	TheCamera:SetTarget(GetClosestInstWithTag("pisointeriorpalace", inst, 30))
	-- 	TheCamera.targetoffset = Vector3(5, 1.5, 0)
	-- elseif val == 8 then --for player prox
	-- 	TheCamera.controllable = false
	-- 	TheCamera.cutscene = true
	-- 	TheCamera.headingtarget = 0
	-- 	TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
	-- 	TheCamera:SetTarget(GetClosestInstWithTag("pisointerioruins", inst, 30)) --inst = ThePlayer
	-- 	TheCamera.targetoffset = Vector3(6, 1.5, 0)
	-- end
	-- Use val and do client related stuff
end



--TheWorld:PushEvent("underwatercave", "night")
--TheWorld:PushEvent("underwatercaveexit", "night")


local function RegisterListenersCameraStuff(inst)
	-- check that the entity is the playing player
	if inst.HUD ~= nil then
		inst:ListenForEvent("DirtyEventCameraStuff", OnDirtyEventCameraStuff)
	end
end



local function OnPlayerSpawn(inst)
	inst.mynetvarCameraMode = GLOBAL.net_tinybyte(inst.GUID, "BakuStuffNetStuff", "DirtyEventCameraStuff")
	inst.mynetvarCameraMode:set(0)
	inst:DoTaskInTime(0, RegisterListenersCameraStuff)

	inst:DoTaskInTime(0, function(inst)
		-- if GLOBAL.GetClosestInstWithTag("shopinterior", inst, 30) then
		-- 	inst.mynetvarCameraMode:set(4)
		-- elseif GLOBAL.GetClosestInstWithTag("caveinterior", inst, 30) then
		-- 	inst.mynetvarCameraMode:set(5)
		-- elseif GLOBAL.GetClosestInstWithTag("pisointeriorpalace", inst, 30) then
		-- 	inst.mynetvarCameraMode:set(7)
		-- else
		inst.mynetvarCameraMode:set(6)
		-- end
	end)
end

AddPlayerPostInit(OnPlayerSpawn)


AddClassPostConstruct("cameras/followcamera", function(Camera)
	--Camera.old = Camera.SetDefault
	function Camera:PushScreenHOffset(ref, xoffset)
		if not self.controllable then
		else
			self:PopScreenHOffset(ref)
			table.insert(self.screenoffsetstack, 1, { ref = ref, xoffset = xoffset })
		end
	end
end)
