require("game.level_config")

test_level_config = {}


function test_level_config:setUp()
  
  file_prefix = ""
  
end

-- GUT4.1
function test_level_config:test_read_unlocked_level_return_not_nil()
  
  assertNotNil(read_unlocked_level())
  
end

-- GUT4.2
function test_level_config:test_read_unlocked_level_return_type_number()

  assertIsNumber(read_unlocked_level())

end

-- GUT4.3
function test_level_config:test_read_unlocked_level_has_no_errors()

  assertError(read_unlocked_level())

end

function test_level_config:tearDown()
end