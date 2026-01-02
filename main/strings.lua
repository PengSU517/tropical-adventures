--- import files outside the script folder
---@param modulename string
local function languagerequire(modulename)
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
-- 查找补集，如果子表为空则删除
local function findComplement(table1, table2)
    -- 递归查找补集
    local function recursiveFindComplement(t1, t2)
        local complement = {}
        for k, v in pairs(t1) do
            if type(k) ~= "number" and v ~= nil and t2[k] == nil then
                -- t2 中没有这个键，加入补集
                complement[k] = _deepcopy(v)
            elseif type(v) == 'table' and type(t2[k]) == 'table' then
                -- 递归处理子表
                local subComplement = recursiveFindComplement(v, t2[k])
                -- 只有当子表非空时才添加
                if next(subComplement) ~= nil then
                    complement[k] = subComplement
                end
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
local function saveTableToFile(tbl, filename)
    local document = tableToDocument(tbl, 0)
    local file = io.open("unsafedata/" .. filename, "w")
    if file then
        file:write(document)
        file:close()
        print("文件已保存: " .. filename)
    else
        print("无法打开文件: " .. filename)
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




-------------------------------dlc speech importing begin--------------------------------------


local DLC_STRINGS = languagerequire("dlc_strings/common") --languagerequire("dlc_strings/common")

DLC_STRINGS.CHARACTERS =
{
    GENERIC = languagerequire "dlc_strings/speech_wilson",
    WAXWELL = languagerequire "dlc_strings/speech_maxwell",
    WOLFGANG = languagerequire "dlc_strings/speech_wolfgang",
    WX78 = languagerequire "dlc_strings/speech_wx78",
    WILLOW = languagerequire "dlc_strings/speech_willow",
    WENDY = languagerequire "dlc_strings/speech_wendy",
    WOODIE = languagerequire "dlc_strings/speech_woodie",
    WICKERBOTTOM = languagerequire "dlc_strings/speech_wickerbottom",

    WATHGRITHR = languagerequire "dlc_strings/speech_wathgrithr",
    WEBBER = languagerequire "dlc_strings/speech_webber",

    WALANI = languagerequire "dlc_strings/speech_walani",
    WARLY = languagerequire "dlc_strings/speech_warly",
    WILBUR = languagerequire "dlc_strings/speech_wilbur",
    WOODLEGS = languagerequire "dlc_strings/speech_woodlegs",

    WARBUCKS = languagerequire "dlc_strings/speech_warbucks",
    WILBA = languagerequire "dlc_strings/speech_wilba",

    WORMWOOD = languagerequire "dlc_strings/speech_wormwood",
    WAGSTAFF = languagerequire "dlc_strings/speech_wagstaff",
    WHEELER = languagerequire "dlc_strings/speech_wheeler",
}

merge(STRINGS, DLC_STRINGS) -- 加载DLC字符串




--------------------clean the mod string files-----------------------------------
-- local CH_strings = languagerequire("extension/chinese")
-- local EN_strings = languagerequire("extension/english")
-- local en_complement = findComplement(EN_strings, STRINGS)
-- local ch_complement = findComplement(CH_strings, STRINGS)


-- local en_filePath = "english_extension.txt"
-- saveTableToFile(en_complement, en_filePath)

-- local ch_filePath = "chinese_extension.txt"
-- saveTableToFile(ch_complement, ch_filePath)

-- local CH_strings = languagerequire("extension/chinese_extension")
-- local EN_strings = languagerequire("extension/english_extension")
-- local en_merged = merge(EN_strings, CH_strings)
-- local en_filePath = "english_extension.txt"
-- saveTableToFile(en_merged, en_filePath)


-- local EN_strings = languagerequire("extension/english_extension")
-- local en_complement = findComplement(EN_strings, STRINGS)
-- local en_filePath = "english_extension1.txt"
-- saveTableToFile(en_complement, en_filePath)


---------------------speech translation begin / start adding mod strings---------------------------------

local setting_languages = {
    de = "german",         --german
    es = "spanish",        --spanish
    ja = "japanese",       --japanese
    fr = "french",         --french
    it = "italian",        --italian
    ko = "korean",         --korean
    pt = "portuguese",     --portuguese
    br = "portuguese_br",  --brazilian portuguese
    pl = "polish",         --polish
    ru = "russian",        --russian
    zh = "chinese_s",      --Chinese for Steam
    zhr = "chinese_s",     --Chinese for WeGame
    ch = "chinese_s",      --Chinese mod
    chs = "chinese_s",     --Chinese mod
    sc = "chinese_s",      --simple Chinese
    zht = "chinese_t",     --traditional Chinese for Steam
    tc = "chinese_t",      --traditional Chinese
    cht = "chinese_t",     --Chinese mod
    chinese = "chinese_s", -- Chinese mod
}

merge(STRINGS, languagerequire("extension/english_extension"), true) -- 加载额外DLC字符串（强制覆盖现有字符串）

require("translator")
local LanguageTranslator = GLOBAL.LanguageTranslator

-- 为兼容其它翻译模组HOOK这个，防止因其它模组使用LoadPOFile使我们的翻译失效
local LoadPOFile_old = LanguageTranslator.LoadPOFile
LanguageTranslator.LoadPOFile = function(self, fname, lang)
    print("The loaded language is" .. (lang or "nil"))
    LoadPOFile_old(self, fname, lang)
    if setting_languages[lang] then
        local _defaultlang = self.defaultlang
        -- Translator不允许我们添加现有的语言
        -- 相反，我们创造“新”语言，然后手动将它们合并到实际的语言数据中

        ------添加原有dlc的台词
        self:LoadPOFile("languages/dlc_translations/" .. setting_languages[lang] .. ".po", lang .. "_TEMP") -- 加载字符串翻译到临时语言
        merge(self.languages[lang], self.languages[lang .. "_TEMP"])
        self.languages[lang .. "_TEMP"] = nil

        ---繁体中文打底
        if setting_languages[lang] == "chinese_t" then -- 如果使用繁体中文，则额外加载简体中文翻译垫底，最后才是英文翻译
            self:LoadPOFile("languages/dlc_translations/chinese_s.po", "chinese_s_TEMP")
            merge(self.languages[lang], LanguageTranslator.languages["chinese_s_TEMP"])
            LanguageTranslator.languages["chinese_s_TEMP"] = nil
        end


        ----针对中文添加补充台词
        if setting_languages[lang] == "chinese_t" or setting_languages[lang] == "chinese_s" then
            self:LoadPOFile("languages/extension/chinese_extension.po", lang .. "_TEMP_extension") -- 加载额外DLC字符串翻译（强制覆盖现有字符串）
            merge(self.languages[lang], self.languages[lang .. "_TEMP_extension"], true)
            self.languages[lang .. "_TEMP_extension"] = nil
        end

        self.defaultlang = _defaultlang
    end
end



-------------------加载本模组的台词------------------------------------
local desiredlang = LanguageTranslator.defaultlang or "en"
local mod_set_lang = TUNING.set_language or "auto"
local langset = mod_set_lang == "auto" and setting_languages[desiredlang] or setting_languages[mod_set_lang]
print("Trpical Adventures: The present desired language is " .. tostring(desiredlang))

if langset then
    local _defaultlang = LanguageTranslator.defaultlang

    -- 加载翻译文件
    LanguageTranslator:LoadPOFile("languages/dlc_translations/" .. langset .. ".po", "_TEMP")
    merge(LanguageTranslator.languages[_defaultlang], LanguageTranslator.languages["_TEMP"])
    LanguageTranslator.languages["_TEMP"] = nil

    ---繁体中文打底
    if setting_languages[_defaultlang] == "chinese_t" then -- 如果使用繁体中文，则额外加载简体中文翻译垫底，最后才是英文翻译
        LanguageTranslator:LoadPOFile("languages/dlc_translations/chinese_s.po", "chinese_s_TEMP")
        merge(LanguageTranslator.languages[_defaultlang], LanguageTranslator.languages["chinese_s_TEMP"])
        LanguageTranslator.languages["chinese_s_TEMP"] = nil
    end

    ----针对中文添加补充台词
    if langset == "chinese_t" or langset == "chinese_s" then
        LanguageTranslator:LoadPOFile("languages/extension/chinese_extension.po", "_TEMP_extension") -- 加载额外DLC字符串翻译（强制覆盖现有字符串）
        merge(LanguageTranslator.languages[_defaultlang], LanguageTranslator.languages["_TEMP_extension"], true)
        LanguageTranslator.languages["_TEMP_extension"] = nil
    end



    if mod_set_lang ~= "auto" then
        TranslateStringTable(STRINGS) -- 非必要不使用
    end

    LanguageTranslator.defaultlang = _defaultlang
end
