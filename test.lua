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

function _handleCommand(command)
	local knownCommands={
		halt=_halt,
		move=_move}
	if _valueInDict(command,knownCommands) then
		knownCommands[command]()
	end
end

function _halt()
	os.exit
end

function _moveInDirection(direction)
	local knownMovements={
		f=robot.forward,
		b=robot.back,
		u=robot.up,
		d=robot.down,
		l=robot.turnLeft,
		r=robot.turnRight}
	if _valueInDict(direction,knownMovements) then
		knownMovements[direction]()
	end
end

while true do
	_,_,_,_,_,revievedData=event.pull('modem_message')
	_handleCommand(recievedData)
