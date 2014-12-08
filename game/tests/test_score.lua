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
function test_score:test_read_from_file_return_type_table()
  
  assertIsTable(read_from_file())
  
end  

-- GUT6.3
function test_score:test_read_from_file_return_zero_or_error()
 
 actual = assertError(read_from_file())
 
if file == nil then
  expected = 0
  assertNotEquals(actual, expected)
end

end  

--GUT6.4
function test_score:test_read_from_file_file_is_nil()
  
  file_prefix = "jibberish"
  assertEquals(read_from_file(), 0)
  
end  



--GUT6.5
function test_score:test_score_page()
  
  score_board = {}
  table.insert(score_board,1)
  assertError(score_page("AAB", 15000, "level1"))
  
end

--GUT6.6
function test_score:test_table_length_return_length()
  
  test_table = {}
  
  table.insert(test_table,1)
  table.insert(test_table,1)
  table.insert(test_table,1)
  table.insert(test_table,1)
  table.insert(test_table,1)
  
  expected = 5
  
  assertEquals(table_length(test_table), expected)
  
end

--GUT6.7
function test_score:test_table_length_return_length_with_empty_table()
  
  test_table = {}
  
  expected = 0
  
  assertEquals(table_length(test_table), expected)
  
end

function test_score:tearDown()
end
