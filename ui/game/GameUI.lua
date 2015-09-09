local DeathUI 		= require "ui/game/DeathUI"
local PauseUI 		= require "ui/game/PauseUI"
local MenuButton 	= require "ui/menu/MenuButton"

local GameUI = Core.class(Sprite)

function GameUI:init()
	self.touchButton = Bitmap.new(Assets:getTexture("assets/button.png"))
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

	self.pauseButton = Bitmap.new(Assets:getTexture("assets/pause.png"))
	self.pauseButton:setScale(math.min(16, utils.screenHeight / 25))
	self.pauseButton:setX(utils.screenWidth - self.pauseButton:getWidth() * 1.25)
	self.pauseButton:setY(utils.screenHeight - self.pauseButton:getHeight() * 1.25)
	self.pauseButton:setAlpha(0.5)
	self:addChild(self.pauseButton)

	self.backButton = MenuButton.new(nil, "Exit to menu")
	self.backButton:setScale(4)
	self.backButton:setVisible(false)
	self.backButton:setPosition(utils.screenWidth / 2 - self.backButton:getWidth() / 2, utils.screenHeight - self.backButton:getHeight() * 0.5)
	self:addChild(self.backButton)

	local progressBarSize = math.min(4, utils.screenHeight * 0.012)
	self.progressBarBackground = Bitmap.new(Assets:getTexture("assets/bar.png"))
	self.progressBarBackground:setScaleX(utils.screenWidth)
	self.progressBarBackground:setScaleY(progressBarSize)
	self.progressBarBackground:setAlpha(0.3)
	self.progressBarBackground:setColorTransform(0.2, 0.2, 0.2)

	self.progressBarLine = Bitmap.new(Assets:getTexture("assets/bar.png"))
	self.progressBarLine:setScaleX(utils.screenWidth / 3)
	self.progressBarLine:setScaleY(progressBarSize)
	self.progressBarLine:setAlpha(0.7)
	self.progressBarLine:setColorTransform(59/255, 226/255, 103/255, 1)

	self.progressBar = Sprite.new()
	self.progressBar:addChild(self.progressBarBackground)
	self.progressBar:addChild(self.progressBarLine)
	self:addChild(self.progressBar)
end

function GameUI:setProgress(progress)
	progress = math.min(1, progress)
	progress = math.max(0, progress)
	self.progressBarLine:setScaleX(utils.screenWidth * progress)
end

function GameUI:setDeathUIVisible(isVisible)
	self.deathUI:setVisible(isVisible)
	self.pauseButton:setVisible(not isVisible)
	self.backButton:setVisible(isVisible)
	self.progressBar:setVisible(not isVisible)
end

function GameUI:setPauseUIVisible(isVisible)
	self:setDeathUIVisible(false)
	self.backButton:setVisible(isVisible)
	self.pauseUI:setVisible(isVisible)
	self.pauseButton:setVisible(not isVisible)
	self.progressBar:setVisible(not isVisible)
end

function GameUI:update(deltaTime)
end

return GameUI