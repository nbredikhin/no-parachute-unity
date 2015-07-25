utils = {}

function utils.getScreenSize()
	local width = application:getDeviceWidth()
	local height = application:getDeviceHeight()

	if string.find(application:getOrientation(), "landscape") then
		width, height = height, width
	end

	return width, height
end

utils.screenWidth, utils.screenHeight = utils.getScreenSize()