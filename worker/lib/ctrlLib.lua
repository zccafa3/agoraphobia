--- provides some operating functionality
-- @module ctrlLib
local ctrlLib = {}

--- Dependencies
local computer = require('computer')

local commsLib = require('commsLib')
local utilsLib = require('utilsLib')

local os = os

_ENV = ctrlLib

--- halt throws an error to try and terminate the current coroutine
-- @param restart whether to restart the device after the halt
-- @tparam string
local function halt(restart)
  if restart then
    commsLib.sendMasterData('cmd:ctrl:halt:true')
    computer.shutdown(restart)
  else
    commsLib.sendMasterData('cmd:ctrl:halt')
    os.exit()
  end
end

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  halt = halt}

--- handleCtrlInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction to be executed
-- @tparam string
-- @return relative returns
function ctrlLib.handleCtrlInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return ctrlLib
