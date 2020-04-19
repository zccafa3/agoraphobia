--- Dependencies
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local logLib = require('logLib')
local utilsLib = require('utilsLib')

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

--- excecuteInstruct
function masterLib.executeInstruct(instructEnv, instructStr)
  logLib.writeLog(instructEnv, logLib.fmtCallCmdLogMsg(instructStr))
  print('Sending instruct: ' .. instructStr)
  commsLib.sendWorkerData(instructStr)
  workerRtn = commsLib.getWorkerData()
  print('Instruct returned: ' .. workerRtn)
  if string.match(workerRtn, '(.-):') == 'rtn' then
    logLib.writeLog(instructEnv,
      logLib.fmtCmdRtnsLogMsg(instructStr, workerRtn))
  else
    handleInstruct(workerRtn)
  end
end
