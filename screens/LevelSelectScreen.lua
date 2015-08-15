local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local MenuSlider		= require "ui/menu/MenuSlider"
local Screen 			= require "screens/Screen"

local LevelSelectScreen = Core.class(Screen)

function LevelSelectScreen:load()
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.icons = {}
	local iconsSpace = utils.screenWidth * 0.04
	local iconsContainer = Sprite.new()
	self:addChild(iconsContainer)
	for y = 1, 2 do
		for x = 1, 4 do
			local icon = Bitmap.new(Texture.new("assets/icons/" .. tostring(#self.icons + 1) .. ".png"))
			iconsContainer:addChild(icon)
			icon:setAlpha(0.1)
			icon:setPosition((x-1)*(icon:getWidth()+iconsSpace), (y-1)*(icon:getHeight()+iconsSpace))
			icon:addEventListener(Event.TOUCHES_BEGIN, 
				function(data, e)
					if data.icon:hitTestPoint(e.touch.x, e.touch.y) then
						data.self:iconClick(data.icon, data.id)
					else
						data.icon:setAlpha(0.1)
					end
				end, {icon=icon, id=#self.icons + 1, self=self})
			table.insert(self.icons, icon)
		end
	end
	iconsContainer:setPosition(utils.screenWidth / 2 - iconsContainer:getWidth() / 2, utils.screenHeight / 2 - iconsContainer:getHeight() / 2.5)

	self.buttons = {}
	self.buttons.start = MenuButton.new()
	self.buttons.start:setText("Play level")
	self.buttons.start:setPosition(utils.screenWidth / 2 - self.buttons.start:getWidth() / 2, utils.screenHeight - self.buttons.start:getHeight())

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function LevelSelectScreen:iconClick(icon, id)
	icon:setAlpha(1)
	self.selectedLevel = id
end

function LevelSelectScreen:buttonClick(e)
	if e:getTarget() == self.buttons.start then
		if self.selectedLevel and self.selectedLevel < 3 then
			screenManager:loadScreen("GameScreen", self.selectedLevel)
		end
	end
end

function LevelSelectScreen:update(dt)
	self.background:update(dt)
end

function LevelSelectScreen:back()
	screenManager:loadScreen("MainMenuScreen")
end


return LevelSelectScreen