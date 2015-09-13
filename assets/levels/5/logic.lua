-- Level 4
-- Spaceship

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.planesCount = 4
	self.requiredTime = 120
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.3)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(40)
end

return LevelLogic