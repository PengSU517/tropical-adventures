------rain effect---------------
AddSimPostInit(function()
    GLOBAL.EmitterManager.old_updatefuncs = { snow = nil, rain = nil, pollen = nil }
    local old_PostUpdate = GLOBAL.EmitterManager.PostUpdate
    local function new_PostUpdate(self, ...)
        for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
            if inst.prefab == "pollen" or inst.prefab == "snow" or inst.prefab == "rain" then
                if self.old_updatefuncs[inst.prefab] == nil then
                    self.old_updatefuncs[inst.prefab] = data.updateFunc
                end
                local pt = inst:GetPosition()
                local ents = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, 40, { "interior_center" })
                if #ents > 0 then
                    data.updateFunc = function() end -- empty function
                else
                    data.updateFunc = self.old_updatefuncs[inst.prefab] ~= nil and self.old_updatefuncs[inst.prefab] or
                        function() end -- the original one
                end
            end
        end
        if old_PostUpdate ~= nil then
            return old_PostUpdate(self, ...)
        end
    end
    GLOBAL.EmitterManager.PostUpdate = new_PostUpdate
end)
