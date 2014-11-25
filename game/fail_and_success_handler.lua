local level_won=false

function get_killed() -- TO BE CALLED WHEN THE SQUIRREL IS KILLED. DECREAES LIFE AND CALLS GAMEOVER MENU
	stop_game()
	change_global_game_state(0)
 	start_menu("gameover_menu")
end

function levelwin() -- TO BE CALLED WHEN A LEVEL IS ENDED. CALLS THE LEVELWIN MENU
 	if player_name == "" then
		player_name= "AAA"
	end
	--score_page(player_name, game_score, 1)
	--draw_highscore(1,620)
 	level_won = true
	stop_game()
	change_global_game_state(0)
	start_menu("levelwin_menu")
end

function prepare_fail_success_handler()
	level_won=false
end

function islevelWon()
	return level_won
end