-----------------------------Treasure Reveal by EvenMr----------------------------
local function OnRevealTreasureDirty(inst)
    local m = math
    if inst._parent ~= nil and inst._parent.HUD and GLOBAL.TheCamera then
        inst._parent.HUD.controls:ShowMap()
        local map = GLOBAL.TheWorld.minimap.MiniMap
        local ang = GLOBAL.TheCamera:GetHeading()
        local zoom = map:GetZoom()
        local posx, _, posy = inst._parent.Transform:GetWorldPosition()
        posx = m.modf(inst.revealtreasure:value() / 65536) - 16384 - posx
        posy = inst.revealtreasure:value() % 65536 - 16384 - posy
        local x = posx * m.cos(m.rad(90 - ang)) - posy * m.sin(m.rad(90 - ang))
        local y = posx * m.sin(m.rad(90 - ang)) + posy * m.cos(m.rad(90 - ang))
        map:ResetOffset()
        map:Offset(x / zoom, y / zoom)
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.revealtreasure = GLOBAL.net_uint(inst.GUID, "messagebottle1.reveal", "revealtreasuredirty")
    inst:ListenForEvent("revealtreasuredirty", OnRevealTreasureDirty)
end)
