local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local MenuSlider		= require "ui/menu/MenuSlider"
local Screen 			= require "screens/Screen"

local LevelSelectScreen = Core.class(Screen)

function LevelSelectScreen:load()
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.buttons = {}
	self.buttons.start = MenuButton.new()
	self.buttons.start:setText("Play level")
	self.buttons.start:setPosition(utils.screenWidth / 2 - self.buttons.start:getWidth() / 2, utils.screenHeight - self.buttons.start:getHeight())

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function LevelSelectScreen:buttonClick(e)
	if e:getTarget() == self.buttons.start then
		screenManager:loadScreen("GameScreen", 1)
	end
end

function LevelSelectScreen:update(dt)
	self.background:update(dt)
end

function LevelSelectScreen:back()
	screenManager:loadScreen("MainMenuScreen")
end


return LevelSelectScreen