--- Provides functionality for logging methods
-- @module logLib
local logLib = {}

--- Dependencies
local filesystem = require('filesystem')

local utilsLib = require('utilsLib')

_ENV = logLib

--- Variables
local maxLogMsgWidth = 80
local tabWidth = 2

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

--- fmtLogMsg formats a log message to include line breaks and tabs
-- @param logStr unformatted log message
-- @tparam string
-- @return formatted log message
local function fmtLogMsg(logStr)
  local logMsg = ''
  if #logStr < maxLogMsgWidth then
    logMsg = logStr
  else
    local logBit, logRmdr = utilsLib.splitStrAtCharNum(logStr,
      maxLogMsgWidth - 1)
    logMsg = logBit .. '\n\t'
    if #logRmdr < maxLogMsgWidth - tabWidth then
      logMsg = logMsg .. logRmdr
    else
      while not #logRmdr < maxLogMsgWidth - tabWidth do
        local logBit, logRmdr = utilsLib.splitStrAtCharNum(logRmdr,
          maxLogMsgWidth - tabWidth - 1)
        logMsg = logMsg .. logBit .. '\n\t'
      end
    end
  end
  return logMsg
end

--- fmtCallCmdLogMsg constructs a formatted 'Calling Command' log message
-- @param instructStr containing the called command
-- @tparam string
-- @return formatted calling command log message
function logLib.fmtCallCmdLogMsg(instructStr)
  local instructLib, instructAndArgs = utilsLib.splitStrAtColon(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructAndArgs)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  local datetime = os.date()
  local logMsg = string.format('[%s] Calling Command; Worker, %s: %s(',
    datetime, instructLib, instruct)
  for i, arg in ipairs(instructArgList) do
    if i < #instructArgList then
      logMsg = logMsg .. string.format('%s, ', arg)
    else
      logMsg = logMsg .. string.format('%s)', arg)
    end
  end
  return fmtLogMsg(logMsg)
end

--- fmtCmdRtnMsg constructs a formatted 'Command Returns' log message
-- @param instructStr containing the called command
-- @tparam string
-- @param instructRtns containing the command returns
-- @tparam table
-- @return formatted command returns log message
function logLib.fmtCmdRtnLogMsg(instructStr, instructRtns)
  local instructLib, instructAndArgs = utilsLib.splitStrAtColon(instructStr)
  local instruct, _ = utilsLib.splitStrAtColon(instructAndArgs)
  local instructRtnList = utilsLib.multiSplitStrAtColon(instructRtns)
  local datetime = os.date()
  local logMsg = string.format('[%s] Command Returns; Worker, %s, %s: ',
    datetime, instructLib, instruct)
  for i, rtn in ipairs(instructRtnList) do
    if i < #instructRtnList then
      logMsg = logMsg .. string.format('%s, ', rtn)
    else
      logMsg = logMsg .. string.format('%s', rtn)
    end
  end
  return fmtLogMsg(logMsg)
end

--- writeLog writes the specified message to the specified log file
-- @param logFile file (name) to log message
-- @tparam string
-- @param logMsg message to log
-- @tparam string
-- @return true, or false
function logLib.writeLog(logFile, logMsg)
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

return logLib
