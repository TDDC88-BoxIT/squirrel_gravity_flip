--[[
@desc: Activates a collidable object (power-up, power-down or obstacle) and lets the game react to it.
@params: pu_name - The name (as defined in level files) of the object to activate.
]]
function activate_power_up(pu_name)
  
  --[[
  This prevents additional powerup events from being fired if the game is over (if you die).
  Previously, hitting two or more obstacles at the same time (easily done on level4) would cause the game to try
  and destroy the surface twice, throwing a runtime exception.
  ]]
  if(global_game_state == 0) then
    return
  end
  
	if(pu_name=="powerup1") then -- Score tile
    game_score = game_score + 100
	elseif(pu_name=="powerup2") then -- Speed tile
    change_game_speed(15,1000)
	elseif(pu_name=="powerup3") then -- Freeze tile
    change_game_speed(1,1000)    
	elseif(pu_name=="powerup4") then -- Invulnerability tile
    activate_invulnerability(10000)
  elseif(pu_name == "win") then -- Win tile!
    levelwin()
  elseif((pu_name == "obstacle1" or pu_name == "obstacle2" or pu_name == "obstacle3" or pu_name == "obstacle4") and not get_invulnerability_state()) then -- Obstacles
    get_killed()
  end
end