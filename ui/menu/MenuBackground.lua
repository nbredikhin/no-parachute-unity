local MenuRectangle = require "ui/menu/MenuRectangle"

local MenuBackground = Core.class(Sprite)

local backgroundRectsCount = 100
local backgroundRectSize = 0
local flyingRectSize = 10
local flyingRectsCount = 10
local flyingRectsSpeed = 2000

function MenuBackground:init()
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
	local logoTexture = Assets:getTexture("assets/logo.png", true)
	self.logo = Bitmap.new(logoTexture)
	local logoScale = utils.scale * 5
	self.logo:setScale(logoScale, logoScale)
	self:addChild(self.logo)
	self.logoY = logoScale * 6.5
	self.logo:setPosition(utils.screenWidth / 2 - self.logo:getWidth() / 2, self.logoY)
end

function MenuBackground:updateFlyingRect(rect)
	-- Случайные координат
	rect:setPosition(math.random(10, utils.screenWidth), -50)

	-- Случайный цвет
	rect:changeColor()

	-- Случайный размер
	local sizeMul = math.random(5, 10) / 10
	rect:setScale(flyingRectSize * sizeMul * 2, flyingRectSize * sizeMul * 2)
	rect:setAlpha(sizeMul / 2 * (rect:getX() / utils.screenWidth))
end

function MenuBackground:update(dt)
	for _, rect in ipairs(self.backgroundRects) do
		rect:changeColor()
	end

	for _, rect in ipairs(self.flyingRects) do
		rect:setY(rect:getY() + flyingRectsSpeed * dt)
		if rect:getY() > utils.screenHeight then
			self:updateFlyingRect(rect)
		end
	end

	self.logo:setY(self.logoY + math.sin(os.timer() * 3.5) * utils.scale * 5)
end

return MenuBackground