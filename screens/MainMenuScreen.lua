local MenuRectangle = require "ui/menu/MenuRectangle"
local MenuButton	= require "ui/menu/MenuButton"
local Screen 		= require "screens/Screen"
local GameScreen 	= require "screens/GameScreen"

local MainMenuScreen = Core.class(Screen)

local backgroundRectsCount = 100
local backgroundRectSize = 0
local flyingRectSize = 10
local flyingRectsCount = 10
local flyingRectsSpeed = 2000

function MainMenuScreen:load()
	application:setBackgroundColor(0)

	-- Фон
	backgroundRectSize = utils.screenWidth / backgroundRectsCount
	self.backgroundRects = {}
	local rectsCount = math.floor(utils.screenWidth / backgroundRectSize) + 1
	for i = 1, rectsCount do
		local rect = MenuRectangle.new()
		rect:setPosition((i - 1) * backgroundRectSize, 0)
		rect:setScale(backgroundRectSize, utils.screenHeight)
		rect:setAlpha(0.15 * (i - 1) / rectsCount)
		self:addChild(rect)
		self.backgroundRects[i] = rect
	end

	-- Летящие квадраты
	self.flyingRects = {}
	for i = 1, flyingRectsCount do
		local rect = MenuRectangle.new()
		self:updateFlyingRect(rect)
		rect:setPosition(math.random(10, utils.screenWidth), math.random(0, utils.screenHeight))
		self:addChild(rect)
		self.flyingRects[i] = rect	
	end

	-- Логотип игры
	local logoTexture = Texture.new("assets/logo.png")
	self.logo = Bitmap.new(logoTexture)
	local logoScale =  (utils.screenWidth / 1.2) / logoTexture:getWidth()
	self.logo:setScale(logoScale, logoScale)
	self:addChild(self.logo)
	self.logoY = 10
	self.logo:setPosition(utils.screenWidth / 2 - self.logo:getWidth() / 2, self.logoY)

	-- Кнопки
	local buttonsX = utils.screenWidth * 0.05
	local buttonsY = utils.screenHeight / 2
	self.startButton = MenuButton.new()
	self.startButton:setText("Start game")
	self.startButton:setPosition(buttonsX, buttonsY)
	self:addChild(self.startButton)
	self.startButton:addEventListener(MenuButton.CLICK, self.buttonClick, self)

	buttonsY = buttonsY + self.startButton:getHeight() * 2
	self.aboutButton = MenuButton.new()
	self.aboutButton:setText("Credits")
	self.aboutButton:setPosition(buttonsX, buttonsY)
	self:addChild(self.aboutButton)	
	self.aboutButton:addEventListener(MenuButton.CLICK, self.buttonClick, self)
end

function MainMenuScreen:updateFlyingRect(rect)
	-- Случайные координат
	rect:setPosition(math.random(10, utils.screenWidth), -50)

	-- Случайный цвет
	rect:changeColor()

	-- Случайный размер
	local sizeMul = math.random(5, 10) / 10
	rect:setScale(flyingRectSize * sizeMul * 2, flyingRectSize * sizeMul * 2)
	rect:setAlpha(sizeMul / 2 * (rect:getX() / utils.screenWidth))
end

function MainMenuScreen:buttonClick(e)
	if e:getTarget() == self.startButton then
		screenManager:loadScreen(GameScreen.new())
	end
end

function MainMenuScreen:update(dt)
	for _, rect in ipairs(self.backgroundRects) do
		rect:changeColor()
	end

	for _, rect in ipairs(self.flyingRects) do
		rect:setY(rect:getY() + flyingRectsSpeed * dt)
		if rect:getY() > utils.screenHeight then
			self:updateFlyingRect(rect)
		end
	end

	self.logo:setY(self.logoY + math.sin(os.timer() * 2.5) * self.logoY)
end

return MainMenuScreen