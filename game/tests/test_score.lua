require("game.score")

test_score = {}

function test_score:setUp()
  
  file_prefix = ""
  
end

-- GUT6.1
function test_score:test_read_from_file_return_not_nil()
  
  assertNotNil(read_from_file())
  
end  

-- GUT6.2
function test_score:test_read_from_file_return_type_string()
  
  assertIsString(read_from_file())
  
end  

-- GUT6.3
function test_score:test_read_from_file_return_zero_or_error()
 
 actual = assertError(read_from_file())
 
if file == nil then
  expected = 0
  assertNotEquals(actual, expected)
end

end  

function test_score:tearDown()
end
