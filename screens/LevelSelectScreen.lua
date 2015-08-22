local MenuBackground 	= require "ui/menu/MenuBackground"
local MenuButton		= require "ui/menu/MenuButton"
local MenuSlider		= require "ui/menu/MenuSlider"
local Screen 			= require "screens/Screen"

local LevelSelectScreen = Core.class(Screen)

local ICONS_COUNT = 8
local ICON_ALPHA_INACTIVE = 0.1
local ICON_ALPHA_ACTIVE = 1

function LevelSelectScreen:load()
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.ICONS_SPACE = utils.screenWidth * 0.1

	self.levelsIcons = {}
	self.iconsContainer = Sprite.new()
	self:addChild(self.iconsContainer)

	for i = 1, ICONS_COUNT do
		-- Create bitmap
		local iconPath = "assets/icons/" .. tostring(i) .. ".png"
		local iconBitmap = Bitmap.new(Texture.new(iconPath))
		iconBitmap:setAlpha(ICON_ALPHA_INACTIVE)
		-- Set position
		local x = (iconBitmap:getWidth() + self.ICONS_SPACE) * (i - 1)
		iconBitmap:setX(x)
		iconBitmap:setAnchorPoint(0.5, 0.5)
		-- Add child
		self.iconsContainer:addChild(iconBitmap)
		self.levelsIcons[i] = {level = i, bitmap = iconBitmap}
	end
	self.ICON_WIDTH = self.levelsIcons[1].bitmap:getWidth()
	-- Select first icon
	self:setSelectedIcon(1)

	-- Center icons container
	self.iconsContainer:setX(utils.screenWidth / 2 - self.ICON_WIDTH / 2)
	self.iconsContainer:setY(utils.screenHeight / 2 + 10)

	self.iconsContainer:addEventListener(Event.TOUCHES_BEGIN, self.iconsTouchBegin, self)
	self.iconsContainer:addEventListener(Event.TOUCHES_MOVE, self.iconsTouchMove, self)

	self.buttons = {}
	self.buttons.start = MenuButton.new()
	self.buttons.start:setText("Start")
	self.buttons.start:setPosition(utils.screenWidth / 2 - self.buttons.start:getWidth() / 2, utils.screenHeight - self.buttons.start:getHeight())

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function LevelSelectScreen:iconsTouchBegin(e)
	self.iconsStartX = e.touch.x
	self.iconsStartY = e.touch.y
end

function LevelSelectScreen:setSelectedIcon(id)
	if self.currentSelectedIcon then
		local iconBitmap = self.levelsIcons[self.currentSelectedIcon].bitmap
		iconBitmap:setAlpha(ICON_ALPHA_INACTIVE)
		iconBitmap:setScale(1)
	end
	self.currentSelectedIcon = id
	local iconBitmap = self.levelsIcons[self.currentSelectedIcon].bitmap
	iconBitmap:setAlpha(ICON_ALPHA_ACTIVE)
	iconBitmap:setScale(2.5)
end

function LevelSelectScreen:iconsTouchMove(e)
	local dragX = e.touch.x - self.iconsStartX
	local dragY = e.touch.y - self.iconsStartY
	self.iconsStartX = e.touch.x
	self.iconsStartY = e.touch.y

	local x = self.iconsContainer:getX() + dragX
	x = math.min(utils.screenWidth / 2 - (self.ICON_WIDTH) / 2, x)
	x = math.max(utils.screenWidth / 2 - self.iconsContainer:getWidth() + self.ICON_WIDTH / 2, x)
	self.iconsContainer:setX(x)

	local selectedIcon = math.floor(((utils.screenWidth / 2 + self.ICONS_SPACE) - self.iconsContainer:getX(x)) / (self.ICON_WIDTH + self.ICONS_SPACE)) + 1
	if self.currentSelectedIcon then
		if self.currentSelectedIcon ~= selectedIcon then
			self:setSelectedIcon(selectedIcon)
		end
	else
		self:setSelectedIcon(selectedIcon)
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