tableutil = {}

function tableutil.is_array(t)
    if type(t) ~= "table" or not next(t) then
        return false
    end

    local n = #t
    for i, v in pairs(t) do
        if type(i) ~= "number" or i <= 0 or i > n then
            return false
        end
    end

    return true
end

function tableutil.has_index(tbl, index)
    for i, v in pairs(tbl) do
        if i == index then
            return true
        end
    end
end

function tableutil.has_component(tbl, component)
    for _, v in pairs(tbl) do
        if v == component then
            return true
        end
    end
end

function tableutil.has_one_of_component(tbl, components)
    for _, v in pairs(components) do
        if tableutil.has_component(tbl, v) then
            return true
        end
    end
end

function tableutil.has_all_of_component(tbl, components)
    for _, v in pairs(components) do
        if not tableutil.has_component(tbl, v) then
            return false
        end
    end
    return true
end

function tableutil.insert_indexes(tbl, vs)
    for i, v in pairs(vs) do
        tbl[i] = v
    end
end

function tableutil.insert_components(tbl, vs)
    if type(vs) ~= "table" then
        vs = { vs }
    end
    for _, v in pairs(vs) do
        if not tableutil.has_component(tbl, v) then
            table.insert(tbl, v)
        end
    end
end

function table.remove_components(tbl, vs)
    -- 从后向前遍历 tbl
    for i = #tbl, 1, -1 do
        for k, w in pairs(vs) do
            if tbl[i] == w then
                table.remove(tbl, i)
                break
            end
        end
    end
end

function tableutil.remove_indexes(tbl, vs)
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if i == k then
                table.remove(tbl, i)
                break
            end
        end
    end
end

function tableutil.common_components(tbl, vs)
    local commontbl = {}
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if v == w then
                table.insert(commontbl, w)
                break
            end
        end
    end
    return commontbl
end

function tableutil.common_indexes(tbl, vs)
    local commontbl = {}
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if i == k then
                commontbl[k] = w
                break
            end
        end
    end
    return commontbl
end

function tableutil.count_components(tbl)
    local lst = {}
    for _, v in pairs(tbl) do
        if not lst[v] then
            lst[v] = 1
        else
            lst[v] = lst[v] + 1
        end
    end
    return lst
end

function tableutil.deep_merge(target, add_table, override)
    target = target or {}

    for k, v in pairs(add_table) do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            elseif type(target[k]) ~= "table" then
                if override then
                    target[k] = {}
                else
                    error("Can not override" .. k .. " to a table")
                end
            end

            tableutil.deep_merge(target[k], v, override)
        else
            if tableutil.is_array(target) and not override then
                table.insert(target, v)
            elseif not target[k] or override then
                target[k] = v
            end
        end
    end

    return target
end

return tableutil
