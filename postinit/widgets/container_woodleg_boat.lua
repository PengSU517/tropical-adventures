-------------------------lock for woodlegs boat by EvenMr-------------------------
local container_handler =
{
    "PutOneOfActiveItemInSlot",
    "PutAllOfActiveItemInSlot",
    "TakeActiveItemFromHalfOfSlot",
    "TakeActiveItemFromAllOfSlot",
    "AddOneOfActiveItemToSlot",
    "AddAllOfActiveItemToSlot",
    "SwapActiveItemWithSlot",
    "MoveItemFromAllOfSlot",
    "MoveItemFromHalfOfSlot",
}

local function containerhack(inst)
    local function lock(self, fname)
        local oldfn = self[fname]
        self[fname] = function(self, slot, ...)
            if (self._parent or self.inst).prefab == "woodlegsboat" and slot == 1 then
                return
            else
                oldfn(self, slot, ...)
            end
        end
    end
    for _, v in ipairs(container_handler) do
        lock(inst, v)
    end
end
AddComponentPostInit("container", containerhack)
AddPrefabPostInit("container_classified", containerhack)
