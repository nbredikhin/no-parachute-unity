local Camera = Core.class()

function Camera:init(container)
	self.container = container

	self.width = application:getDeviceWidth()
	self.height = application:getDeviceHeight()

	if string.find(application:getOrientation(), "landscape") then
		self.width, self.height = self.height, self.width
	end

	self.center = {
		x = 0,
		y = 0,
		z = 0
	}

	self.x = 0
	self.y = 0 
	self.z = 0

	self.rx = 0
	self.ry = 0

	self:update()
end

function Camera:setCenter(x, y, z)
	self.center = {x = x, y = y, z = z}
	self:update()
end

function Camera:update()
	self.container:setPosition(self.center.x - self.x, self.center.y - self.y, self.center.z - self.z)
	self.container:setRotation(-self.rx, -self.ry)
end

function Camera:setX(x)
	self.x = x
	self:update()
end

function Camera:setY(y)
	self.y = y
	self:update()
end

function Camera:setZ(z)
	self.z = z
	self:update()
end

function Camera:setPosition(x, y, z)
	self.x = x
	self.y = y
	self.z = z
	self:update()
end

function Camera:setRotation(rx, ry)
	self.rx = 0
	self.ry = 0
	self:update()
end

function Camera:getX()
	return self.x
end

function Camera:getY()
	return self.y
end

function Camera:getZ()
	return self.z
end

return Camera