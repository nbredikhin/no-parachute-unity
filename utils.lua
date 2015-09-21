utils = {}

function utils.getScreenSize()
	local width = application:getDeviceWidth()
	local height = application:getDeviceHeight()

	if string.find(application:getOrientation(), "landscape") then
		width, height = height, width
	end

	return width, height
end

function utils.fileExists(path)
	local file = io.open(path)
	if file then
		file:close()
		return true
	end
	return false
end

function utils.rgbToHex(rgb)
	local hexadecimal = '0X'

	for key, value in pairs(rgb) do
		local hex = ''
		value = math.floor(value)

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

utils.screenWidth, utils.screenHeight = utils.getScreenSize()

utils.scale = utils.screenHeight / 480