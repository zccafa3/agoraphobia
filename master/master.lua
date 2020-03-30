local component = require('component')
local event = require('event')

local tunnel = component.tunnel

function sendWorkerData(data)
  return tunnel.send(data)
end

function recieveWorkerData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

function getUserInstruct()
  return io.stdin:read()
end

while true do
  print('master program running\nawaiting user instruction')
  userInstruct = getUserInstruct()
  print('recieved user instruction: '..userInstruct)
  print('commencing execution of instruct in 3 seconds')
  os.sleep(3)
  sendWorkerData(userInstruct)
  workerReturns = recieveWorkerData()
  print('worker returned: '..workerReturns)
end
