require('surface_class')
gfx = require('gfx')
sys = require('sys')

----------------------
-- love2d functions --
----------------------

function love.load()
  --print('love.load')
  love.keyboard.setKeyRepeat(true)
  first_run = true
  
  key_translation = {}
  --key_translation[keyboard] = stb
  key_translation["0"] = "0"
  key_translation["1"] = "1"
  key_translation["2"] = "2"
  key_translation["3"] = "3"
  key_translation["4"] = "4"
  key_translation["5"] = "5" 
  key_translation["6"] = "6"
  key_translation["7"] = "7"
  key_translation["8"] = "8"
  key_translation["9"] = "9"
  key_translation[" "] = "ok"
  key_translation["up"] = "up"  
  key_translation["down"] = "down"
  key_translation["left"] = "left"
  key_translation["right"] = "right"
  key_translation["q"] = "red"
  key_translation["w"] = "green"
  key_translation["e"] = "yellow"
  key_translation["r"] = "blue"
  key_translation["t"] = "white"
  key_translation["i"] = "info"
  key_translation["lshift"] = "menu"
  key_translation["g"] = "guide"
  key_translation["o"] = "opt"
  key_translation["h"] = "help"
  key_translation["s"] = "star"
  key_translation["a"] = "multi"
  key_translation["x"] = "exit"
  key_translation["p"] = "pause"
  key_translation["z"] = "toggle_tv_radio"
  key_translation["c"] = "record"
  key_translation["v"] = "play"
  key_translation["b"] = "stop"
  key_translation["n"] = "fast_forward"
  key_translation["m"] = "rewind"
  key_translation[","] = "skip_forward"
  key_translation["."] = "skip_reverse"
  key_translation["-"] = "jump_to_end"
  key_translation["rshift"] = "jump_to_beginning"
  key_translation["l"] = "toggle_pause_play"
  key_translation["k"] = "vod"
  key_translation["backspace"] = "backspace"
  key_translation["j"] = "hash"
  key_translation["'"] = "back"
  key_translation["+"] = "ttx"
  key_translation["d"] = "record_list"
  key_translation["f"] = "play_list"
  key_translation["u"] = "mute"

  buffer_screen = screen
  require('game.main')
end


function love.draw()
  --print('love.draw')
  --love.graphics.draw(image)
  if first_run then
    if type(onStart) == "function" then
      print('Calling onStart')
      onStart()
    end
    first_run = false
  end
  
  if gfx.auto_update then
    --print('Auto draw')
    buffer_screen = screen
    
  --else
  --  love.graphics.draw(gfx.buffer_screen)
  end
  love.graphics.draw(buffer_screen.canvas)
end


function love.keypressed(key, isrepeat)
  if isrepeat then
    state = "repeat"
  else
    state = "down"
  end
  
  if key_translation[key] ~= nil and type(onKey) == "function" then
    print("Keybord key: " .. key .. ", STB key: " .. key_translation[key] .. ", state: " .. state )
    onKey(key_translation[key], state)
  elseif key == "escape" then
    print("Memory usage: " .. string.format("%.0f",gfx.get_memory_use()) .. " of " .. string.format("%.0f",gfx.get_memory_limit()) .. " bytes or " .. string.format("%.2f", gfx.get_memory_use() * 100 / gfx.get_memory_limit()) .. " %")
  end
end

function love.keyreleased(key)
  if key_translation[key] ~= nil and type(onKey) == "function" then
    print("Keybord key: " .. key .. ", STB key: " .. key_translation[key] .. ", state: up")
    onKey(key_translation[key], "up")
  end
end

function love.run()

  if love.math then
      love.math.setRandomSeed(os.time())
  end

  if love.event then
      love.event.pump()
  end

  if love.load then love.load(arg) end

  -- We don't want the first frame's dt to include time taken by love.load.
  if love.timer then love.timer.step() end

  local dt = 0

  -- Main loop time.
  while true do
    -- Process events.
    if love.event then
      love.event.pump()
      for e,a,b,c,d in love.event.poll() do
        if e == "quit" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            return
          end
        end
        love.handlers[e](a,b,c,d)
      end
    end

    for i,t in ipairs(sys.timers) do
      if t.running then
        if t.time_since >= t.interval_millisec then 
          if type(t.callback) == "function" then
            t.callback()
          elseif type(t.callback) == "string" then
            cb_function = loadstring(t.callback .. "()")
            cb_function(t)
          end
          t.time_since = 0
        else
          t.time_since = t.time_since + (dt * 1000)
        end
        sys.timers[i] = t
      end
    end 

    -- Update dt, as we'll be passing it to update
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end

    -- Call update and draw
    if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

    if love.window and love.graphics and love.window.isCreated() then
      love.graphics.clear()
      love.graphics.origin()
      if love.draw then love.draw() end
      love.graphics.present()
    end

    if love.timer then love.timer.sleep(0.001) end
  end

end