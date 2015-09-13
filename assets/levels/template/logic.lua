-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 2
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.2)
end

return LevelLogic