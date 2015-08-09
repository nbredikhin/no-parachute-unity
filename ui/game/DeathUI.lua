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

	local text = TextField.new(nil, "Tap to restart")
	text:setScale(4)
	text:setTextColor(0xFFFFFF)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, utils.screenHeight / 2)
	self:addChild(text)
end

return DeathUI