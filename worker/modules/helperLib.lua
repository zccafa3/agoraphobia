--- provides a few helpful functions
-- @module helperLib
local helperLib = {}


--- checkValueInDict checks whether a value is a key of a table
-- @param value to check whether key in table
-- @param dict table of keys to check
-- @return true, or false
function helperLib.checkValueInDict(value, dict)  
  for key, v in pairs(dict) do
    if value == key then
      return true
    end
  end
  return false
end


--- splitStringAtChar splits a string at the first specified character
-- @param string to be split
-- @param char character to split the strong at
-- @return split string before char, or string
-- #return split string after char, or nil
function helperLib.splitStringAtChar(string, char)
  if string.match(string, char) == nil then
    return string, nil
  else
    local regex = '([^' .. char .. ']+)' .. char .. '([^,]+)'
    return string.match(string, regex)
  end
end

return helperLib
