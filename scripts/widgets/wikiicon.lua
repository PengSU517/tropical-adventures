local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local desc_terms = require("datadefs/wikibook_contents").wiki_terms

-- 定义按键常量（对应 DST 标准输入值）
local MOUSEBUTTON_CLICK = MOUSEBUTTON_LEFT   -- 右键拖拽 (2)
local MOUSEBUTTON_DRAG = MOUSEBUTTON_RIGHT   -- 右键拖拽 (2)
local MOUSEBUTTON_RESET = MOUSEBUTTON_MIDDLE -- 中键复位 (3)
local SCROLL_UP = MOUSEBUTTON_SCROLLUP       -- 滚轮向上 (4)
local SCROLL_DOWN = MOUSEBUTTON_SCROLLDOWN   -- 滚轮向下 (5)
local SAVE_KEY = "WikiIcon_User_Layout"      -- 存档键名

-- -- 存档读写封装（确保数据持久化）
-- local function SaveData(id, value)
--     if not id then return end
--     if SaveModData then
--         SaveModData(id, value)
--     end
-- end

-- local function LoadData(id)
--     if not id then return nil end
--     if LoadModData then
--         return LoadModData(id)
--     end
--     return nil
-- end

local WikiIcon = Class(Widget, function(self)
    Widget._ctor(self, "WikiIcon")
    self.root = self:AddChild(Widget("ROOT"))

    -- 1. 创建图标按钮
    self.pageIcon = self.root:AddChild(ImageButton(
        "images/inventoryimages1.xml", "book_research_station.tex",
        nil, nil, nil, nil, { 1, 1 }, { 0, 0 }))

    self.pageIcon:SetScale(2.5, 2.5, 2.5)
    self.pageIcon:SetHAnchor(1)      -- 左
    self.pageIcon:SetVAnchor(2)      -- 下
    self.pageIcon:SetPosition(350, 70, 0)
    self.pageIcon:SetClickable(true) -- 确保接收鼠标事件

    -- 基础功能：点击打开界面
    self.pageIcon:SetOnClick(function()
        if ThePlayer and ThePlayer.HUD then
            ThePlayer.HUD:OpenWikiBookScreen()
        end
    end)

    -- --- 核心搬运逻辑开始 --- ---

    -- 记录原始位置和缩放用于复位
    self.oldPos                 = self.pageIcon:GetPosition()
    local sx, sy, sz            = self.pageIcon:GetLooseScale()
    self.oldScale               = Vector3(sx, sy, sz)

    -- 2. 拦截 SetPosition 和 SetScale
    -- 只有处于“手动应用变换”或“正在拖拽”时，才允许执行位移，防止 HUD 自动重置位置
    local oldSetPos             = self.pageIcon.SetPosition
    self.pageIcon.SetPosition   = function(inst, ...)
        if self.allowTransform or self.isDragging then
            oldSetPos(inst, ...)
        end
    end

    local oldSetScale           = self.pageIcon.SetScale
    self.pageIcon.SetScale      = function(inst, ...)
        if self.allowTransform or self.isDragging then
            oldSetScale(inst, ...)
        end
    end

    -- 辅助方法：强制应用变换
    self.ApplyTransform         = function(inst, fn, ...)
        self.allowTransform = true
        fn(inst, ...)
        self.allowTransform = false
    end

    -- 3. 存档与加载
    self.SaveLayout             = function()
        local pos = self.pageIcon:GetPosition()
        local scx, scy, scz = self.pageIcon:GetLooseScale()
        local data = {
            pos = { x = pos.x, y = pos.y, z = pos.z },
            scale = { x = scx, y = scy, z = scz }
        }
        -- SaveData(SAVE_KEY, data)
    end

    self.LoadLayout             = function()
        local data = nil --LoadData(SAVE_KEY)
        if data then
            if data.pos then
                self.ApplyTransform(self.pageIcon, oldSetPos, data.pos.x, data.pos.y, data.pos.z)
            end
            if data.scale then
                self.ApplyTransform(self.pageIcon, oldSetScale, data.scale.x, data.scale.y, data.scale.z)
            end
        end
    end

    -- 4. 鼠标事件处理
    local oldOnMB               = self.pageIcon.OnMouseButton
    self.pageIcon.OnMouseButton = function(inst, button, down, x, y)
        local handled = false

        if button == MOUSEBUTTON_DRAG then
            handled = true
            if down then
                self.isDragging = true -- 允许 SetPosition 执行位移
                inst:FollowMouse()     -- 开始跟随鼠标
            else
                inst:StopFollowMouse() -- 停止跟随
                self.isDragging = false
                self.SaveLayout()      -- 停止后保存位置
            end
        elseif button == MOUSEBUTTON_RESET and not self.isDragging then
            -- 复位功能
            handled = true
            self.ApplyTransform(inst, oldSetPos, self.oldPos.x, self.oldPos.y, self.oldPos.z)
            self.ApplyTransform(inst, oldSetScale, self.oldScale.x, self.oldScale.y, self.oldScale.z)
            self.SaveLayout()
        elseif (button == SCROLL_UP or button == SCROLL_DOWN) and not self.isDragging then
            -- 缩放功能 (步长 0.05)
            handled = true
            local curX, curY, curZ = inst:GetLooseScale()
            local step = (button == SCROLL_UP) and 0.05 or -0.05
            local nextS = math.max(1, curX + step) -- 限制最小缩放防止消失
            self.ApplyTransform(inst, oldSetScale, nextS, nextS, nextS)
            self.SaveLayout()
        end

        -- 如果处理了自定义按键，返回 true 拦截事件
        if handled then return true end

        -- 否则交还给原生的 ImageButton 处理（确保左键点击正常执行）
        if oldOnMB then return oldOnMB(inst, button, down, x, y) end
    end

    -- 5. 设置提示语与读取存档

    local clickIcon             = STRINGS.UI.CONTROLSSCREEN.INPUTS[1][MOUSEBUTTON_CLICK] or ""
    local dragIcon              = STRINGS.UI.CONTROLSSCREEN.INPUTS[1][MOUSEBUTTON_DRAG] or ""
    local resetIcon             = STRINGS.UI.CONTROLSSCREEN.INPUTS[1][MOUSEBUTTON_RESET] or ""
    local zoomIcon              = STRINGS.UI.CONTROLSSCREEN.INPUTS[1][SCROLL_DOWN] -- 滚轮通常使用这个通用标签表示缩放

    local baseTip               = desc_terms.click_to_read or ""
    local fullTooltip           = string.format("%s %s\n%s %s    %s %s",
        clickIcon, baseTip,
        dragIcon, desc_terms.drag,
        zoomIcon, desc_terms.zoom
    )
    self.pageIcon:SetTooltip(fullTooltip)

    self:LoadLayout() -- 启动时自动加载保存的位置和大小

    -- --- 核心搬运逻辑结束 --- ---
end)

return WikiIcon
