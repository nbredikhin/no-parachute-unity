local PlaneMesh = require "PlaneMesh"

local Blood = Core.class(Sprite)

function Blood:init(texture)
	self.plane = PlaneMesh.new(texture, 50)
	self.plane:setZ(-500)
	self:addChild(self.plane)
	self.sx = 0
	self.sy = 0
	self.sz = 0
	local colorMul = math.random(5, 10) / 10
	self:setColorTransform(colorMul, colorMul, colorMul, 50)
end

function Blood:update(deltaTime)
	self:setPosition(self:getX() + self.sx, self:getY() + self.sy, self:getZ() + self.sz)
	self.sx = self.sx * 0.9
	self.sy = self.sy * 0.9
end

return Blood