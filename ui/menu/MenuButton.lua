local MenuButton = Core.class(TextField)
MenuButton.CLICK = "menuButtonClick"

local defaultTextSize 		= 5
local defaultColorNormal 	= 0xFFFFFF
local defaultColorHover 	= 0x7B2AEA

local maxShake = 30

function MenuButton:init(textSize, colorNormal, colorHover)
	if not textSize then textSize = defaultTextSize end
	if not colorNormal then colorNormal = defaultColorNormal end
	if not colorHover then colorHover = defaultColorHover end

	self.colorNormal = colorNormal
	self.colorHover = colorHover

	self:setTextColor(self.colorNormal)
	self:setScale(textSize, textSize)

	self.shake = 0

	self:addEventListener(Event.TOUCHES_BEGIN, self.onHover, self)
	self:addEventListener(Event.TOUCHES_END, self.onOut, self)
	self:addEventListener(Event.ENTER_FRAME, self.update, self)

end

function MenuButton:onHover(e)
	if not self:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	self.shakeX = self:getX()
	self.shakeY = self:getY()
	self.shake = maxShake
	self:setTextColor(self.colorHover)
end

function MenuButton:onOut(e)
	if self:getTextColor() == self.colorHover then
		self:setTextColor(self.colorNormal)
		self:setPosition(self.shakeX, self.shakeY)
	end
	if self:hitTestPoint(e.touch.x, e.touch.y) then
		self:dispatchEvent(Event.new(MenuButton.CLICK))
	end
end

function MenuButton:update()
	if self.shake > 1 then
		self:setX(self.shakeX + math.random(0, self.shake) - self.shake / 2)
		self:setY(self.shakeY + math.random(0, self.shake) - self.shake / 2)
		self.shake = self.shake * 0.9
	end
end

return MenuButton