-- dependencies
local robot = require('robot')

local helperLib = require('helperLib')
local sideLib = require('sideLib')


--- provides functionality for a robot's internal inventoy methods 
-- @module internalInventoryLib
local internalInventoryLib = {}


--- getInventorySize() gets the number of slots in the internal inventory
-- @return number of slots
function internalInventoryLib.getInventorySize()
  return robot.inventorySize()
end


--- checkSlotIsValid checks the specified slot is valid
-- @param slot value to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSlotIsValid(slot)
  if slot <= internalInventoryLib.getInventorySize() then
    return true
  else
    return false
  end
end


--- getCurrentSlot gets the number of the current slot
-- @return current slot
function internalInventoryLib.getCurrentSlot()
  return robot.select()
end


--- selectSlot sets the specified slot
-- @param slot to be selected
-- @tparam integer
-- @return 
-- @todo handle invalid slot error
function internalInventoryLib.selectSlot(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    return robot.select(slot)
  else
    -- todo: handle invalid slot error
  end
end


--- getCurrentSlotCount gets the number of items in the current slot
-- @return number of items in slot
function internalInventoryLib.getCurrentSlotCount()
  return robot.count()
end


--- getSlotCount gets the number of items in the specified slot
-- @param slot to be counted
-- @tparam integer
-- @return number of items in slot
-- @todo handle invalid slot error
function internalInventoryLib.getSlotCount(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    return robot.count(slot)
  else
    -- todo: handle invalid slot error
  end
end


--- getSlotSpace gets the remaining number of items that can be added to the current slot
-- @return number of items that can be added to slot
function internalInventoryLib.getCurrentSlotSpace()
  return robot.space()
end


--- getSlotSpace gets the remaining number of items that can be added to the specified slot
-- @param slot to be evaluated
-- @tparam integer
-- @retun number of items that can be added to slot
-- @todo handle invalid slot error
function internalInventoryLib.getSlotSpace(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    return robot.sapce(slot)
  else
    -- todo: handle invalid slot error
  end
end


--- checkSlotItemsEquivalent compares the contents of the current slot and the specified slot
-- @param slot to be compared
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkSlotItemsEquivalent(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    return robot.compareTo(slot)
  else
    -- todo: handle invalid slot error
  end
end


--- moveStackToSlot moves all items (stack) in the current slot to the specified slot 
-- @param slot for stack to be moved
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.moveStackToSlot(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    return robot.transferTo(slot)
  else
    -- todo: handle invalid slot error
  end
end


--- moveItemsToSlot moves the specified number of items in the current slot to the specified slot
-- @param slot for items to be moved
-- @tparam integer
-- @param items number of items to be moved
-- @tparam integer
-- @return true, or false
-- @todo handle invalid number of items error
-- @todo handle invalid slot error
function internalInventoryLib.moveItemsToSlot(slot, items)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if items <= internalInventoryLib.getCurrentSlotCount then
      return robot.transferTo(slot, items)
    else
      -- todo: handle invalid number of items error
    end
  else
    -- todo: handle invalid slot error
  end
end


--- getNumTanks gets the number of tanks installed
-- @return number of tanks
function internalInventoryLib.getNumTanks()
  return robot.tankCount()
end


--- checkTankIsValid checks the specified tank is valid
-- @param tank value to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkTankIsValid(tank)
  if tank <= internalInventoryLib.getNumTanks() then
    return true
  else
    return false
  end
end


--- setTank selects the specified tank
-- @param tank to be selected
-- @tparam integer
-- @return 
-- @todo handle invalid tank error
function internalInventoryLib.setTank(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    return robot.selectTank(tank)
  else
    -- todo: handle invalid tank error
  end
end


--- getCurrentTankLevel gets the level of the current tank
-- @return tank level
function internalInventoryLib.getCurrentTankLevel()
  return robot.tankLevel()
end


--- getTankLevel gets the level of the specified tank
-- @param tank to be level checked
-- @tparam integer
-- @return tank level
-- @todo handle invalid tank error
function internalInventoryLib.getTankLevel(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    return robot.tankLevel(tank)
  else
    -- todo: handle invalid tank error
  end
end


--- getCurrnetTankSpace gets the remaining amount of fluid that can be added to the current tank
-- @return amount of fluid that can be added to tank
function internalInventoryLib.getCurrentTankSpace()
  return robot.tankSpace()
end


--- getTankSpace gets the remaining amount of fluid that can be added to the specified tank
-- @param tank to be evaluated
-- @tparam integer
-- @return amount of fluid that can be added to tank
-- @todo handle invalid tank error
function internalInventoryLib.getTankSpace(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    return robot.tankSpace(tank)
  else
    -- todo: handle invalid tank error
  end
end


--- checkTankFluidsEquivalent compares the fluid in the current tank to the specified tank
-- @param tank to be compared
-- @tparam integer
-- @return true, or false
-- @todo handle invalid tank error
function internalInventoryLib.checkTankFluidsEquivalent(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    return robot.compareFluidTo(tank)
  else
    -- todo: handle invalid tank error
  end
end


--- moveBucketToTank moves 1000mB of fluid from current tank to specified tank 
-- @param tank for fluid to be moved
-- @tparam integer
-- @return true, or false
-- @todo handle invalid tank error
function internalInventoryLib.moveBucketToTank(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    return robot.transferFluidTo(tank)
  else
    -- todo: handle invalid tank error
  end
end


--- moveFluidToTank moves the specified volume of fluid from current tank to specified tank
-- @param tank for fluid to be moved
-- @tparam integer
-- @param milliBuckets volume of fluid to be moved
-- @tparam integer
-- @return true, false
-- @todo handle invalid volume error
-- @todo handle invalid tank error
function internalInventoryLib.moveFluidToTank(tank, milliBuckets)
  if internalInventoryLib.checkTankIsValid(tank) then
    if milliBuckets <= internalInventoryLib.getCurrentTankLevel() then
      return robot.transferFluidTo(tank, milliBuckets)
    else
      -- todo: handle invalid volume error
    end
  else
    -- todo: handle invalid tank error
  end
end


return internalInventoryLib
