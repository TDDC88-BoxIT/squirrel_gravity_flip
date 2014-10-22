--path for windows:
-- package.path = package.path .. arg[1] .. "\\game\\?.lua;"

--path for mac / linux:
package.path = package.path .. arg[1] .. "/game/?.lua;"

require "game"
require "menu/main"
require "controller"
require "gravity_main"


global_game_state = 0
function onStart()
  --startGame()
  start_menu() 
end



