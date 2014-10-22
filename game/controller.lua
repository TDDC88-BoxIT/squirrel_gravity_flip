function onKey(key, state)
	  if global_game_state == 0 then
	    menu_key(key, state)
	  elseif global_game_state == 1 then
	  	game_key(key, state)
	  end  
end

function menu_key(key, state)
 	menu_key_down(key, state)
end

function game_key(key, state)
	game_key_down(key, state)
end

function change_global_game_state(state)
	global_game_state=state
end