local hats = {
    earmuffshat = {
        "stunresist",
    },
    eyemaskhat = {
        "fogproof", "stunresist",
    },
    lunarplanthat = {
        "fogproof", "stunresist",
    },
    voidclothhat = {
        "fogproof", "stunresist",
    },
}
for hat, tags in pairs(hats) do
    AddPrefabPostInit(hat, function(inst)
        for _, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
    end)
end