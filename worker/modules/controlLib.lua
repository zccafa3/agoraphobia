--- provides some operating functionality
-- @module controlLib
local controlLib = {}


--- halt throws an error to try and terminate the current coroutine
function controlLib.halt()
  os.exit()
end


return controlLib
