
Achievement    = { tile = nil, energy = 0, animation = nil }
Achievement_mt = { __index = Achievement }

function Achievement:new(text, bonus)
	text = text or ""
	bonus = bonus or 0
  return setmetatable({text=text, bonus=bonus}, Achievement_mt)
end

function Achievement:draw(x, y)
    text = "This is a test"
  love.graphics.print(self.text, x, y)
end

achievement_playerDies = Achievement:new("You died", 0)

Achievement:draw(600, 65)