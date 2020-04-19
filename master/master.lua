--- Dependencies
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local logLib = require('logLib')
local utilsLib = require('utilsLib')

--- getUserInstruct gets instruct to send to Worker from User
-- @return User instruct
local function getUserInstruct()
  return io.stdin:read()
end

--- Table of known instructs
-- @table knownInstructs
local knownInstructs = {
  ctrl  = ctrlLib}

--- handleInstruct executed the specified instruct
-- @param instructStr
-- @tparam string
-- @return relative returns
local function handleInstruct(instructStr)
  local instruct, instructArgs = utilsLib.splitStrAtColon(instructStr)
  return utilsLib.runFuncWithArgs(knownInstructs[instruct], instructArgs)
end

--- main
local function main()
  print('Running Master program')
  while true do
    print('awaiting instruction for Worker')
    instructStr = getUserInstruct()
    print('recieved instruction: ' .. instructStr)
    os.sleep(0.5)
    print('commencing execution of instruct in 3 seconds')
    os.sleep(3)
    commsLib.sendWorkerData(instructStr)
    workerReturns = commsLib.getWorkerData()
    print('worker returned: ' .. workerReturns)
  end
end

main()
