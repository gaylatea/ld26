-- Tile class.
-- Handle processing for each of the game tiles.
Tile = {x = 0, y = 0, cost = 1, sx = 32, sy = 32,
        costValue = 1, visible = false,
        red=90, green=90, blue=90}
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

  if self:is_inside(mousex, mousey)
    then
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
    love.graphics.print(self.costValue, self.x+13, self.y+9)
    love.graphics.setColor(255, 255, 255)
    end
  end

  --run the animation for the path the payer has traveled
  if self.visible == true and self~=player.tile
    then
    if self.t_path == true
      then
      animations.t_path:draw(self.x, self.y)
    else
    animations.s_path:draw(self.x, self.y)
    end
  end

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
