local a=Class(function(self,inst)
self.inst=inst;
self.range=4;
self.damage=nil;
self.stimuli=nil;
self.onleap=nil 


    self.aoeradius = 4
    self.physicspadding = 3

    --self.onpreleapfn = nil
    --self.onleaptfn = nil

    --V2C: Recommended to explicitly add tag to prefab pristine state
    inst:AddTag("aoeweapon_leap")
end)

local TOSS_MUSTTAGS = { "_inventoryitem" }
local TOSS_CANTTAGS = { "locomotor", "INLIMBO" }

function a:SetAOERadius(radius)
    self.aoeradius = radius
end

function a:SetOnPreLeapFn(fn)
    self.onpreleapfn = fn
end

function a:SetOnLeaptFn(fn)
    self.onleaptfn = fn
end


function a:SetRange(c)
self.range=c 
end;

function a:SetStimuli(d)
self.stimuli=d end;

function a:SetOnLeapFn(e)
self.onleap=e end;

function a:DoLeap(doer,startingpos,targetpos)
local namao = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
if namao and (namao.prefab == "tfwp_spear_lance" or namao.prefab == "tfwp_lava_hammer")then


local i={}
local j,k,l=targetpos:Get()
local m=TheSim:FindEntities(j,k,l,self.range,nil,{"player","companion"})
for n,o in ipairs(m)do 
if doer~=nil and o~=doer and(doer.components.combat:IsValidTarget(o)and o.components.health or o.entity:IsValid()and o.components.workable and o.components.workable:CanBeWorked()and o.components.workable:GetWorkAction())then 
table.insert(i,o)end end;
if self.inst.components.weapon and self.inst.components.weapon:HasAltAttack()then 
self.inst.components.weapon:DoAltAttack(doer,i,nil,self.stimuli)end;
if self.onleap then 
self.onleap(self.inst,doer,startingpos,targetpos) end 

else

    if not startingpos or not targetpos or not doer or not doer.components.combat then
        return false
    end

    if self.onpreleapfn ~= nil then
        self.onpreleapfn(self.inst, doer, startingpos, targetpos)
    end

    doer.components.combat:EnableAreaDamage(false)
    doer.components.combat.ignorehitrange = true

    local weapon_component = self.inst.components.weapon
    local attackwear, damage = 0, 0
    if weapon_component then
        attackwear = weapon_component.attackwear
        damage = weapon_component.damage
        if attackwear ~= 0 then
            weapon_component.attackwear = 0
        end
        if damage ~= self.damage then
            weapon_component:SetDamage(self.damage)
        end
    end

    local leap_targets = TheSim:FindEntities(targetpos.x, 0, targetpos.z, self.aoeradius + self.physicspadding, nil, self.notags, self.combinedtags)
    for _, leap_target in ipairs(leap_targets) do
        if leap_target ~= doer and leap_target:IsValid() and not leap_target:IsInLimbo()
                and not (leap_target.components.health and leap_target.components.health:IsDead()) then
            local targetrange = self.aoeradius + leap_target:GetPhysicsRadius(0.5)
            if leap_target:GetDistanceSqToPoint(targetpos) < targetrange * targetrange then
                self:OnHit(doer, leap_target)
            end
        end
    end

    doer.components.combat:EnableAreaDamage(true)
    doer.components.combat.ignorehitrange = false
    if weapon_component then
        if attackwear ~= 0 then
            weapon_component.attackwear = attackwear
        end
        if damage ~= self.damage then
            weapon_component:SetDamage(damage)
        end
    end

    --Tossing
    local toss_targets = TheSim:FindEntities(targetpos.x, 0, targetpos.z, self.aoeradius + self.physicspadding, TOSS_MUSTTAGS, TOSS_CANTTAGS)
    for _, toss_target in ipairs(toss_targets) do
        local toss_targetrangesq = self.aoeradius + toss_target:GetPhysicsRadius(0.5)
        toss_targetrangesq = toss_targetrangesq * toss_targetrangesq

        local vx, vy, vz = toss_target.Transform:GetWorldPosition()
        local lensq = distsq(vx, vz, targetpos.x, targetpos.z)
        if lensq < toss_targetrangesq and vy < 0.2 then
            self:OnToss(doer, toss_target, nil, 1.5 - lensq / toss_targetrangesq, math.sqrt(lensq))
        end
    end

    if self.onleaptfn then
        self.onleaptfn(self.inst, doer, startingpos, targetpos)
    end
    return true


end
end;

return a