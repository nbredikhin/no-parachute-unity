local DeathUI = require "ui/game/DeathUI"

local GameUI = Core.class(Sprite)

function GameUI:init()
	self.touchButton = Bitmap.new(Texture.new("assets/button.png"))
	self.touchButton:setAnchorPoint(0.5, 0.5)
	self.touchButton:setScale(0.3, 0.3)
	self.touchButton:setAlpha(0.5)
	self:addChild(self.touchButton)
	self.touchButton:setVisible(false)

	self.deathUI = DeathUI.new()
	self:addChild(self.deathUI)
	self.deathUI:setVisible(false)
end

return GameUI