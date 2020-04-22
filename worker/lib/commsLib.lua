--- Provide functionality for Worker-Master communication methods
-- @module commsLib
local  commsLib = {}

--- Dependencies
local component = require('component')
local event = require('event')

local utilsLib = require('utilsLib')

local event = component.event
local tunnel = component.tunnel

_ENV = commsLib

--- getMasterData gets data sent from the Master device
-- @return recieved data
local function getMasterData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

--- sendMasterData sends data to the Master device
-- @param data to send
-- @tparam string
-- @return true, or false
local function sendMasterData(data)
  return tunnel.send(data)
end

--- Table of communication instructs
-- @table knownInsrructs
local knownInstructs = {
  getMasterData   = getMasterData,
  sendMasterData  = sendMasterData}

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
