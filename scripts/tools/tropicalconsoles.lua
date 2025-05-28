local arrangelist = nil

---Arrange uninlimbo ents
---@param ranking number|nil @ranking positions
---@param mininum number|nil @ranking mininum amount
---@param printonly boolean|nil @is should't be announced
function t_arrange(ranking, mininum, printonly)
    local u = {}
    for _, ent in pairs(Ents) do
        if ent ~= nil and ent:IsValid() and ent:IsInLimbo() ~= true then
            if ent.prefab then
                u[ent.prefab] = (u[ent.prefab] or 0) + 1
            else
                u["UNKNOWN"] = (u["UNKNOWN"] or 0) + 1
            end
        end
    end
    local s = {}
    for k, v in pairs(u) do
        table.insert(s, {prefab = k, amount = v})
    end
    table.sort(s, function(a, b) return a.amount > b.amount end)
    print("ARRANGING ENTS")
    arrangelist = {}
    local rn = 0
    ranking = ranking or 10
    for k, v in ipairs(s) do
        rn = rn + 1
        if rn > ranking or v.amount < (mininum or 0) then
            break
        end
        table.insert(arrangelist, v)
        if not printonly then
            c_announce(string.format("#%d. %s %s %d", k, STRINGS.NAMES[string.upper(v.prefab)] or
                STRINGS.NAMES.UNKNOWN, v.prefab, v.amount))
        end
        print(k, v.prefab, v.amount)
    end
end

---Remove ents in wild
---@param name string @ent's prefab name
---@param keepamount number|nil @keeping lowest amount
function t_removewild(name, keepamount)
    local count = 0
    if keepamount then
        for _, ent in pairs(Ents) do
            if ent.prefab == name and ent:IsInLimbo() ~= true then
                count = count + 1
            end
        end
    end
    local remove = 0
    count = count - (keepamount or 50)
    for _, ent in pairs(Ents) do
        if keepamount and count <= 0 then
            break
        end
        if ent.prefab == name and ent:IsInLimbo() ~= true then
            ent:Remove()
            remove = remove + 1
            count = count - 1
        end
    end
    print("removed on wild", remove)
end

---Count specific ents
---@param name string
---@param printonly boolean|nil
function t_count(name, printonly)
    local count = 0
    for _, ent in pairs(Ents) do
        if ent and ent.prefab == name then
            count = count + 1
        end
    end
    print("COUNT", name, count)
    if not printonly then
        c_announce(string.format("Amount of %s: %d", STRINGS.NAMES[string.upper(name)] or name, count))
    end
    return count

end