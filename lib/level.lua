-- Level management.
require("lib/tile")

Level    = {}
Level_mt = { __index = Level }

function Level:new(number, startx, starty)
  -- Load in necessary resources for the screen.
  local row = 0
  local tiles = {}
  repeat
    local y = (row * 32) + 100
    local column = 0
    local rowtable = {}
    repeat
      local x = (column * 32) + 100
      table.insert(rowtable, Tile:new(x, y, column, row))
      column = column + 1
    until column == 32
    table.insert(tiles, rowtable)
    row = row + 1
  until row == 15

  -- Figure out a small text to display for each level.
  local text = ""
  if number == 1 then
    text = "Watch your energy, you need it to find that wormhole.  Click an adjacent tile to move."
  elseif number == 2 then
    text = "Would you look at that! New area. Rougher though."
  elseif number == 3 then
    text = "So. No destination? That’s alright. There’s some pretty nebulas."
  elseif number == 4 then
    text = "Oh. More space. Great."
  end

  -- Record the starting tile so we can put a wormhole there.
  local start = tiles[starty][startx]

  -- Give the player less energy per level, so they have to try and
  -- conserve their resources.
  newEnergy = (75 - ((number - 1) * 25))
  if newEnergy < 25 then
    newEnergy = 25
  end

  player.energy = newEnergy + player.energy

  -- Randomize where the target tile is, but try to keep it at least
  -- certain distance away from the player.
  local randomTargetRow     = math.random(15)
  local randomTargetColumn  = math.random(32)

  local target = tiles[randomTargetRow][randomTargetColumn]
  target.costValue = 0

  -- Choose a random background from the available list for this
  -- level.
  local bgNumber    = math.random(1, 5)
  local background  = love.graphics.newImage("assets/spacebg"..bgNumber..".png")

  return setmetatable({
    number      = number,
    tiles       = tiles,
    target      = target,
    background  = background,
    start       = start,
    text        = text,
  }, Level_mt)
end

function Level:draw()
  -- Draw the level for this frame.
  love.graphics.draw(self.background, 0, 0)

  for i, v in ipairs(self.tiles) do
    for row, tile in ipairs(v) do tile:draw() end
  end
end
