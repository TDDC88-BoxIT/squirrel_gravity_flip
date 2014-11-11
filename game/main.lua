--path for windows:
-- package.path = package.path .. arg[1] .. "\\game\\?.lua;"

--path for mac / linux:
package.path = package.path .. arg[1] .. "/game/?.lua;"

require "game/game"
require "game/menu/main"
require "game/controller"


global_game_state = 0
function onStart()
  start_menu() 
end
