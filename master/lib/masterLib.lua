--- provides a Master-Worker feedback loop
-- @module masterLib
local masterLib = {}

--- Dependencies
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local logLib = require('logLib')
local utilsLib = require('utilsLib')

_ENV = masterLib

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  ctrl  = ctrlLib}

--- handleInstruct executes the specified instruct
-- @param instructStr
-- @tparam string
-- @return relative returns
local function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgs)
end

--- excecuteInstruct logs and executes a specified Worker instruct
-- @param instructEnv the environment the specified instruct is issued
-- @tparam string
-- @param instructStr the specified instruct to be executed
-- @tparam string
function masterLib.executeInstruct(instructEnv, instructStr)
  print('Sending instruct: ' .. instructStr)
  logLib.writeLog(instructEnv, logLib.fmtCallCmdLogMsg(instructStr))
  commsLib.sendWorkerData(instructStr)
  workerRtn = commsLib.getWorkerData()
  print('Instruct returned: ' .. workerRtn)
  if string.match(workerRtn, '(.-):') == 'rtn' then
    _, workerRtns = utilsLib.splitStrAtColon(workerRtn)
    logLib.writeLog(instructEnv,
      logLib.fmtCmdRtnsLogMsg(instructStr, workerRtns))
  else
    handleInstruct(workerRtn)
  end
end

return masterLib
