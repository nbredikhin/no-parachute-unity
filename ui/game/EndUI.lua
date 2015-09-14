local EndUI = Core.class(Sprite)

function EndUI:init()
	local background = Shape.new()
	background:setFillStyle(Shape.SOLID, 0, 0.5)
	background:beginPath()
	background:moveTo(0, 0)
	background:lineTo(utils.screenWidth, 0)
	background:lineTo(utils.screenWidth, utils.screenHeight)
	background:lineTo(0, utils.screenHeight)
	background:lineTo(0, 0)
	background:endPath()
	self:addChild(background)

	self.textScale = 8 * utils.scale
	local text = Bitmap.new(Assets:getTexture("assets/level_passed.png"))
	text:setScale(8 * utils.scale)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, math.max(6, utils.screenHeight / 2 - text:getHeight() / 2))
	self:addChild(text)
	self.text = text

	local text2 = Bitmap.new(Assets:getTexture("assets/level_passed2.png"))
	text2:setScale(8 * utils.scale)
	text2:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, math.max(6, utils.screenHeight / 2 - text:getHeight() / 2))
	self:addChild(text2)
	self.text2 = text2

	local buttonText = TextField.new(nil, "Tap to continue")
	buttonText:setScale(4 * utils.scale)
	buttonText:setTextColor(0xFFFFFF)
	buttonText:setPosition(utils.screenWidth / 2 - buttonText:getWidth() / 2, text:getY() + text:getHeight() + buttonText:getHeight())
	self:addChild(buttonText)
	self.buttonText = buttonText

	self.continueButton = Shape.new()
	self.continueButton:moveTo(0, 0)
	self.continueButton:lineTo(utils.screenWidth, utils.screenHeight / 2 + buttonText:getHeight() * 2)
	self.continueButton:endPath()

	self.time = 0
end


function EndUI:reset()
	self:setAlpha(0)
	self.text:setX(-self.text:getWidth() / 2)
	self.textTime = math.abs(self.text:getX() - (utils.screenWidth / 2 - self.text:getWidth() / 2)) * 1.5
	self.text2:setX(utils.screenWidth)
	self.textTime2 = math.abs(self.text2:getX() - (utils.screenWidth / 2 - self.text2:getWidth() / 2)) * 1.5
	self.time = 0
	self.buttonText:setAlpha(0)
end

function EndUI:update(deltaTime)
	self.time = self.time + deltaTime
	self:setAlpha(math.min(1, self:getAlpha() + deltaTime / 3))
	self.text:setX(math.min(self.text:getX() + deltaTime * self.textTime, utils.screenWidth / 2 - self.text:getWidth() / 2))
	self.text2:setX(math.max(self.text2:getX() - deltaTime * self.textTime2, utils.screenWidth / 2 - self.text2:getWidth() / 2))
	if self.time > 1.5 then
		self.buttonText:setAlpha(self.buttonText:getAlpha() + deltaTime)
	end
end

return EndUI