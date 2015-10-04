-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 150
	self.planesCount = 2

	self.movingPlanes[6] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 720 * deltaTime)
	end

	self.movingPlanes[7] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 360 * deltaTime)
	end

	self.movingPlanes[8] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 180 * deltaTime)
	end

	self.movingPlanes[9] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime)
	end

	self.movingPlanes[10] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 180 * deltaTime)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() + 180 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self:setCameraSpeed(90)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.9)
end

return LevelLogic