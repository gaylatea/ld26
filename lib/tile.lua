-- Tile class.
-- Handle processing for each of the game tiles.
Tile = {x = 0, y = 0, cost = 1, sx = 32, sy = 32,
        costValue = 1, visible = false,
        red=90, green=90, blue=90, levelNumber = 0}
Tile_mt = { __index = Tile }
function Tile:new(x, y, gx, gy, levelNumber)
  levelNumber = levelNumber or 0
  costTemp = math.random(101)
  if costTemp == 1 and costTemp < (40-(levelNumber * 5)) then
    costValue = 1
  elseif costTemp > (41-(levelNumber * 5)) and costTemp < (65-(levelNumber * 5)) then
    costValue = 2
  elseif costTemp > (66-(levelNumber * 5)) and costTemp < (85-(levelNumber * 5)) then
    costValue = 3
  elseif costTemp > (86-(levelNumber * 5)) and costTemp < (95-(levelNumber * 5)) then
    costValue = 4
  elseif costTemp > (96-(levelNumber * 5))  and costTemp == 101 then
    costValue = 5
  end
  visible = visible or false
  red = red or 90
  green = green or 90
  blue = blue or 90
  return setmetatable( {x=x, y=y, gx=gx, gy=gy, costValue=costValue, visible=visible, red=red, green=green, blue=blue, levelNumber=levelNumber}, Tile_mt)
end


function Tile:draw()
  -- Draw the target tile in red so we know what's up.
  if game.level.target == self then
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
        or (self.x == player.tile.x-32 and self.y == player.tile.y)
          then
            love.graphics.setColor(255, 255, 255)
          else
            love.graphics.setColor(self.red, self.blue, self.green)
      end

    if self:is_inside(mousex, mousey) then
      love.graphics.print(self.costValue, self.x+13, self.y+9)
    end

    love.graphics.setColor(255, 255, 255)

    if  self.costValue == 3 then
        love.graphics.draw(game.images.asteroidBelt, self.x, self.y)
      elseif self.costValue == 4 then
       love.graphics.draw(game.images.spaceStation, self.x, self.y)
      elseif self.costValue == 5 then
        love.graphics.draw(game.images.sun, self.x, self.y)
    end
  end

  --run the animation for the path the payer has traveled
  if self.visible == true and self~=player.tile
    then
    if self.t_path == true
      then
      game.animations.t_path:draw(self.x, self.y)
    else
    game.animations.s_path:draw(self.x, self.y)
    end
  end

  if player.tile == self then
    player:draw(self.x, self.y)
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
