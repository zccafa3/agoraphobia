--- provides a Master-Worker feedback loop
-- @module masterLib
local masterLib = {}

--- Dependencies
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local logLib = require('logLib')
local utilsLib = require('utilsLib')

local print = print

_ENV = masterLib

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  ctrl = ctrlLib.handleCtrlInstruct}

--- handleInstruct executes the specified instruct
-- @param instructStr
-- @tparam string
-- @return relative returns
local function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], {instructArgs})
end

--- excecuteInstruct logs and executes a specified Worker instruct
-- @param instructEnv the environment the specified instruct is issued
-- @tparam string
-- @param instructStr the specified instruct to be executed
-- @tparam string
function masterLib.executeInstruct(instructEnvType, instructEnv, instructStr)
  print('Sending instruct: ' .. instructStr)
  logLib.writeLog(instructEnvType, instructEnv,
    logLib.fmtCallCmdLogMsg('Worker', instructStr))
  commsLib.sendWorkerData(instructStr)
  local workerRtn = commsLib.getWorkerData()
  print('Instruct returned: ' .. workerRtn)
  local workerRtnType, workerRtns = utilsLib.splitStrAtColon(workerRtn)
  if workerRtnType == 'rtn' then
    logLib.writeLog(instructEnvType, instructEnv,
      logLib.fmtCmdRtnsLogMsg('Worker', instructStr, workerRtns) .. '\n')
  elseif workerRtnType == 'cmd' then
    logLib.writeLog(instructEnvType, instructEnv,
      logLib.fmtCallCmdLogMsg('Master', workerRtns) .. '\n')
    handleInstruct(workerRtns)
  end
end

return masterLib
