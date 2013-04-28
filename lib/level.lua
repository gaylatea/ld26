-- Level management.
require("lib/tile")

Level    = {}
Level_mt = { __index = Level }

function Level:new(number)
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

  -- Give the player less energy per level, so they have to try and
  -- conserve their resources.
  newEnergy = (100 - ((number - 1) * 25))
  if newEnergy < 25 then
    newEnergy = 25
  end

  -- Randomize where the target tile is, but try to keep it at least
  -- certain distance away from the player.
  local randomTargetRow     = math.random(15)
  local randomTargetColumn  = math.random(32)

  local target = tiles[randomTargetRow][randomTargetColumn]
  target.costValue = 0

  return setmetatable({
    number  = number,
    tiles   = tiles,
    target  = target,
  }, Level_mt)
end
