local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 110

	self.movingPlanes[5] = function(plane, deltaTime, gameTime)
		plane:setRotation(plane:getRotation() + 90 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.1)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(5)
end

return LevelLogic