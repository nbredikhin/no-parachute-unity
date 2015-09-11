local PlaneMesh = require "PlaneMesh"

local PowerUp = Core.class(Sprite)

local powerUpTypes = {
	"speed",
	"size",
	"life",
	"health"
} 

function PowerUp:init()
	self.size = 150
	self.type = math.random(1, #powerUpTypes)
	local path = "assets/powerups/" .. powerUpTypes[self.type] .. ".png"
	self.plane = PlaneMesh.new(Assets:getTexture(path), self.size * 2)
	self:addChild(self.plane)
	self:setAlpha(0)
	self.time = math.random() * math.pi * 2	
end

function PowerUp:update(dt)
	self:setAlpha(math.min(1, self:getAlpha() + 1 * dt))
	local scale = 1 - (math.cos(self.time * 10) + 1) / 2 * 0.1
	self:setScale(scale)
	local brightness = 1 - (math.cos(self.time * 10) + 1) / 2 * 0.5
	self:setColorTransform(brightness, brightness, brightness)
	self.time = self.time + dt
end

function PowerUp:hitTestPoint(x, y)
	local dx = self:getX() - x
	local dy = self:getY() - y
	return dx*dx+dy*dy <= self.size*self.size
end

return PowerUp