local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
local Deployable = require("components/deployable")

function Deployable:DeployAtRange()
    return self.deployatrange
end

function Deployable:GetDeployDist()
    return self.deploydistance
end

local _CanDeploy = Deployable.CanDeploy
function Deployable:CanDeploy(pt, ...)
    if self.forcedeploy then -- for surfboard drop in water
        return true
    end

    local _map = TheWorld.Map
    if self.inst._tile_candeploy_fn then
        local tile = _map:GetTileAtPoint(pt:Get())
        if not self.inst._tile_candeploy_fn(tile) then
            return false
        end
    end

    return _map:RunWithoutTropicalCorners(_CanDeploy, self, pt, ...)
end

function Deployable:ForceDeploy(...)
    self.forcedeploy = true
    self:Deploy(...)
    self.forcedeploy = false
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

local function ondeployatrange(self, deployatrange)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.deployatrange:set(deployatrange)
    end
end

local function ondeploydistance(self, deploydistance)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.deploydistance:set(deploydistance)
    end
end

TAENV.AddComponentPostInit("deployable", function(cmp)
    addsetter(cmp, "deployatrange", ondeployatrange)
    addsetter(cmp, "deploydistance", ondeploydistance)

    cmp.forcedeploy = false
    cmp.deployatrange = false
    cmp.deploydistance = 0
end)
