local component=require('component')
local robot=require('robot')
local event=require('event')

local tunnel=component.tunnel

function _valueInDict(value,dict)
  for k,v in pairs(dict) do
    if value==k then
      return true
    end
  end
  return false
end

function _splitStringAtChar(string,char)
  if not string.match(data,char)==nil then
    a,b=string.match(data,'([^'..char..']+)'..char..'([^,]+)')
    return a,b
  else
    return nil
end

function _handleCommand(recievedData)
  local knownCommands={
    halt=_halt,
    move=_move
  }
  command,remaining=_splitStringAtChar(recievedData,':')
  if not command==nil and _valueInDict(command,knownCommands) then
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

while true do
  _,_,_,_,_,recievedData=event.pull('modem_message')
  _handleCommand(recievedData)
end
