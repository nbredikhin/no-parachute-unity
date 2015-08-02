local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton	= require "ui/menu/MenuButton"
local Screen 		= require "screens/Screen"

local SettingsMenuScreen = Core.class(Screen)

function SettingsMenuScreen:load()
	-- Фон
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.settings = {
		graphics = 3,
		controls = 50,
	}

	-- Кнопки
	local buttonsX = utils.screenWidth * 0.05
	local buttonsY = utils.screenHeight / 2
	self.buttons = {}
	self.buttons.graphics = MenuButton.new()
	self.buttons.graphics:setText("Graphics quality: HIGH")
	self.buttons.graphics:setPosition(buttonsX, buttonsY)

	buttonsY = buttonsY + self.buttons.graphics:getHeight() * 2
	self.buttons.controls = MenuButton.new()
	self.buttons.controls:setText("Controls sensitivity: 50%")
	self.buttons.controls:setPosition(buttonsX, buttonsY)

	buttonsY = buttonsY + self.buttons.graphics:getHeight() * 2
	self.buttons.back = MenuButton.new()
	self.buttons.back:setText("Back")
	self.buttons.back:setPosition(buttonsX, buttonsY)

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function SettingsMenuScreen:buttonClick(e)
	if e:getTarget() == self.buttons.back then
		screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
	elseif e:getTarget() == self.buttons.graphics then
		self.settings.graphics = self.settings.graphics + 1
		if self.settings.graphics > 3 then
			self.settings.graphics = 1
		end
		self.buttons.graphics:setText("Graphics quality: " .. ({"LOW", "MEDIUM", "HIGH"})[self.settings.graphics])
	elseif e:getTarget() == self.buttons.controls then
		self.settings.controls = self.settings.controls + 25
		if self.settings.controls > 100 then
			self.settings.controls = 25
		end
		self.buttons.controls:setText("Controls sensitivity: " .. tostring(self.settings.controls) .. "%")
	end
end

function SettingsMenuScreen:update(dt)
	self.background:update(dt)
end

function SettingsMenuScreen:back()
	-- Возврат на главный экран
	screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
end

return SettingsMenuScreen