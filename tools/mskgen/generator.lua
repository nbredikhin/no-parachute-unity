require "png"
require "lfs"

local args = {...}

-- Check args
if #args == 0 then
	print([[No Parachute! MSK file generation tool
Usage: generator <path>
	--levels <count>]])
	return
end 

-- Change dir
local dir_str = args[1]
local result, error_text = lfs.chdir(dir_str)
if not result then
	print("Error: No such file or directory")
	return
end

local working_path = lfs.currentdir()

local function processFile(path)
	local img = pngImage(path)
	if not img then
		return false, "File not found"
	end

	local outputFile = io.open(path .. ".msk", "w+")
	for pixelY = 1, img.height do
		for pixelX = 1, img.width do
			local pixel = img:getPixel(pixelX, pixelY)
			if pixel.A > 0 then
				outputFile:write("1")
			else
				outputFile:write("0")
			end
		end
	end
	outputFile:close()
	return true
end

local function processFolder(folder_path)
	local filesCount = 0
	for filename in lfs.dir(folder_path) do
		if filename ~= "." and filename ~= ".." and string.find(filename, ".png") and not string.find(filename, "msk") then
			local result, error_text = processFile(folder_path .. "/" .. filename)
			local result_string = " - OK"
			if not result then
				result_string = " - ERROR (" .. tostring(error_text) .. ")"
			end
			print(filename .. result_string)
			filesCount = filesCount + 1
		end
	end
	if filesCount == 0 then
		print("No images found")
		return false
	end
	return true
end

local function processLevel(root_path, index)
	print("Processing level " .. tostring(index))
	processFolder(root_path .. "/" .. tostring(index) .. "/planes")
end

local function processAllLevels(root_path, count)
	for i = 1, count do
		print("Processing level " .. tostring(i))
		processFolder(root_path .. "/" .. tostring(i) .. "/planes")
		print("")
	end
	print("Done")
end

if args[2] and args[3] and args[2] == "--levels" then
	local count = tonumber(args[3])
	if not count then
		print("Error: Bad levels count")
		return
	end
	processAllLevels(working_path, count)
	return
elseif args[2] and args[3] and args[2] == "--level" then
	local index = tonumber(args[3])
	if not index then
		print("Error: Bad level index")
		return
	end
	processLevel(working_path, index)
	return
end

processFolder(working_path)