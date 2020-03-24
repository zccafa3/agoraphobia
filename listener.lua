local component = require('component')
local event = require('event')

local tunnel = component.tunnel

function _getUserCommand()
  return io.stdin:read()
end

function _sendDataToWorker(data)
  return tunnel.send(data)
end

function _recieveDataFromWorker()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

while true do
  userCommand = _getUserCommand()
  _sendDataToWorker(userCommand)
  workerResponse = _recieveDataFromWorker()
  print('Worker Response to User Command: ' .. userCommand .. ' was; ' .. workerResponse)
end
