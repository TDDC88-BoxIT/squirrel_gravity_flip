require("game.level_config")

test_level_config = {}

function test_level_config:setUp()
  
  file_prefix = ""
  
end

function test_level_config:test_read_unlocked_level_return_not_nil()
  
  assertNotNil(read_unlocked_level())
  
end

function test_level_config:test_read_unlocked_level_return_type_number()

  assertIsNumber(read_unlocked_level())

end

function test_level_config:test_read_unlocked_level_has_no_errors()

  assertError(read_unlocked_level())

end

function test_level_config:tearDown()
end