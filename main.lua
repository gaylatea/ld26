-- ld26 main.lua
require("AnAL")
require("states/splashScreen")
require("states/gameScreen")

playDeath     = false

function love.load()
  -- Create some sample tiles to mess around with.
  player          = Player:new()
  game            = gameScreen:new()
  currentScreen   = splashScreen:new()
end

function love.update(dt)
  -- Updates the animation. (Enables frame changes)
  currentScreen:update(dt)
end

function love.draw()
  -- Draw the grid system.
  currentScreen:draw()
end

function love.mousepressed(x, y, button)
  currentScreen:click(x, y, button)
end

function love.keypressed( key, unicode )
   game:keyboardPressed(key) 
end

--function love.keyreleased( key, unicode )
	--game:keyboardPressed(key) 
--end