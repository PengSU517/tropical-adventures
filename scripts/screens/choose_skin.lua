local Screen = require "widgets/screen"
local Widget = require "widgets/widget" 
local Text = require "widgets/text" 
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local TextEdit = require "widgets/textedit" 
local TextButton = require "widgets/textbutton"


local choose_skin = Class(Screen ,function(self,owner)

Screen._ctor(self, "choose_skin")--创建这个界面,choose_skin为screen名称
--TheInput:ClearCachedController()--让玩家不能使用摁键?
self.owner = owner

--载入按钮

local x=100
 local y=-250

--]]

self.root = self:AddChild(Widget("ROOT"))--可理解为创建屏幕的一个基础点
self.root:SetVAnchor(ANCHOR_MIDDLE)--把整个界面的中心点设成屏幕中心点
self.root:SetHAnchor(ANCHOR_RIGHT)
self.root:SetPosition(-300,0,0)
self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)




self.bg=self.root:AddChild(Image("images/choose_skin.xml","choose_skin.tex"))--panel_long
self.bg:SetVRegPoint(ANCHOR_MIDDLE)
self.bg:SetHRegPoint(ANCHOR_MIDDLE)
self.bg:SetScale(0.8,0.8,0.8)
self.bg:SetFadeAlpha(0.8)

self.text0=self.root:AddChild(Text(BODYTEXTFONT,40))
self.text0:SetPosition(0,180,0)
self.text0:SetString("换人物部件")
self.text0:SetColour(240/255,152/255,74/255,1)
self.text0:EnableWordWrap(true)

self.text={}
self.abctext={}
local line=1

for i=1,12 do
	self.text[i]=self.root:AddChild(TextButton("images/ui.xml","blank.tex","blank.tex","blank.tex","blank.tex"))
	self.text[i]:SetPosition(0,170-i*30,0)
	self.text[i]:SetText("人物"..i)
	self.text[i]:SetTextSize(25)
	self.text[i]:SetColour(240/255,152/255,74/255,1)
	self.text[i]:SetOnClick(function() 
		SendModRPCToServer(GetModRPC("choose_skin0","choose_skin0"),i)
		line=170-i*30
		for i=1,5 do
			self.abctext[i]:SetPosition(110,line-i*30+30,0)
		end
	end)

	
end
self.text[1]:SetText("威尔逊")
self.text[2]:SetText("威洛")
self.text[3]:SetText("沃尔夫冈")
self.text[4]:SetText("温蒂")
self.text[5]:SetText("机器人")
self.text[6]:SetText("老奶奶")
self.text[7]:SetText("伍迪")
self.text[8]:SetText("维斯")
self.text[9]:SetText("麦斯威尔")
self.text[10]:SetText("女武神")
self.text[11]:SetText("韦伯")
self.text[12]:SetText("女工")

for i=1,5 do
	self.abctext[i]=self.root:AddChild(TextButton("images/ui.xml","blank.tex","blank.tex","blank.tex","blank.tex"))
	self.abctext[i]:SetPosition(110,170-i*30,0)
	self.abctext[i]:SetText("部位"..i)
	self.abctext[i]:SetTextSize(25)
	self.abctext[i]:SetColour(169/255,163/255,160/255,1)
	self.abctext[i]:SetOnClick(function() 
		SendModRPCToServer(GetModRPC("choose_skin1","choose_skin1"),i)
	end)

	
end

self.abctext[1]:SetText("脸")
self.abctext[2]:SetText("头发")
self.abctext[3]:SetText("马尾")
self.abctext[4]:SetText("头部")
self.abctext[5]:SetText("身体")




local closebutton=self.root:AddChild(TextButton("images/ui.xml","blank.tex","blank.tex","blank.tex","blank.tex"))
closebutton:SetPosition(130,240,0)
closebutton.text:SetRegionSize(100,50)
closebutton.text:SetHAlign(ANCHOR_MIDDLE)
closebutton:SetText("关闭")
closebutton:SetTextSize(45)
closebutton:SetFont(UIFONT)
--closebutton:SetTextColour(244/255,62/255,6/255,1)
--closebutton:SetTextFocusColour(244/255,62/255,6/255,1)
closebutton:SetColour(1,0,0,1)
closebutton:SetOverColour(1,1,1,1)
closebutton:SetOnClick(function()self:Close() end)--]]




--[[TheInput:AddKeyDownHandler(KEY_A,function()
    x=x+1
 closebutton:SetPosition( x or 85, y or -20, 0)
 end)
TheInput:AddKeyDownHandler(KEY_D,function()
  x=x-1
closebutton:SetPosition( x or 85, y or -20, 0)
end)
 TheInput:AddKeyDownHandler(KEY_W,function()
   y=y+1
closebutton:SetPosition( x or 85, y or -20, 0)
end)
 TheInput:AddKeyDownHandler(KEY_S,function()
    y=y-1
 closebutton:SetPosition( x or 85, y or -20, 0)
end)
 TheInput:AddKeyDownHandler(KEY_Z,function()
print(x.." "..y)
end)--]]
--[[local cancelbutton=self.root:AddChild(TextButton("images/ui.xml","blank.tex","blank.tex","blank.tex","blank.tex"))
cancelbutton:SetPosition(250,-90,0)
cancelbutton.text:SetRegionSize(100,50)
cancelbutton.text:SetHAlign(ANCHOR_MIDDLE)
cancelbutton:SetText("取消")
cancelbutton:SetTextSize(32)
cancelbutton:SetFont(UIFONT)
cancelbutton:SetTextColour(0.9,0.8,0.6,1)
cancelbutton:SetTextFocusColour(1,1,1,1)
cancelbutton:SetOnClick(function()self:Close() end)--]]





end)




function choose_skin:Close()

	TheFrontEnd:PopScreen()

end



return choose_skin














