--path for windows:
-- package.path = package.path .. arg[1] .. "\\game\\?.lua;"

--path for mac / linux:
--package.path = package.path .. arg[1] .. "/game/?.lua;"

-- file_prefix is used in box to provide full path.
-- In the emulator, we set it to "" to does nothing.
if file_prefix == nil then
  file_prefix = ""
end

require "game/game"
require "game/menu/main"
require "game/input_handler"

global_game_state = 0
local screen_width
local screen_height

function set_screen_size()
  screen_width=screen:get_width()
  screen_height=screen:get_height()
  print("Current Screen Width: "..screen_width)
  print("Current Screen Height: "..screen_height)
end

function get_screen_size()
  return {width=screen_width,height=screen_height}
end

function onStart()
	set_screen_size()
	start_menu("start_menu") 
end




