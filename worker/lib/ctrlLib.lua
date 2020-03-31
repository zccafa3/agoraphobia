--- provides some operating functionality
-- @module ctrlLib
local ctrlLib = {}

--- Dependencies
local utilsLib = require('utilsLib')

_ENV = ctrlLib

--- halt throws an error to try and terminate the current coroutine
local function halt()
  os.exit()
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
