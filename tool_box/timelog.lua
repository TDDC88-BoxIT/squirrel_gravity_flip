-- Used to print a series of time spent

local previous ptime = sys.time()

-- Reset the time
function logstartover()
 ptime = sys.time()
end

-- Print the time interval and memerize the current time
function logprint(prefix)
  local t = sys.time() - ptime
  print(prefix .. " " .. t)
  ptime = sys.time();
end