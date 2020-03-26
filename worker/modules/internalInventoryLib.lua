-- dependencies
local robot = require('robot')


--- provides functionality for a device's internal inventory methods 
-- @module internalInventoryLib
local internalInventoryLib = {}


--- getNumberOfSlots gets the number of slots in the internal inventory
-- @return number of slots
function internalInventoryLib.getNumberOfSlots()
  return robot.inventorySize()
end


--- checkSlotIsValid checks the specified slot is valid
-- @param slot value to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSlotIsValid(slot)
  if slot <= internalInventoryLib.getNumberOfSlots() then
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


--- checkSufficientItemsInCurrentSlot checks there is sufficient items in the current slot
-- @param items number of items to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientItemsInCurrentSlot(items)
  if items <= internalInventoryLib.getCurrentSlotCount() then
    return true
  else
    return false
  end
end


--- checkSufficientItemsInSlot checks there is sufficient items in the specified slot
-- @param slot to be checked
-- @tparam integer
-- @param items number of items to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkSufficientItemsInSlot(slot, items)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if items <= internalInventoryLib.getSlotCount(slot) then
      return true
    else
      return false
    end
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


--- checkSufficientSpaceInCurrentSlot checks there is sufficient space in the current slot for the specified number of items
-- @param items number of items to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientSpaceInCurrentSlot(items)
  if items <= internalInventoryLib.getCurrentSlotSpace() then
    return true
  else
    return false
  end
end


--- checkSufficientSpaceInSlot checks there is sufficient space in the specified slot for the specified number of items
-- @param slot to be checked
-- @tparam integer
-- @param items number of items to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkSufficientSpaceInSlot(slot, items)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if items <= internalInventoryLib.getSlotSpace(slot) then
      return true
    else
      return false
    end
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


--- checkSlotIsEmpty checks whether the specified slot is empty
-- @param slot to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkSlotIsEmpty(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if internalInventoryLib.getSlotCount(slot) == 0 then
      return true
    else
      return false
    end
  else
    -- todo: handle invalid slot error
  end
end


--- checkMoveStackToSlot checks whether it is possible to move all the items (stack) in the current slot to the specified slot
-- @param slot to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkMoveStackToSlot(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if internalInventoryLib.checkSlotIsEmpty(slot) then 
      return true
    else
      if internalInventoryLib.checkSlotItemsEquivalent(slot) then
        local itemsInCurrentSlot = internalInventoryLib.getCurrentSlotCount()
        if internalInventoryLib.checkSufficientSpaceInSlot(slot, itemsInCurrentSlot) then
          return true
        else
          return false
        end
      else
        return false
      end
    end
  else
    -- todo: handle invalid slot error
  end
end


--- checkMoveItemsToSlot checks whether it is possible to move the specified number of items in the current slot to the specified slot
-- @param slot to be checked
-- @tparam integer
-- @param items number of items to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid slot error
function internalInventoryLib.checkMoveItemsToSlot(slot, items)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if internalInventoryLib.checkSlotIsEmpty(slot) then 
      return true
    else
      if internalInventoryLib.checkSlotItemsEquivalent(slot) then
        if internalInventoryLib.checkSufficientSpaceInSlot(slot, items) then
          return true
        else
          return false
        end
      else
        return false
      end
    end
  else
    -- todo: handle invalid slot error
  end
end


--- moveStackToSlot moves all items (stack) in the current slot to the specified slot 
-- @param slot for stack to be moved
-- @tparam integer
-- @return true, or false
-- @todo handle insufficeint items/space error
-- @todo handle invalid slot error
function internalInventoryLib.moveStackToSlot(slot)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if internalInventoryLib.checkMoveStackToSlot(slot) then
      return robot.transferTo(slot)
    else
      -- todo: handle insufficient items/space error
    end
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
-- @todo handle insufficeint items/space error
-- @todo handle invalid slot error
function internalInventoryLib.moveItemsToSlot(slot, items)
  if internalInventoryLib.checkSlotIsValid(slot) then
    if internalInventoryLib.checkMoveItemsToSlot(slot, items) then
      return robot.transferTo(slot, items)
    else
      -- todo: handle insufficient items/space error
    end
  else
    -- todo: handle invalid slot error
  end
end


--- getNumberOfTanks gets the number of tanks installed
-- @return number of tanks
function internalInventoryLib.getNumberOfTanks()
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


--- checkSufficientVolumeInCurrentTank checks the current tank contains the specified volume of fluid
-- @param milliBuckets volume to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientVolumeInCurrentTank(milliBuckets)
  if milliBucket <= internalInventoryLib.getCurrentTankLevel() then
    return true
  else
    return false
  end
end


--- checkSufficientVolumeInTank check the specified tank contains the specified volume of fluid
-- @param tank to be checked
-- @tparam integer
-- @param milliBuckets volume to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientVolumeInTank(tank, milliBuckets)
  if internalInventoryLib.checkTankIsValid(tank) then
    if milliBucket <= internalInventoryLib.getTankLevel(tank) then
      return true
    else
      return false
    end
  else
    -- todo: handle invalid tank error
  end
end


--- getCurrentTankSpace gets the remaining amount of fluid that can be added to the current tank
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


--- checkSufficientSpaceInCurrentTank checks there is sufficient space in the current tank for the specified volume of fluid
-- @param milliBuckets volume to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientSpaceInCurrentTank(milliBuckets)
  if milliBuckets <= internalInventoryLib.getCurrentTankSpace() then
    return true
  else
    return false
  end
end


--- checkSufficientSpaceInTank checks there is sufficient space in the specified tank for the specified volume of fluid
-- @param tank to be checked
-- @tparam integer
-- @param milliBuckets volume to be checked
-- @tparam integer
-- @return true, or false
function internalInventoryLib.checkSufficientSpaceInTank(tank, milliBuckets)
  if milliBuckets <= internalInventoryLib.getTankSpace(tank) then
    return true
  else
    return false
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


--- checkTankIsEmpty checks whether the specified tank is empty
-- @param tank to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid tank error
function internalInventoryLib.checkTankIsEmpty(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    if internalInventoryLib.getTankLevel(tank) == 0 then
      return true
    else
      return false
    end
  else
    -- todo: handle invalid tank error
  end
end


--- checkMoveBucketToTank checks whether possible to move 1000 mB of fluid from current tank to specified tank
-- @param tank to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid tank error
function internalInventoryLib.checkMoveBucketToTank(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    if internalInventoryLib.checkTankIsEmpty(tank) then 
      return true
    else
      if internalInventoryLib.checkTankFluidsEquivalent(tank) then
        if internalInventoryLib.checkSufficientSpaceInTank(tank, 1000) then
          return true
        else
          return false
        end
      else
        return false
      end
    end
  else
    -- todo: handle invalid tank error
  end
end


--- checkMoveItemsToTank checks whether possible to move specified volume (mB) of fluid from current tank to the specified tank
-- @param tank to be checked
-- @tparam integer
-- @param milliBuckets volume of fluid to be checked
-- @tparam integer
-- @return true, or false
-- @todo handle invalid tank error
function internalInventoryLib.checkMoveFluidToTank(tank, milliBuckets)
  if internalInventoryLib.checkTankIsValid(tank) then
    if internalInventoryLib.checkTankIsEmpty(tank) then 
      return true
    else
      if internalInventoryLib.checkTankFluidsEquivalent(tank) then
        if internalInventoryLib.checkSufficientSpaceInTank(tank, milliBuckets) then
          return true
        else
          return false
        end
      else
        return false
      end
    end
  else
    -- todo: handle invalid tank error
  end
end


--- moveBucketToTank moves 1000 mB of fluid from current tank to specified tank 
-- @param tank for fluid to be moved
-- @tparam integer
-- @return true, or false
-- @todo handle insufficient level/space error
-- @todo handle invalid tank error
function internalInventoryLib.moveBucketToTank(tank)
  if internalInventoryLib.checkTankIsValid(tank) then
    if internalInventoryLib.checkMoveBucketToTank(tank) then
      return robot.transferFluidTo(tank)
    else
      -- todo: handle insufficient level/space error
    end
  else
    -- todo: handle invalid tank error
  end
end


--- moveFluidToTank moves the specified volume (mB) of fluid from current tank to specified tank
-- @param tank for fluid to be moved
-- @tparam integer
-- @param milliBuckets volume of fluid to be moved
-- @tparam integer
-- @return true, false
-- @todo handle insufficient level/space error 
-- @todo handle invalid tank error
function internalInventoryLib.moveFluidToTank(tank, milliBuckets)
  if internalInventoryLib.checkTankIsValid(tank) then
    if internalInventoryLib.checkMoveFluidToTank(tank, milliBuckets) then
      return robot.transferFluidTo(tank, milliBuckets)
    else
      -- todo: handle insufficient level/space error
    end
  else
    -- todo: handle invalid tank error
  end
end


return internalInventoryLib
