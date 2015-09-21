local TextFieldShadow = Core.class(Sprite)

function TextFieldShadow:init(...)
	self.shadow = TextField.new(...)
	self.shadow:setTextColor(0x000000)
	self.shadow:setPosition(4, 4)
	self:addChild(self.shadow)
	self.text = TextField.new(...)
	self:addChild(self.text)
end

function TextFieldShadow:setText(...)
	self.text:setText(...)
	self.shadow:setText(...)
end

function TextFieldShadow:setTextColor(...)
	self.text:setTextColor(...)
end

function TextFieldShadow:setAlpha(...)
	self.shadow:setAlpha(...)
end

return TextFieldShadow