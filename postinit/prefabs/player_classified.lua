-----------------------------Treasure Reveal by EvenMr----------------------------
local function OnRevealTreasureDirty(inst)
    if inst._parent ~= nil and inst._parent.HUD and TheCamera then
        inst._parent.HUD.controls:ShowMap()
        local map = TheWorld.minimap.MiniMap
        local ang = TheCamera:GetHeading()
        local zoom = map:GetZoom()
        local posx, _, posy = inst._parent.Transform:GetWorldPosition()
        posx = math.modf(inst.revealtreasure:value() / 65536) - 16384 - posx
        posy = inst.revealtreasure:value() % 65536 - 16384 - posy
        local x = posx * math.cos(math.rad(90 - ang)) - posy * math.sin(math.rad(90 - ang))
        local y = posx * math.sin(math.rad(90 - ang)) + posy * math.cos(math.rad(90 - ang))
        map:ResetOffset()
        map:Offset(x / zoom, y / zoom)
    end
end

local function OnRegionDirty(inst)
    if inst._parent ~= nil then
        -- print("region change client")
        -- print(inst._region:value())
        --立即推送客机可能有些 内容还来不及更新
        inst._parent:PushEventInTime(0.1, "regionchange_client", { region = inst._region:value() })
    end
end


local function RegisterNetListeners(inst)
    if TheWorld.ismastersim then
        inst._parent = inst.entity:GetParent()
    else
        ----主机客机都推送的同名event放在这里
    end

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("revealtreasuredirty", OnRevealTreasureDirty)
        inst:ListenForEvent("regiondirty", OnRegionDirty)
        ----仅在客机推送的event放在这里
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst._region = net_tinybyte(inst.GUID, "regionaware._region", "regiondirty")
    inst.revealtreasure = net_uint(inst.GUID, "messagebottle_sw.reveal", "revealtreasuredirty")


    inst._region:set(1)
    inst:DoTaskInTime(0, RegisterNetListeners)
end)
