require("game.fail_and_success_handler")

test_fail_and_success_handler = {}

function test_fail_and_success_handler:test_islevelWon_return_not_nil()
  
    assertNotNil(islevelWon())
    
end  

function test_fail_and_success_handler:test_islevelWon_return_false()
  
    assertFalse(islevelWon())
    
end  

function test_fail_and_success_handler:test_prepare_fail_success_handlers_sets_false()
        
    prepare_fail_success_handler()
    assertFalse(islevelWon())
    
end 


-- CAN'T BE RUNNED ON DEVELOPMENT BRANCH
--function test_fail_and_success_handler:test_level_win_sets_true()
      
--    levelwin() 
--    assertTrue(islevelWon())
    
--end  

-- CAN'T BE RUNNED ON DEVELOPMENT BRANCH
--function test_fail_and_success_handler:test_level_win_then_prepare_fail_success_handlers()
      
--    levelwin() 
--    prepare_fail_success_handler()
--    assertFalse(islevelWon())
    
--end  

