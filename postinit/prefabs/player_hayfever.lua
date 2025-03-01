local function OnDeath(inst, data)
    if inst.components.hayfever ~= nil then
        inst.components.hayfever:Disable()
    end
end

local function OnRespawnFromGhost(inst, data)
    if inst.components.hayfever ~= nil then
        inst.components.hayfever:OnHayFever(TheWorld.state.ishayfever)
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if TUNING.hayfever then
        if not inst.components.hayfever then
            inst:AddComponent("hayfever")
        end
        -- inst:ListenForEvent("death", OnDeath)
        -- inst:ListenForEvent("respawnfromghost", OnRespawnFromGhost)
    end
end)
