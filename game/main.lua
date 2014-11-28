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
function onStart()
  start_menu("start_menu") 
end
