-- dependencies
local helperLib = require('helperLib')


--- provides orientation functionality
-- @module sideLib
local sideLib = {}


--- a table of orientations and values
-- @table knownSides
local knownSides = {
  u = 1,
  d = 0,
  f = 3,
  b = 2,
  l = 5,
  r = 4}


--- checkSideIsValid checks the specified orientation is valid
-- @param side specified orientation
-- @tparam string
-- @return true, or false
function sideLib.checkSideIsValid(side)
  if helperLib.checkValueInDict(side, knownSides) then
    return true
  else
    return false
  end
end


--- getSideValue provides the relative value for the specified orientation
-- @param side specified orientation
-- @tparam string
-- @return orientation value, or nil
-- @todo handle invalid side error
function sideLib.getSideValue(side)
  if sideLib.checkSideIsValid(side) then
    return knownSides[side]
  else
    -- todo: handle invalid side error
  end
end


return sideLib
