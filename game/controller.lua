function onKey(key, state)
  
  if global_game_state == 0 then
    menu_key(key, state)
  end 
  
end

function menu_key(key, state)
  menu_key_down(key, state)
end
