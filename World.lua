local PlaneMesh = require "PlaneMesh"

local World = Core.class(Sprite)
local wallsColors = { 0xBBBBBB, 0x999999, 0xBBBBBB, 0xDDDDDD }

function World:init()
	-- Размеры мира
	self.size = 1000
	self.depth = self.size * 10
	self.fallingSpeed = 3000

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

	-- Передние стены
	self.decorativePlanesCount = 30
	self.decorativePlanes = {}
	local planeTexture = Texture.new("assets/plane.png")
	for i = 1, self.decorativePlanesCount do
		local d = self.depth / self.decorativePlanesCount
		self.decorativePlanes[i] = PlaneMesh.new(planeTexture, self.size)
		self.decorativePlanes[i]:setPosition(0, 0, -i * d + self.depth / 2)
		self.decorativePlanes[i]:setRotation(math.random(1, 4) * 90)
		self:addChild(self.decorativePlanes[i])
	end
end

function World:update(dt)
	for i, plane in ipairs(self.decorativePlanes) do
		plane:setZ(plane:getZ() + self.fallingSpeed * dt)
		
		if plane:getZ() > self.depth / 2 then
			plane:setZ(plane:getZ() - self.depth)
		end
		
		local mul = (plane:getZ() + self.depth / 2) / self.depth
		plane:setColorTransform(mul, mul, mul, 1)
	end
end

return World