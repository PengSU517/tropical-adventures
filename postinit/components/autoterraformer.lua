AddComponentPostInit("autoterraformer", function(self)
    Utils.FnDecorator(self, "DoTerraform", function(_self, px, py, pz, _x, _y)
        local tile = TheWorld.Map:GetTileAtPoint(px, py, pz)
		if tile == GROUND.GASRAINFOREST or tile == GROUND.DEEPRAINFOREST then return nil, true end
    end)
end)
