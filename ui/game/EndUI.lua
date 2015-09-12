local EndUI = Core.class(Sprite)

function EndUI:init()
	local background = Shape.new()
	background:setFillStyle(Shape.SOLID, 0, 1)
	background:beginPath()
	background:moveTo(0, 0)
	background:lineTo(utils.screenWidth, 0)
	background:lineTo(utils.screenWidth, utils.screenHeight)
	background:lineTo(0, utils.screenHeight)
	background:lineTo(0, 0)
	background:endPath()
	self:addChild(background)

	local text = TextField.new(nil, "LEVEL COMPLETED")
	text:setScale(7)
	text:setTextColor(0xFFFFFF)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, math.max(text:getHeight() + 6, utils.screenHeight / 2))
	self:addChild(text)

	local buttonText = TextField.new(nil, "Tap to continue")
	buttonText:setScale(4)
	buttonText:setTextColor(0xFFFFFF)
	buttonText:setPosition(utils.screenWidth / 2 - buttonText:getWidth() / 2, text:getY() + text:getHeight() + buttonText:getHeight())
	self:addChild(buttonText)

	self.continueButton = Shape.new()
	self.continueButton:moveTo(0, 0)
	self.continueButton:lineTo(utils.screenWidth, utils.screenHeight / 2 + buttonText:getHeight() * 2)
	self.continueButton:endPath()
end

return EndUI