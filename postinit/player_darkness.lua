------darkness---------------
AddPlayerPostInit(function(inst)
    if GLOBAL.TheNet:GetIsServer() then
        inst.findpigruinstask = inst:DoPeriodicTask(2, function()
            local pt = inst:GetPosition()
            local interior = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, 40, { "pisodaruina" })
            if #interior > 0 and inst.LightWatcher ~= nil then
                local thresh = GLOBAL.TheSim:GetLightAtPoint(10000, 10000, 10000)
                inst.LightWatcher:SetLightThresh(0.075 + thresh)
                inst.LightWatcher:SetDarkThresh(0.05 + thresh)
            else
                inst.LightWatcher:SetLightThresh(0.075)
                inst.LightWatcher:SetDarkThresh(0.05)
            end
        end)
    end
end)
