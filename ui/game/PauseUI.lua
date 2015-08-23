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

	local text = TextField.new(nil, "Tap to continue")
	text:setScale(4)
	text:setTextColor(0xFFFFFF)
	text:setPosition(utils.screenWidth / 2 - text:getWidth() / 2, utils.screenHeight / 2 + text:getHeight() / 2)
	self:addChild(text)

	--[[local backButton = TextField.new(nil, "Back to menu")
	backButton:setScale(3)
	backButton:setTextColor(0xFFFFFF)
	backButton:setPosition(utils.screenWidth / 2 - backButton:getWidth() / 2, text:getY() + text:getHeight() * 1.5)
	self:addChild(backButton)]]
end

return PauseUI