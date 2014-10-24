-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'


--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"
require "game/level"

-- CERATES A TILE SURFACE
function create_tile(tile_index) 
  return gfx.loadpng("images/floor" .. tile_index .. ".png") 
end

local tile_surface = create_tile(1)

player = {}
--player.image = "game/images/hero.png"
function start_game()   
  player.x = 400
  player.y = 480
  pos_change = 0
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  Level.load_level(2)
  floors = Level.get_floor()
end

function resume_game()   
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  Level.load_level(2)
  floors = Level.get_floor()
end

function stop_game()
  screen:clear()
  timer:stop()
  timer = nil  
end

function draw_screen(floors)
  --- Get a green screen but can't change the color
  screen:clear({r=72,g=72,b=72})
  
  for k,v in pairs(floors) do 
    draw_tile(v, pos_change)
    pos_change = pos_change + 0.1
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

function draw_tile(tile, pos_change) 
  screen:copyfrom(tile_surface, nil, {x=tile.x - pos_change, y=tile.y, width=tile.width, height=tile.height})
end

function game_navigation(key, state)
  print(key)
  if key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    stop_game()
    change_global_game_state(0)
    set_menu_state("pause_menu")
    start_menu()
  end
end 



