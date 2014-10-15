-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'


package.path = package.path .. arg[1] .. "\\api_squirrel_game\\?.lua"
require "level"

my_table = {
  floors = {
    {
      x = 10,
      y = 10,
      width = 32,
      height = 32,
    },
    
    {
      x = 50,
      y = 50,
      width = 32,
      height = 32,
    }
  }
}

player = {}
--player.image = love.graphics.newImage("images/hero.png")
player.x = 100
player.y = 100

function onStart()
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  
  Level.load_level(1)

  floors = Level.get_floor()
  print(floors)
  --draw_screen(floors)
end

function draw_screen(floors)
  --- Get a green screen but can't change the color
  screen:clear({g=160})
  
  for k,v in pairs(floors) do 
    draw_tile(v)
  end
end

--Taken directly from Zenterio's game since I think we will need this or is this for a later user story?
function update_cb(timer)
  now = sys.time()
  --last_time = last_time or 0
  --update_state(now - last_time)
  --last_time = now
 -- print(now)
  if lives > 0 then
    draw_screen(floors)
  else
   -- game_over()
    print ("YOU LOST!!")
  end
end

function draw_tile(tile)
  
  
  screen:fill({r=0,g=255,b=0}, {x=tile.x, y=tile.y, width=tile.width, height=tile.height})
  
end

