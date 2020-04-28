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
local testReqsStr = 'debug:insertItemToInv'

local testDictList = {
{
  ['id']    = '0',
  ['desc']  = 'get test requirements',
  ['cmd']   = testReqsStr,
  ['rtn']   = 'true'},
{
  ['id']    = '1',
  ['desc']  = 'get name of Worker device',
  ['cmd']   = 'base:getName',
  ['rtn']   = 'doggo'},
{
  ['id']    = '2',
  ['desc']  = 'get color of device light',
  ['cmd']   = 'base:getLightColor',
  ['rtn']   = '0xFFFFFF'},
{
  ['id']    = '3',
  ['desc']  = 'set color of device light',
  ['cmd']   = 'base:setLightColor:0xFFFFFF',
  ['trn']   = '16777215.0'},
{
  ['id']    = '4',
  ['desc']  = 'get durability of equipped tool',
  ['cmd']   = 'base:getToolDurability',
  ['rtn']   = ''},
{
  ['id']    = '5.1',
  ['desc']  = 'turn device to the left',
  ['cmd']   = 'base:turn:l',
  ['rtn']   = 'true'},
{
  ['id']    = '5.2',
  ['desc']  = 'turn device to the right',
  ['cmd']   = 'base:turn:r',
  ['rtn']   = 'true'},
{
  ['id']    = '6.1',
  ['desc']  = 'move device forward',
  ['cmd']   = 'base:move:f',
  ['rtn']   = 'true'},
{
  ['id']    = '6.2',
  ['desc']  = 'move device up',
  ['cmd']   = 'base:move:u',
  ['rtn']   = 'true'},
{
  ['id']    = '6.3',
  ['desc']  = 'move device back',
  ['cmd']   = 'base:move:b',
  ['rtn']   = 'true'},
{
  ['id']    = '6.4',
  ['desc']  = 'move device down',
  ['cmd']   = 'base:move:d',
  ['rtn']   = 'true'},
{
  ['id']    = '7.0.1',
  ['desc']  = 'prep for \'placeBlock\' test',
  ['cmd']   = 'base:move:f',
  ['rtn']   = 'true'},
{
  ['id']    = '7.1',
  ['desc']  = 'place block front',
  ['cmd']   = 'base:placeBlock:f',
  ['rtn']   = 'true'},
{
  ['id']    = '7.0.2',
  ['desc']  = 'setup for \'placeBlock\' test',
  ['cmd']   = 'base:turn:r;base:move:f;base:turn:l;2(base:placeBlock:f;base:move:u);base:placeBlock:f;base:move:b;base:placeBlock:f;base:move:l;base:move:f;base:move:r;base:move:d;base:move:f',
  ['rtn']   = 'true;true;true;true;true;true;true;true;true;true;true;true;true;true;true'},
{
  ['id']    = '7.2',
  ['desc']  = 'place block up',
  ['cmd']   = 'base:placeBlock:u',
  ['rtn']   = 'true'},
{
  ['id']    = '7.3',
  ['desc']  = 'place block down',
  ['cmd']   = 'base:placeBlock:d',
  ['rtn']   = 'true'},
{
  ['id']    = '8.1',
  ['desc']  = 'harvest (left click) block front',
  ['cmd']   = 'base:leftClick:f',
  ['rtn']   = 'true'},
{
  ['id']    = '8.2',
  ['desc']  = 'harvest (left click) block up',
  ['cmd']   = 'base:leftClick:u',
  ['rtn']   = 'true'},
{
  ['id']    = '8.3',
  ['desc']  = 'harvest (left click) block down',
  ['cmd']   = 'base:leftClick:d',
  ['rtn']   = 'true'},
{
  ['id']    = '7.0.2',
  ['desc']  = 'clean-up for \'placeBlock\' test',
  ['cmd']   = 'base:move:b;base:move:u;base:tun:r;base:move:f;base:turn:l;base:leftClick:f;base:move:f;2(base:leftClick:f;base:move:d);base:leftClick:f;base:turn:l;base:move:f;base:turn:r;base:leftClick:f',
  ['rtn']   = 'true;true;true;true;true;true;true;true;true;true;true;true;true;true;true;true'},
}

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
