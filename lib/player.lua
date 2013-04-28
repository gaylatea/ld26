-- Player state during the game.
Player    = { tile = nil, energy = 0, animation = nil }
Player_mt = { __index = Player }

function Player:new()
  -- Load in necessary resources for the screen.
  return setmetatable({}, Player_mt)
end

function Player:draw(x, y)
  -- Handle animating the player.
  if playDeath then
    if game.animations.death:getCurrentFrame() == 7 then
      game.level = Level:new(1)
    end
    game.animations.death:draw(x, y)
  else
    if self.energy >= 76 then
      game.animations.good:draw(x, y)
    elseif self.energy >= 51 then
      game.animations.okay:draw(x, y)
    elseif self.energy >= 26 then
      game.animations.bad:draw(x, y)
    else
      game.animations.dying:draw(x, y)
    end
  end
end
