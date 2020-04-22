--- Provide functionality for Worker-Master communication methods
-- @module commsLib
local  commsLib = {}

--- Dependencies
local component = require('component')
local event = require('event')

local utilsLib = require('utilsLib')

local tunnel = component.tunnel

_ENV = commsLib

--- getMasterData gets data sent from the Master device
-- @return recieved data
function commsLib.getMasterData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

--- sendMasterData sends data to the Master device
-- @param data to send
-- @tparam string
-- @return true, or false
function commsLib.sendMasterData(data)
  return tunnel.send(data)
end

return commsLib
