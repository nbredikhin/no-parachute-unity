-- Level 1
-- Очень лёгкий, обучающий уровень

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 70
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed)
end

return LevelLogic