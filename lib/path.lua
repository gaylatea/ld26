Path    = {
  tile        = nil,
  animation   = nil,
}
Path_mt = { __index = Path }

function Path:new(tile)
	tile = tile or nil
	animation = game.animations.sh_path--self:DetermineAnimation(tile)
	return setmetatable({tile=tile, animation=animation}, Achievement_mt)
end

function Path:draw(tile) 
	if path.tile = tile then
		return path.animation
	end
end

--function Path:determineAnimation(tile)
	--for i, v in ipairs(Path) do
	--priorTile = tile[i-1]
	--beforePriorTile = tile[i-2]
--end