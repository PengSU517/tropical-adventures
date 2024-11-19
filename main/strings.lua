--- import files outside the script folder
---@param modulename string
local function modrequire(modulename)
    modulename = string.gsub(modulename, "%.lua$", "")
    print("modimport (strings file): " .. env.MODROOT .. "languages/" .. modulename .. ".lua")
    local result = kleiloadlua(env.MODROOT .. "languages/" .. modulename .. ".lua")
    if result == nil then
        error("Error in custom import: Stringsfile " .. "languages/" .. modulename .. " not found!")
    elseif type(result) == "string" then
        error("Error in custom import: importing languages/" .. modulename .. "!\n" .. result)
    else
        setfenv(result, env) -- in case we use mod data
        return result()
    end
end



--- merge tables
---@param target table
---@param new table
local function merge(target, new, hard)
    target = target or {}

    for k, v in pairs(new) do
        if type(v) == "table" and type(target[k]) == "table" then
            merge(target[k], v, hard)
        else
            if hard then
                target[k] = v
            else
                target[k] = target[k] or v
            end
        end
    end
    return target
end


local function _deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[_deepcopy(orig_key)] = _deepcopy(orig_value)
        end
        setmetatable(copy, _deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- 查找补集
local function findComplement(table1, table2)
    -- 递归查找补集
    local function recursiveFindComplement(t1, t2)
        local complement = {}
        for k, v in pairs(t1) do
            if v ~= nil and t2[k] == nil then
                -- t2 中没有这个键，加入补集
                complement[k] = _deepcopy(v)
            elseif type(v) == 'table' and type(t2[k]) == 'table' then
                -- 递归处理子表
                complement[k] = recursiveFindComplement(v, t2[k])
            end
        end

        return complement
    end

    return recursiveFindComplement(table1, table2)
end



-- 将表转换为字符串形式的文档，并按键名的字母顺序排序
local function tableToDocument(tbl, indent)
    local padding = ""
    if indent then
        padding = string.rep(" ", indent)
    end

    local function serializeValue(v, level)
        if type(v) == "string" then
            return string.format("%q", v)
        elseif type(v) == "number" or type(v) == "boolean" or v == nil then
            return tostring(v)
        elseif type(v) == "table" then
            return tableToDocument(v, (level or 0) + 2)
        else
            return "nil" -- 不支持的类型
        end
    end

    local function serializeKey(k)
        if type(k) == "string" then
            return k .. " = "
        else
            return " " ---[" .. serializeValue(k) .. "]"
        end
    end

    -- 获取表中的所有键，并按字母顺序排序
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end
    table.sort(keys)


    local result = {}

    for _, k in ipairs(keys) do
        local v = tbl[k]
        table.insert(result, padding .. serializeKey(k) .. serializeValue(v, indent) .. ",")
    end


    if #result > 0 then
        table.insert(result, 1, "{")
        table.insert(result, padding .. "}")
    else
        table.insert(result, "{}")
    end

    return table.concat(result, "\n")
end

-- 将表保存到文件
local function saveTableToFile(tbl, filePath)
    local document = tableToDocument(tbl, 0)
    local file = io.open(filePath, "w")
    if file then
        file:write(document)
        file:close()
        print("文件已保存: " .. filePath)
    else
        print("无法打开文件: " .. filePath)
    end
end

-- -- 示例表
-- local exampleTable = {
--     name = "Alice",
--     age = 30,
--     address = {
--         street = "123 Main St",
--         city = "Anytown",
--         state = "Anystate"
--     },
--     hobbies = { "reading", "hiking", "coding" }
-- }

-- -- 将表保存到文件
-- local filePath = env.MODROOT .. "example_sorted.txt"
-- saveTableToFile(exampleTable, filePath)



-- -- 示例表
-- local table1 = {
--     name = "Alice",
--     age = 30,
--     address = {
--         street = "123 Main St",
--         city = "Anytown",
--         state = "Anystate"
--     },
--     hobbies = { "reading", "hiking", "coding" }
-- }

-- local table2 = {
--     name = "Alice",
--     age = 30,
--     address = {
--         street = "123 Main St",
--         city = "Anytown"
--     },
--     hobbies = { "reading", "hiking" }
-- }

-- -- 查找补集
-- local complement = findComplement(table1, table2)

-- local filePath = env.MODROOT .. "example_comp.txt"
-- saveTableToFile(complement, filePath)

-------------------------------speech importing begin--------------------------------------


local DLC_STRINGS = {} --modrequire("dlc_strings/common") --modrequire("dlc_strings/common")

DLC_STRINGS.CHARACTERS =
{
    GENERIC = modrequire "dlc_strings/speech_wilson",
    WAXWELL = modrequire "dlc_strings/speech_maxwell",
    WOLFGANG = modrequire "dlc_strings/speech_wolfgang",
    WX78 = modrequire "dlc_strings/speech_wx78",
    WILLOW = modrequire "dlc_strings/speech_willow",
    WENDY = modrequire "dlc_strings/speech_wendy",
    WOODIE = modrequire "dlc_strings/speech_woodie",
    WICKERBOTTOM = modrequire "dlc_strings/speech_wickerbottom",

    WATHGRITHR = modrequire "dlc_strings/speech_wathgrithr",
    WEBBER = modrequire "dlc_strings/speech_webber",

    WALANI = modrequire "dlc_strings/speech_walani",
    WARLY = modrequire "dlc_strings/speech_warly",
    WILBUR = modrequire "dlc_strings/speech_wilbur",
    WOODLEGS = modrequire "dlc_strings/speech_woodlegs",

    -- WARBUCKS = modrequire "dlc_strings/speech_warbucks",
    -- WILBA = modrequire "dlc_strings/speech_wilba",

    WORMWOOD = modrequire "dlc_strings/speech_wormwood",
    -- WAGSTAFF = modrequire "dlc_strings/speech_wagstaff",
    -- WHEELER = modrequire "dlc_strings/speech_wheeler",
}


merge(STRINGS, DLC_STRINGS)

---------------------speech translation begin---------------------------------

local setting_languages = {
    de = "german",        --german
    es = "spanish",       --spanish
    fr = "french",        --french
    it = "italian",       --italian
    ko = "korean",        --korean
    pt = "portuguese",    --portuguese
    br = "portuguese_br", --brazilian portuguese
    pl = "polish",        --polish
    ru = "russian",       --russian
    zh = "chinese_s",     --Chinese for Steam
    zhr = "chinese_s",    --Chinese for WeGame
    ch = "chinese_s",     --Chinese mod
    chs = "chinese_s",    --Chinese mod
    sc = "chinese_s",     --simple Chinese
    zht = "chinese_t",    --traditional Chinese for Steam
    tc = "chinese_t",     --traditional Chinese
    cht = "chinese_t",    --Chinese mod
}



merge(STRINGS, modrequire("extension/english"), true)

local desiredlang = nil
if LanguageTranslator.defaultlang then
    desiredlang = LanguageTranslator.defaultlang
end

print("desired language: " .. (desiredlang or "nil"))
if desiredlang and setting_languages[desiredlang] then
    LoadPOFile("languages/dlc_translations/" .. setting_languages[desiredlang] .. ".po", desiredlang)
    TranslateStringTable(DLC_STRINGS)
    if setting_languages[desiredlang] == "chinese_s" or setting_languages[desiredlang] == "chinese_t" then
        merge(STRINGS, modrequire("extension/chinese"), true)
    end
end
