local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.1)
	self.requiredTime = 90
end

return LevelLogic