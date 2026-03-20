local atlas_list = { -----有序表，需要有一定的优先级
    [1] = "images/inventoryimages/cookpotfoods_sw.xml",
    [2] = "images/inventoryimages/cookpotfoods_ham.xml",
    [3] = "images/inventoryimages/inventory_shipwrecked.xml",
    [4] = "images/inventoryimages/inventory_hamlet.xml",
    [5] = "images/inventoryimages/inventory_extension.xml",
    -- [6] = "images/hud/customization_shipwrecked.xml",
    -- [7] = "images/hud/customization_porkland.xml",
    [6] = "images/inventoryimages/pigmancity.xml",
}



local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    local rst = nil
    for i, v in ipairs(atlas_list) do
        local path = resolvefilepath(v)
        if TheSim:AtlasContains(path, imagename) then
            rst = path
            break
        end
    end

    if rst ~= nil then
        return rst
    else
        local atlasname = old_GetInventoryItemAtlas_Internal(imagename, no_fallback)
        return atlasname
    end
end

local old_GetInventoryItemAtlas = GetInventoryItemAtlas

function GetInventoryItemAtlas(imagename, no_fallback)
    local atlas = old_GetInventoryItemAtlas(imagename, no_fallback)
    -----------用来打印一些漏网之鱼----------
    if not atlas then print("IMG without ATL !!!", imagename or "nil") end
    return atlas
end

--Checks if direction vector tar is between vec1 and vec2
local function isbetween(tar, vec1, vec2)
    return ((vec2.x - vec1.x) * (tar.z - vec1.z) - (vec2.z - vec1.z) * (tar.x - vec1.x)) > 0
end


function CheckLOSFromPoint(pos, target_pos)
    local dist = target_pos:Dist(pos)
    local vec = (target_pos - pos):GetNormalized()

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, dist, { "blocker" })

    for k, v in pairs(ents) do
        if v.Physics:IsActive() then
            local blocker_pos = v:GetPosition()
            local blocker_vec = (blocker_pos - pos):GetNormalized()
            local blocker_perp = Vector3(-blocker_vec.z, 0, blocker_vec.x)
            local blocker_radius = v.Physics:GetRadius()
            blocker_radius = math.max(0.75, blocker_radius)

            local blocker_edge1 = blocker_pos +
                Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)
            local blocker_edge2 = blocker_pos -
                Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)

            local blocker_vec1 = (blocker_edge1 - pos):GetNormalized()
            local blocker_vec2 = (blocker_edge2 - pos):GetNormalized()

            --[[
            print("Checking LoS With:", v)
            local colourstr = "00000"..v.GUID
            local r = tonumber(colourstr:sub(-6, -5), 16) / 255
            local g = tonumber(colourstr:sub(-4, -3), 16) / 255
            local b = tonumber(colourstr:sub(-2), 16) / 255
            --Note : world must have debugger component and be debug selected for this to display.
            GetWorld().components.debugger:SetAll(v.GUID.."_angle1", {x=pos.x, y=pos.z}, {x=pos.x + (blocker_vec1.x * dist*2), y= pos.z + (blocker_vec1.z * dist*2)}, {r=r,g=g,b=b,a=1})
            GetWorld().components.debugger:SetAll(v.GUID.."_angle2", {x=pos.x, y=pos.z}, {x=pos.x + (blocker_vec2.x * dist*2), y= pos.z + (blocker_vec2.z * dist*2)}, {r=r,g=g,b=b,a=1})
            --]]

            if isbetween(vec, blocker_vec1, blocker_vec2) then
                return false
            end
        end
    end

    return true
end
