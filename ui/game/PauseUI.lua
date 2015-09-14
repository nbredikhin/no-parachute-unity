local PauseUI = Core.class(Sprite)

function PauseUI:init()
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

	local paused = Bitmap.new(Assets:getTexture("assets/paused.png"))
	paused:setScale(8 * utils.scale)
	paused:setPosition(utils.screenWidth / 2 - paused:getWidth() / 2, math.max(6, utils.screenHeight / 2 - paused:getHeight() / 2))
	self:addChild(paused)

	local text = TextField.new(nil, "Tap to continue")
	text:setScale(4 * utils.scale)
	text:setTextColor(0xFFFFFF)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, paused:getY() + paused:getHeight() + text:getHeight())
	self:addChild(text)

	self.continueText = Shape.new()
	self.continueText:moveTo(0, 0)
	self.continueText:lineTo(utils.screenWidth, text:getY() + text:getHeight() / 2)
	self.continueText:endPath()
end


return PauseUI