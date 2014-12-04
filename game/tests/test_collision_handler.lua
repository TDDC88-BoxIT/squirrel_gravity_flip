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

function test_check_collision:test_check_collision_type_not_expected()
  
  assertError(CheckCollision(nil,1,1,1,1,1,1,1))
  
end


-- CAN'T RUN ALL THESE TESTS ON THE DEVELOPMENT BRANCH
-- HITTEST IS USING SCREEN CALLS = Not Testable
-- test_hit_test = {}

--function test_hit_test:setUp()
 --   tiles = {}
--    
 --   tile = {
 --       name = "floor",
  --      gid = 1,
  --      visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((1-1) % 5) * 5,
  --      y = (math.floor((1-1) / 5)) * 5
  --    }
  --  table.insert(tiles, tile)
    
  --    tile = {
  --      name = "floor",
  --      gid = 1,
   --     visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((2-1) % 5) * 5,
  --      y = (math.floor((2-1) / 5)) * 5
  --    }
      
  --    table.insert(tiles, tile)
      
  --          tile = {
  --      name = "floor",
  --      gid = 1,
  --      visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((3-1) % 5) * 5,
  --      y = (math.floor((3-1) / 5)) * 5
  --    }
      
  --    table.insert(tiles, tile)
      
  --    tile = {
  --      name = "floor",
  --      gid = 1,
  --      visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((4-1) % 5) * 5,
  --      y = (math.floor((4-1) / 5)) * 5
  --    }
      
  --    table.insert(tiles, tile)
      
  --    SpSet = {}

  --    fire = {
  --      name = "obstacle4",
  --      gid = 10,
  --      visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((5-1) % 10) * 5,
  --      y = (math.floor((5-1) / 10)) * 5
  --    }
      
  --    table.insert(SpSet, fire)
      
  --    cloud = {
  --      name = "obstacle3",
  --      gid = 9,
  --      visibility = true,
  --      width = 32,
  --      height = 32,
  --      x = ((6-1) % 10) * 5,
   --     y = (math.floor((6-1) / 10)) * 5
   --   }
      
  --    table.insert(SpSet, cloud)
--end

-- GUT2.1
--function test_hit_test:test_hitTest_return_nil()
  
 -- assertNil(hitTest(100,tiles, 5, 5, 32, 32))
  
--end

-- GUT2.2
--function test_hit_test:test_hitTest_return_not_nil()
  
  --assertNotNil(hitTest(0,tiles, 5, 5, 32, 32))
  
--end  

-- GUT2.3
--function test_hit_test:test_hitTest_return_type_number_and_nil()
  
--actual_1, actual_2, actual_3, acutal_4 =  hitTest(0,tiles, 5, 5, 32, 32)
  
  --assertIsNumber(actual_1)
  --assertIsNumber(actual_2)
  --assertIsNumber(actual_3)
  --assertNil(actual_4)

--end

-- GUT2.4
--function test_hit_test:test_hitTest_boundaries1()
  
--assertError(hitTest(0,tiles, -5000000, 99999999999, 32, 32)) 
  
--end  

-- GUT2.5
--function test_hit_test:test_hitTest_boundaries2()
 --assertError(hitTest(-99999999999,tiles, 5, 5, 32, 32) )

--end

-- GUT2.6
--function test_hit_test:test_hitTest_boundaries3()
  
-- assertError(hitTest(99999999999,tiles, 5, 5, 32, 32) )

--end
  
-- GUT2.7
--function test_hit_test:test_hitTest_boundaries4_tiles()
  
  -- test_table = {}
  --    tile_test = {
  --      name = "floor",
  --      gid = 1,
  --      visibility = true,
  --      width = -5,
  --      height = 0,
  --      x = ((3-1) % 5) * 5,
  --      y = (math.floor((3-1) / 5)) * 5
  --    }
      
  --    table.insert(test_table, tile_test)
      
  --    tile_test = {
  --      name = "floor",
   --     gid = 1,
   --     visibility = true,
   --     width = -5,
   --     height = 0,
   --     x = ((4-1) % 5) * 5,
   --     y = (math.floor((4-1) / 5)) * 5
   --   }  
 --table.insert(test_table, tile_test)
 
 --assertError(hitTest(0,tiles, 5, 5, 32, 32) )
--end
  
--function test_hit_test:tearDown()
--end

