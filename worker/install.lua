local component = require('component')
local filesystem = require('filesystem')
local serialization = require('serialization')
local term = require('term')

local githubUserUrl = 'https://raw.githubusercontent.com/zccafa3/agoraphobia/'
local githubDirectory = 'worker/'

local pathsAndScriptsToInstall = {
  ['/home/worker.lua']          = 'worker.lua',
  ['/home/lib/utilsLib.lua']    = 'lib/utilsLib.lua',
  ['/home/lib/sidesLib.lua']    = 'lib/sidesLib.lua',
  ['/home/lib/ctrlLib.lua']     = 'lib/ctrlLib.lua',
  ['/home/lib/baseLib.lua']     = 'lib/baseLib.lua',
  ['/home/lib/intInvLib.lua']   = 'lib/intInvLib.lua',
  ['/home/lib/intTankLib.lua']  = 'lib/intTankLib.lua',
  ['/home/lib/extInvLib.lua']   = 'lib/extInvLib.lua',
  ['/home/lib/extTankLib.lua']  = 'lib/extTankLib.lua'}

local function isComponentAvailable(component)
  return component.isAvailable(component) 
end

local function getGithubInstallBranch()
  return io.stdin:read()
end

local function getScriptNameMaxLen()
  local scriptNameMaxLen = 0
  for filePath, githubPath in pairs(pathsAndScripts) do
    local scriptNameMaxLen = math.max(scriptNameMaxLen, string.len(githubPath))
  end
  return scriptNameMaxLen
end

local function printScriptInstallFiles()
  for absolutePath, githubPath in pairs(pathsAndScripts) do
    local scriptName = string.match(githubPath, '([^/]+)$')
    local filePath = string.match(absolutePath, '(.+)/')
    print(' - ' .. scriptName .. ' to be installed in directory: ' .. filePath)
  end
end

local function fetchScript(script)
  local url = githubUserUrl .. branch .. script
  local requestScript = internet.request(url)
  if requestScript == nil then
    return nil
  end
  local scriptData = ''
  for scriptChunk in requestScript do
    scriptData = scriptData .. chunk
  end
  return serialization.unserialize(scriptData)
end

local function verifyScript(scriptData)
  for fileName, fileChecksum in pairs(scriptData.checksums or {}) do
    if (scriptData.files[fileName]
      and component.data.sha256(scriptData.files[fileName]) ~= fileChecksum)
      then
      return false
    end
  end
  return true
end

local function installScript(pathsAndScripts)
  for absolutePath, script  in pairs(pathsAndScripts) do
    if filesystem.exists(absolutePath) then
      filesystem.remove(absolutePath)
    end
    local filePath = filesystem.path(absolutePath)
    if filePath ~= nil then
      local pathSegments = filesystem.segments(filePath)
      local pathChecked = '/'
      for _, segment in pairs(pathSegments) do
        pathChecked = filesystem.concat(pathChecked, segment)
        if not filesystem.exists(pathChecked) then
          filesystem.makeDirectory(pathChecked)
        end
      end
    end
    -- todo: scriptData
    local file = io.open(absolutePath, 'wb')
    if file == nil then
      return false
    end
    file:write(scriptData)
    file:close()
  end
end

local function main()
  print('Running \'zccafa3\'s\' script installer')
  if isComponentAvailable('internet') then
    local internet = component.internet
  else
    print('An internet card is required for script installer')
  end
  print('Input branch to download insallation scripts from')
  local githubInstallBranch = getGithubInstallBranch()
  print('The following scripts will be installed:')
  printScriptInstallFiles()
  if isComponentAvailable('gpu') then
    local scriptNameMaxLen = getScriptNameMaxLen()
    local gpu = component.gpu
    local termWidth = gpu.getResolution()
    local _, termY = term.getCursor()
    local barWidthMax = termWidth - scriptNameMaxLen - 11

    local currScriptNum = 0
    for absolutePath, githubPath in pairs(pathsAndScripts) do
      local percent = currScriptNum / #pathsAndScripts
      local barRep = math.floor(barWidthMax * percent + 0.5)
      term.setCursor(1, termY)
      local sName = string.sub(string.match(githubPath, '([^/]+)$') .. 
      string.rep(' ', scriptNameMaxLen), 1, scriptNameMaxLen)
      term.write(sName .. ' |' .. string.rep('=', barRep) .. '>' .. 
      string.rep(' ', barWidthMax - barRep) .. '|' .. 
      string.format('%6.2f%%', percent * 100), false)
      local scriptData = fetchScript(githubPath)
      if scriptData == nil then
        print('Failed to download script: ' .. 
        string.match(githubPath, '([^/]+)$'))
        return
      end
      term.setCursor(1, termY)
      percent = (currScriptNum + 1) / #pathsAndScripts
      barRep = math.floor(barWidthMax * percent + 0.5)
      term.write(sName .. ' |' .. string.rep('=', barRep) .. '>' .. 
      string.rep(' ', barWidthMax - barRep) .. '|' .. 
      string.format('%6.2f%%', percent * 100), false)
      if not verifyScript(scriptData) then
        print('Failed verification of script: ' .. 
        string.match(githubPath, '([^/]+)$'))
      end
      if not installScript(scriptData) then
        print('Failed to install script: ' .. 
        string.match(githubPath, '([^/]+)$'))
      end
      local currScriptNum = currScriptNum + 1
    end
    term.setCursor(1, termY)
    local sName = string.sub('Done' .. 
    string.rep(' ', scriptNameMaxLen), 1, scriptNameMaxLen)
    term.write(sName .. ' |' .. string.rep('=', barWidthMax) .. '>' .. '|' .. 
    '100.00%', false)
  end
end

main()
