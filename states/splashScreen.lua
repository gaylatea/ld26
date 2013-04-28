-- Splash screen mode.
require("lib/button")

splashScreen    = {}
splashScreen_mt = { __index = splashScreen }

function splashScreen:new()
  -- Load in necessary resources for the screen.
  local sounds = {
    start   = love.audio.newSource("assets/start.wav"),
  }

  local background = love.graphics.newImage("assets/splash.png")

  local buttons   = {
    normal = Button:new(900, 450, 200, 32, "New Game", self.normalMode),
    potato = Button:new(900, 520, 200, 32, "Potato Mode", self.potatoMode),
  }

  return setmetatable({
    sounds      = sounds,
    background  = background,
    buttons     = buttons,
  }, splashScreen_mt)
end

function splashScreen:update(dt)
  -- Update any animations in this screen.
end

function splashScreen:click(x, y, button)
  -- Process mouse clicks on this screen.
  if button ~= "l" then return end

  for i, button in pairs(self.buttons) do
    if button:is_inside(x, y) then
      button:click()
      love.audio.play(self.sounds.start)

      game          = gameScreen:new()
      currentScreen = game
    end
  end
end

function splashScreen.potatoMode()
  -- Callback for potato mode button.
  player = Player:new(true)
end

function splashScreen.normalMode()
  -- Callback for normal button.
  player = Player:new()
end

function splashScreen:draw()
  -- Draw this screen for the current frame.
  love.graphics.draw(self.background, 0, 0)
  for i, button in pairs(self.buttons) do
    button:draw()
  end
end
