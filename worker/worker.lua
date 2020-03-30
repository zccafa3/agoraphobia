local event = require('event')
local tunnel = require('tunnel')

local utilsLib = require('utilsLib')
local ctrlLib = require('ctrlLib')
local baseLib = require('baseLib')
local intInvLib = require('intInvLib')
local intTankLib = require('intTankLib')
local extInvLib = require('extInvLib')
local extTankLib = require('extTankLib')

local knownInstructs = {
  ctrl = ctrlLib,
  base = baseLib,
  intInv = intInvLib,
  intTank = intTankLib,
  extInv = extInvLib,
  extTank = extInvLib}

function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgs)
end

function getMasterData()
  local _, _, _, _, _, recievedData = event.pull('modem_message')
  return recievedData
end

function sendMasterData(data)
  return tunnel.send(data)
end

while true do
  print('worker program running\nawaiting instruction')
  recievedData = getMasterData()
  print('recieved instruction: '..recievedData)
  print('commencing execution of instruction in 3 seconds')
  os.sleep(3)
  instructReturns = {handleInstruct(recievedData)}
  sendMasterData(table.concat(instructReturns))
end
