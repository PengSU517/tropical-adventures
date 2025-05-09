local hats = { "eyemaskhat", "lunarplanthat", "voidclothhat" }
for _, hat in ipairs(hats) do
    AddPrefabPostInit(hat, function(inst)
        inst:AddTag("fogproof")
        inst:AddTag("stunresist")
    end)
end