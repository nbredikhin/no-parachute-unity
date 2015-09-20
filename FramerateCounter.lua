local FramerateCounter = Core.class(Sprite)

function FramerateCounter:init()
	self.text = "FPS: "

	self.textField = TextField.new(nil, self.text .. "0")
	self.textField:setScale(math.max(1, math.floor(utils.scale)))
	self.textField:setX(5)
	self.textField:setY(self.textField:getHeight() + 5)
	self.textField:setTextColor(0xFFFFFF)
	self:addChild(self.textField)

	self.framesCount = 0
	self.delayMax = 1
	self.delayCurrent = 0 
end

function FramerateCounter:update(dt)
	self.framesCount = self.framesCount + 1
	self.delayCurrent = self.delayCurrent + dt 
	if self.delayCurrent >= self.delayMax then
		self.delayCurrent = 0
		-- Обновление счётчика
		local currentFPS = self.framesCount
		self.textField:setText(self.text .. currentFPS)
		self.framesCount = 0
	end
end

return FramerateCounter