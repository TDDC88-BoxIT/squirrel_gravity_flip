package.path = package.path .. arg[1] .. "\\game\\?.lua;"
require "game"
require "menu"

game_state = 0
function onStart()
  --startGame()
  startMenu()
  
end



function onKey(key, state)
  
  
  if key=="ok" and state=='up' then
    if game_state == 1 then    
      stopMenu()
      startGame()      
      game_state = 0
    elseif game_state == 0 then
      stopGame()
      startMenu()      
      game_state = 1
    end   
  end
  
end