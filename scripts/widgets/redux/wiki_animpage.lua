local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"
local TEMPLATES = require "widgets/redux/templates"
local TrueScrollArea = require "widgets/truescrollarea"

require("util")

local FILTER_ALL = "ALL"
local RARITY_CONFIGS = {
    Rare = { 0.15, 0.45, 0.65, 1 },
    Legendary = { 0.70, 0.30, 0.15, 1 },
    Mythic = { 0.50, 0.15, 0.60, 1 }
}


local wiki_data = require("datadefs/wikibook_contents")
local desc_contents = wiki_data.wiki_desc
local desc_terms = wiki_data.wiki_terms
local size_multi = (TUNING.LANGUAGE_CHINESE) and 1 or 0.5

-- 详细信息标签
-- 只用更换新的贴图设计就好了
local function MakeDetailsLine(details_root, x, y, scale, image_override)
    local value_title_line = details_root:AddChild(Image("images/quagmire_recipebook.xml",
        image_override or "quagmire_recipe_line.tex"))
    value_title_line:SetScale(scale, scale)
    value_title_line:SetPosition(x, y)
end


local function clean(intro_text)
    if not intro_text or type(intro_text) ~= "string" then return "" end

    -- % [ 匹配左中括号，% ] 匹配右中括号
    -- (.-) 非贪婪匹配中间的内容
    local formatted_text = intro_text:gsub("%[(.-)%]", function(prefab_code)
        local key = string.upper(prefab_code) or prefab_code
        local real_name = STRINGS.NAMES[key]

        -- 处理饥荒中可能的表结构（如 STRINGS.NAMES.PIGMAN.DEFAULT）
        if type(real_name) == "table" then
            real_name = real_name.DEFAULT
        end

        if real_name and type(real_name) == "string" then
            -- 找到译名后，返回带中文书名号或括号的名字
            return "【" .. real_name .. "】"
        else
            -- 找不到译名时，保留原始格式 [prefab] 以便检查
            return "【" .. prefab_code .. "】"
        end
    end)

    return (formatted_text:gsub("\n%s+", "\n"):gsub("^%s+", ""))
end
-------------------------------------------------------------------------------------------------------

local WikiDescAnimPage = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "WikiDescAnimPage")

    self.current_data = nil -- 新增：初始化当前数据存储
    self.parent_screen = parent_screen
    self.category = category or "structures"

    self:CreateDesc()

    self:_DoFocusHookups()

    return self
end)

function WikiDescAnimPage:_DoFocusHookups()
    -- 滚轮
    if self.spinners then
        for i, v in ipairs(self.spinners) do
            v:ClearFocusDirs()

            if i > 1 then
                v:SetFocusChangeDir(MOVE_UP, self.spinners[i - 1])
            end
            if i < #self.spinners then
                v:SetFocusChangeDir(MOVE_DOWN, self.spinners[i + 1])
            end
        end

        local reset_default_focus = self.parent_default_focus ~= nil and self.parent_screen ~= nil and
            self.parent_screen.default_focus == self.parent_default_focus

        if self.recipe_grid.items ~= nil and #self.recipe_grid.items > 0 then
            self.spinners[#self.spinners]:SetFocusChangeDir(MOVE_DOWN, self.recipe_grid)
            self.recipe_grid:SetFocusChangeDir(MOVE_UP, self.spinners[#self.spinners])

            self.parent_default_focus = self.recipe_grid
            self.focus_forward = self.recipe_grid
        else
            self.parent_default_focus = self.spinners[1]
            self.focus_forward = self.spinners[1]
        end
    end

    -- 添加箭头焦点控制
    if self.skin_buttons then
        -- 安全访问左右箭头
        local left_button = self.skin_buttons.left
        local right_button = self.skin_buttons.right

        if left_button and right_button then
            left_button:SetFocusChangeDir(MOVE_RIGHT, right_button)
            right_button:SetFocusChangeDir(MOVE_LEFT, left_button)

            -- 仅当存在皮肤数据时连接网格与箭头
            if self.recipe_grid.items then
                self.recipe_grid:SetFocusChangeDir(MOVE_RIGHT, right_button)
                right_button:SetFocusChangeDir(MOVE_LEFT, self.recipe_grid)
            end
        end
    end
end

-- 整个框架，包括左右两个区域
function WikiDescAnimPage:CreateDesc()
    local panel_root = self
    -----------
    -- 左侧网格内容，大框架，不用动的
    self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-180, 0)

    -- BuildDesc的内容
    -- 左侧的网格信息和滚轮
    self.recipe_grid = self.gridroot:AddChild(self:BuildDesc())
    self.recipe_grid:SetPosition(-15, 0)
    local grid_w, grid_h = self.recipe_grid:GetScrollRegionSize()

    -- 左侧网格内容上下的两个line
    -- ⭐️位置肯定要调整
    local boarder_scale = 0.75
    local grid_boarder = self.gridroot:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    grid_boarder:SetScale(boarder_scale, boarder_scale)
    grid_boarder:SetPosition(-3, grid_h / 2 + 7)
    grid_boarder = self.gridroot:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    grid_boarder:SetScale(boarder_scale, -boarder_scale)
    grid_boarder:SetPosition(-3, -grid_h / 2 - 7)

    -----------

    -- 覆盖的矩形背景
    -- ⭐️要更换贴图
    local details_decor = panel_root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_menu_block.tex"))
    details_decor:ScaleToSize(360, 500)
    details_decor:SetPosition(225, 0)
    -- 右侧左下角的纹理
    -- ⭐️要更换贴图
    details_decor =
        panel_root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_corner_decoration.tex"))
    details_decor:ScaleToSize(100, 100)
    details_decor:SetPosition(105, -190)
    -- 右侧友下角的纹理
    -- ⭐️要更换贴图
    details_decor =
        panel_root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_corner_decoration.tex"))
    details_decor:ScaleToSize(-100, 100)
    details_decor:SetPosition(345, -190)

    -- details_root的内容
    self.details_root = panel_root:AddChild(Widget("details_root"))
    self.details_root:SetPosition(45, -205)
    self.details_root.panel_width = 350
    self.details_root.panel_height = 500

    -- 右侧矩形背景中的具体内容
    self.details_root:AddChild(self:PopulateRecipeDetailPanel(self.all_recipes[1]))

    -- 初始化显示内容
    -- 注释掉看有没有影响
    self:ApplyFilters()
    self.recipe_grid:RefreshView()
end

-- 放置具体的配方信息
function WikiDescAnimPage:_SetupRecipeIngredientDetails(recipes, parent, y)
    local ingredient_size = 30
    local x_spacing = 2

    local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
    local inv_item_root = parent:AddChild(Widget("inv_item_root"))
    local index = 1

    local b = 1
    for c = 1, #recipes do
        local items = recipes[index] -- items = {"shanhai_goumang", 1}

        local tmp_spacing = (ingredient_size + x_spacing) / 2
        local tmp_offset = 48 + tmp_spacing * (4 - #recipes)

        local x = -((#items + 1) * ingredient_size + (#items - 1) * x_spacing) / 2 + tmp_offset
        local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
        backing:ScaleToSize(ingredient_size, ingredient_size)
        local tmp = x + (index) * ingredient_size + (index - 1) * x_spacing
        backing:SetPosition(x + (index) * ingredient_size + (index - 1) * x_spacing,
            y - ingredient_size / 2 - (b - 1) * (ingredient_size + 5) + 10)

        local img_name = items[1] .. ".tex"
        local img_atlas = GetInventoryItemAtlas(img_name, true)
        local img = inv_item_root:AddChild(Image(img_atlas or "images/quagmire_recipebook.xml",
            img_atlas ~= nil and img_name or "cookbook_missing.tex"))

        img:ScaleToSize(ingredient_size, ingredient_size)
        img:SetPosition(backing:GetPosition())
        img:SetHoverText(STRINGS.NAMES[string.upper(items[1])] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, {
            ingredient = items[1]
        }))

        local tx, ty, tz = backing:GetPosition():Get()
        local title_font_size = 12
        local img_under = inv_item_root:AddChild(Image("images/global_redux.xml", "value_gold.tex"))
        img_under:SetScale(.33)
        img_under:SetPosition(tx + 1.5, ty - 20, tz)
        local item_num = inv_item_root:AddChild(Text(HEADERFONT, title_font_size, items[2], UICOLOURS.BROWN_DARK))
        item_num:SetPosition(tx + 1.5, ty - 20, tz)

        index = index + 1
    end
end

function WikiDescAnimPage:_SetupRelatedItemDetails(recipes, parent, y)
    local ingredient_size = 30
    local x_spacing = 2
    local y_spacing = 5
    local max_per_row = 8 -- 每行最多4个图标

    local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
    local inv_item_root = parent:AddChild(Widget("inv_item_root"))

    for i, prefab in ipairs(recipes) do
        -- 计算当前图标所在的行和列 (从0开始计数)
        local row = math.floor((i - 1) / max_per_row)
        local col = (i - 1) % max_per_row

        -- 动态计算当前行的起始 X 偏移，使其在该行居中
        local items_in_this_row = math.min(max_per_row, #recipes - row * max_per_row)
        local row_width = (items_in_this_row * ingredient_size) + ((items_in_this_row - 1) * x_spacing)
        local start_x = -row_width / 2 + ingredient_size / 2 - 32

        -- 1. 创建背景槽
        local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
        backing:ScaleToSize(ingredient_size, ingredient_size)

        local current_x = start_x + (col + 1) * (ingredient_size + x_spacing)
        local current_y = y - (row + 0.5) * (ingredient_size + y_spacing) + 10
        backing:SetPosition(current_x, current_y)

        -- 2. 创建物品图标
        local img_name = prefab .. ".tex"
        local img_atlas = GetInventoryItemAtlas(img_name, true)
        local img = inv_item_root:AddChild(Image(img_atlas or "images/quagmire_recipebook.xml",
            img_atlas and img_name or "cookbook_missing.tex"))

        img:ScaleToSize(ingredient_size, ingredient_size)
        img:SetPosition(backing:GetPosition())

        -- 3. 设置悬浮文本
        local name_str = STRINGS.NAMES[string.upper(prefab)] or
            subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, { ingredient = prefab })
        img:SetHoverText(name_str)
    end
end

-- 循环皮肤显示
function WikiDescAnimPage:CycleSkin(direction)
    local total_skins = #self.current_data.desc_def.skins
    self.current_skin_index = (self.current_skin_index + direction - 1) % total_skins + 1
    self:UpdateSkinVisibility()
    self:ApplyCurrentSkin()
end

-- 设置箭头的可见效果
function WikiDescAnimPage:UpdateSkinVisibility()
    if self.skin_buttons then
        self.skin_buttons.left:Show(true)
        self.skin_buttons.right:Show(true)

        self.skin_buttons.left:SetClickable(true)
        self.skin_buttons.right:SetClickable(true)
    end
end

-- 实际修改动画
function WikiDescAnimPage:ApplyCurrentSkin()
    local skin_data_fn = self.current_data.desc_def.skins[self.current_skin_index]
    local skin_name = skin_data_fn.name or ""
    local skin_rarity = skin_data_fn.rarity or nil
    if skin_data_fn and skin_data_fn.fn then
        skin_data_fn.fn(self.item_anim)
        self.skin_name:SetString(STRINGS.SKIN_NAMES[skin_name] or "")
        if skin_rarity ~= nil then
            self.skin_name:SetColour(RARITY_CONFIGS[skin_rarity][1], RARITY_CONFIGS[skin_rarity][2],
                RARITY_CONFIGS[skin_rarity][3], RARITY_CONFIGS[skin_rarity][4])
        end
    end
end

-- 右侧矩形背景中的具体内容
-- ⭐️需要修改具体逻辑
function WikiDescAnimPage:PopulateRecipeDetailPanel(data)
    local top = self.details_root.panel_height / 2
    local left = -self.details_root.panel_width / 2

    local details_root = Widget("details_root")

    local y = top - 11

    local image_size = 110


    local name_font_size = 34
    local title_font_size = 22 -- 18
    local body_font_size = 20  -- 16

    -- 显示名称
    local name_offset_x = 100
    y = y - name_font_size / 2

    local title = details_root:AddChild(Text(HEADERFONT, name_font_size * size_multi, data.name, UICOLOURS.BROWN_DARK))
    title:SetPosition(0, y)

    y = y - name_font_size / 2 - 4

    -- 显示名称下的纹理
    MakeDetailsLine(details_root, 0, y - 10, -.55, "quagmire_recipe_line_break.tex")
    y = y - 30

    y = y - image_size / 2

    -- -- 控制右方anim的位置
    self.portrait_root = details_root:AddChild(Widget("portrait_root"))
    self.portrait_root:SetPosition(0 + data.desc_def.x_offset, y - 100 + data.desc_def.y_offset)

    self.skin_buttons = {}
    if data.desc_def.skins and #data.desc_def.skins > 1 then
        self.current_data = data
        -- 右侧的皮肤切换按键（右）
        self.skin_buttons.right = details_root:AddChild(ImageButton("images/quagmire_recipebook.xml",
            "arrow2_right.tex", "arrow2_right_over.tex", "arrow_right_disabled.tex", "arrow2_right.tex"))
        self.skin_buttons.right:SetScale(0.3)
        self.skin_buttons.right:SetPosition(135, 0)
        self.skin_buttons.right:SetOnClick(function()
            self:CycleSkin(1)
        end)

        -- 右侧的皮肤切换按键（左）
        self.skin_buttons.left = details_root:AddChild(ImageButton("images/quagmire_recipebook.xml", "arrow2_left.tex",
            "arrow2_left_over.tex", "arrow_left_disabled.tex", "arrow2_left.tex"))
        self.skin_buttons.left:SetScale(0.3)
        self.skin_buttons.left:SetPosition(-135, 0)
        self.skin_buttons.left:SetOnClick(function()
            self:CycleSkin(-1)
        end)

        self.skin_name = details_root:AddChild(Text(HEADERFONT, title_font_size, "", UICOLOURS.BROWN_DARK))
        if self.current_data and self.current_data.desc_def and self.current_data.desc_def.skins and
            self.current_data.desc_def.skins[1] then
            if self.current_data.desc_def.skins[1].name then
                self.skin_name:SetString(STRINGS.SKIN_NAMES[self.current_data.desc_def.skins[1].name] or "")
            end
            local skin_rarity = self.current_data.desc_def.skins[1].rarity or nil
            if skin_rarity ~= nil then
                self.skin_name:SetColour(RARITY_CONFIGS[skin_rarity][1], RARITY_CONFIGS[skin_rarity][2],
                    RARITY_CONFIGS[skin_rarity][3], RARITY_CONFIGS[skin_rarity][4])
            end
        end

        self.skin_name:SetPosition(0, -25)

        -- 初始化皮肤索引
        self.current_skin_index = 1
        self:UpdateSkinVisibility()
    else
        -- 无皮肤数据时彻底移除箭头
        if self.skin_buttons.left then
            self.skin_buttons.left:Kill()
            self.skin_buttons.left = nil
        end
        if self.skin_buttons.right then
            self.skin_buttons.right:Kill()
            self.skin_buttons.right = nil
        end
    end

    y = y - image_size / 2

    -- 右侧的动画展示
    if data.desc_def.desc_anim then
        self.item_anim = self.portrait_root:AddChild(UIAnim())
        self.item_anim:GetAnimState():SetBank(data.desc_def.desc_bank)
        self.item_anim:GetAnimState():SetBuild(data.desc_def.desc_build)

        if data.desc_def.desc_override_build then
            self.item_anim:GetAnimState():AddOverrideBuild(data.desc_def.desc_override_build)
        end
        if data.desc_def.oversymbolfn then
            data.desc_def.oversymbolfn(self.item_anim)
        end

        if data.desc_def.facing == nil then
            self.item_anim:SetFacing(FACING_DOWN)
        elseif not data.desc_def.facing == "fixed" then
            self.item_anim:SetFacing(data.desc_def.facing or FACING_DOWN)
        end



        if data.desc_def.resize then
            self.item_anim:SetScale(data.desc_def.resize * 0.3)
        else
            self.item_anim:SetScale(0.3)
        end

        self.item_anim:GetAnimState():PlayAnimation(data.desc_def.desc_anim, true)
        if data.desc_def.speed then
            self.item_anim:GetAnimState():SetDeltaTimeMultiplier(data.desc_def.speed)
        end

        if data.desc_def.animcolor then
            self.item_anim:GetAnimState():SetMultColour(unpack(data.desc_def.animcolor))
        end

        self.item_anim:GetAnimState():SetTime(math.random() * self.item_anim:GetAnimState():GetCurrentAnimationLength())
    end

    y = y - 90 + data.desc_def.y_offset

    local row_start_y = y
    local column_offset_x = 80

    if data.desc_def.related_items then
        local details_y = y
        local status_scale = 0.7
        y = y + 20
        row_start_y = row_start_y + 20

        -- 相关物品
        y = y - title_font_size / 2
        title = details_root:AddChild(Text(HEADERFONT, title_font_size, desc_terms.related,
            UICOLOURS.BROWN_DARK))
        title:SetPosition(0, y)
        y = y - title_font_size / 2
        MakeDetailsLine(details_root, 0, y - 2, .49)
        y = y - 8
        y = y - body_font_size / 2
        if data.desc_def.related_items then
            self:_SetupRelatedItemDetails(data.desc_def.related_items, details_root, y)
            y = y - math.floor(#data.desc_def.related_items / 8) * name_font_size
        end

        y = y - body_font_size / 2 - 4
        y = y - 15
    end

    y = y - title_font_size / 2
    title = details_root:AddChild(Text(HEADERFONT, title_font_size, desc_terms.desc,
        UICOLOURS.BROWN_DARK))
    title:SetPosition(0, y)
    y = y - title_font_size / 2
    MakeDetailsLine(details_root, 0, y - 2, .49)
    y = y - 8

    y = y - body_font_size / 2

    local body = details_root:AddChild(Text(HEADERFONT, body_font_size, "", UICOLOURS.BROWN_DARK))
    body:SetHAlign(ANCHOR_LEFT)
    body:SetVAlign(ANCHOR_TOP)

    local descriptions = clean(data.desc_def.description)
    body:SetMultilineTruncatedString(descriptions, 50, 320)
    local _, msg_h = body:GetRegionSize()
    y = y - msg_h / 2
    body:SetPosition(0, y)

    local _, textH = body:GetRegionSize()

    local width = 360
    local category_height = 720
    local height = textH + category_height
    local PANEL_HEIGHT = 530
    local max_visible_height = PANEL_HEIGHT - 80 -- -20
    local padding = 5
    local top = max_visible_height / 2 - padding

    local scissor_data = {
        x = 0,
        y = 0,
        width = width,
        height = max_visible_height
    }
    local context = {
        widget = details_root,
        offset = {
            x = width / 2,
            y = max_visible_height / 2 - 20
        },
        size = {
            w = width,
            height = height + padding
        }
    }
    local scrollbar = {
        scroll_per_click = 20 * 3,
        h_offset = -43
    }

    local scroll_area = TrueScrollArea(context, scissor_data, scrollbar)

    scroll_area.up_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    scroll_area.up_button:SetScale(0.5)

    scroll_area.down_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    scroll_area.down_button:SetScale(-0.5)

    scroll_area.scroll_bar_line:SetTexture("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_bar.tex")
    scroll_area.scroll_bar_line:SetScale(.9)

    scroll_area.position_marker:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_handle.tex")
    scroll_area.position_marker:OnGainFocus()
    scroll_area.position_marker:SetScale(.6)

    return scroll_area
end

-- 左侧的网格信息和滚轮
function WikiDescAnimPage:BuildDesc()
    local base_size = 128
    local cell_size = 91
    local row_w = cell_size
    local row_h = cell_size;
    local reward_width = 80
    local row_spacing = 25
    local column_spacing = 5

    local item_size = cell_size + 30
    -- local icon_size = 20 / (cell_size / base_size)

    local function ScrollWidgetsCtor(context, index)
        local w = Widget("shdesc-cell-" .. index)

        ----------------
        -- 默认为未获取的显示和选中显示
        w.imagebutton = ImageButton("images/quagmire_recipebook.xml", "cookbook_unknown.tex",
            "cookbook_unknown_selected.tex")
        w.cell_root = w:AddChild(w.imagebutton)
        w.cell_root:SetFocusScale(cell_size / base_size + .05, cell_size / base_size + .05)
        w.cell_root:SetNormalScale(cell_size / base_size, cell_size / base_size)

        w.focus_forward = w.cell_root

        w.cell_root.ongainfocusfn = function()
            self.recipe_grid:OnWidgetFocus(w)
        end

        ----------------
        w.recipie_root = w.cell_root.image:AddChild(Widget("recipe_root"))

        -- 会被替换为具体图片的方形
        w.item_img = w.recipie_root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex")) -- this will be replaced with the food icon
        -- w.item_img = w.recipie_root:AddChild(Image("images/global.xml", "square.tex")) -- this will be replaced with the food icon


        w.cell_root:SetOnClick(function()
            self.details_root:KillAllChildren()
            self.details_root:AddChild(self:PopulateRecipeDetailPanel(w.data))
        end)

        ----------------
        return w
    end

    -- 已经unlock的内容会显示为known图标
    -- 将方square图片替换为具体的item图片
    local function ScrollWidgetSetData(context, widget, data, index)
        widget.data = data
        if data ~= nil then
            widget.cell_root:Show()

            widget.recipie_root:Show()
            widget.cell_root:SetTextures("images/quagmire_recipebook.xml", "cookbook_known.tex",
                "cookbook_known_selected.tex")

            widget.item_img:SetTexture(data.item_atlas, data.item_tex)
            widget.item_img:ScaleToSize(item_size, item_size)
            -- widget.item_img:SetTint(1,0, 0, 0.3)
            widget:Enable()

            local imagebutton = widget.imagebutton
            imagebutton:SetText(data.name)

            imagebutton:SetFont(HEADERFONT)
            imagebutton:SetTextColour(UICOLOURS.BLACK)
            imagebutton:SetTextFocusColour(UICOLOURS.IVORY)
            imagebutton:SetTextSelectedColour(UICOLOURS.IVORY)
            imagebutton:SetTextSize(18 * size_multi)
            imagebutton.text:SetPosition(0, -53)
        else
            widget:Disable()
            widget.cell_root:Hide()
        end
    end

    self.all_recipes = {}
    self.filtered_recipes = {}

    local category_contents = desc_contents[self.category]
    for prefab, desc_def in pairs(category_contents) do
        local data = {
            prefab = prefab,
            name = desc_def.name or STRINGS.NAMES[string.upper(prefab)] or desc_terms.unknown,
            desc_def = desc_def,
            defaultsortkey = hash(prefab),
            -- 统一的xml路径，整理图片后才会用到

        }

        local img_name = desc_def.desc_tex or (prefab .. ".tex")
        local atlas = desc_def.desc_atlas or GetInventoryItemAtlas(img_name)

        if atlas ~= nil then
            data.item_atlas = atlas
            data.item_tex = img_name
        else
            data.item_atlas = "images/hud/customization_shipwrecked.xml"
            data.item_tex = "blank_world.tex"
        end

        table.insert(self.all_recipes, data)
    end

    table.sort(self.all_recipes, function(a, b)
        return self:_sortfn_default(a, b)
    end)
    for i, data in ipairs(self.all_recipes) do
        data.index = i
    end

    local grid = TEMPLATES.ScrollingGrid({}, {
        context = {},
        widget_width = row_w + column_spacing,
        widget_height = row_h + row_spacing,
        force_peek = true,
        num_visible_rows = 3.5,
        num_columns = 4,
        item_ctor_fn = ScrollWidgetsCtor,
        apply_fn = ScrollWidgetSetData,
        scrollbar_offset = 20,
        scrollbar_height_offset = -60
    })

    -- 滚条的上箭头
    grid.up_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    grid.up_button:SetScale(0.5)

    -- 滚条的下箭头
    grid.down_button:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_arrow_hover.tex")
    grid.down_button:SetScale(-0.5)

    -- 滚条
    grid.scroll_bar_line:SetTexture("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_bar.tex")
    grid.scroll_bar_line:SetScale(.8)

    -- 滚轮位置
    grid.position_marker:SetTextures("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_handle.tex")
    grid.position_marker.image:SetTexture("images/quagmire_recipebook.xml", "quagmire_recipe_scroll_handle.tex")
    grid.position_marker:SetScale(.6)

    return grid
end

function WikiDescAnimPage:_sortfn_default(a, b)
    return a.desc_def.priority < b.desc_def.priority or
        (a.desc_def.priority == b.desc_def.priority and a.defaultsortkey > b.defaultsortkey)
end

function WikiDescAnimPage:ApplySort()
    table.sort(self.filtered_recipes, function(a, b)
        return self:_sortfn_default(a, b)
    end)
    self.recipe_grid:SetItemsData(self.filtered_recipes)
    self:_DoFocusHookups()
end

function WikiDescAnimPage:ApplyFilters()
    self.filtered_recipes = {}
    for i, item in ipairs(self.all_recipes) do
        table.insert(self.filtered_recipes, item)
    end
    self:ApplySort()
end

return WikiDescAnimPage
