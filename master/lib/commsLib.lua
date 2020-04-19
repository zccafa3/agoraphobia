--- Provide functionality for Master-Worker communication methods
-- @module commsLib
local  commsLib = {}

--- Dependencies
local conmponent = require('component')

local utilsLib = require('utilsLib')

local event = component.event
local tunnel = component.tunnel

_ENV = commsLib

--- getWorkerData gets data sent from the Worker device
-- @return recieved data
local function getWorkerData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

--- sendWorkerData sends data to the Worker device
-- @param data to send
-- @tparam string
-- @return true, or false
local function sendWorkerData(data)
  return tunnel.send(data)
end

--- Table of communication instructs
-- @table knownInsrructs
local knownInstructs = {
  getWorkerData   = getWorkerData,
  sendWorkerData  = sendWorkerData}

--- handleCommsInstructs executed the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function commsLib.handleCommsInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return commsLib
