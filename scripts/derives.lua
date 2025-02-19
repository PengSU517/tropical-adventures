require("prefabs")

Derive = Class(Prefab, function(self, parent, name, postfn, assets, deps, force_path_search)
    local function fn()
        assert(Prefabs[parent], string.format("Failed to derive %s from %s: Prefab %s doesn't exist yet",
                                              name, parent, parent))
        local inst = Prefabs[parent].fn()
        return postfn(inst)
    end
    Prefab._ctor(self, name, fn, assets, deps, force_path_search)
    self.lastname = parent
end)

function Derive:__tostring()
    return string.format("Prefab %s(derive from %s) - %s", self.name, self.lastname, self.desc)
end