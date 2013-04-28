-- Clickable button for the splash screen.
Button    = {}
Button_mt = { __index = Button }

function Button:new(x, y, sx, sy, text, callback)
  -- Setup.
  local fonts = {
    large   = love.graphics.newFont("assets/sourcesans.ttf", 32),
    normal  = love.graphics.newFont(11),
  }

  return setmetatable({
    x         = x,
    y         = y,
    sx        = sx,
    sy        = sy,
    text      = text,
    callback  = callback,
    fonts     = fonts,
  }, Button_mt)
end

function Button:is_inside(x, y)
  -- Returns if a given point is inside the square.
  return (x >= self.x and x <= (self.x + self.sx) and
    y >= self.y and y <= (self.y + self.sy))
end

function Button:click()
  -- Perform whatever function the button should do.
  self.callback()
end

function Button:draw()
  love.graphics.setFont(self.fonts.large)

  -- Glow red on hover to show the player that this is clickable.
  local mousex, mousey = love.mouse.getPosition()
  local oldr, oldg, oldb, olda = love.graphics.getColor()

  if self:is_inside(mousex, mousey) then
    love.graphics.setColor(255, 0, 0)
  else
    love.graphics.setColor(255,255,255)
  end

  love.graphics.print(self.text, self.x, self.y)
  love.graphics.setFont(self.fonts.normal)
  love.graphics.setColor(oldr, oldg, oldb, olda)
end
