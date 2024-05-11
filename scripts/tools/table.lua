TABLE = {}

function TABLE.has_index(tbl, index)
    for i, v in pairs(tbl) do
        if i == index then
            return true
        end
    end
end

function TABLE.has_component(tbl, component)
    for _, v in pairs(tbl) do
        if v == component then
            return true
        end
    end
end

function TABLE.insert_index(tbl, vs)
    for i, v in pairs(vs) do
        tbl[i] = v
    end
end

function TABLE.insert(tbl, vs)
    for _, v in pairs(vs) do
        if not TABLE.has_component(tbl, v) then
            table.insert(tbl, v)
        end
    end
end

function TABLE.remove(tbl, vs)
    for i, v in pairs(tbl) do
        for k, w in pairs(vs) do
            if v == w then
                table.remove(tbl, i)
                break
            end
        end
    end
end

return TABLE
