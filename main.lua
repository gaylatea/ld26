-- ld26 main.lua
-- Callbacks for Love2d.
-- Animation library.
require("AnAL")

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
  local mousex, mousey = love.mouse.getPosition()
  if self:is_inside(mousex, mousey) then
    local oldr, oldg, oldb, olda = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x, self.y, (self.x+self.sx), self.y)
    love.graphics.line(self.x, self.y, self.x, (self.y+self.sy))
    love.graphics.line((self.x+self.sx), self.y, (self.x+self.sx), (self.y+self.sy))
    love.graphics.line(self.x, (self.y+self.sy), (self.x+self.sx), (self.y+self.sy))

    love.graphics.setColor(oldr, oldg, oldb, olsa)
  end

  if playertile == self then
    anim:draw(self.x, self.y)
  end
end

function Tile:is_inside(x, y)
  return(x >= (self.x + 1) and x <= (self.x + (self.sx - 1)) and
    y >= (self.y + 1) and y <= (self.y + (self.sy - 1)))
end


function love.load()
  -- Create some sample tiles to mess around with.
  local row = 0
  tiles = {}
  repeat
    local y = (row * 32) + 100
    local column = 0
    local rowtable = {}
    repeat
      local x = (column * 32) + 100
      table.insert(rowtable, Tile:new(x, y))
      column = column + 1
    until column == 32
    table.insert(tiles, rowtable)
    row = row + 1
  until row == 15

  playertile = tiles[8][1]

  local image = love.graphics.newImage('ball1.png')
  anim = newAnimation(image, 32, 32, 0.13, 0)
end

function love.update(dt)
   -- Updates the animation. (Enables frame changes)
   anim:update(dt)
end

function love.draw()
  -- Draw the grid system.
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Path. Use the mouse to navigate.", 100, 50)
  for i, v in ipairs(tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
end

function love.mousepressed(x, y, button)
  if button == "l" then
    for row, v in ipairs(tiles) do
      for column, tile in ipairs(v) do
        if tile:is_inside(x, y) then
          playertile = tiles[row][column]
          break
        end
      end
    end
  end
end
