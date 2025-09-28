local REGION_NAMES = REGION_NAMES
local REGIONS = REGIONS



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
    -- print("region change dirty")
    -- print(inst._region:value())
    --立即推送客机可能有些 内容还来不及更新
    if inst._parent then -----------------------这个函数似乎也有问题
        -- print("region change pushevent  client")
        inst._parent:PushEventInTime(0, "regionchange_client", { region = inst._region:value() })
    end
end


local function RegisterNetListeners(inst)
    inst._parent = inst.entity:GetParent()

    if TheWorld.ismastersim then

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


    inst._region:set(REGIONS.forest)
    inst:DoTaskInTime(0, RegisterNetListeners)
end)
