-- Level 4
-- Spaceship

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-20)
end

return LevelLogic