local DeathUI = Core.class(Sprite)

function DeathUI:init()
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

	self.backgroundImage = Bitmap.new(Assets:getTexture("assets/death_bg.png", true))
	self.backgroundImage:setScaleX(utils.screenWidth / self.backgroundImage:getWidth())
	self.backgroundImage:setScaleY(utils.screenHeight / self.backgroundImage:getHeight())
	self:addChild(self.backgroundImage)

	local deathText = TextField.new(nil, "YOU DIED")
	deathText:setScale(7 * utils.scale)
	deathText:setTextColor(0xFF0000)
	deathText:setPosition(utils.screenWidth / 2 - deathText:getWidth() / 2, math.max(deathText:getHeight() + 6, utils.screenHeight / 2 - deathText:getHeight() * 1.5))
	self:addChild(deathText)
	self.deathText = deathText

	local text = TextField.new(nil, "Tap to try again")
	text:setScale(4 * utils.scale)
	text:setTextColor(0xFFFFFF)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, utils.screenHeight / 2)
	self:addChild(text)
	self.text = text

	self.restartButton = Shape.new()
	self.restartButton:moveTo(0, 0)
	self.restartButton:lineTo(utils.screenWidth, utils.screenHeight / 2 + text:getHeight() * 2)
	self.restartButton:endPath()
end

function DeathUI:show(gameOver)
	if gameOver then
		self.deathText:setText("GAME OVER")
		self.text:setText("Tap to restart level")
	else
		self.deathText:setText("YOU DIED")
		self.text:setText("Tap to try again")
	end
	self.deathText:setPosition(utils.screenWidth / 2 - self.deathText:getWidth() / 2, math.max(self.deathText:getHeight() + 6, utils.screenHeight / 2 - self.deathText:getHeight() * 1.5))
	self.text:setPosition(utils.screenWidth / 2 - self.text:getWidth() / 2, utils.screenHeight / 2)
end

return DeathUI