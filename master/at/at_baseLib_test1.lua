--- Automated Test Environment
local envType = 'at'
local atEnv = 'at_baseLib'

--- Dependencies
local commsLib = require('commsLib')
local ctrlLib = require('ctrlLib')
local logLib = require('logLib')
local masterLib = require('masterLib')

local io = io
local os = os
local print = print
local string = string

--- Physical Test Dependencies

--- Automated Test Variables
local testOrderList = {
  'Test 0: ',
  'Test 1: get name of Worker device',
  'Test 2: get color of device light',
  'Test 3: set color of device light',
  'Test 4: get durability of equipped tool',
  'Test 5a: move device forward',
  'Test 5b: move decice up',
  'Test 5c: move device back',
  'Test 5d: move device down',
  'Test 6a: turn device to the left',
  'Test 6b: turn device to the right',
  'Test 7a: move forward, place block front',
  'Test 7b: place a block right',
  'Test 7c: place a block back',
  'Test 7d: place a block left',
  'Test 7e: move up, place block down',
  'Test 7f: place block up',
  'Test 7g: move forward (x4), place block front',
  'Test 7h: place a block right',
  'Test 7i: place a block back',
  'Test 7j: place a block left',
  'Test 7k: move down, move forward (x3), place block up',
  'Test 7l: move forward (x2), move up (x2), place block down'}

local testInstructList = {
  'debug:insertItemToInv:',
  'base:getName',
  'base:getLightColor',
  'base:setLightColor:0xFFFFFF',
  'base:getToolDurability',
  'base:move:f',
  'base:move:u',
  'base:move:b',
  'base:move:d',
  'base:turn:l',
  'base:turn:r',
  'base:move:f;base:placeBlock:f',
  'base:placeBlock:r',
  'base:placeBlock:b',
  'base:placeBlock:l',
  'base:move:u;base:placeBlock:d',
  'base:placeBlock:u',
  'base:move:f;base:move:f;base:move:f;base:move:f;base:placeBlock:f',
  'base:placeBlock:r',
  'base:placeBlock:b',
  'base:placeBlock:l',
  'base:move:d;base:move:f;base:move:f;base:move:f;base:placeBlock:u',
  'base:move:f;base:move:f;base:move:u;base:move:u;base:placeBlock:d'}

local testMaterialDict = {
  ['minecraft:stone'] = 12} 

---
--
local function getUserApproval()
  local userApproval = ''
  while not utilsLib.checkStrInTab(userApproval, {'y', 'yes', 'n', 'no'}) do
    print('Input: was the test successful (y)es/(n)o')
    userApproval = io.read()
    if utilsLib.checkStrInTab(userApproval, {'y', 'yes'}) then
      return true
    elseif utilsLib.checkStrInTab(userApproval, {'n', 'no'}) then
      return false
    else
      print(userApproval .. 'not a valid response')
    end
  end
end

--- main
local function main(testDesc, instructStr)
  local datetime = os.date()
  local date = string.sub(datetime, 1, 8) 
  logLib.writeLog(envType, atEnv, '[' .. date .. '] ' .. testDesc .. '\n')
  masterLib.executeInstruct(envType, atEnv, instructStr)
end

for testIndex, testDesc in ipairs(testOrderTab) do
  main(testDesc, testInstructTab[testIndex])
  if getUserApproval() then
    logLib.writeLog(envType, atEnv, 'Success')
  else
    logLib.writeLog(envType, atEnv, 'Failed')
    commsLib.sendWorkerData('ctrl:halt:true')
    ctrlLib.handleCtrlInstruct('halt:true')
  end
end
