--- provides a few helpful functions
-- @module utilsLib
local utilsLib = {}

local ipairs = ipairs
local string = string
local table = table
local tonumber = tonumber
local tostring = tostring
local type = type

_ENV = utilsLib

--- checkStrIsBool checks if the specified string is a boolean
-- @param str string to be checked
-- @tparam string
-- @return true, or false
local function checkStrIsBool(str)
  return str == 'true' or str == 'false'
end

--- checkStrIsNum checks in the specified string is a number
-- @param str string to be checked
-- @tparam string
-- @return true, or false
local function checkStrIsNum(str)
  return tonumber(str) ~= nil
end

--- checkCharInStr checks if the specified character in string
-- @param char character to check
-- @tparam string
-- @param str string to be checked
-- @tparam string
-- @return true, or false
local function checkCharInStr(char, str)
  return string.match(str, char) ~= nil
end

--- checkStrInTab checks if string in table
-- @param str string to check
-- @tparam string
-- @param tab to be checked
-- @tparam table
-- @return true, or false
function utilsLib.checkStrInTab(str, tab)
  for _, val in ipairs(tab) do
    if val == str then
      return true
    end
  end
  return false
end

--- splitStrAtChar splits the string at the specified character (excluded)
-- @param char character to split the string at (exluded)
-- @tparam str
-- @param str string to be split
-- @tparam string
-- @return string before the specified character, or string
-- @return string after the specified character, or nil
local function splitStrAtChar(char, str)
  if checkCharInStr(char, str) then
    return string.match(str, '(.-)' .. char .. '(.*)')
  else
    return str, nil
  end
end

--- splitStrAtColon splits a string at ':' (excluded)
-- @param str string to be split
-- @tparam string
-- @return string before ':', or string
-- @return string after ':', or nil
function utilsLib.splitStrAtColon(str)
  return splitStrAtChar(':', str)
end

--- splitStrAtCharNum splits a string at the specified character number
-- @param str string to be split
-- @tparam string
-- @param num character number for string to be split
-- @tparam number
-- @return string before specified charNum
-- @return string after specified charNum
function utilsLib.splitStrAtCharNum(str, num)
  return string.match(str, '(.-' .. string.rep('.', num) .. ')(.*)')
end

--- multiSplitStrAtChar splits the string at each specified character
---(excluded)
-- @param char character to split the string at (excluded)
-- @tparam string
-- @param str string to be split
-- @tparam string
-- @return table of string splits, or table of string, or empty table
local function multiSplitStrAtChar(char, str)
  local strList = {}
  if type(str) == 'string' and checkCharInStr(char, str) then
    for val in string.gmatch(str, '[^' .. char .. ']+') do
      table.insert(strList, val)
    end
  elseif type(str) == 'string' then
    table.insert(strList, str)
  end
  return strList
end

--- multiSplitStrAtColon splits a string at each ':' (excluded)
-- @param str string to be split
-- @tparam string
-- @return table of string splits, or table of string, or empty table
function utilsLib.multiSplitStrAtColon(str)
  return multiSplitStrAtChar(':', str)
end

--- multiSplitStrAtSemiColon splits a string at each ';' (excluded)
-- @param str string to be split
-- @tparam string
-- @return table of string splits, or table of string, or empty table
function utilsLib.multiSplitStrAtSemiColon(str)
  return multiSplitStrAtChar(';', str)
end

--- fmtTabVals formats a table of strings to their respective value types
-- @param tab table of strings to format
-- @tparam table
-- @return table of strings
local function fmtTabVals(tab)
  local valTab = {}
  for _, str in ipairs(tab) do
    if checkStrIsBool(str) then
      if str == 'true' then
        table.insert(valTab, true)
      else
        table.insert(valTab, false)
      end
    elseif checkStrIsNum(str) then
      table.insert(valTab, tonumber(str))
    else
      table.insert(valTab, str)
    end
  end
  return valTab
end

--- fmtTabAsStr formats a table of value types to a string seperated by ':'
-- @param tab table of values to format
-- @tparam table
-- @return string
function utilsLib.fmtTabAsStr(tab)
  local str = ''
  for i, val in ipairs(tab) do
    str = str .. tostring(val)
    if i ~= #tab then
      str = str .. ':'
    end
  end
  return str
end

--- runFuncWithArgs executes the specified function with appropriate number of
---arguements
-- @param f function to be executed
-- @tparam function
-- @param argList table of arguements to be passed
-- @tparam table
-- @return relative returns
-- @todo handle more arguements (if required)
function utilsLib.runFuncWithArgs(f, argList)
  local argList = fmtTabVals(argList)
  if #argList == 0 then
    return f()
  elseif #argList == 1 then
    return f(argList[1])
  elseif #argList == 2 then
    return f(argList[1], argList[2])
  elseif #argList == 3 then
    return f(argList[1], argList[2], argList[3])
  elseif #argList == 4 then
    return f(argList[1], argList[2], argList[3], argList[4])
  elseif #argList == 5 then
    return f(argList[1], argList[2], argList[3], argList[4], argList[5])
  elseif #argList == 6 then
    return f(argList[1], argList[2], argList[3], argList[4], argList[5],
      argList[6])
  elseif #argList == 7 then
    return f(argList[1], argList[2], argList[3], argList[4], argList[5],
      argList[6], argList[7])
  elseif #argList == 6 then
    return f(argList[1], argList[2], argList[3], argList[4], argList[5],
      argList[6], argList[7], argList[8])
  else
    -- todo: handle more arguements (if required)
  end
end

return utilsLib
