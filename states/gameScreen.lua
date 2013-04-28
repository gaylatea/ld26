-- Actual game mode.
require("lib/player")
require("lib/level")
require("lib/achievement")

gameScreen    = { level = nil }
gameScreen_mt = { __index = gameScreen }

function gameScreen:new()
  -- Load in necessary resources for this screen.
  local images = {
    s_path        = love.graphics.newImage("assets/ball0.png"),
    t_path        = love.graphics.newImage("assets/ball25.png"),
    asteroidBelt  = love.graphics.newImage("assets/asteroid belt.png"),
    spaceStation  = love.graphics.newImage("assets/space station.png"),
    sun           = love.graphics.newImage("assets/sun.png"),
  }

  local animations = {
    s_path  = newAnimation(images.s_path, 32, 32, 0.13, 0),
  }

  spaceBackground = love.graphics.newImage("assets/spacebg.png")

  local level           = Level:new(1)
  player.tile           = level.tiles[8][1]
  player.tile.costValue = 0

  local sounds = {
    death = love.audio.newSource("assets/explosion.wav"),
  }

  return setmetatable({
    animations  = animations,
    bg          = spaceBackground,
    level       = level,
    images      = images,
    sounds      = sounds,
  }, gameScreen_mt)
end

function gameScreen:update(dt)
  -- Update any animations on this screen.
  player:update(dt)
  self.animations.s_path:update(dt)
end

function gameScreen:click(x, y, button)
  -- Handle mouse clicks on this screen.
  if button == "l" then
    for row, v in ipairs(game.level.tiles) do
      for column, tile in ipairs(v) do
        if tile:is_inside(x, y) and tile:is_legal_move() then
          if tile == game.level.target then
            game.level = Level:new(game.level.number + 1)
          end
          player.tile.visible = true
          player.tile = game.level.tiles[row][column]
          if player.tile.costValue >= player.energy then
            player:updateEnergy(0)
          else
            player:updateEnergy(player.energy - player.tile.costValue)
          end
          break
        end
      end
    end
  end
end

function gameScreen:draw()
  -- Draw this screen for the current frame.
  love.graphics.draw(self.bg, 0, 0)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Path. Use the mouse to navigate.", 100, 50)
  love.graphics.print("Current Energy: " .. player.energy, 100, 65)
  Achievement:display()
  --if player.energy < 90 then
 -- love.graphics.print(, 600, 65)
--end
  for i, v in ipairs(self.level.tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
end
