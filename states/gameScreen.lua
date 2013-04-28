-- Actual game mode.
require("lib/player")
require("lib/level")
require("lib/achievement")

gameScreen    = { level = nil }
gameScreen_mt = { __index = gameScreen }

function gameScreen:new()
  -- Load in necessary resources for this screen.
  local images = {
    sh_path        = love.graphics.newImage("assets/trail H.png"),
    sv_path        = love.graphics.newImage("assets/trail V.png"),
    ur_path        = love.graphics.newImage("assets/trail UR.png"),
    ul_path        = love.graphics.newImage("assets/trail UL.png"),
    dr_path        = love.graphics.newImage("assets/trail DR.png"),
    dl_path        = love.graphics.newImage("assets/trail DL.png"),
    asteroidBelt  = love.graphics.newImage("assets/asteroid belt.png"),
    spaceStation  = love.graphics.newImage("assets/space station.png"),
    sun           = love.graphics.newImage("assets/sun.png"),
    wormhole      = love.graphics.newImage("assets/wormhole out.png"),
    wormhole_in   = love.graphics.newImage("assets/wormhole in.png"),
  }

  local animations = {
    sh_path  = newAnimation(images.sh_path, 32, 32, 0.13, 0),
    sv_path  = newAnimation(images.sv_path, 32, 32, 0.13, 0),
    ur_path  = newAnimation(images.ur_path, 32, 32, 0.13, 0),
    ul_path  = newAnimation(images.ul_path, 32, 32, 0.13, 0),
    dr_path  = newAnimation(images.dr_path, 32, 32, 0.13, 0),
    dl_path  = newAnimation(images.dl_path, 32, 32, 0.13, 0),
  }

  spaceBackground = love.graphics.newImage("assets/spacebg.png")

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
    bg          = spaceBackground,
    level       = level,
    images      = images,
    sounds      = sounds,
    fonts       = fonts,
  }, gameScreen_mt)
end

function gameScreen:update(dt)
  -- Update any animations on this screen.
  player:update(dt)
  self.animations.sh_path:update(dt)
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
  love.graphics.draw(self.bg, 0, 0)
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

  Achievement:display()

  for i, v in ipairs(self.level.tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
  love.graphics.setFont(game.fonts.normal)
end
