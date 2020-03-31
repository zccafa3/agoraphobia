--- provides a few helpful functions
-- @module utilsLib
local utilsLib = {}

local string = string
local table = table

_ENV = utilsLib

--- checkColonInStr checks if there is a ':' in string
-- @param string to be checked
-- @tparam string
-- @return true, or false
function utilsLib.checkColonInStr(string)
  return string.match(string, ':') ~= nil
end

--- splitStrAtColon splits a string at ':' (excluded)
-- @param string to be split
-- @tparam string
-- @return string before ':', or string
-- @return string after ':', or nil
function utilsLib.splitStrAtColon(string)
  if checkColonInStr(string) then
    return string.match(string, '(.-):(.*)')
  else
    return string, nil
  end
end

--- multiSplitStrAtColon splits a string at each ':' (excluded)
-- @param string to be split
-- @tparam string
-- @return table of string splits, or string
function utilsLib.multiSplitStrAtColon(string)
  local stringList = {}
  if utilsLib.checkColonInStr(string) then
    for str in string.gmatch(string, '[^:]+') do
      table.insert(stringList, str)
    end
  else
    table.insert(stringList, string)
  end
  return stringList
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
  if #argList == 1 then
    return f(argList[1])
  elseif #argList == 2 then
    return f(argList[1], argList[2])
  elseif #argList == 3 then
    return f(argList[1], argList[2], argList[3])
  else
    -- todo: handle more arguements (if required)
  end
end

return utilsLib
