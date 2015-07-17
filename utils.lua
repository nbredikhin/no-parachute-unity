function setPlaneColor(plane, color)
	if not color then
		color = 0xFFFFFF
	end
	plane:setColors(1,color,1, 2,color,1, 3,color,1, 4,color,1.0)
end

function setPlaneTexture(plane, texture)
	local textureWidth = texture:getWidth()
	plane:setTextureCoordinate(1, 0, 0)
	plane:setTextureCoordinate(2, 0, textureWidth)
	plane:setTextureCoordinate(3, textureWidth, textureWidth)
	plane:setTextureCoordinate(4, textureWidth, 0)
	plane:setTexture(texture)
end

function createPlaneMesh(size, color)
	if not size then
		size = 50
	end
	if not color then
		color = 0xFFFFFF
	end
	local mesh = Mesh.new(true)
	local s = size/2
	mesh:setVertexArray(-s,-s,-s, -s,s,-s, s,s,-s, s,-s,-s)
	setPlaneColor(mesh, color)
	mesh:setIndices(1,1,2,2,3,3,4,1,5,3,6,4)
	mesh:setTextureCoordinate(1, 0, 0)
	mesh:setTextureCoordinate(2, 0, 100)
	mesh:setTextureCoordinate(3, 100, 100)
	mesh:setTextureCoordinate(4, 100, 100)
	return mesh	
end