-----------------------------------------------------------------------------------
-- Adds the ability to remove health triggers for the healthtrigger component
AddComponentPostInit("healthtrigger", function(self)
    self.AddTrigger = function(self, amount, fn, override)
        if self.triggers[amount] and not override then
            local _oldTriggerFN = self.triggers[amount]
            self.triggers[amount] = function(inst)
                _oldTriggerFN(inst)
                fn(inst)
            end
        else
            self.triggers[amount] = fn
        end
    end
    self.RemoveTrigger = function(self, amount)
        self.triggers[amount] = nil
    end
end)
