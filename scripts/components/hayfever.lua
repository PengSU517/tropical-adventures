local Hayfever = Class(function(self, inst)
    self.inst = inst
    self.fevervalue = 0
    self:OnUpdate(0)
    self.inst:StartUpdatingComponent(self)
end
)



function Hayfever:OnSave()
    return
    {
        fevervalue = self.fevervalue,

    }
end

function Hayfever:OnLoad(data)
    if data and data.fevervalue then
        self.fevervalue = data.fevervalue
    else
        self.fevervalue = 0
    end
end

function Hayfever:OnUpdate()
    -- local interior = GetClosestInstWithTag("interior_center", self.inst, 15)
    -- print("check hayfevervalue !!!!!!!!")
    -- print(self.fevervalue)
    -- print(self.inst.prefab)
    local isinhamlet = self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("hamlet")
    local headequip = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    local isequip = headequip and headequip.prefab == "gasmaskhat" or headequip and headequip.prefab == "gashat"
    local fan = GetClosestInstWithTag("prevents_hayfever", self.inst, 15)
    local isplayer = (not self.inst:HasTag("wereplayer")) and (not self.inst:HasTag("plantkin"))

    if (TheWorld.state.isspring and isinhamlet and isplayer and (not isequip) and (not fan)) then
        if self.fevervalue < 3500 then self.fevervalue = self.fevervalue + 1 end
    else
        if self.fevervalue > 0 then self.fevervalue = self.fevervalue - 5 end
    end

    if self.fevervalue > 3400 then
        self.fevervalue = math.random(2000, 2500)
        -- self.inst:PushEvent("sneeze")------------------pushevent好像出什么大病了没查出bug在哪儿

        if self.inst.sg then self.inst.sg:GoToState("sneeze") end
    end
end

return Hayfever
