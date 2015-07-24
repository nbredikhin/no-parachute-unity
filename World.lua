local PlaneMesh = require "PlaneMesh"

local World = Core.class(Sprite)
local wallsColors = { 0xBBBBBB, 0x999999, 0xBBBBBB, 0xDDDDDD }

function World:init()
	-- Размеры мира
	self.size = 1000
	self.depth = self.size * 10

	-- Боковые стены
	self.walls = Sprite.new()
	local wallTexture = Texture.new("assets/wall.png")
	for i = 1, 4 do
		local wall = PlaneMesh.new(wallTexture, self.size, wallsColors[i])
		wall:setRotationX(90)
		wall:setRotationY(90 * (i - 1))
		self.walls:addChild(wall)	
	end
	self.walls:setScaleZ(self.depth / self.size)	
	self:addChild(self.walls)	
end

function World:update(dt)

end

return World