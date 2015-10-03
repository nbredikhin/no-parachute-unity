-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 150
	self.planesCount = 2

	self.movingPlanes[1] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() + 90 * deltaTime * plane.direction)
	end

	self.movingPlanes[6] = function(plane, deltaTime)
		plane:setRotation(0)
		plane.decoPlane:setY(plane.decoPlane:getY() - 500 * deltaTime)
	end

	self.movingPlanes[7] = function(plane, deltaTime)
		plane:setRotation(0)
		if plane.decoPlane:getY() == 0 then
			plane.decoPlane:setY(math.random(-1000, 1000))
		end
		plane.decoPlane:setY(plane.decoPlane:getY() - 400 * deltaTime)
	end

	self.movingPlanes[8] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() + 90 * deltaTime * plane.direction)
	end
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.45)
	self:setBackgroundColor(61, 33, 33)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-50)
end

return LevelLogic