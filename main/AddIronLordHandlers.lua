AddModRPCHandler("Living Artifact", "UpdateControls", function(player)
	player.player_classified.artifactoverridden:set(true)
end)

AddModRPCHandler("Living Artifact", "UpdateInput", function(player, event, x, y, z)
    if event then player:PushEvent(event) end
    if x and y and z then player.targetpos = GLOBAL.Vector3(x, y ,z) end
end)

local function UpdateInput(event, pos)
	if event then GLOBAL.ThePlayer:PushEvent(event) end

	local x, y, z
	if pos then
		GLOBAL.ThePlayer.targetpos = pos
		x, y, z = pos.x, pos.y, pos.z 
	end

	SendModRPCToServer(GetModRPC("Living Artifact", "UpdateInput"), event, x, y, z)
end

TheInput:AddControlHandler(GLOBAL.CONTROL_SECONDARY, function(down)
	if GLOBAL.TheNet:IsServerPaused() or not (GLOBAL.ThePlayer and GLOBAL.ThePlayer:HasTag("ironlord")) then return end

	local event = down and "rightbuttondown" or "rightbuttonup"
	UpdateInput(event, GLOBAL.TheInput:GetWorldPosition())
end)

TheInput:AddMoveHandler(function()
	if GLOBAL.TheNet:IsServerPaused() or not (GLOBAL.ThePlayer and GLOBAL.ThePlayer:HasTag("charged")) then return end
	UpdateInput(nil, GLOBAL.TheInput:GetWorldPosition())
end)

AddClientModRPCHandler("Living Artifact", "ToggleBGM", function(on)
	if on then
        ThePlayer.SoundEmitter:KillAllSounds()
		ThePlayer.SoundEmitter:PlaySound("dontstarve_DLC003/music/iron_lord_suit", "ironlord_music")
	else
		ThePlayer.SoundEmitter:KillSound("ironlord_music")
	end
end)