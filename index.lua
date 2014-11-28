-- This file is used in the box as start point.
-- Type: sendcmd LuaEngine run /usr/1128/index.lua to start App.

logfile = assert(io.open("/usr/1128/logfile", "w"))
file_prefix = "/usr/1128/"

function startApp()
 logfile:write("startApp\n")
 logfile:flush()
 require('game/main')
 onStart()
end

startApp()


