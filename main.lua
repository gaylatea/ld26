-- ld26 main.lua
require("AnAL")
require("states/splashScreen")
require("states/gameScreen")

playDeath     = false

function love.load()
  -- Create some sample tiles to mess around with.
  player        = Player:new()
  game          = gameScreen:new()
end

function love.update(dt)
  -- Updates the animation. (Enables frame changes)
  game:update(dt)
end

function love.draw()
  -- Draw the grid system.
  game:draw()
end

function love.mousepressed(x, y, button)
  game:click(x, y, button)
end
