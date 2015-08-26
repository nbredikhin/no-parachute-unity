local DeathUI = require "ui/game/DeathUI"
local PauseUI = require "ui/game/PauseUI"

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

	self.pauseUI = PauseUI.new()
	self:addChild(self.pauseUI)
	self.pauseUI:setVisible(false)

	self.pauseButton = Bitmap.new(Texture.new("assets/pause.png"))
	self.pauseButton:setScale(math.min(16, utils.screenHeight / 25))
	self.pauseButton:setX(utils.screenWidth - self.pauseButton:getWidth() * 1.25)
	self.pauseButton:setY(utils.screenHeight - self.pauseButton:getHeight() * 1.25)
	self.pauseButton:setAlpha(0.5)
	self:addChild(self.pauseButton)
end

function GameUI:setDeathUIVisible(isVisible)
	self.deathUI:setVisible(isVisible)
	self.pauseButton:setVisible(not isVisible)
end

function GameUI:setPauseUIVisible(isVisible)
	self:setDeathUIVisible(false)

	self.pauseUI:setVisible(isVisible)
	self.pauseButton:setVisible(not isVisible)
end

function GameUI:update(deltaTime)
end

return GameUI