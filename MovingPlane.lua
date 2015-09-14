local Plane 		= require "Plane"

local MovingPlane = Core.class(Sprite)

function MovingPlane:init(size, texture1, texture2)
	self.decoPlane = Plane.new(texture1, size)
	self:addChild(self.decoPlane)

	self.basePlane = Plane.new(texture1, size)
	self:addChild(self.basePlane)

	self:setMovingPlaneTexture(texture1, texture2)
end

function MovingPlane:hitTestPoint(x, y)
	return (self.decoPlane:hitTestPoint(x, y) and self.decoPlane:isVisible()) or self.basePlane:hitTestPoint(x, y)
end

function MovingPlane:setMovingPlaneTexture(texture1, texture2)
	self.basePlane:setPlaneTexture(texture1)
	if texture2 then
		self.decoPlane:setPlaneTexture(texture2)
		self.decoPlane:setVisible(true)
	else
		self.decoPlane:setVisible(false)
	end
end

function MovingPlane:setRotation(...)
	self.basePlane:setRotation(...)
end

function MovingPlane:getRotation()
	return self.basePlane:getRotation()
end

function MovingPlane:getX()
	return self.basePlane:getX()
end

function MovingPlane:getY()
	return self.basePlane:getY()
end

function MovingPlane:setX(...)
	self.basePlane:setX(...)
end

function MovingPlane:setY(...)
	self.basePlane:setY(...)
end

return MovingPlane