--- Automated Test Environment
local atEnv = 'at_ctrlLib.lua'

--- Dependencies
local masterLib = require('masterLib')

--- main
local function main(instructStr)
  masterLib.executeInstruct(atEnv, instructStr)
end

test1 = 'ctrl:halt'
main(test1)
