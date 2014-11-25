logfile = assert(io.open("/usr/1125/logfile", "w"))

function startApp()
 logfile:write("startApp\n")
 logfile:flush()
 require('game/main')
 onStart()
end

startApp()


