local component = require('component')
local robot = require('robot')
local event = require('event')

local tunnel = component.tunnel

-- query user for location on startup
-- track location (master)
-- send command success/fail and data to master
-- detect block (safe to move)
-- query block known to whitelisted database (safe to mine)
-- send master block data (if unknown)
-- harvest block with appropriate tool
-- collect liquid and input to barrel
-- track blocks mined (master)


-- Helper Functions --
----------------------

function _checkValueInDict(value, dict)
  for k, v in pairs(dict) do
    if value == k then
      return true
    end
  end
  return false
end

function _splitStringAtChar(string, char)
  if string.match(string, char) == nil then
    return string, nil
  else
    return string.match(string, '([^' .. char .. ']+)' .. char .. '([^,]+)')
  end
end

function _checkSideIsValid(side)
  local knownSides = {
    u = 1,
    d = 0,
    f = 3,
    b = 2,
    l = 5,
    r = 4}
  if _checkValueInDict(side, knownSides) then
    return true
  else
    return false
  end
end

function _getSideValue(side)
  local knownSides = {
    u = 1,
    d = 0,
    f = 3,
    b = 2,
    l = 5,
    r = 4}
  return knownSides[side]
end

function _logError(message)
  print('ERR: ' .. message)
end

function _concatListValues(list)
  return table.concat(table, ':')
end

function _sendDataToMaster(data)
  return tunnel.send(data)
end

function _recieveDataFromMaster()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end


-- Command Handlers --
----------------------

function _handleCommand(recievedData)
  local knownHandlers = {
    control = _handleControlCommand,
    base = _handleBaseCommand}
  local handler, remainder = _splitStringAtChar(recievedData, ':')
  if _checkValueInDict(handler, knownHandlers) then
    return knownHandlers[handler](remainder)
  else
    _logError('unknown handler, ' .. handler)
  end
end

function _handleControlCommand(recievedData)
  local knownControlCommands = {
    halt = _halt}
  local controlCommand, remainder = _splitStringAtChar(recievedData, ':')
  if _checkValueInDict(controlCommand, knownControlCommands) then
    return knownControlCommands[controlCommand](remainder)
  else
    _logError('unknown control command, ' .. controlCommand)
  end
end

function _handleBaseCommand(recievedData)
  local knownBaseCommands = {
    durability = _getToolDurability,
    move = _move,
    turn = _turn,
    name = _name,
    leftClick = _leftClick,
    rightClick = _rightClick,
    place = _place,
    getLightColor = _getLightColor,
    setLightColor = _setLightColor}
  local baseCommand, remainder = _splitStringAtChar(recievedData, ':')
  if _checkValueInDict(baseCommand, knownBaseCommands) then
    return knownBaseCommands[baseCommand](remainder)
  else
    _logError('unknown base command, ' .. baseCommand)
  end
end


-- Control Methods --
---------------------

function _halt()
  os.exit()
  print('this executed')
end


-- Base Methods --
------------------

function _getToolDurability()
  return robot.durability()
end

function _move(direction)
  local knownDirections={
    u = robot.up,
    d = robot.down,
    f = robot.forward,
    b = robot.back}
  if _checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  end
end

function _turn(direction)
  local knownDirections={
    l = robot.turnLeft,
    r = robot.turnRight}
  if _checkValueInDict(direction, knownDirections) then
    return knownDirections[direction]()
  end
end

function _name()
  return robot.name()
end

function _leftClick(side)
  if _checkSideIsValid(side) then
    return robot.swing(_getSideValue(side))
  end
end

function _rightClick(side, sneaky, duration)
  if _checkSideIsValid(side) then
    return robot.use(_getSideValue(side), sneaky, duration)
  end
end

function _place(side, sneaky)
  if _checkSideIsValid(side) then
    return robot.place(_getSideValue(side), sneaky)
  end
end

function _getLightColor()
  return robot.getLightColor()
end

function _setLightColor(value)
  -- ToDo: is value integer encoded RGB value (0xRRGGBB)
  return robot.setLightColor(value)
end


-- Internal Inventory Methods --
--------------------------------

function _getInventorySize()
  -- returns size of the device's internal inventoy
  return robot.inventorySize()
end

function _getInventorySlot()
  -- returns currently selected slot
  return robot.select()
end

function _selectInventorySlot(slot)
  -- Sets the slot if valid, otherwise returns false
  if slot <= _getInventorySize() then
    return robot.select(slot)
  else
    return false
  end
end

-- function _getNumItemsInSlot(slot)
  -- returns number of items in specified slot, otherwise selected slot


-- Custom Methods

function _moveInPath(path)
  for step in string.gmatch(path, '%d*%a') do
    quantity = string.match(step, '%d+') or 1
    direction = string.sub(step, -1)
    for i = 1, quantity do
      _moveInDirection[direction]()
    end
  end
end

while true do
  print('running\nawaiting command')
  recievedData = _recieveDataFromMaster()
  print('recieved command: ' .. recievedData .. '\ncomencing execution of command in 3s')
  os.sleep(3)
  commandReturns = {_handleCommand(recievedData)}
  if commandReturns[1] == true then
    _sendDataToMaster(true)
  else
    _sendDataToMaster(_concatListValues(commandReturns))
  end
end
