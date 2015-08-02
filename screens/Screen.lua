-- Базовый класс для игровых экранов

local Screen = Core.class(Sprite)

function Screen:load()

end

function Screen:update(deltaTime)

end

function Screen:unload()

end

-- Обработка нажатия кнопки "назад"
function Screen:back()

end

return Screen