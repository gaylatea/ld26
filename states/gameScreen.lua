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
    wormhole      = love.graphics.newImage("assets/wormhole out.png"),
    wormhole_in   = love.graphics.newImage("assets/wormhole in.png"),
  }

  local animations = {
    s_path  = newAnimation(images.s_path, 32, 32, 0.13, 0),
  }

  local level           = Level:new(1, 8, 1)
  player.tile           = level.start
  player.tile.costValue = 0

  local sounds = {
    death = love.audio.newSource("assets/explosion.wav"),
  }

  local fonts = {
    large   = love.graphics.newFont("assets/sourcesans.ttf", 32),
    normal  = love.graphics.newFont(11),
  }

  return setmetatable({
    animations  = animations,
    level       = level,
    images      = images,
    sounds      = sounds,
    fonts       = fonts,
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
        if tile:click(x, y) then
          break
        end
      end
    end
  end
end

function gameScreen:draw()
  -- Draw this screen for the current frame.
  self.level:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(game.fonts.large)

  -- Try to adjust the energy readout so that it doesn't shift between
  -- 100% and 99%.
  energyPosX = 1100
  if player.energy >= 100 then
    energyPosX = energyPosX - 18
  end

  -- Show the energy in colours based off of the player status.
  if (player.energy > 25 and player.energy <= 50) then
    love.graphics.setColor(255, 255, 0)
  elseif (player.energy >= 0 and player.energy <= 25) then
    love.graphics.setColor(255, 0, 0)
  end
  love.graphics.print(player.energy.."%", energyPosX, 50)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(game.fonts.normal)

  love.graphics.print(game.level.text, 100, 65)
end
