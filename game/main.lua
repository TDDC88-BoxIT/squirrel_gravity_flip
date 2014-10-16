package.path = package.path .. arg[1] .. "\\game\\?.lua;"
require "game"
require "menu"

game_state = 0
function onStart()
  --showGame()
  showMenu()
  
end



function onKey(key, state)
  if key=="ok" and state=='up' then
    if game_state == 1 then      
      showGame()
      game_state = 0
    elseif game_state == 0 then
      showMenu()
      game_state = 1
    end   
  end
  
end