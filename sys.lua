require('timer_class')

-- ## sys module ##

-- sys.new_timer(interval_millisec, callback)
--   Creates and starts a timer that calls <callback> every <interval_millisec>.
--   <callback> can be a function or a string.
--   If a string, the global variable of this name will be fetched each
--   time the timer triggers and that variable will be called, assuming
--   it is a function. In this way, callbacks can be replaced in real-time.

--   The callback function is called with signature:
--   callback(timer)
--   where <timer> is the timer object that triggered the event

-- sys.time()
--   Returns the time since the system started, in seconds and fractions
--   of seconds. Useful to measure lengths of time.

-- sys.stop()
--   Terminates the execution of the script. The rest of the currently
--   executing code will be run, but all timers are stopped and the
--   current script environment will never be called again.

local sys = {}


function sys.new_timer(interval_millisec, callback)
  print("New timer created. Calling: " .. callback .. " every " .. interval_millisec)
  new_timer = timer_class(interval_millisec, callback)
  new_timer:start()
  table.insert(sys.timers, new_timer)
  return new_timer
end


function sys.time()
  return love.timer.getTime()
end


function sys.stop()
  love.event.quit()
end

sys.timers = {}

return sys
