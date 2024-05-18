tabel = {}

function tabel.has_index(tbl, index)
    for i, v in pairs(tbl) do
        if i == index then
            return true
        end
    end
end

function tabel.has_component(tbl, component)
    for _, v in pairs(tbl) do
        if v == component then
            return true
        end
    end
end

function tabel.insert_indexes(tbl, vs)
    for i, v in pairs(vs) do
        tbl[i] = v
    end
end

function tabel.insert_components(tbl, vs)
    for _, v in pairs(vs) do
        if not tabel.has_component(tbl, v) then
            table.insert(tbl, v)
        end
    end
end

function tabel.remove_components(tbl, vs)
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if v == w then
                table.remove(tbl, i)
                break
            end
        end
    end
end

function tabel.remove_indexes(tbl, vs)
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if i == k then
                table.remove(tbl, i)
                break
            end
        end
    end
end

function tabel.common_components(tbl, vs)
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

function tabel.common_indexes(tbl, vs)
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

return tabel
