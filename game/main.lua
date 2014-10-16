package.path = package.path .. arg[1] .. "\\game\\?.lua;"

require "game"
require "menu"

require "controller"
global_game_state = 0
function onStart()
  --startGame()
  start_menu()
  
end



