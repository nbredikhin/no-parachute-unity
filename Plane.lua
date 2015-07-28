local PlaneMesh = require "PlaneMesh"
local Plane = Core.class(PlaneMesh)


function Plane:init()

end

function Plane:getTexturePosition(x, y)
	local radians = math.rad(-self:getRotation())
	local ca = math.cos(radians)
	local sa = math.sin(radians)
	return ca * x - sa * y, sa * x + ca * y
end

function Plane:hitTestPoint(x, y)
	assert(self.texture.pngData, "Texture must be TexturePNG to use hitTestPoint method")
	x, y = self:getTexturePosition(x, y)
	x = math.floor((x + self.size / 2) / self.size * self.texture.width)
	y = math.floor((y + self.size / 2) / self.size * self.texture.height)
	return self.texture:getPixelAlpha(x, y) > 0
end

return Plane