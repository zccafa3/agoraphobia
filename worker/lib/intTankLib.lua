--- provides functionality for a device's internal inventory methods 
-- @module intTankLib
local intTankLib = {}

--- dependencies
local component = require('component')

local utilsLib = require('utilsLib')

local robot = component.robot

_ENV = intTankLib

--- getNumTanks gets the number of tanks installed
-- @return number of tanks
local function getNumTanks()
  return robot.tankCount()
end

--- setTank selects the specified tank
-- @param tank to be selected
-- @tparam integer
-- @return 
local function setTank(tank)
 return robot.selectTank(tank)
end

--- getCurrTankLevel gets the level of the current tank
-- @return tank level
local function getCurrTankLevel()
  return robot.tankLevel()
end

--- getTankLevel gets the level of the specified tank
-- @param tank to be level checked
-- @tparam integer
-- @return tank level
local function getTankLevel(tank)
  return robot.tankLevel(tank)
end

--- getCurrTankSpace gets the remaining amount of fluid that can be added to
---the current tank
-- @return amount of fluid that can be added to tank
local function getCurrTankSpace()
  return robot.tankSpace()
end

--- getTankSpace gets the remaining amount of fluid that can be added to the
---specified tank
-- @param tank to be evaluated
-- @tparam integer
-- @return amount of fluid that can be added to tank
local function getTankSpace(tank)
  return robot.tankSpace(tank)
end

--- checkTankFluidEquiv checks whether the contents of the current and
---specified tanks are equivalent
-- @param tank to be compared
-- @tparam integer
-- @return true, or false
local function checkTankFluidEquiv(tank)
  return robot.compareFluidTo(tank)
end

--- moveBucketToTank moves 1000 mB of fluid in the current to the specified
---tank 
-- @param tank for fluid to be moved
-- @tparam integer
-- @return true, or false
local function moveBucketToTank(tank)
  return robot.transferFluidTo(tank)
end

--- moveFluidToTank moves the specified volume (mB) of fluid in the current to
---the specified tank
-- @param tank for fluid to be moved
-- @tparam integer
-- @param milliBuckets volume of fluid to be moved
-- @tparam integer
-- @return true, false
local function moveFluidToTank(tank, milliBuckets)
  return robot.transferFluidTo(tank, milliBuckets)
end

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

return intTankLib
