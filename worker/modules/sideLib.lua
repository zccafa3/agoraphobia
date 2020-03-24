local helperLib = require('helperLib')


--- provides orientation functionality
-- @module sidesLib
local sideLib = {}


--- a table of orientations and values
local knownSides = {
  u = 1,
  d = 0,
  f = 3,
  b = 2,
  l = 5,
  r = 4}


---
--
function sideLib.checkSideIsValid(side)
  if helperLib.checkValueInDict(side, knownSides) then
    return true
  else
    return false
  end
end


--- getSideValue provides the relative value for the specified orientation
-- @param side specified orientation string
-- @return orientation value, or nil
function sideLib.getSideValue(side)
  if sideLib.checkSideIsValid(side) then
    return knownSides[side]
  else
    -- ToDo: handle invalid side error
  end
end


return sideLib
