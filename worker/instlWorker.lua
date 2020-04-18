--- Dependencies
local component = require('component')
local computer = require('computer')
local filesystem = require('filesystem')
local serialization = require('serialization')
local term = require('term')

local gpu = component.gpu

--- Github Download Repositorys URL and Instalation Paths
local githubUserUrl = 'https://raw.githubusercontent.com/zccafa3/agoraphobia/'
local githubDir = 'worker/'

local installPathsAndScripts = {
  ['/home/worker.lua']          = 'worker.lua',
  ['/home/lib/utilsLib.lua']    = 'lib/utilsLib.lua',
  ['/home/lib/sidesLib.lua']    = 'lib/sidesLib.lua',
  ['/home/lib/ctrlLib.lua']     = 'lib/ctrlLib.lua',
  ['/home/lib/baseLib.lua']     = 'lib/baseLib.lua',
  ['/home/lib/intInvLib.lua']   = 'lib/intInvLib.lua',
  ['/home/lib/intTankLib.lua']  = 'lib/intTankLib.lua',
  ['/home/lib/extInvLib.lua']   = 'lib/extInvLib.lua',
  ['/home/lib/extTankLib.lua']  = 'lib/extTankLib.lua'}

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
    if directoryPath ~= nil then
      local directoryPathSegments = filesystem.segments(directoryPath)
      for _, segment in pairs(directoryPathSegments) do
        local directory = filesystem.concat('/', segment)
        if not filesystem.exists(directory) then
          filesystem.makeDirectory(directory)
        end
      end
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
  if percent < 1.0 then
    local sName = string.sub(string.match(githubPath, '([^/]+)$') .. 
      string.rep(' ', scriptNameMaxLen), 1, scriptNameMaxLen)
  else
    local sName = string.sub('Done' ..            
      string.rep(' ', scriptNameMaxLen), 1, scriptNameMaxLen)
  end
  term.write(sName .. ' |' .. string.rep('=', barRep) .. '>' .. 
    string.rep(' ', barWidthMax - barRep) .. '|' .. 
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
  if component.isAvailable('internet') then
    local internet = component.internet
    -- local internet = require('internet')
  else
    print('An internet card is required for script installer')
    return false
  end
  removeExistingScripts()
  createMissingDirs()
  local githubInstallBranch = getGithubInstallBranch()
  printInstallScripts()
  local numCurrScript = 0
  for installPath, githubPath in pairs(installPathsAndScripts) do
    updateInstallPercent(numCurrScript, githubPath)
    os.sleep(0.5)
    local scriptData = fetchScript(githubInstallBranch, githubPath)
    if scriptData == nil then
      print('Failed to download script: ' .. 
        string.match(githubPath, '([^/]+)$'))
      return false
    end
    if not installScript(scriptData) then
      print('Failed to install script: ' .. 
      string.match(githubPath, '([^/]+)$'))
    end
    currScriptNum = currScriptNum + 1
    updateInstallPercent(numCurrScript, githubPath)
  end
  print('Installation complete. Restarting system.')
  os.sleep(1)
  computer.shutdown(true)
end

main()
