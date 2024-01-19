local Getposition = Class(function(self, inst)
    self.inst = inst;
    self.maxnum = 500
    self.roomnum = 0
    self.num = 0
end)

function Getposition:GetPosition()
    if self:IsMax() then
        return
    end

    local x, z = -1950, -1950 ------------太远会超出加载范围
    local aa = math.ceil(self.num / 5) - 1
    x = x + 100 * aa
    z = 100 * ((self.num - 5 * aa) - 1) + z


    while (#TheSim:FindEntities(x, 0, z, 20) > 0) do --很近的范围不能有东西
        self.num = self.num + 1
        aa = math.ceil(self.num / 5) - 1
        x = x + 100 * aa
        z = 100 * ((self.num - 5 * aa) - 1) + z
    end

    return x, z
end

function Getposition:IsMax()
    return self.roomnum >= self.maxnum
end

function Getposition:BuildHouse()
    self.roomnum = self.roomnum + 1
    self.num = self.num + 1
end

function Getposition:OnLoad(data)
    if data then
        self.num = data.num
        self.roomnum = data.roomnum
    end
end

function Getposition:OnSave()
    return {
        num = self.num,
        roomnum = self.roomnum,
    }
end

return Getposition
