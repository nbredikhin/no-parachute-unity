local Assets = {}
local assetsCache = {}

function Assets:clearCache()
	assetsCache = {}
end

function Assets:getTexture(path, useCache, enableFiltering, ...)
	if not path or type(path) ~= "string" then
		return
	end
	if useCache and assetsCache[path] then
		return assetsCache[path]
	end
	if not enableFiltering then
		enableFiltering = false
	end
	return Texture.new(path, enableFiltering, ...)
end

return Assets