--- Dependencies
local baseLib = require('baseLib')
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local debugLib = require('debugLib')
local extInvLib = require('extInvLib')
local extTankLib = require('extTankLib')
local intInvLib = require('intInvLib')
local intTankLib = require('intTankLib')
local utilsLib = require('utilsLib')

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  base    = baseLib,
  ctrl    = ctrlLib,
  debug   = debugLib,
  extInv  = extInvLib,
  extTank = extTankLib,
  intInv  = intInvLib,
  intTank = intTankLib}

--- handleInstruct executes the specified instruct
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
local function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgs)
end

--- main
local function main()
  while true do
    print('Running Worker program\nawaiting instruction from Master')
    instructStr = commsLib.getMasterData()
    print('recieved instruction: ' .. instructStr)
    os.sleep(0.5)
    print('commencing execution of instruct in 3 seconds')
    os.sleep(3)
    instructReturns = {handleInstruct(instructStr)}
    commsLib.sendMasterData('rtn:' .. table.concat(instructReturns, ':'))
  end
end

main()
