--- Provide functionality for Master-Worker communication methods
-- @module commsLib
local  commsLib = {}

--- Dependencies
local conmponent = require('component')
local event = require('event')

local utilsLib = require('utilsLib')

local tunnel = component.tunnel

_ENV = commsLib

--- getWorkerData gets data sent from the Worker device
-- @return recieved data
function commsLib.getWorkerData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

--- sendWorkerData sends data to the Worker device
-- @param data to send
-- @tparam string
-- @return true, or false
function commsLib.sendWorkerData(data)
  return tunnel.send(data)
end

return commsLib
