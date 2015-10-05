-- Level 4
-- Spaceship

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.planesCount = 4
	self.requiredTime = 140

	self.movingPlanes[6] = function(plane, deltaTime, gameTime)
		plane:setRotation(math.sin(gameTime) / math.pi * 180)
	end
	self.movingPlanes[8] = function(plane, deltaTime, gameTime)
		plane:setRotation(plane:getRotation() + 90 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.3)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(40)
end

return LevelLogic