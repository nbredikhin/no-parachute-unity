local PlaneMesh = require "PlaneMesh"

local PowerUp = Core.class(Sprite)

local powerUpTypes = {
	"speed",
	"size",
	"life",
	"health",
	"ring"
} 

local ANIMATION_DELAY = 0.5

function PowerUp:init(type)
	self.size = 150
	if not type then
		self.type = math.random(1, #powerUpTypes)
	else
		self.type = type
	end
	local path = "assets/powerups/" .. powerUpTypes[self.type] .. ".png"
	self.plane = PlaneMesh.new(Assets:getTexture(path), self.size * 2)
	self:addChild(self.plane)
	self:setAlpha(0)
	self.time = math.random() * math.pi * 2	

	self.isRemoved = false
	self.isAnimating = false
	self.animationDelay = 0
end

function PowerUp:update(dt)
	-- Анимация при подбирании
	if self.isAnimating then
		if self.animationDelay > 0 then
			self.animationDelay = self.animationDelay - dt
			self:setAlpha(self.animationDelay / ANIMATION_DELAY)
			self:setScale(self:getScale() * 1.05)
			local brightness =  self.animationDelay / ANIMATION_DELAY
			self:setColorTransform(1, 1, 1, brightness)
		else
			self.isRemoved = true
		end
	else
		self:setAlpha(math.min(1, self:getAlpha() + 1 * dt))
		local scale = 1 - (math.cos(self.time * 10) + 1) / 2 * 0.1
		self:setScale(scale)
		local brightness = 1 - (math.cos(self.time * 10) + 1) / 2 * 0.5
		self:setColorTransform(brightness, brightness, brightness)
	end

	self.time = self.time + dt
end

function PowerUp:hitTestPoint(x, y)
	local dx = self:getX() - x
	local dy = self:getY() - y
	return dx*dx+dy*dy <= self.size*self.size*3
end

function PowerUp:startAnimation()
	self.animationDelay = ANIMATION_DELAY
	self.isAnimating = true
end

return PowerUp