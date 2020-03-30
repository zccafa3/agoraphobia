--- provides orientation functionality
-- @module sideLib
local sidesLib = {}

--- Dependencies
local sides = require('sides')

_ENV = sidesLib

--- Table of orientations and relative values
-- @table knownSides
local knownSides = {
  u = sides.bottom,
  d = sides.top,
  f = sides.front,
  b = sides.back,
  l = sides.left,
  r = sides.right}

--- getSideVal provides the relative value for the specified orientation
-- @param side specified orientation
-- @tparam string
-- @return orientation value, or nil
-- @todo handle invalid side error
function sidesLib.getSideVal(side)
    return knownSides[side]
end

return sidesLib
