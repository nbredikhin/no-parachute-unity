-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 3

	self.movingPlanes[1] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime)
	end
	self.movingPlanes[2] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + 45 * deltaTime)
	end
	self.movingPlanes[3] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + 10 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.6)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-90)

	self:setBackgroundColor(116, 158, 37)
end

return LevelLogic