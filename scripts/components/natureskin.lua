local skinlist = require("datadefs/skin_nature_defs").skinlist
local testfns = require("datadefs/skin_nature_defs").testfns

local NatureSkin = Class(function(self, inst)
	self.nature_skin_name = nil
	self.inst = inst
	self.possible_skins = skinlist[self.inst.prefab]
	-- self:ReSkin()
end)

function NatureSkin:InheritFrom(source)
	if not source then return end

	if source.components.natureskin and source.components.natureskin.has_nature_skin then
		for k, v in pairs(self.possible_skins) do
			if v.skintype == source.components.natureskin.nature_skin_type then
				self.nature_skin_type = v.skintype
				self.nature_skin_name = k
				break
			end
		end
	else
		for k, v in pairs(self.possible_skins) do
			if (v.sourceprefabs and table.contains(v.sourceprefabs, source.prefab)) or
				(v.sourcetags and source:HasOneOfTags(v.sourcetags)) then
				self.nature_skin_type = v.skintype
				self.nature_skin_name = k
				break
			end
		end
	end


	self:SetSkin(self.nature_skin_name)

	self.has_nature_skin = true
end

function NatureSkin:SetSkin(skinname)
	if self.inst.components.inventoryitem and ----暂时搞不懂原理，但是生成立即被堆叠的不需要reskin
		(not self.inst.replica.inventoryitem or not self.inst.replica.inventoryitem.classified) then
		return
	end
	if skinname then
		TheSim:ReskinEntity(self.inst.GUID, self.inst.skinname or self.inst.natureskinname, skinname) ----怎么切换成默认皮肤
	end
end

function NatureSkin:ReSkin()
	if self.has_nature_skin then
		if not self.inst.skinname and self.nature_skin_name then
			self:SetSkin(self.nature_skin_name)
		end
	else
		for k, v in pairs(self.possible_skins) do
			if v.skintype and testfns[v.skintype] and testfns[v.skintype](self.inst) then
				self.nature_skin_name = k
				self.nature_skin_type = v.skintype
				break
			end
		end
		self:SetSkin(self.nature_skin_name)
		self.has_nature_skin = true --这一步必须在dotaskintime里面，让人非常奇怪
	end


	--根据是否有onload的数据决定是否重新换皮
	--留1帧给其他前置操作时间
end

function NatureSkin:OnSave()
	-- print("skin save111" .. self.inst.prefab)
	-- print((self.nature_skin_name or "nil") ..
	-- 	(self.nature_skin_type or "nil") .. (self.has_nature_skin and "true" or "nil"))
	return {
		nature_skin_name = self.nature_skin_name,
		nature_skin_type = self.nature_skin_type,
		has_nature_skin = self.has_nature_skin,

	}
end

function NatureSkin:OnLoad(data)
	-- print("skin load111" .. self.inst.prefab)
	-- print((data.nature_skin_name or "nil") ..
	-- 	(data.nature_skin_type or "nil") .. (data.has_nature_skin and "true" or "nil"))

	if data then
		self.nature_skin_name = data.nature_skin_name
		self.nature_skin_type = data.nature_skin_type
		self.has_nature_skin = data.has_nature_skin
	end
end

return NatureSkin
