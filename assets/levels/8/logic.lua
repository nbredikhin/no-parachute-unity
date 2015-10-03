-- Level 8

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 150
	self.planesCount = 2

	self.movingPlanes[1] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 110 * deltaTime)
	end
	self.movingPlanes[2] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() + 65 * deltaTime)
	end
	self.movingPlanes[3] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() + 20 * deltaTime)
	end
	self.movingPlanes[4] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 180 * deltaTime)
	end
	self.movingPlanes[5] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane.basePlane:getRotation() - 90 * deltaTime)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() + 90 * deltaTime)
	end
	self.movingPlanes[6] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.7)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-90)

	self:setBackgroundColor(116, 158, 37)
end

return LevelLogic