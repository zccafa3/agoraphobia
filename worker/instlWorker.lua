--- Dependencies
local component = require('component')
local computer = require('computer')
local filesystem = require('filesystem')
local internet = require('internet')
local serialization = require('serialization')
local term = require('term')

local gpu = component.gpu

--- Github Download Repositorys URL and Instalation Paths
local githubUserUrl = 'https://raw.githubusercontent.com/zccafa3/agoraphobia/'
local githubDir = 'worker/'

local installPathsAndScripts = {
  ['/home/lib/baseLib.lua']     = 'lib/baseLib.lua',
  ['/home/lib/commsLib.lua']    = 'lib/commsLib.lua',
  ['/home/lib/ctrlLib.lua']     = 'lib/ctrlLib.lua',
  ['/home/lib/debugLib.lua']    = 'lib/debugLib.lua',
  ['/home/lib/extInvLib.lua']   = 'lib/extInvLib.lua',
  ['/home/lib/extTankLib.lua']  = 'lib/extTankLib.lua',
  ['/home/lib/intInvLib.lua']   = 'lib/intInvLib.lua',
  ['/home/lib/intTankLib.lua']  = 'lib/intTankLib.lua',
  ['/home/lib/sidesLib.lua']    = 'lib/sidesLib.lua',
  ['/home/lib/utilsLib.lua']    = 'lib/utilsLib.lua',
  ['/home/worker.lua']          = 'worker.lua'}

--- removeExistingScripts removes any existing scripts in intallPathsAndScripts
local function removeExistingScripts()
  for installPath, gihubPath in pairs(installPathsAndScripts) do
    if filesystem.exists(installPath) then
      filesystem.remove(installPath)
    end
  end
end

--- createMissingDirs makes a new directory for any missing directories in
-- installPathsAndScripts
local function createMissingDirs()
  for installPath, githubPath in pairs(installPathsAndScripts) do
    local directoryPath = filesystem.path(installPath)
    if directoryPath ~= nil and not filesystem.exists(directoryPath) then
      filesystem.makeDirectory(directoryPath)
    end
  end
end

--- getGithubInstallBranch gets the branch of install from User
-- @return branch
local function getGithubInstallBranch()
  print('Input branch to download insallation scripts from')
  return io.stdin:read() .. '/'
end

--- printInstallScripts prints the scripts in installPathsAndScripts for
-- install
local function printInstallScripts()
  print('The following scripts will be installed:')
  os.sleep(0.5)
  for installPath, githubPath in pairs(installPathsAndScripts) do
    local scriptName = string.match(githubPath, '([^/]+)$')
    print(' - ' .. scriptName)
    os.sleep(0.5)
  end
end

--- getMaxScriptNameLen gets the length of the largest script name in
-- installPathsAndScripts
-- @return length of largest script name
local function getMaxScriptNameLen()
  local maxScriptNameLen = 0
  for installPath, githubPath in pairs(installPathsAndScripts) do
    maxScriptNameLen = math.max(maxScriptNameLen, string.len(githubPath))
  end
  return maxScriptNameLen
end

--- getNumInstallScripts gets the total number of scripts in
-- installPathsAndScripts
-- @return number of install scripts
local function getNumInstallScripts()
  local numInstallScripts = 0
  for installPath, githubPath in pairs(installPathsAndScripts) do
    numInstallScripts = numInstallScripts + 1
  end
  return numInstallScripts
end

--- updateInstallPercent displays the current progress percent of Installer
local function updateInstallPercent(numCurrScript, githubPath) 
  local maxScriptNameLen = getMaxScriptNameLen()
  local termWidth = gpu.getResolution()
  local _, termY = term.getCursor()
  local barWidth = termWidth - maxScriptNameLen - 11
  local numInstallScripts = getNumInstallScripts()
  local percent = numCurrScript / numInstallScripts
  local barRep = math.floor(barWidth * percent + 0.5)
  term.setCursor(1, termY)
  local scriptName = ''
  if percent ~= 1.0 then
    scriptName = scriptName .. string.sub(string.match(githubPath, '([^/]+)$') 
      .. string.rep(' ', maxScriptNameLen), 1, maxScriptNameLen)
  else
    scriptName = scriptName .. string.sub('Done' ..            
      string.rep(' ', maxScriptNameLen), 1, maxScriptNameLen)
  end
  term.write(scriptName .. ' |' .. string.rep('=', barRep) .. '>' .. 
    string.rep(' ', barWidth - barRep) .. '|' .. 
    string.format('%6.2f%%', percent * 100), false)
end

--- downloadScript downloads the specified script from the specified branch
-- @param branch to download scripts
-- @tparam string
-- @param script to download
-- @tparam string
-- @return script
local function downloadScript(branch, script)
  local downloadUrl = githubUserUrl .. branch .. githubDir .. script
  local scriptData = ''
  for scriptChunk in internet.request(downloadUrl) do
    scriptData = scriptData .. scriptChunk
  end
  return scriptData
end

--- installScript installs the script to the specified path
-- @param installPath destination script name and path
-- @tparam string
-- @param scriptData script to install
-- @tparam string
-- @return true, or false
local function installScript(installPath, scriptData)
  local file = io.open(installPath, 'wb')
  if file == nil then
    return false
  end
  file:write(scriptData)
  file:close()
  return true
end

--- main
local function main()
  print('Running \'zccafa3\'s\' script installer')
  removeExistingScripts()
  createMissingDirs()
  local githubInstallBranch = getGithubInstallBranch()
  printInstallScripts()
  local numCurrScript = 0
  for installPath, githubPath in pairs(installPathsAndScripts) do
    updateInstallPercent(numCurrScript, githubPath)
    os.sleep(0.5)
    local scriptData = downloadScript(githubInstallBranch, githubPath)
    if scriptData == nil then
      print('Failed to download script: ' .. 
        string.match(githubPath, '([^/]+)$'))
      return false
    end
    if not installScript(installPath, scriptData) then
      print('Failed to install script: ' .. 
        string.match(githubPath, '([^/]+)$'))
      return false
    end
    numCurrScript = numCurrScript + 1
    updateInstallPercent(numCurrScript, githubPath)
  end
  print('Installation complete. Restarting system.')
  os.sleep(1)
  computer.shutdown(true)
end

main()
