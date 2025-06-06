local IronMachine = Class(function(self, inst)
     self.inst = inst
     self.turnonfn = nil
     self.turnofffn = nil
end)

function IronMachine:TurnOn()
     if self.turnonfn then
          self.turnonfn(self.inst)
     end
     self.inst:AddTag("ironmachineon")
end

function IronMachine:TurnOff()
     if self.turnofffn then
          self.turnofffn(self.inst)
     end
     self.inst:RemoveTag("ironmachineon")
end

function IronMachine:IsOn()
     return self.inst:HasTag("ironmachineon")
end

return IronMachine