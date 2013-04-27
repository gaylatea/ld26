-- ld26 main.lua
-- Callbacks for Love2d.

-- Current tile the player is located in.
playertile = nil

-- Handle processing for each of the game tiles.
Tile = {x = 0, y = 0, cost = 1, sx = 32, sy = 32}
Tile_mt = { __index = Tile }
function Tile:new(x, y, sx, sy)
  sx = sx or 32
  sy = sy or 32
  return setmetatable( {x=x, y=y, sx=sx, sy=sy}, Tile_mt)
end

function Tile:draw()
  -- Be a good citizen and pop the graphics back to their proper
  -- colours when we're done.
  local oldr, oldg, oldb, olda = love.graphics.getColor()

  local mousex, mousey = love.mouse.getPosition()
  if self:is_inside(mousex, mousey) then
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x, self.y, (self.x+self.sx), self.y)
    love.graphics.line(self.x, self.y, self.x, (self.y+self.sy))
    love.graphics.line((self.x+self.sx), self.y, (self.x+self.sx), (self.y+self.sy))
    love.graphics.line(self.x, (self.y+self.sy), (self.x+self.sx), (self.y+self.sy))
  end

  if playertile == self then
    love.graphics.draw(image, self.x, self.y)
  end

  love.graphics.setColor(oldr, oldg, oldb, olsa)
end

function Tile:is_inside(x, y)
  return(x >= (self.x + 1) and x <= (self.x + (self.sx - 1)) and
    y >= (self.y + 1) and y <= (self.y + (self.sy - 1)))
end


function love.load()
  image = love.graphics.newImage('samplesprite.png')
  -- Create some sample tiles to mess around with.
  local tile = 0
  tiles = {}
  repeat
    local x = (tile * 32) + 100
    table.insert(tiles, Tile:new(x, 100))
    tile = tile + 1
  until tile >= 20

  playertile = tiles[1]
end

function love.draw()
  -- Draw the grid system.
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Path. Use the mouse to navigate.", 100, 50)
  for i, v in ipairs(tiles) do v:draw() end
end

function love.mousepressed(x, y, button)
  if button == "l" then
    for i, v in ipairs(tiles) do
      if v:is_inside(x, y) then
        playertile = tiles[i]
        break
      end
    end
  end
end
