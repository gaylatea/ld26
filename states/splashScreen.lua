-- Splash screen mode.
splashScreen    = {}
splashScreen_mt = { __index = splashScreen }

function splashScreen:new()
  -- Load in necessary resources for the screen.
  return setmetatable({}, splashScreen_mt)
end

function splashScreen:update(dt)
  -- Update any animations in this screen.
end

function splashScreen:click(x, y, button)
  -- Process mouse clicks on this screen.
end

function splashScreen:draw()
  -- Draw this screen for the current frame.
end
