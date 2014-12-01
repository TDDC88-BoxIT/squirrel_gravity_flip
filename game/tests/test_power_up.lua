require("game.power_up")

test_power_up ={}

function test_power_up:test_activate_power_up_increasing_score()
  game_score = 0
  global_game_state = 1
   
 expected = 100
 
 activate_power_up("powerup1")
 
 assertEquals(game_score, expected)
 
end  

function test_power_up:test_activate_power_up_increasing_score_100_times()
  
  game_score = 0
  global_game_state = 1
  expected = 100*100
 
 for i = 0, 99, 1 do
  activate_power_up("powerup1")
 end

 assertEquals(game_score, expected)
 
end  


function test_power_up:test_activate_power_up_global_game_state_is_zero()
  
  global_game_state = 0
  game_score = 0
  
  activate_power_up("powerup1")
  
  expected = 0
  
  assertEquals(game_score, expected)
  
end

function test_power_up:test_activate_power_up_score_is_minus()
  global_game_state = 1
  
  game_score = -101
  
  assertError(activate_power_up("powerup1"))
  
end

function test_power_up:test_activate_power_up_nil_as_parameter()
  
  global_game_state = 1
  assertError(activate_power_up(nil))
  
end

