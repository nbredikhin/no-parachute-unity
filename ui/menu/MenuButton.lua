local MenuButton = Core.class(TextField)
MenuButton.CLICK = "menuButtonClick"

local defaultTextSize 		= 5
local defaultColorNormal 	= 0xFFFFFF
local defaultColorHover 	= 0x7B2AEA

local maxShake = 30

function MenuButton:init()
	self.colorNormal = defaultColorNormal
	self.colorHover = defaultColorHover

	self:setTextColor(self.colorNormal)
	local textSize = math.min(defaultTextSize, math.max(1, math.floor(defaultTextSize * utils.screenHeight / 500)))
	self:setScale(textSize, textSize)

	self.shake = 0
	self.isHovered = false

	self:addEventListener(Event.TOUCHES_BEGIN, self.onHover, self)
	self:addEventListener(Event.TOUCHES_END, self.onOut, self)
	self:addEventListener(Event.ENTER_FRAME, self.update, self)
end

function MenuButton:onHover(e)
	if not self.doubleClickFix then
		return
	end
	if not self:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	if self:getTextColor() == self.normalColor then
		return
	end
	if self.shake < 1 then
		self.shakeX = self:getX()
		self.shakeY = self:getY()
	end
	self.shake = maxShake
	self:setTextColor(self.colorHover)
	self.isHovered = true
end

function MenuButton:onOut(e)
	if not self.doubleClickFix then
		return
	end
	if self:getTextColor() == self.colorHover then
		self:setTextColor(self.colorNormal)
		self:setPosition(self.shakeX, self.shakeY)
	end
	if self:hitTestPoint(e.touch.x, e.touch.y) and self.isHovered then
		self:dispatchEvent(Event.new(MenuButton.CLICK))
		self.isHovered = false
		self.doubleClickFix = false
	end
end

function MenuButton:update()
	if not self.doubleClickFix then
		self.doubleClickFix = true
	end
	if self.shake > 1 then
		self:setX(self.shakeX + math.random(0, self.shake) - self.shake / 2)
		self:setY(self.shakeY + math.random(0, self.shake) - self.shake / 2)
		self.shake = self.shake * 0.9
	end
end

return MenuButton