local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local MenuSlider		= require "ui/menu/MenuSlider"
local Screen 			= require "screens/Screen"

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
	local buttonsY = utils.screenHeight * 0.4
	self.buttons = {}
	self.sliders = {}

	local sliderWidth = utils.screenWidth * 0.4

	-- Слайдер "качество графики"
	local text = TextField.new(nil, "Graphics quality")
	text:setTextColor(0xFFFFFF)
	text:setScale(2)
	text:setPosition(buttonsX, buttonsY - 10)
	self:addChild(text)

	self.sliders.graphics = MenuSlider.new(sliderWidth, 32)
	self.sliders.graphics:setPosition(buttonsX, buttonsY)
	self:addChild(self.sliders.graphics)
	
	buttonsY = buttonsY + self.sliders.graphics:getHeight() * 3

	-- Слайдер "чувствительность ввода"
	local text = TextField.new(nil, "Controls sensitivity")
	text:setTextColor(0xFFFFFF)
	text:setScale(2)
	text:setPosition(buttonsX, buttonsY - 10)
	self:addChild(text)
	self.sliders.controls = MenuSlider.new(sliderWidth, 32)
	self.sliders.controls:setPosition(buttonsX, buttonsY)
	self:addChild(self.sliders.controls)

	buttonsY = buttonsY + self.sliders.graphics:getHeight() * 3

	self.buttons.back = MenuButton.new()
	self.buttons.back:setText("Back")
	self.buttons.back:setPosition(utils.screenWidth - self.buttons.back:getWidth() - self.buttons.back:getHeight(), utils.screenHeight - self.buttons.back:getHeight())

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function SettingsMenuScreen:buttonClick(e)
	if e:getTarget() == self.buttons.back then
		screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
	elseif e:getTarget() == self.buttons.graphics then
		--[[self.settings.graphics = self.settings.graphics + 1
		if self.settings.graphics > 3 then
			self.settings.graphics = 1
		end
		self.buttons.graphics:setText("Graphics quality: " .. ({"LOW", "MEDIUM", "HIGH"})[self.settings.graphics])]]
	elseif e:getTarget() == self.buttons.controls then
		--[[self.settings.controls = self.settings.controls + 25
		if self.settings.controls > 100 then
			self.settings.controls = 25
		end
		self.buttons.controls:setText("Controls sensitivity: " .. tostring(self.settings.controls) .. "%")]]
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