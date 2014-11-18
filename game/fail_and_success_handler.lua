function get_killed() -- TO BE CALLED WHEN THE SQUIRREL IS KILLED. DECREAES LIFE AND CALLS GAMEOVER MENU
	stop_game()
  decrease_life()
	if(check_alive()) then
		start_game(3,"story",get_lives()) 
	else
		change_global_game_state(0)
		start_menu("gameover_menu")
	end
end

function levelwin() -- TO BE CALLED WHEN A LEVEL IS ENDED. CALLS THE LEVELWIN MENU
  stop_game()
  change_global_game_state(0)
  start_menu("levelwin_menu")
end