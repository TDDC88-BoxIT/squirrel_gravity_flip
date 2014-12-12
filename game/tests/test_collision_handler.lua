require('game.collision_handler')

test_check_collision= {}

-- GUT1.1
function test_check_collision:test_check_collision_not_nil()
  assertNotNil(CheckCollision(1,1,1,1,1,1,1,1))
end


-- GUT1.2
function test_check_collision:test_check_collision_nil()
  assertNil(CheckCollision(1,1,1,1,5,1,5,1))
end


-- GUT1.3
function test_check_collision:test_check_collision_boundaries_numbers()
  
  assertError(CheckCollision(-1, -555555555, -0, -133431,-34654523,-3465467,-6,-9999999999999999999999999))
  
end

-- GUT1.4
function test_check_collision:test_check_collision_boundaries_numbers2()
  
  assertError(CheckCollision(99999999999999999999, 100000000000000000000000000000, 2333333333333333333333, 133431,234545434654523,2345543465467,333333333333333336,9999999999999999999999999))
  
end

-- GUT1.5
function test_check_collision:test_check_collision_return_type_number()
  
 a, b, c, d =CheckCollision(1,1,1,1,1,1,1,1) 
 assertIsNumber(a)
 assertIsNumber(b)
 assertIsNumber(c)
 assertIsNumber(d)
  
end

