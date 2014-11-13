
-- ACTIVATES A POWERUP DEPENDING ON pu-type
function activate_power_up(pu_type)
  
	if(pu_type==2) then -- Score tile
    game_score = game_score + 100
	elseif(pu_type==3) then -- Speed tile
    change_game_speed(15,1000)
	elseif(pu_type==4) then -- Freeze tile
    change_game_speed(1,1000)    
	elseif(pu_type==5) then -- Invulnerability tile
    activate_invulnerability(1000)
  elseif(pu_type == 6) then -- Win tile!
    levelwin()
  elseif((pu_type == 7 or pu_type == 8) and not get_invulnerability_state()) then -- Obstacles
    stop_game() -- This NEEDS to be changed to the actual fail screen when that has been implemented
  end
end