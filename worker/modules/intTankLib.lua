--- provides functionality for a device's internal inventory methods 
-- @module intTankLib
local intTankLib = {}

--- dependencies
local robot = require('robot')

local utilsLib = require('utilsLib')

_ENV = intTankLib

--- Table of known internal tank inventory instructs
-- @table knownInstructs
local knownInstructs = {
  getNumTanks         = getNumTanks,
  setTank             = setTank,
  getCurrTankLevel    = getCurrTankLevel,
  getTankLevel        = getTankLevel,
  getCurrTankSpace    = getCurrTankSpace,
  getTankSpace        = getTankSpace,
  checkTankFluidEquiv = checkTankFluidEquiv,
  moveBucketToTank    = moveBucketToTank,
  moveFluidToTank     = moveFluidToTank}

--- handleIntTankInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function intTankLib.handleIntTankInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

--- getNumTanks gets the number of tanks installed
-- @return number of tanks
function intTankLib.getNumTanks()
  return robot.tankCount()
end

--- setTank selects the specified tank
-- @param tank to be selected
-- @tparam integer
-- @return 
function intTankLib.setTank(tank)
 return robot.selectTank(tank)
end

--- getCurrTankLevel gets the level of the current tank
-- @return tank level
function intTankLib.getCurrTankLevel()
  return robot.tankLevel()
end

--- getTankLevel gets the level of the specified tank
-- @param tank to be level checked
-- @tparam integer
-- @return tank level
function intTankLib.getTankLevel(tank)
  return robot.tankLevel(tank)
end

--- getCurrTankSpace gets the remaining amount of fluid that can be added to
---the current tank
-- @return amount of fluid that can be added to tank
function intTankLib.getCurrTankSpace()
  return robot.tankSpace()
end

--- getTankSpace gets the remaining amount of fluid that can be added to the
---specified tank
-- @param tank to be evaluated
-- @tparam integer
-- @return amount of fluid that can be added to tank
function intTankLib.getTankSpace(tank)
  return robot.tankSpace(tank)
end

--- checkTankFluidEquiv checks whether the contents of the current and
---specified tanks are equivalent
-- @param tank to be compared
-- @tparam integer
-- @return true, or false
function intTankLib.checkTankFluidEquiv(tank)
  return robot.compareFluidTo(tank)
end

--- moveBucketToTank moves 1000 mB of fluid in the current to the specified
---tank 
-- @param tank for fluid to be moved
-- @tparam integer
-- @return true, or false
function intTankLib.moveBucketToTank(tank)
  return robot.transferFluidTo(tank)
end

--- moveFluidToTank moves the specified volume (mB) of fluid in the current to
---the specified tank
-- @param tank for fluid to be moved
-- @tparam integer
-- @param milliBuckets volume of fluid to be moved
-- @tparam integer
-- @return true, false
function intTankLib.moveFluidToTank(tank, milliBuckets)
  return robot.transferFluidTo(tank, milliBuckets)
end

return intTankLib
