require("lib/player")

Achievement    = { text = "", bonus = 0, enabled = false, display = false, initialDisplayTime=love.timer.getTime() }
Achievement_mt = { __index = Achievement }

function Achievement:new(text, bonus, enabled, display, initialDisplayTime)
	text = text or ""
	bonus = bonus or 0
	enabled = enabled or false
	display = display or false
	initialDisplayTime = initialDisplayTime or 0
  return setmetatable({text=text, bonus=bonus, enabled=enabled, display=display, initialDisplayTime=initialDisplayTime}, Achievement_mt)
end

function Achievement:draw(x, y)  	
  	if self.display == true then
  		love.graphics.print(self.text, 600, 65)
  		self.display = false
  	end
end

function Achievement:display()
		--Set the rules of the achievement and then pass the values of the object to a reference.
		if player.energy < 90 then
			if achievement_deepFried.enabled == false then
				completed = achievement_deepFried
				achievement_deepFried.enabled = true
				completed.display = true
				completed.initialDisplayTime = love.timer.getTime()
			end
		end
		if player.energy < 80 then
			if achievement_deepFried.enabled == false then
				completed = achievement_playerOnSun
				achievement_deepFried.enabled = true
				completed.display = true
				completed.initialDisplayTime = love.timer.getTime()
			end
		end
		if player.energy < 70 then
			if achievement_deepFried.enabled == false then
				completed = achievement_levelOne
				achievement_deepFried.enabled = true
				completed.display = true
				completed.initialDisplayTime = love.timer.getTime()
			end
		end
		if player.energy < 60 then
			if achievement_deepFried.enabled == false then
				completed = achievement_potatoMode
				achievement_deepFried.enabled = true
				completed.display = true
				completed.initialDisplayTime = love.timer.getTime()
			end
		end
		if completed.display == true then
		love.graphics.print(completed.text, 600, 65)
		self:update()
		end	
end

function Achievement:update()
	local currentTime = love.timer.getTime()
    currentNumber = currentTime-completed.initialDisplayTime
    if currentNumber > 3 then
        completed.display = false
    end
end 

--Area to create achievments
achievement_playerOnSun = Achievement:new("That sun must be hot", 5, false, love.timer.getTime())

achievement_levelOne = Achievement:new("You passed level 1", 0, false, love.timer.getTime())

achievement_deepFried = Achievement:new("Never eat fries off another's plate", 0, false, love.timer.getTime())

achievement_potatoMode = Achievement:new("Are you happy now? You are a potato!", 0, false, love.timer.getTime())

completed = Achievement:new("", 0, false, love.timer.getTime())