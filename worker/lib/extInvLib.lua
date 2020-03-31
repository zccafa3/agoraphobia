--- provides functionality for a device's external inventory methods
-- @module extInvLib
local extInvLib = {}

--- Dependencies
local component = require('component')

local sidesLib = require('sidesLib')
local utilsLib = require('utilsLib')

local robot = component.robot

_ENV = extInvLib

--- checkBlockEquiv checks whether the current slot item and block on the
--specified side are equivalent
-- @param side to be checked
-- @tparam string
-- @param fuzzy
-- @tparam boolean
-- @return true, or false
local function checkBlockEquiv(side, ...) -- fuzzy
  return robot.compare(sidesLib.getSideVal(side), ...)
end

--- giveItems depositss the specified number of items from the current slot to
---(an inventory on the) specified side
-- @param side for items to be deposited
-- @tparam string
-- @param items to be deposited
-- @tparam number
-- @return true if at least one item deposited, or false
local function giveItems(side, ...) -- items
  return robot.drop(sidesLib.getSideVal(side), ...)
end

--- takeItems extracts the specified number of items from (an inventory on) the
---specified side to the current slot
-- @param side for items to be extracted
-- @tparam string
-- @param items to be extracted
-- @tparam number
-- @retun true, or false
local function takeItems(side, ...) -- items
  return robot.suck(sidesLib.getSideVal(side), ...)
end

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  checkBlockEquiv = checkBlockEquiv,
  giveItems       = giveItems,
  takeItems       = takeItems}

--- handleExtInvInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function extInvLib.handleExtInvInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return extInvLib
