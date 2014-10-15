-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'

my_table = {
  floors = {
    {
      x = 1234,
      y = 5432,
      width = 32,
      height = 32,
    },
    
    {
      x = 1234,
      y = 5432,
      width = 32,
      height = 32,
    }
  }
}

player = {}
player.image = love.graphics.newImage("images/hero.png")
player.x = 100
player.y = 100

function onStart()
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  draw_screen()
end

function draw_screen()
  --- Get a green screen but can't change the color
  screen:clear({g=160})
  
  table.foreach(my_table["floors"], draw_tile)
  
  --screen:fill({0,0,200}, {59,60,200,500})
  
  --gfx.update()
end

--Taken directly from Zenterio's game since I think we will need this or is this for a later user story?
function update_cb(timer)
  now = sys.time()
  --last_time = last_time or 0
  --update_state(now - last_time)
  --last_time = now
 -- print(now)
  if lives > 0 then
    draw_screen()
  else
   -- game_over()
    print ("YOU LOST!!")
  end
end

function draw_tile(floors)
  
  screen:fill({10, 10, 32, 32})
  
end

