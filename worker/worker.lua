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
  base    = baseLib.handleBaseInstruct,
  ctrl    = ctrlLib.handleCtrlInstruct,
  debug   = debugLib.handleDebugInstruct,
  extInv  = extInvLib.handleExtInvInstruct,
  extTank = extTankLib.handleExtTankInstruct,
  intInv  = intInvLib.handleIntInvInstruct,
  intTank = intTankLib.handleIntTankInstruct}

--- handleInstruct executes the specified instruct
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
local function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], {instructArgs})
end

--- main
local function main()
  while true do
    print('Running Worker program\nawaiting instruction from Master')
    local instructStr = commsLib.getMasterData()
    print('recieved instruction: ' .. instructStr)
    os.sleep(0.5)
    print('commencing execution of instruct in 3 seconds')
    os.sleep(3)
    local instructRtnList = {handleInstruct(instructStr)}
    commsLib.sendMasterData('rtn:' .. table.concat(instructRtnList, ':'))
  end
end

main()
