local a = Class(function(self, b)
    self.inst = b;
    self.onparrystart = nil;
    self.duration = 2;
    b:AddTag("parryweapon")


    self.arc = 178
    self.onpreparryfn = nil
    self.onparryfn = nil
end)

function a:SetOnParryStartFn(c) self.onparrystart = c end;

function a:OnRemoveFromEntity()
    self.inst:RemoveTag("parryweapon")
end

function a:SetParryArc(arc)
    self.arc = arc
end

--This is purely for stategraph animation sfx, can actually be bypassed!
function a:SetOnPreParryFn(fn)
    self.onpreparryfn = fn
end

function a:SetOnParryFn(fn)
    self.onparryfn = fn
end

function a:OnPreParry(d)
    if d.sg then d.sg:PushEvent("start_parry") end;
    if self.onparrystart then self.onparrystart(self.inst, d) end

    if self.onpreparryfn ~= nil then
        self.onpreparryfn(self.inst, doer)
    end
end;

function a:EnterParryState(doer, rot, duration)
    doer:PushEvent("combat_parry", { weapon = self.inst, direction = rot, duration = duration })
end

function a:TryParry(doer, attacker, damage, weapon, stimuli)
    if doer.sg then doer.sg:PushEvent("try_parry") end;
    if self.ontryparry then return self.ontryparry(doer, attacker, damage, weapon, stimuli) end;

    local i = attacker or weapon;
    local j = doer.Transform:GetRotation() - doer:GetAngleToPoint(i.Transform:GetWorldPosition())
    if not (math.abs(j) <= 70) then return false end;

    local k = i.components.weapon and i.components.weapon.damagetype or
        i.components.combat and i.components.combat.damagetype or nil;


    --if not(k==DAMAGETYPES.PHYSICAL)then return false end;

    --da atualização

    if (stimuli ~= nil and stimuli ~= "stun") or attacker:HasTag("groundspike") then
        return false
    end
    --first check if doer is facing attacker
    local rot = doer.Transform:GetRotation()
    local drot = math.abs(rot - doer:GetAngleToPoint(attacker.Transform:GetWorldPosition()))
    while drot > 180 do
        drot = drot - 360
    end
    local threshold = self.arc * .5
    if math.abs(drot) >= threshold then
        --if not, check if locomotor attacker is facing doer (could be a charge attack, going thru the parry)
        if attacker.components.locomotor == nil then
            return false
        end
        drot = math.abs(rot - attacker.Transform:GetRotation() + 180)
        while drot > 180 do
            drot = drot - 360
        end
        if math.abs(drot) >= threshold then
            return false
        end
    end
    if self.onparryfn ~= nil then
        self.onparryfn(self.inst, doer, attacker, damage)
    end

    return true
end;

return a
