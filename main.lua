-- ld26 main.lua
-- Callbacks for Love2d.
tile = 1

function love.load()
  image = love.graphics.newImage('samplesprite.png')
end

function love.draw()
  -- Draw the grid system.
  love.graphics.setColor(100, 100, 100)
  love.graphics.line(100, 100, 1156, 100)
  love.graphics.line(100, 612, 1156, 612)
  love.graphics.line(100, 100, 100, 612)
  love.graphics.line(1156, 100, 1156, 612)

  y = 100
  repeat
    y = y + 32
    love.graphics.line(100, y, 1156, y)
  until y > 610

  x = 100
  repeat
    x = x + 32
    love.graphics.line(x, 100, x, 612)
  until x > 1140

  -- Figure out where to draw the player.
  row = math.floor((tile / 34) + 1)
  column = (tile % 34) + 1
  love.graphics.draw(image, ((column * 32) + 36), ((row * 32) + 67))
end

function love.keyreleased(key, unicode)
  if key == 'down' then
    tile = tile + 34
  elseif key == 'up' then
    if tile < 35 then
      tile = 1
    else
      tile = tile - 34
    end
  elseif key == 'right' then
    tile = tile + 1
  elseif key == 'left' then
    if tile <= 1 then
      tile = 1
    else
      tile = tile - 1
    end
  end
end
