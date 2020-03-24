local robot = require('robot')

local helperLib = require('helperLib')
local sideLib = require('sideLib')


--- 
--
local baseCommandLib = {}


---
--
function baseCommandLib.getToolDurability()
  return robot.durability()
end


---
--
function baseCommandLib.move(direction)
  local knownDirections={
    u = robot.up,
    d = robot.down,
    f = robot.forward,
    b = robot.back}
  if helperLib.checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  else
    -- ToDo: handle unknown direction error
  end
end


---
--
function baseCommandLib.turn(direction)
  local knownDirections={
    l = robot.turnLeft,
    r = robot.turnRight}
  if helperLib.checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  else
    -- ToDo: handle unknown direction error
  end
end


---
--
function baseCommand.name()
  return robot.name()
end


---
--
function baseCommand.leftClick(side)
  if sideLib.checkSideIsValid(side) then
    return robot.swing(sideLib.getSideValue(side))
  else
    -- ToDo: handle unknown side error
  end
end


---
--
function baseCommand.rightClick(side, sneaky, duration)
  if sideLib.checkSideIsValid(side) then
    return robot.use(sideLib.getSideValue(side))
  else
    -- ToDo: handle unknown side error
  end
end


---
--
function baseCommand.placeBlock(side, sneaky)
  if sideLib.checkSideIsValid(side) then
    return robot.place(sideLib.getSideValue(side))
  else
    -- ToDo: handle unknown side error
  end
end


---
--
function baseCommand.getLightColor()
  return robot.getLightColor()
end


---
--
function baseCommand.setLightColor(value)
  -- ToDo: check value is a valid interger encoded RGB value (0xRRGGBB)
  return robot.setLightColor(value)
end


return baseCommand
