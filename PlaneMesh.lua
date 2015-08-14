local PlaneMesh = Core.class(Mesh)

function PlaneMesh:init(texture, size, color)
	if not size then
		size = 50
	end
	if not color then
		color = 0xFFFFFF
	end

	self.size = size

	local s = size / 2
	self:setVertexArray(-s,-s,-s, -s,s,-s, s,s,-s, s,-s,-s)
	self:setIndices(1,1,2,2,3,3,4,1,5,3,6,4)

	if texture then
		self:setPlaneTexture(texture)
	end
	self:setPlaneColor(color)
end

function PlaneMesh:setPlaneColor(color)
	if not color then
		color = 0xFFFFFF
	end
	self:setColors(1,color,1, 2,color,1, 3,color,1, 4,color,1.0)
end

function PlaneMesh:setPlaneTexture(texture)
	local textureWidth = texture:getWidth()
	self:setTextureCoordinate(1, 0, 0)
	self:setTextureCoordinate(2, 0, textureWidth)
	self:setTextureCoordinate(3, textureWidth, textureWidth)
	self:setTextureCoordinate(4, textureWidth, 0)
	self:setTexture(texture)
	self.texture = texture
	return true
end

return PlaneMesh
