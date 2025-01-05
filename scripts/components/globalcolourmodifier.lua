local GlobalColourModifier = Class(function(self, inst)
    self.inst = inst
    self.modifycolorfndefault = function(ent)
        if ent.AnimState then
            ent.AnimState:SetMultColour(1, 1, 1, 1)
            ent.AnimState:SetAddColour(0, 0, 0, 1)
            if not ent:HasTag("FX") then
                ent.AnimState:ClearBloomEffectHandle()
            end
        end
    end
    self.modifycolorfn = self.modifycolorfndefault
end)

function GlobalColourModifier:SetModifyColourFn(fn)
    self.modifycolorfn = fn
    for i, ent in pairs(Ents) do
        if ent.AnimState and not ent:HasTag("widget") then
            self.modifycolorfn(ent)
        end
    end
    self.modifycolorfn(TheWorld)
end

function GlobalColourModifier:Apply(ent)
    if ent.AnimState and not ent:HasTag("widget") then
        self.modifycolorfn(ent)
    end
end

function GlobalColourModifier:Reset()
    self:SetModifyColourFn(self.modifycolorfndefault)
end

return GlobalColourModifier
