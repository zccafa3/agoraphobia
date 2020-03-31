--- Provides functionality for a device's base methods 
-- @module baseLib
local baseLib = {}

--- Dependencies
local component = require('component')

local utilsLib = require('utilsLib')
local sidesLib = require('sidesLib')

local robot = component.robot

_ENV = baseLib

--- Table of base instructs
-- @table knownInstructs
local knownInstructs = {
  getToolDurability = getToolDurability,
  move              = move,
  turn              = turn,
  getName           = getName,
  leftClick         = leftClick,
  rightClick        = rightClick,
  placeBlock        = placeBlock,
  getLightColor     = getLightColor,
  setLightColor     = setLightColor,
  isObstructed      = isObstructed}

--- handleBaseInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function baseLib.handleBaseInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  --if #instructArgList == 1 then
  --  return knownInstructs[instruct](instructArgList[1])
  --elseif #instructArgList == 2 then
  --  return knownInstructs[instruct](instructArgList[1], instructArgList[2])
  --elseif #instructArgList == 3 then
  --  return knownInstructs[instruct](
  --  instructArgList[1],
  --  instructArgList[2],
  --  instructArgList[3])
  --end
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

--- getToolDurability gets the durability of the currently equipted tool
-- @return tool durability
function baseLib.getToolDurability()
  return robot.durability()
end

--- move moves in the specified direction
-- @param direction to move
-- @tparam string
-- @return true, or false
function baseLib.move(direction)
  return robot.move(sidesLib.getSideVal(direction))
end

--- turn turns in the specified direction
-- @param direction to turn
-- @tparam string
-- @return true, or false
function baseLib.turn(direction)
  return robot.turn((sidesLib.getSideVal(direction) == 4) or false)
end

--- getName gets the name of the device
-- @return name
function baseLib.getName()
  return robot.name()
end

--- leftClick performs a leftClick action on the specified side
-- @param side to perform the leftClick action
-- @tparam string
-- @return true, or false[, string]
function baseLib.leftClick(side)
  return robot.swing(sidesLib.getSideVal(side))
end

--- rightClick performs a rightClick action on the specified side
-- @param side to perform the rightClick action
-- @tparam string
-- @param sneaky performs rightClick while shifting
-- @tparam boolean
-- @param duration to perform the rightClick action
-- @tparam number
-- @return true, or false[, string]
function baseLib.rightClick(side, ...) -- sneaky, duration
  return robot.use(sidesLib.getSideVal(side, ...))
end

--- placeBlock places a block from the current slot on the specified side
-- @param side to place the block
-- @tparam string
-- @param sneaky performs placeBlock while shifting
-- @tparam boolean
-- @return true, or false[, string]
function baseLib.placeBlock(side, ...) -- sneaky
  return robot.place(sidesLib.getSideVal(side, ...))
end

--- getLightColor gets the current color of the device's light
-- @return integer encoded RGB value (0xRRGGBB)
function baseLib.getLightColor()
  return robot.getLightColor()
end

--- setLightColor sets the color of the device's light
-- @param color is an integer enconded RGB value (0xRRGGBB)
-- @return true, or false
function baseLib.setLightColor(color)
  return robot.setLightColor(color)
end

--- isObstructed checks whether there is an obstruction (block) on the
---specified side
-- @param side to be checked
-- @tparam string
-- @return true, or false[, string]
function baseLib.isObstructed(side)
  return robot.detect(sidesLib.getSideVal(side))
end

return baseLib
