local component=require('component')
local robot=require('robot')
local sides=require('sides')
local event=require('event')

local tunnel=component.tunnel

-- query user for location on startup
-- track location (master)
-- send command success/fail and data to master
-- detect block (safe to move)
-- query block known to whitelisted database (safe to mine)
-- send master block data (if unknown)
-- harvest block with appropriate tool
-- collect liquid and input to barrel
-- track blocks mined (master)

function _valueInDict(value,dict)
  for k,v in pairs(dict) do
    if value==k then
      return true
    end
  end
  return false
end

function _splitStringAtChar(string,char)
  if string.match(string,char)==nil then
    return nil
  else
    return string.match(string,'([^'..char..']+)'..char..'([^,]+)')
  end
end

function _handleCommand(recievedData)
  local knownCommands={
    halt=_halt,
    use=_use,
    dig=_dig,
    detect=_detect,
    analyze=_analyze,
    move=_moveInDirection,
    movepath=_moveInPath
  }
  command,remaining=_splitStringAtChar(recievedData,':')
  if _valueInDict(command,knownCommands) then
    knownCommands[command](remaining)
  end
end

function _halt()
  os.exit()
end

function _moveInDirection(direction)
  local knownDirections={
    u=robot.up,
    d=robot.down,
    f=robot.forward,
    b=robot.back,
    l=robot.turnLeft,
    r=robot.turnRight
  }
  if _valueInDict(direction,knownDirections) then
    knownDirections[direction]()
  end
end

function _moveInPath(path)
  for step in string.gmatch(path, '%d*%a') do
    quantity=string.match(step, '%d+') or 1
    direction=string.sub(step,-1)
    for i=1,quantity do
      moveInDirection[direction]()
    end
  end
end

while true do
  _,_,_,_,_,recievedData=event.pull('modem_message')
  _handleCommand(recievedData)
end
