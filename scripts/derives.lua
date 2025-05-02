require("prefabs")

Derive = function(parent, name, postfn, assets, deps, force_path_search)
    local function fn()
        local inst = Prefabs[parent].fn()
        postfn(inst)
        return inst
    end
    return Prefab(name, fn, assets, deps, force_path_search)
end