--- Provides functionality for a device's internal inventory methods 
-- @module intInvLib
local intInvLib = {}

--- Dependencies
local component = require('component')

local utilsLib = require('utilsLib')

local robot = component.robot

_ENV = intInvLib

--- getNumSlots gets number of slots in the internal inventory
-- @return number of slots
local function getNumSlots()
  return robot.inventorySize()
end

--- getCurrSlot gets the number of the current slot
-- @return current slot number
local function getCurrSlot()
  return robot.select()
end

--- selectSlot sets the specified slot
-- @param slot to be selected
-- @tparam number
-- 
local function selectSlot(slot)
  return robot.select(slot)
end

--- getCurrSlotCount gets the number of items in the current slot
-- @return number of items in slot
local function getCurrSlotCount()
  return robot.count()
end

--- getSlotCount gets the number of items in the specified slot
-- @param slot to be counted
-- @tparam number
-- @return number of items in slot
local function getSlotCount(slot)
  return robot.count(slot)
end

--- getCurrSlotSpace gets the remaining number of items that can be added to
---the current slot
-- @return number of items that can be added to slot
local function getCurrSlotSpace()
  return robot.space()
end

--- getSlotSpace gets the remaining number of items that can be added to
---the specified slot
-- @param slot to be evaluated
-- @tparam number
-- @retun number of items that can be added to slot
local function getSlotSpace(slot)
  return robot.sapce(slot)
end

--- checkSlotItemEquiv check whether the contents of the current and specified
---slots are equivalent
-- @param slot to be compared
-- @tparam number
-- @return true, or false
local function checkSlotItemEquiv(slot)
  return robot.compareTo(slot)
end

--- moveStackToSlot moves all items (stack) in the current to the specified
---slot 
-- @param slot for stack to be moved
-- @tparam number
-- @return true, or false
local function moveStackToSlot(slot)
  return robot.transferTo(slot)
end

--- moveItemsToSlot moves the specified number of items in the current to the
---specified slot
-- @param slot for items to be moved
-- @tparam number
-- @param items number of items to be moved
-- @tparam number
-- @return true, or false
local function moveItemsToSlot(slot, items)
  return robot.transferTo(slot, items)
end

--- Table of known internal inventory instructs
-- @table knownInstructs
local knownInstructs = {
  getNumSlots         = getNumSlots,
  getCurrSlot         = getCurrSlot,
  selectSlot          = selectSlot,
  getCurrSlotCount    = getCurrSlotCount,
  getSlotCount        = getSlotCount,
  getCurrSlotSpace    = getCurrSlotSpace,
  getSlotSpace        = getSlotSpace,
  checkSlotItemEquiv  = checkSlotItemEquiv,
  moveStackToSlot     = moveStackToSlot,
  moveItemsToSlot     = moveItemsToSlot}

--- handleIntInvInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function intInvLib.handleIntInvInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return intInvLib
