--- provides some operating functionality
-- @module ctrlLib
local ctrlLib = {}
_ENV = ctrlLib

--- Dependencies
local utilsLib = require('utilsLib')

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

--- halt throws an error to try and terminate the current coroutine
function ctrlLib.halt()
  os.exit()
end

return ctrlLib
