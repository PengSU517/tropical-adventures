local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
local AOESpell = require("components/aoespell")



TROENV.AddComponentPostInit("AOESpell", function(self)
    self.spell_type = nil
    self.aoe_cast = nil

    -- cmp.SetWaveSettings = SetWaveSettings
end)

function AOESpell:SetAOESpell(inst)
    self.aoe_cast = inst
end;

function AOESpell:CanCast(doer, pos)
    local x, y, z = pos:Get()
    return self.inst.components.aoetargeting ~= nil and self.inst.components.aoetargeting.alwaysvalid or
        TheWorld.Map:IsPassableAtPoint(x, y, z) and not TheWorld.Map:IsGroundTargetBlocked(pos)
end;

function AOESpell:SetSpellFn(fn)
    self.spellfn = fn
end

-----------------怎么嵌入旧的函数呢
function AOESpell:CastSpell(doer, pos)
    if self.inst.components.reticule_spawner and (self.inst.components.recarregavel and self.inst.components.recarregavel.isready) then
        self.inst.components.reticule_spawner:Spawn(pos)
        self.inst:PushEvent("aoe_casted", { caster = doer, pos = pos })
    end;

    if self.aoe_cast ~= nil then
        self.aoe_cast(self.inst, doer, pos)
        self.inst:PushEvent("aoe_casted", { caster = doer, pos = pos })
    end;


    -----------------------------------------
    local success, reason = true, nil
    if self.spellfn then
        success, reason = self.spellfn(self.inst, doer, pos)
        if success == nil and reason == nil then
            success = true
        end
    end

    if doer and doer:IsValid() then
        doer:PushEvent("oncastaoespell", { item = self.inst, pos = pos, success = success })
    end
    ----waxwelll update------
    local livromagico = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if livromagico and livromagico.prefab == "waxwelljournal" then
        doer:DoTaskInTime(3, function(inst)
            doer.AnimState:ClearOverrideSymbol("swap_object")
            doer.AnimState:OverrideSymbol("book_closed", "swap_book_maxwellte", "book_closed")
        end)
    end

    return success, reason
end;

function AOESpell:SetSpellType(inst)
    self.spell_type = inst
end;

function AOESpell:OnSpellCast(d, j)
    d:PushEvent("spell_complete", { spell_type = self.spell_type })
end;
