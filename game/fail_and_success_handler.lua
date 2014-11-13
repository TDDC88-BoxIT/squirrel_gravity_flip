function get_squeezed()
	stop_game()
	if(check_alive()) then
		decrease_life()
		start_game(3,"story",get_lives())
	end
end

function levelwin() -- TO BE CALLED WHEN A LEVEL IS ENDED. CALLS THE LEVELWIN MENU
  stop_game()
  change_global_game_state(0)
  start_menu("levelwin_menu")
end