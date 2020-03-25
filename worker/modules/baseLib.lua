-- dependencies
local robot = require('robot')

local helperLib = require('helperLib')
local sideLib = require('sideLib')


--- provides functionality for a robot's baseLib methods 
-- @module baseLibLib
local baseLibLib = {}


--- getToolDurability gets the durability of the currently equipted tool
-- @return tool durability
function baseLibLib.getToolDurability()
  return robot.durability()
end


--- move moves in the specified direction
-- @param direction to move
-- @tparam string
-- @return true, or false
-- @todo handle invalid side error
function baseLibLib.move(direction)
  local knownDirections={
    u = robot.up,
    d = robot.down,
    f = robot.forward,
    b = robot.back}
  if helperLib.checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  else
    -- todo: handle invalid direction error
  end
end


--- turn turns in the specified direction
-- @param direction to turn
-- @tparam string
-- @return true, or false
-- @todo handle invalid side error
function baseLibLib.turn(direction)
  local knownDirections={
    l = robot.turnLeft,
    r = robot.turnRight}
  if helperLib.checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  else
    -- todo: handle invalid direction error
  end
end


--- getName gets the name of the device
-- @return name
function baseLib.getName()
  return robot.name()
end


--- leftClick performs a leftClick action
-- @param side to perform the leftClick action
-- @tparam string
-- @return true, or false[, string]
-- @todo handle invalid side error
function baseLib.leftClick(side)
  if sideLib.checkSideIsValid(side) then
    return robot.swing(sideLib.getSideValue(side))
  else
    -- todo: handle invalid side error
  end
end


--- rightClick performs a rightClick action
-- @param side to perform the rightClick action
-- @tparam string
-- @param sneaky performs rightClick while shifting
-- @tparam boolean
-- @param duration to perform the rightClick action
-- @tparam number
-- @return true, or false[, string]
-- @todo handle invalid side error
function baseLib.rightClick(side, sneaky, duration)
  if sideLib.checkSideIsValid(side) then
    return robot.use(sideLib.getSideValue(side))
  else
    -- todo: handle invalid side error
  end
end


--- placeBlock places a block from the current slot
-- @param side to place the block
-- @tparam string
-- @param sneaky performs placeBlock while shifting
-- @tparam boolean
-- @return true, or false[, string]
-- @todo handle invalid side error
function baseLib.placeBlock(side, sneaky)
  if sideLib.checkSideIsValid(side) then
    return robot.place(sideLib.getSideValue(side))
  else
    -- todo: handle invalid side error
  end
end


--- getLightColor gets the current color of the device's light
-- @return integer encoded RGB value (0xRRGGBB)
function baseLib.getLightColor()
  return robot.getLightColor()
end


--- setLightColor sets the color of the device's light
-- @param color is an integer enconded RGB value (0xRRGGBB)
-- @return true, or false
-- @todo check color is integer encoded RGB value (0xRRGGBB)
function baseLib.setLightColor(color)
  -- todo: check color is interger encoded RGB value (0xRRGGBB)
  return robot.setLightColor(color)
end


return baseLib
