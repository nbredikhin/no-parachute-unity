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

	self.ICONS_SPACE = 40

	self.levelsIcons = {}
	self.iconsContainer = Sprite.new()
	self:addChild(self.iconsContainer)

	for i = 1, ICONS_COUNT do
		-- Create bitmap
		local iconPath = "assets/icons/" .. tostring(i) .. ".png"
		local iconSprite = Sprite.new()

		local bitmap = Bitmap.new(Assets:getTexture(iconPath, true))
		iconSprite:addChild(bitmap)
		bitmap:setAnchorPoint(0.5, 0.5)

		if self:isLevelLocked(i) then
			bitmap:setColorTransform(0.1, 0.1, 0.1, 1)
			local lock = Bitmap.new(Assets:getTexture("assets/icons/locked.png"), true)
			iconSprite:addChild(lock)
			lock:setAnchorPoint(0.5, 0.5)
		end

		iconSprite:setAlpha(ICON_ALPHA_INACTIVE)
		-- Set position
		local x = (iconSprite:getWidth() + self.ICONS_SPACE) * (i - 1)
		iconSprite:setX(x)
		-- Add child
		self.iconsContainer:addChild(iconSprite)
		self.levelsIcons[i] = {level = i, image = iconSprite, interpolate = {}, icon = bitmap, lock = lock}
	end
	self.ICON_WIDTH = self.levelsIcons[1].image:getWidth()

	-- Center icons container
	self.iconsContainer:setScale(math.max(utils.scale, 1))
	self.iconsContainer:setX(utils.screenWidth / 2 - self.ICON_WIDTH / 2)
	self.iconsContainer:setY(utils.screenHeight / 2 + 10)

	-- Select first icon
	self:setSelectedIcon(1)

	self.iconsContainer:addEventListener(Event.TOUCHES_BEGIN, self.iconsTouchBegin, self)
	self.iconsContainer:addEventListener(Event.TOUCHES_MOVE, self.iconsTouchMove, self)
	self.iconsContainer:addEventListener(Event.TOUCHES_END, self.iconsTouchEnd, self)

	self.buttons = {}
	self.buttons.start = MenuButton.new()
	self.buttons.start:setText("Start")
	self.buttons.start:setScale(self.buttons.start:getScale() * 2)
	self.buttons.start:setPosition(utils.screenWidth / 2 - self.buttons.start:getWidth() / 2, utils.screenHeight - self.buttons.start:getHeight() / 2)

	self.buttons.back = MenuButton.new()
	self.buttons.back:setText("Back")
	self.buttons.back:setPosition(utils.screenWidth - self.buttons.back:getWidth() - self.buttons.back:getHeight(), utils.screenHeight - self.buttons.back:getHeight())

	for _, button in pairs(self.buttons) do
		button:addEventListener(MenuButton.CLICK, self.buttonClick, self)
		self:addChild(button)
	end
end

function LevelSelectScreen:isLevelLocked(levelID)
	return levelID > 6
end

function LevelSelectScreen:iconsTouchBegin(e)
	if not self.iconsContainer:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	self.iconsPrevX = e.touch.x
	self.iconsPrevY = e.touch.y

	self.iconsStartX = e.touch.x
	self.iconsStartY = e.touch.y
end

function LevelSelectScreen:setSelectedIcon(id)
	id = math.max(id, 1)
	id = math.min(id, 8)
	if self.currentSelectedIcon then
		local iconSprite = self.levelsIcons[self.currentSelectedIcon].image
		self.levelsIcons[self.currentSelectedIcon].interpolate.alpha = ICON_ALPHA_INACTIVE
		self.levelsIcons[self.currentSelectedIcon].interpolate.scaleX = math.min(1, 1 * utils.screenHeight / 360)
		self.levelsIcons[self.currentSelectedIcon].interpolate.scaleY = math.min(1, 1 * utils.screenHeight / 360)
	end
	self.currentSelectedIcon = id
	local iconSprite = self.levelsIcons[self.currentSelectedIcon].image
	self.levelsIcons[self.currentSelectedIcon].interpolate.alpha = ICON_ALPHA_ACTIVE
	self.levelsIcons[self.currentSelectedIcon].interpolate.scaleX = math.min(2, 2 * utils.screenHeight / 360)
	self.levelsIcons[self.currentSelectedIcon].interpolate.scaleY = math.min(2, 2 * utils.screenHeight / 360)

	self.iconsContainerTargetX = utils.screenWidth / 2 - (self.ICON_WIDTH + self.ICONS_SPACE) * (id - 1) * self.iconsContainer:getScale()
end

function LevelSelectScreen:iconsTouchMove(e)
	if not self.iconsContainer:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	if not self.iconsPrevX then
		return
	end
	local dragX = e.touch.x - self.iconsPrevX
	local dragY = e.touch.y - self.iconsPrevY

	if dragX < -self.ICON_WIDTH then
		self:setSelectedIcon(self.currentSelectedIcon + 1)
		self.iconsPrevX = e.touch.x
		self.iconsPrevY = e.touch.y
	elseif dragX > self.ICON_WIDTH then
		self:setSelectedIcon(self.currentSelectedIcon - 1)
		self.iconsPrevX = e.touch.x
		self.iconsPrevY = e.touch.y
	end
end

function LevelSelectScreen:iconsTouchEnd(e)
	if not self.iconsContainer:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	if not self.iconsStartX then
		return
	end
	local dragX = e.touch.x - self.iconsStartX
	local dragY = e.touch.y - self.iconsStartY

	-- Тап по иконкам
	if math.abs(dragX) < 10 then
		-- Номер иконки, по которой был тап
		local tapIcon = math.floor((e.touch.x - self.iconsContainer:getX()) / (self.ICON_WIDTH + self.ICONS_SPACE) + 1.5)
		local diff = math.abs(self.currentSelectedIcon - tapIcon)
		if diff <= 2 then
			if diff > 0 then
				self:setSelectedIcon(tapIcon)
			elseif diff == 0 then
				self:startSelectedLevel()
			end
		end
	end
end

function LevelSelectScreen:startSelectedLevel()
	local levelID = self.currentSelectedIcon
	if levelID then
		levelID = math.max(levelID, 1)
		levelID = math.min(levelID, ICONS_COUNT)
		if self:isLevelLocked(levelID) then
			return
		end
		screenManager:loadScreen("GameScreen", self.currentSelectedIcon)
	end
end

function LevelSelectScreen:buttonClick(e)
	if e:getTarget() == self.buttons.start then
		self:startSelectedLevel()
	elseif e:getTarget() == self.buttons.back then
		self:back()
	end
end

function LevelSelectScreen:update(dt)
	self.background:update(dt)
	self.iconsContainer:setX(self.iconsContainer:getX() + (self.iconsContainerTargetX - self.iconsContainer:getX()) * 0.2)
	for i, icon in ipairs(self.levelsIcons) do
		local iconSprite = icon.image
		for property, targetValue in pairs(icon.interpolate) do
			local currentValue = iconSprite:get(property)
			iconSprite:set(property, currentValue + (targetValue - currentValue) * 0.2)
		end
	end
end

function LevelSelectScreen:back()
	screenManager:loadScreen("MainMenuScreen")
end


return LevelSelectScreen