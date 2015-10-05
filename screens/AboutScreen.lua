local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local MenuSlider		= require "ui/menu/MenuSlider"
local Screen 			= require "screens/Screen"

local AboutScreen = Core.class(Screen)

function AboutScreen:load()
	-- Фон
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.settings = {
		graphics = 3,
		controls = 50,
	}

	local buttonsX = utils.screenWidth * 0.05
	local buttonsY = utils.screenHeight * 0.4

	local lines = {}
	lines[1] = TextField.new(nil, "\"No Parachute!\"")
	lines[2] = "-"
	lines[3] = "-"
	lines[4] = TextField.new(nil, "Programming and art by Nikita Bredikhin")
	lines[5] = TextField.new(nil, "  bredikhin.nikita@gmail.com")
	lines[6] = "-"
	lines[7] = TextField.new(nil, "With help of Eugene Morozov")
	lines[8] = TextField.new(nil, "  morozov5f@gmail.com")

	for i,_ in ipairs(lines) do
		if lines[i] ~= "-" then
			lines[i]:setTextColor(0xFFFFFF)
			lines[i]:setScale(2 * utils.scale)
			lines[i]:setPosition(buttonsX, buttonsY - 10)
			self:addChild(lines[i])
		end
		buttonsY = buttonsY + lines[1]:getHeight() * 2	
	end

	self.buttons = {}
	self.buttons.back = MenuButton.new()
	self.buttons.back:setText("Back")
	self.buttons.back:setPosition(utils.screenWidth - self.buttons.back:getWidth() - self.buttons.back:getHeight() / 2, utils.screenHeight - self.buttons.back:getHeight() / 2)

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function AboutScreen:buttonClick(e)
	if e:getTarget() == self.buttons.back then
		self:back()
	end
end

function AboutScreen:update(dt)
	self.background:update(dt)
end

function AboutScreen:back()
	screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
end

return AboutScreen