require "lib/png"
local PlaneMesh = require "PlaneMesh"

local World = Core.class(Sprite)

local defaultWorldSize = 1000
local defaultFallingSpeed = 3000
local defaultDecorativePlanesCount = 30
local defaultPlanesCount = 2

local textureSize = 64

local wallsColors = { 0xBBBBBB, 0x999999, 0xBBBBBB, 0xDDDDDD }

function World:init(player)
	-- Размеры мира
	self.size = defaultWorldSize
	self.depth = self.size * 10
	self.fallingSpeed = defaultFallingSpeed

	-- Игрок
	self.player = player
	self:addChild(self.player)
	self.player:setPosition(32, -12, self.depth/2 - 1200)

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

	-- Передние декоративные стены
	self.decorativePlanesCount = defaultDecorativePlanesCount
	self.decorativePlanes = {}
	local planeTexture = Texture.new("assets/plane1.png")
	for i = 1, self.decorativePlanesCount do
		local d = self.depth / self.decorativePlanesCount
		self.decorativePlanes[i] = PlaneMesh.new(planeTexture, self.size)
		self.decorativePlanes[i]:setPosition(0, 0, -i * d + self.depth / 2)
		self.decorativePlanes[i]:setRotation(math.random(1, 4) * 90)
		self:addChild(self.decorativePlanes[i])
	end

	-- Передние стены
	self.planesCount = defaultPlanesCount
	self.planes = {}
	for i = 1, self.planesCount do
		local texture = Texture.new("assets/plane2.png")
		local plane = PlaneMesh.new(texture, self.size)
		plane:setPosition(0, 0, -i * self.depth / self.planesCount + 10)
		--plane:setRotation(math.random(1, 4) * 90)
		self:addChild(plane)	
		self.planes[i] = plane
	end

	self.planePNG = pngImage("assets/plane2.png")
end

function World:updatePlane(plane, dt)
	plane:setZ(plane:getZ() + self.fallingSpeed * dt)
	
	if plane:getZ() > self.depth / 2 then
		plane:setZ(plane:getZ() - self.depth)
		--plane:setRotation(math.random(1, 4) * 90)
	end
	
	local mul = math.clamp((plane:getZ() + self.depth / 2) / self.depth, 0, 1)
	plane:setColorTransform(mul, mul, mul, 1)
end

function World:update(dt)
	for i, plane in ipairs(self.decorativePlanes) do
		self:updatePlane(plane, dt)
	end

	for i, plane in ipairs(self.planes) do
		self:updatePlane(plane, dt)
		if plane:getZ() > self.depth / 2 - 800 then
			local alpha = 1 - (plane:getZ() - self.depth / 2) / 800
			local r, g, b = plane:getColorTransform()
			plane:setColorTransform(r, g, b, alpha)
		end

		-- Проверка столкновений
		if plane:getZ() > self.player:getZ() - self.fallingSpeed * dt and plane:getZ() < self.player:getZ() + self.fallingSpeed * dt then
			local x = math.floor((self.player:getX() + self.size / 2) / self.size * textureSize)
			local y = math.floor((self.player:getY() + self.size / 2) / self.size * textureSize)
			local pixel = self.planePNG:getPixel(x, y)
			if pixel.A > 0 then
				plane:setZ(self.player:getZ() - 1)
				self.player:die()
				self.fallingSpeed = 0
			end
		end
	end
end

return World