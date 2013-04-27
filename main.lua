-- ld26 main.lua
-- Callbacks for Love2d.
-- Animation library.
require("AnAL")

-- Stats about the player.
player        = {tile=nil, energy=0, animation=nil}
playDeath     = false
currentLevel  = 1
targetTile    = nil

-- Handle processing for each of the game tiles.
Tile = {x = 0, y = 0, cost = 1, sx = 32, sy = 32, costValue = 1, visible = false, red=90, green=90, blue=90}
Tile_mt = { __index = Tile }
function Tile:new(x, y, gx, gy)
  costValue = math.random(5)
  visible = visible or false
  red = red or 90
  green = green or 90
  blue = blue or 90
  return setmetatable( {x=x, y=y, gx=gx, gy=gy, costValue=costValue, visible=visible, red=red, green=green, blue=blue}, Tile_mt)
end

function Tile:draw()
  -- Draw the target tile in red so we know what's up.
  if targetTile == self then
    local oldr, oldg, oldb, olda = love.graphics.getColor()

    love.graphics.setColor(255, 0, 0)
    love.graphics.line(self.x, self.y, (self.x+self.sx), self.y)
    love.graphics.line(self.x, self.y, self.x, (self.y+self.sy))
    love.graphics.line((self.x+self.sx), self.y, (self.x+self.sx), (self.y+self.sy))
    love.graphics.line(self.x, (self.y+self.sy), (self.x+self.sx), (self.y+self.sy))
    love.graphics.setColor(oldr, oldg, oldb, olda)
  end

  -- Be a good citizen and pop the graphics back to their proper
  -- colours when we're done.
  local mousex, mousey = love.mouse.getPosition()
  if self:is_inside(mousex, mousey) and self:is_legal_move() then
    local oldr, oldg, oldb, olda = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x, self.y, (self.x+self.sx), self.y)
    love.graphics.line(self.x, self.y, self.x, (self.y+self.sy))
    love.graphics.line((self.x+self.sx), self.y, (self.x+self.sx), (self.y+self.sy))
    love.graphics.line(self.x, (self.y+self.sy), (self.x+self.sx), (self.y+self.sy))
    love.graphics.setColor(oldr, oldg, oldb, olda)
  end

  --Check to see if the the tile is within range of the player, if so then make the cost value visible
  if (self.x == player.tile.x and self.y == player.tile.y)
    or (self.x == player.tile.x+32 and self.y == player.tile.y+32)
    or (self.x == player.tile.x-32 and self.y == player.tile.y-32)
    or (self.x == player.tile.x+32 and self.y == player.tile.y-32)
    or (self.x == player.tile.x-32 and self.y == player.tile.y+32)
    or (self.x == player.tile.x+32 and self.y == player.tile.y)
    or (self.x == player.tile.x+64 and self.y == player.tile.y)
    or (self.x == player.tile.x and self.y == player.tile.y+32)
    or (self.x == player.tile.x and self.y == player.tile.y+64)
    or (self.x == player.tile.x-32 and self.y == player.tile.y)
    or (self.x == player.tile.x-64 and self.y == player.tile.y)
    or (self.x == player.tile.x and self.y == player.tile.y-32)
    or (self.x == player.tile.x and self.y == player.tile.y-64)
    or self.visible == true
  then
    if (self.x == player.tile.x and self.y == player.tile.y-32)
      or (self.x == player.tile.x and self.y == player.tile.y+32)
      or (self.x == player.tile.x+32 and self.y == player.tile.y)
      then
        love.graphics.setColor(255, 255, 255)
      else
        love.graphics.setColor(self.red, self.blue, self.green)
    end
  love.graphics.print(self.costValue, self.x, self.y)
  love.graphics.setColor(255, 255, 255)
  end

  --Only draw the tiles value if it is set to visible
  --if self.visible == true then
  --  love.graphics.setColor(self.red, self.blue, self.green)
  --  love.graphics.print(self.costValue, self.x, self.y)
    --reset color
   -- love.graphics.setColor(255, 255, 255)
  --end

  if player.tile == self then
    if playDeath then
      if animations.death:getCurrentFrame() == 7 then
        currentLevel = 1
        reset()
      end
      animations.death:draw(self.x, self.y)
    else
      if player.energy >= 76 then
        animations.good:draw(self.x, self.y)
      elseif player.energy >= 51 then
        animations.okay:draw(self.x, self.y)
      elseif player.energy >= 26 then
        animations.bad:draw(self.x, self.y)
      else
        animations.dying:draw(self.x, self.y)
      end
    end
  end

end

function Tile:is_inside(x, y)
  return(x >= (self.x + 1) and x <= (self.x + (self.sx - 1)) and
    y >= (self.y + 1) and y <= (self.y + (self.sy - 1)))
end

function Tile:is_legal_move()
  -- Does not allow diagonal motion. Might want to change that soon.
  -- Also does not allow backwards motion. (west)
  if self.x == (player.tile.x + 32) and self.y == player.tile.y then
    return true
  end

  if self.x == (player.tile.x - 32) and self.y == player.tile.y then
    return true
  end

  if self.y == (player.tile.y + 32) and self.x == player.tile.x then
    return true
  end

  if self.y == (player.tile.y - 32) and self.x == player.tile.x then
    return true
  end
end

function reset()
  local row = 0
  tiles = {}
  repeat
    local y = (row * 32) + 100
    local column = 0
    local rowtable = {}
    repeat
      local x = (column * 32) + 100
      table.insert(rowtable, Tile:new(x, y, column, row))
      column = column + 1
    until column == 32
    table.insert(tiles, rowtable)
    row = row + 1
  until row == 15

  player.tile   = tiles[8][1]
  -- Give the player less energy per level, so they have to try and
  -- conserve their resources.
  newEnergy = (100 - ((currentLevel - 1) * 25))
  if newEnergy < 25 then
    newEnergy = 25
  end

  player.energy = newEnergy + player.energy
  playDeath = false
  animations.death:seek(1)

  -- Randomize where the target tile is, but try to keep it at least
  -- certain distance away from the player.
  local randomRow     = math.random(15)
  local randomColumn  = math.random(32)

  targetTile = tiles[randomRow][randomColumn]
  targetTile.costValue = 0
end

function love.load()
  -- Create some sample tiles to mess around with.
  local images = {
    good  = love.graphics.newImage("ball1.png"),
    okay  = love.graphics.newImage("ball75.png"),
    bad   = love.graphics.newImage("ball50.png"),
    dying = love.graphics.newImage("ball25.png"),
    death = love.graphics.newImage("ball0b.png"),
  }

  animations = {
    good  = newAnimation(images.good, 32, 32, 0.13, 0),
    okay  = newAnimation(images.okay, 32, 32, 0.13, 0),
    bad   = newAnimation(images.bad, 32, 32, 0.13, 0),
    dying = newAnimation(images.dying, 32, 32, 0.13, 0),
    death = newAnimation(images.death, 32, 32, 0.25, 0),
  }

  spaceBackground = love.graphics.newImage("spacebg.png")

  reset()

end

function love.update(dt)
  -- Updates the animation. (Enables frame changes)
  animations.good:update(dt)
  animations.okay:update(dt)
  animations.bad:update(dt)
  animations.dying:update(dt)

  if playDeath then
    animations.death:update(dt)
  end
end

function love.draw()
  -- Draw the grid system.
  love.graphics.draw(spaceBackground, 0, 0)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Path. Use the mouse to navigate.", 100, 50)
  love.graphics.print("Current Energy: " .. player.energy, 100, 65)
  for i, v in ipairs(tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
end

function love.mousepressed(x, y, button)
  if button == "l" then
    for row, v in ipairs(tiles) do
      for column, tile in ipairs(v) do
        if tile:is_inside(x, y) and tile:is_legal_move() then
          if tile == targetTile then
            currentLevel = currentLevel + 1
            reset()
          end
          player.tile.visible = true
          player.tile = tiles[row][column]
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
  elseif button == "r" then
    reset()
  end
end
