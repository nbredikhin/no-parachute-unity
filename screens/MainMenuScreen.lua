local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local Screen 			= require "screens/Screen"

local MainMenuScreen = Core.class(Screen)

function MainMenuScreen:load()
	-- Фон
	self.background = MenuBackground.new()
	self:addChild(self.background)

	-- Кнопки
	local buttonsX = utils.screenWidth * 0.05
	local buttonsY = utils.screenHeight / 2
	self.buttons = {}
	self.buttons.start = MenuButton.new()
	self.buttons.start:setText("Start game")
	self.buttons.start:setPosition(buttonsX, buttonsY)

	buttonsY = buttonsY + self.buttons.start:getHeight() * 2
	self.buttons.settings = MenuButton.new()
	self.buttons.settings:setText("Settings")
	self.buttons.settings:setPosition(buttonsX, buttonsY)

	buttonsY = buttonsY + self.buttons.start:getHeight() * 2
	self.buttons.credits = MenuButton.new()
	self.buttons.credits:setText("Credits")
	self.buttons.credits:setPosition(buttonsX, buttonsY)
	

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function MainMenuScreen:unload()

end

function MainMenuScreen:buttonClick(e)
	if e:getTarget() == self.buttons.start then
		screenManager:loadScreen("LevelSelectScreen")
	elseif e:getTarget() == self.buttons.settings then
		screenManager:loadScreen("SettingsMenuScreen")
	elseif e:getTarget() == self.buttons.credits then
		screenManager:loadScreen("AboutScreen")
	end
end

function MainMenuScreen:update(dt)
	-- Фон
	self.background:update(dt)
end

function MainMenuScreen:back()
	application:exit()
end

return MainMenuScreen
