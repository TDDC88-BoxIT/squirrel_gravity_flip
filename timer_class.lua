require('class')


timer_class = class(function (self, interval_millisec, callback)
  self.interval_millisec = interval_millisec
  self.callback = callback
  self.running = false
  self.time_since = 0
end)

function timer_class:set_interval(interval_millisec)
  self.interval_millisec = interval_millisec
end

function timer_class:stop()
  self.running = false
  self.time_since = 0
end

function timer_class:start()
  self.running = true
end