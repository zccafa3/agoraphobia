--- provides functionality for a device's external inventory methods
-- @module extTankLib
local extTankLib = {}

--- Dependencies
local component = require('component')

local sidesLib = require('sidesLib')
local utilsLib = require('utilsLib')

local robot = component.robot

_ENV = extTankLib

--- checkFluidEquiv compares the fluid on the specified side to the current
---tank
-- @param side to be checked
-- @tparam string
-- @return true, or false
local function checkFluidEquiv(side)
  return robot.compareFluid(sideLib.getSideVal(side))
end

--- takeBucket extracts 1000mB from the specified side
-- @param side to be extracted
-- @tparam string
-- @return true, or false
local function takeBucket(side)
  return robot.drain(sidesLib.getSideVal(side))
end

--- takeFluid extracts the specified volume of fluid from the specified side
-- @param side to be extracted
-- @tparam string
-- @param milliBuckets to be extracted
-- @tparam number
-- @return true, or false
local function takeFluid(side, milliBuckets)
  return robot.drain(sidesLib.getSideVal(side), milliBuckets)
end

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  checkFluidEquiv = checkFluidEquiv,
  takeBucket      = takeBucket,
  takeFluid       = takeFluid}

--- handleExtInvInstruct executes the specified instruct with the appropriate
---number of arguement
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function extTankLib.handleExtTankInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return extTankLib
