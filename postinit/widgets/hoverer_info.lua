local function GetBuild(inst)
    local strnn = ""
    local str = inst.entity:GetDebugString()

    if not str then
        return nil
    end
    local bank, build, anim = str:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")

    if bank ~= nil and build ~= nil then
        strnn = strnn .. "动画bank: anim/" .. bank .. ".zip"
        strnn = strnn .. "\n" .. "贴图build: anim/" .. build .. ".zip"
    end
    return strnn
end


AddClassPostConstruct("widgets/hoverer", function(self)
    local old_SetString = self.text.SetString
    self.text.SetString = function(text, str)
        local target = TheInput:GetHUDEntityUnderMouse()
        if target ~= nil then
            target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
        else
            target = TheInput:GetWorldEntityUnderMouse()
        end
        if target and target.entity ~= nil then
            if target.prefab ~= nil then
                str = str .. "\n" .. "代码:" .. target.prefab
            end
            local build = GetBuild(target)
            if build ~= nil then
                str = str .. "\n" .. build
            end
            local skin = target:GetSkinName(target)
            if skin ~= nil then
                str = str .. "\n" .. "皮肤:" .. skin
            end

            local skinid = target.skin_id
            if skinid ~= nil then
                str = str .. "\n" .. "皮肤ID:" .. skinid
            end
        end
        return old_SetString(text, str)
    end
end)
