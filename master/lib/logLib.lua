--- Provides functionality for logging methods
-- @module logLib
local logLib = {}

--- Dependencies
local filesystem = require('filesystem')

local utilsLib = require('utilsLib')

_ENV = logLib

--- checkLogDir checks the log file directory exists
-- @return true, or false
local function checkLogDir()
  return filesystem.exists('/home/log')
end

--- createLogDir creates the log file directory
-- @return true, or nil[, string]
local function createLogDir()
  return filesystem.makeDirectory('/home/log')
end

--- writeLog writes the specified message to the specified log file
-- @param logFile file (name) to log message
-- @tparam string
-- @param logMsg message to log
-- @tparam string
-- @return true, or false
local function writeLog(logFile, logMsg)
  if not checkLogDir() then
    createLogDir()
  end
  local file = io.open('/home/log/' .. logFile, 'a')
  if file == nil then
    return false
  end
  file:write(logMsg)
  file:close()
  return true
end

--- Table of log Instructs
-- @table knownInstructs
local knownInstructs = {
  writeLog = writeLog}

--- handleLogInstruct executes the specified instruct with the appropriate
---number of arguements
-- @param instructStr instruction ti be executed
-- @tparam string
-- @return relative returns
function logLib.handleLogInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgList)
end

return logLib
