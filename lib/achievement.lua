require("lib/player")

Achievement    = { tile = nil, energy = 0, animation = nil }
Achievement_mt = { __index = Achievement }

function Achievement:new(text, bonus, enabled)
	text = text or ""
	bonus = bonus or 0
	enabled = enabled or false
  return setmetatable({text=text, bonus=bonus}, Achievement_mt)
end

function Achievement:draw(x, y)
  	love.graphics.print(self.text, x, y)
end

function Achievement:display()

	if player.energy < 90 then
		completed = achievement_deepFried
	end
	if player.energy < 80 then
		completed = achievement_playerOnSun
	end
	if player.energy < 70 then
		completed = achievement_levelOne
	end
	if player.energy < 60 then
		completed = achievement_potatoMode
	end
	return completed.text
end


achievement_playerOnSun = Achievement:new("That sun must be hot", 5, false)

achievement_levelOne = Achievement:new("You passed level 1", 0, false)

achievement_deepFried = Achievement:new("Never eat fries off another's plate", 0, false)

achievement_potatoMode = Achievement:new("Are you happy now? You are a potato!", 0, false)

completed = Achievement:new("Are you happy now? You are a potato!", 0, false)