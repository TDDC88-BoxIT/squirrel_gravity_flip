local speed_timer
local invul_timer


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
    character:set_state("boost")
    change_game_speed(15,3000)
	elseif(pu_name=="powerup3") then -- Freeze tile
    character:set_state("slow")
    change_game_speed(1,1000)    
	elseif(pu_name=="powerup4") then -- Invulnerability tile
    character:set_state("invulnerable")
    activate_invulnerability(10000)
  end
end

function change_game_speed(new_speed, time)
  set_game_speed(new_speed)
  if speed_timer~=nil then
    speed_timer=nil
  end
  speed_timer = sys.new_timer(time, "reset_game_speed")
end

--[[
@desc: Makes the player character invulnerable (i.e. unable to die from touching obstacles).
@params: time - Time (in milliseconds) to apply invulnerability.
]]
function activate_invulnerability(time)
  if(player.invulnerable) then
    return
  else
    player.invulnerable = true
    invul_timer = sys.new_timer(time, "end_invulnerability")
  end
end

--[[
@desc: Public getter for player local attribute "invulnerable".
@return: (bool) Whether or not the character is currently invulnerable.
]]
function get_invulnerability_state()
  return player.invulnerable
end

--[[
@desc: Ends invulnerability by setting the player.invulnerable flag to false. Called by system timer, which is stopped.
]]
function end_invulnerability()
  character:set_state("normal")
  player.invulnerable = false
  invul_timer:stop()
end

function reset_game_speed()
  character:set_state("normal")
  set_game_speed(10)
  if speed_timer ~=nil then
    speed_timer:stop()
    speed_timer=nil
  end
  end