-- Level 1
-- Очень лёгкий, обучающий уровень

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed)

	self:setCameraType(LevelLogic.CAMERA_STATIC)
end

return LevelLogic