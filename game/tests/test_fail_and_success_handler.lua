require("game.fail_and_success_handler")

test_fail_and_success_handler = {}

-- GUT3.1
function test_fail_and_success_handler:test_islevelWon_return_not_nil()
  
    assertNotNil(islevelWon())
    
end  

-- GUT3.2
function test_fail_and_success_handler:test_islevelWon_return_false()
  
    assertFalse(islevelWon())
    
end  

--GUT3.3
function test_fail_and_success_handler:test_prepare_fail_success_handlers_sets_false()
        
    prepare_fail_success_handler()
    assertFalse(islevelWon())
    
end 


-- CAN'T BE RUNNED ON DEVELOPMENT BRANCH

-- GUT3.4
--function test_fail_and_success_handler:test_level_win_sets_true()
      
--    levelwin() 
--    assertTrue(islevelWon())
    
--end  

-- CAN'T BE RUNNED ON DEVELOPMENT BRANCH

-- GUT3.5
--function test_fail_and_success_handler:test_level_win_then_prepare_fail_success_handlers()
      
--    levelwin() 
--    prepare_fail_success_handler()
--    assertFalse(islevelWon())
    
--end  

