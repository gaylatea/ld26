-- Actual game mode.
require("lib/player")
require("lib/level")

gameScreen    = { level = nil }
gameScreen_mt = { __index = gameScreen }

function gameScreen:new()
  -- Load in necessary resources for this screen.
  local images = {
    good  = love.graphics.newImage("ball1.png"),
    okay  = love.graphics.newImage("ball75.png"),
    bad   = love.graphics.newImage("ball50.png"),
    dying = love.graphics.newImage("ball25.png"),
    death = love.graphics.newImage("ball0b.png"),
    s_path = love.graphics.newImage("ball0.png"),
    t_path = love.graphics.newImage("ball25.png"),
  }

  local animations = {
    good    = newAnimation(images.good, 32, 32, 0.13, 0),
    okay    = newAnimation(images.okay, 32, 32, 0.13, 0),
    bad     = newAnimation(images.bad, 32, 32, 0.13, 0),
    dying   = newAnimation(images.dying, 32, 32, 0.13, 0),
    death   = newAnimation(images.death, 32, 32, 0.25, 0),
    s_path  = newAnimation(images.s_path, 32, 32, 0.13, 0),
    t_path  = newAnimation(images.s_path, 32, 32, 0.13, 0)
  }

  spaceBackground = love.graphics.newImage("spacebg.png")

  local level     = Level:new(1)
  player.tile     = level.tiles[8][1]

  return setmetatable({
    animations  = animations,
    bg          = spaceBackground,
    level       = level,
  }, gameScreen_mt)
end

function gameScreen:update(dt)
  -- Update any animations on this screen.
  self.animations.good:update(dt)
  self.animations.okay:update(dt)
  self.animations.bad:update(dt)
  self.animations.dying:update(dt)
  self.animations.s_path:update(dt)
  self.animations.t_path:update(dt)

  if playDeath then
    self.animations.death:update(dt)
  end
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
            playDeath = true
            player.energy = 0
          else
            player.energy = player.energy - player.tile.costValue
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
  for i, v in ipairs(self.level.tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
end
