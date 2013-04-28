-- Player state during the game.
Player    = {
  tile        = nil,
  energy      = 0,
  animations  = nil,
  animation   = nil,
  sounds      = nil,
}
Player_mt = { __index = Player }

function Player:new(potato_mode)
  -- Load in animations the player will play.
  -- Optionally, load in the "potato mode" skins.
  potato_mode   = potato_mode or false
  local images  = {}

  if potato_mode then
    images.good   = love.graphics.newImage("assets/potato100.png")
    images.okay   = love.graphics.newImage("assets/potato75.png")
    images.bad    = love.graphics.newImage("assets/potato50.png")
    images.dying  = love.graphics.newImage("assets/potato25.png")
    images.death  = love.graphics.newImage("assets/potato0.png")
  else
    images.good   = love.graphics.newImage("assets/ball1.png")
    images.okay   = love.graphics.newImage("assets/ball75.png")
    images.bad    = love.graphics.newImage("assets/ball50.png")
    images.dying  = love.graphics.newImage("assets/ball25.png")
    images.death  = love.graphics.newImage("assets/ball0b.png")
  end

  local sounds = {
    death = love.audio.newSource("assets/explosion.wav"),
  }

  local animations = {
    good    = newAnimation(images.good,   32, 32, 0.13, 0),
    okay    = newAnimation(images.okay,   32, 32, 0.13, 0),
    bad     = newAnimation(images.bad,    32, 32, 0.13, 0),
    dying   = newAnimation(images.dying,  32, 32, 0.13, 0),
  }

  -- Setup the death animation because it's needs the callback support.
  animations.death = newAnimation(images.death, 32, 32, 0.25, 0, nil, nil,
    self.gameOver)
  animations.death:setMode("once")

  return setmetatable({
    animations  = animations,
    animation   = animations.good,
    sounds      = sounds,
  }, Player_mt)
end

function Player:updateEnergy(energy)
  -- Change animations based off of how much energy we have.
  self.energy = energy
  if self.energy > 75 then
    self.animation = self.animations.good
  elseif self.energy > 50 then
    self.animation = self.animations.okay
  elseif self.energy > 25 then
    self.animation = self.animations.bad
  elseif self.energy > 0 then
    self.animation = self.animations.dying
  else
    self.animation = self.animations.death
    love.audio.play(player.sounds.death)
  end
  self.animation:reset()
end

function Player:update(dt)
  -- Handle changing the animations on-the-fly.
  self.animation:update(dt)
end

function Player:draw(x, y)
  -- Handle animating the player.
  self.animation:draw(x, y)
end

function Player.gameOver()
  -- Called when the death animation is finished playing.
  -- Will reset the game (for now).
  -- Will eventually transition to Game Over screen.
  player.animations.death:reset()
  player.animations.death:play()
  game.level = Level:new(1)

  player:updateEnergy(100)
  player.tile           = game.level.tiles[8][1]
  player.tile.costValue = 0
end
