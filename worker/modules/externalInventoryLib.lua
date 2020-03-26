-- dependencies
local sideLib = require('sideLib')
local internalInventoryLib = require('internalInventoryLib')

--- provides functionality for a device's external inventory methods
-- @module externalInventoryLib
local externalInventoryLib = {}


--- checkIfObstructed checks the specified side for obstruction
-- @param side to be checked
-- @tparam string
-- @return true, or false
function externalInventoryLib.checkIfObstructed(side)
  if sideLib.checkSideIsValid(side) then
    return robot.detect(sideLib.getSideValue(side))
  end
end


--- checkFluidIsEquivalent compares the fluid on the specified side to the current tank
-- @param side to be checked
-- @tparam string
-- @return true, or false
function externalInventoryLib.checkFluidIsEquivalent(side)
  if sideLib.checkSideIsValid(side) then
    return robot.compareFluid(sideLib.getSideValue(side))
  end
end


--- collectBucket extracts 1000mB from the specified side
-- @param side to be extracted
-- @tparam string
-- @return true, or false
function externalInventoryLib.collectBucket(side)
  if sideLib.checkSideIsValid(side) then
    return robot.drain(side)
  end
end


--- collectFluid extracts the specified volume of fluid from the specified side
-- @param side to be extracted
-- @tparam string
-- @param milliBuckets to be extracted
-- @tparam integer
-- @return true, or false
function externalInventoryLib.collectFluid(side, milliBuckets)
  if sideLib.checkSideIsValid(side) then
    if volume <= internalInventoryLib.getCurrentTankSpace() then
      return robot.drain(side, volume)
    end
  end
end


