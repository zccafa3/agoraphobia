--- Provides functionality for logging methods
-- @module logLib
local logLib = {}

--- Dependencies
local filesystem = require('filesystem')

local utilsLib = require('utilsLib')

local io      = io
local ipairs  = ipairs
local os      = os

_ENV = logLib

--- Variables
local maxLogMsgWidth = 80
local tabWidth = 2

--- checkLogDir checks the log file directory exists
-- @return true, or false
local function checkLogDir()
  return filesystem.exists('/home/log')
end

--- checkLogSubDir checks the log file sub directory exists
-- @param subDir sub directory to check
-- @tparam string
-- @return true, or false
local function checkLogSubDir(subDir)
  return filesystem.exists('/home/log/' .. subDir)
end

--- createLogDir creates the log file directory
-- @return true, or nil[, string]
local function createLogDir()
  return filesystem.makeDirectory('/home/log')
end

--- createLogSubDir creates the log file sub directory
-- @param subDir sub directory to create
-- @tparam string
-- @return true, or nill[, string]
local function createLogSubDir(subDir)
  return filesystem.makeDirectory('/home/log/' .. subDir)
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
  logMsg = logMsg .. '\n'
  return logMsg
end

--- fmtCallCmdLogMsg constructs a formatted 'Calling Command' log message
-- @param device the command is being issued
-- @tparam string
-- @param instructStr containing the called command
-- @tparam string
-- @return formatted calling command log message
function logLib.fmtCallCmdLogMsg(device, instructStr)
  local instructLib, instructAndArgs = utilsLib.splitStrAtColon(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructAndArgs)
  local instructArgList = utilsLib.multiSplitStrAtColon(instructArgs)
  local datetime = os.date()
  local logMsg = '[' .. datetime .. '] Calling Command; ' .. device .. 
    ', ' .. instructLib .. ': ' .. instruct .. '('
  for i, arg in ipairs(instructArgList) do
    if i < #instructArgList then
      logMsg = logMsg .. arg .. ', '
    else
      logMsg = logMsg .. arg
    end
  end
  logMsg = logMsg .. ')'
  return fmtLogMsg(logMsg)
end

--- fmtCmdRtnsMsg constructs a formatted 'Command Returns' log message
-- @param device the command is being issued
-- @tparam string
-- @param instructStr containing the called command
-- @tparam string
-- @param instructRtns containing the command returns
-- @tparam table
-- @return formatted command returns log message
function logLib.fmtCmdRtnsLogMsg(device, instructStr, instructRtns)
  local instructLib, instructAndArgs = utilsLib.splitStrAtColon(instructStr)
  local instruct, instructRtns = utilsLib.splitStrAtColon(instructAndArgs)
  local instructRtnList = utilsLib.multiSplitStrAtColon(instructRtns)
  local datetime = os.date()
  local logMsg = '[' .. datetime .. '] Command Returns; ' .. device ..
    ', ' .. instructLib .. ', ' .. instruct .. ': '
  for i, rtn in ipairs(instructRtnList) do
    if i < #instructRtnList then
      logMsg = logMsg .. rtn .. ', '
    else
      logMsg = logMsg .. rtn
    end
  end
  return fmtLogMsg(logMsg)
end

--- writeLog writes the specified message to the specified log file
-- @param logSubDir sub directory to store log file
-- @tparam string
-- @param logFile file (name) to log message
-- @tparam string
-- @param logMsg message to log
-- @tparam string
-- @return true, or false
function logLib.writeLog(logSubDir, logFile, logMsg)
  if not checkLogDir() then
    createLogDir()
  end
  if not checkLogSubDir(logSubDir) then
    createLogSubDir(logSubDir)
  end
  local file = io.open('/home/log/' .. logSubDir .. '/' .. logFile .. '.log',
    'a')
  if file == nil then
    return false
  end
  file:write(logMsg)
  file:close()
  return true
end

return logLib
