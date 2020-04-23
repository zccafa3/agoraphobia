--- Automated Test Environment
local envType = 'at'
local atEnv = 'at_ctrlLib'

--- Dependencies
local logLib = require('logLib')
local masterLib = require('masterLib')

local os = os
local string = string

--- main
local function main(instructStr)
  local datetime = os.date()
  local date = string.sub(datetime, 8) 
  logLib.writeLog(envType, atEnv, '[' .. date .. '] Test 2\n')
  masterLib.executeInstruct(envType, atEnv, instructStr)
end

test2 = 'ctrl:halt:true'
main(test2)
