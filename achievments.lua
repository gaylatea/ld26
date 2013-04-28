--achievments

--energy falls below 0 

Achievment = {text="", earned=false, }

Achievment_mt = { __index = Achievment }

function Achievment:new(text, earned)
  text = text or ""
  earned = visible or false
  return setmetatable( {text=text, earned=earned}, Achievment_mt)
end