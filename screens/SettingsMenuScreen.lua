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

	-- Слайдер "громкость звука"
	local text = TextField.new(nil, "Sounds")
	text:setTextColor(0xFFFFFF)
	text:setScale(2 * utils.scale)
	text:setPosition(buttonsX, buttonsY - 10)
	self:addChild(text)

	self.buttons.sound = MenuButton.new()
	self.buttons.sound:setText("Yes")
	if not SettingsManager.settings.sound_enabled then
		self.buttons.sound:setText("No")
	end
	self.buttons.sound:setPosition(buttonsX, buttonsY + 20 * utils.scale + self.buttons.sound:getHeight() / 2)
	self:addChild(self.buttons.sound)

	-- Слайдер "громкость звука"
	local vibrationX = math.max(utils.screenWidth / 2 - text:getWidth() * 2, text:getX() + text:getWidth() + 10)
	local text = TextField.new(nil, "Vibration")
	text:setTextColor(0xFFFFFF)
	text:setScale(2 * utils.scale)
	text:setPosition(vibrationX, buttonsY - 10)
	self:addChild(text)

	self.buttons.vibration = MenuButton.new()
	self.buttons.vibration:setText("Yes")
	if not SettingsManager.settings.vibration_enabled then
		self.buttons.vibration:setText("No")
	end
	self.buttons.vibration:setPosition(vibrationX, buttonsY + 20 * utils.scale + self.buttons.vibration:getHeight() / 2)
	self:addChild(self.buttons.vibration)
	
	buttonsY = buttonsY + self.buttons.sound:getHeight() * 3

	-- Слайдер "качество графики"
	local text = TextField.new(nil, "Graphics quality")
	text:setTextColor(0xFFFFFF)
	text:setScale(2 * utils.scale)
	text:setPosition(buttonsX, buttonsY - 10)
	self:addChild(text)

	self.sliders.graphics = MenuSlider.new(sliderWidth, 32 * utils.scale)
	self.sliders.graphics:setPosition(buttonsX, buttonsY)
	self:addChild(self.sliders.graphics)
	
	buttonsY = buttonsY + self.sliders.graphics:getHeight() * 3

	-- Слайдер "чувствительность ввода"
	local text = TextField.new(nil, "Controls sensitivity")
	text:setTextColor(0xFFFFFF)
	text:setScale(2 * utils.scale)
	text:setPosition(buttonsX, buttonsY - 10)
	self:addChild(text)
	self.sliders.controls = MenuSlider.new(sliderWidth, 32 * utils.scale)
	self.sliders.controls:setPosition(buttonsX, buttonsY)
	self:addChild(self.sliders.controls)

	buttonsY = buttonsY + self.sliders.graphics:getHeight() * 3

	self.buttons.back = MenuButton.new()
	self.buttons.back:setText("Back")
	self.buttons.back:setPosition(utils.screenWidth - self.buttons.back:getWidth() - self.buttons.back:getHeight() / 2, utils.screenHeight - self.buttons.back:getHeight() / 2)

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
	
	self.sliders.graphics:setValue(SettingsManager.settings.graphics_quality)
	self.sliders.controls:setValue(SettingsManager.settings.input_sensitivity)
end

function SettingsMenuScreen:updateButtonText(b)
	local text = "Yes"
	if b:getText() == "Yes" then
		text = "No"
	end
	b:setText(text)
end

function SettingsMenuScreen:buttonClick(e)
	if e:getTarget() == self.buttons.back then
		self:back()
	elseif e:getTarget() == self.buttons.sound then
		self:updateButtonText(self.buttons.sound)
		SettingsManager.settings.sound_enabled = e:getTarget():getText() == "Yes"
	elseif e:getTarget() == self.buttons.vibration then
		self:updateButtonText(self.buttons.vibration)
		SettingsManager.settings.vibration_enabled = e:getTarget():getText() == "Yes"
	end
end

function SettingsMenuScreen:update(dt)
	self.background:update(dt)
end

function SettingsMenuScreen:back()
	-- Возврат на главный экран
	SettingsManager.settings.graphics_quality = self.sliders.graphics:getValue()
	SettingsManager.settings.input_sensitivity = self.sliders.controls:getValue()
	SettingsManager:save()

	screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
end

return SettingsMenuScreen