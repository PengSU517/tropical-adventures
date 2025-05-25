---@version 20250525
require("prefabs")

---Derive a prefab from other prefab
---@param self klass
---@param parent string
---@param name string
---@param postfn function
---@param assets string[]
---@param deps string[]
---@param force_path_search string
---@return entity
Derive = Class(Prefab, function(self, parent, name, postfn, assets, deps, force_path_search)
    local function fn()
        assert(Prefabs[parent], string.format("Failed to derive %s from %s: Prefab %s doesn't exist yet",
                                              name, parent, parent))
        local inst = Prefabs[parent].fn()
        postfn(inst)
        return inst
    end
    deps = table.insert(deps or {}, parent)
    Prefab._ctor(self, name, fn, assets, deps, force_path_search)
    self.derive = parent
end)

function Derive:__tostring()
    return string.format("Prefab %s(derive from %s) - %s", self.name, self.derive, self.desc)
end
