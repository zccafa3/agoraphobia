--- Provides functionality for some useful debug methods
-- @module debugLib
local debugLib = {}

--- Dependencies
local component = require('component')

local utilsLib = require('utilsLib')

local world = component.debug.getWorld()

_ENV = debugLib

--- insertItemToInv inserts the specified item stack to the inventry in the
--specified location
-- @param id of item stack to insert
-- @tparam string
-- @param count number of items in stack to insert
-- @tparam number
-- @param damage (or color?) of items in stack to insert
-- @tparam number
-- @param nbt data of items in stack to insert
-- @tparam string
-- @param x inventory x coordinate
-- @tparam number
-- @param y inventory y coordinate
-- @tparam number
-- @param z inventory z coordinate
-- @tparam number
-- @param side of inventory to insert item stack
-- @tparam number
-- @return true, or false
local function insertItemToInv(id, count, damage, nbt, x, y, z, side)
  return world.insertItem(id, count, damage, nbt, x, y, z, side)
end

--- removeItemFromInv removes the specified item stack from the inventory in
--the specified location
-- @param x inventory x coordinate
-- @tparam number
-- @param y inventory y coordinate
-- @tparam number
-- @param z inventory z coordinate
-- @tparam number
-- @param slot in inventory to remove stack
-- @tparam number
-- @param count number of items in stack to remove
-- @tparam number
-- @return number
local function removeItemFromInv(x, y, z, slot, ...) -- count
  return world.removeItem(x, y, z, slot, ...) -- count
end

--- Table of debug instructs
-- @table knownInstructs
local knownInstructs = {
  insertItemToInv   = insertItemToInv,
  removeItemFromInv = removeItemFromInv}

--- handleDebugInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function debugLib.handleDebugInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return debugLib
