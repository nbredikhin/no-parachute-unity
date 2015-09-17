-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 3

	self.movingPlanes[4] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() - 10 * deltaTime)
	end
	self.movingPlanes[6] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() - 10 * deltaTime)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() + 10 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_PLAYER)
	self:setCameraSpeed(180)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.3)
	self:setBackgroundColor(150, 20, 0)
end

return LevelLogic