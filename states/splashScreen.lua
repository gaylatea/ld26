-- Splash screen mode.
splashScreen    = {}
splashScreen_mt = { __index = splashScreen }

function splashScreen:new()
  -- Load in necessary resources for the screen.
  local sounds = {
    start   = love.audio.newSource("assets/start.wav"),
  }
  return setmetatable({ sounds = sounds }, splashScreen_mt)
end

function splashScreen:update(dt)
  -- Update any animations in this screen.
end

function splashScreen:click(x, y, button)
  -- Process mouse clicks on this screen.
  love.audio.play(self.sounds.start)

  if button == "r" then
    player = Player:new(true)
  else
    player = Player:new()
  end

  game          = gameScreen:new()
  currentScreen = game
end

function splashScreen:draw()
  -- Draw this screen for the current frame.
  love.graphics.print("Click the mouse to start", 550, 350)
end
