-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'


--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"
require "game/level"
require ("game/physic")
require ("game/tiledmap")
require ("tool_box/character_object")

gKeyPressed = {}
gCamX,gCamY = 100,100
local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local direction_flag=0 -- 0 MEANS DOWN AND 1 MEANS UP
local character_size = 32
local tile_surface=nil
local floor_speed = 10
player = {}
--player.image = "game/images/hero.png"
function start_game() 

  TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  character = character_object(character_size,character_size,imageDir.."menuImg/squirrel1.png")
  character:add_image(imageDir.."menuImg/squirrel2.png")
  player.x = 100
  player.y = 100 
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(100, "update_game_character")

  --player.x = 400
  --player.y = 480
  pos_change = 0
  lives = 10
  --timer = sys.new_timer(20, "update_cb")
  --Level.load_level(1)
  --floors = Level.get_floor()
end

function resume_game()   
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(100, "update_game_character")
  --Level.load_level(2)
 -- floors = Level.get_floor()
end

function stop_game()
  screen:clear()
  timer:stop()
  timer = nil
  change_character_timer:stop()
  change_character_timer=nil   
end


function update_game_character()
  character:destroy() -- DESTROYS THE CHARACTER'S SURFACE SO THAT NEW UPDATES WON'T BE PLACED ONTOP OF IT
  character:update()  -- UPDATES THE CHARACTERS BY CREATING A NEW SURFACE WITH THE NEW IMAGE TO BE DISPLAYED
end


--Taken directly from Zenterio's game since I think we will need this or is this for a later user story?
function update_cb(timer)
  --last_time = last_time or 0
  --update_state(now - last_time)
  --last_time = now
 -- print(now)
  if lives > 0 then
    dt=0.01
    hitTest(gCamX, gCamY, player.x, player.y, character_size)
    -- gravity
    gsetGravity(10)
    local gy = CurveY(dt)
    player.y = player.y + gy
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, character_size) then
      player.y = player.y - gy --THIS MAKES THE CHARACTED STOP FALLING OR RISING IF IT HITS SOMETHING
    end

     -- go ahead
    player.x = player.x + 100*dt
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, character_size) then
      player.x = player.x  - 100*dt --THIS MAKES THE SQUIRREL STOP MOVING FORWARD IF IT RUNS INTO SOMEHTING
    end
    
    gCamX = player.x
    gCamY = player.y

    draw_screen(floors)
  else
   -- game_over()
    print ("YOU LOST!!")
  end
end

function draw_screen(floors)

  screen:clear()
  
  -- CREATES A NEW SURFACE FOR THE GAME BACKGOUND AND GIVES IT A GRAY COLOR
  sf = gfx.new_surface(screen:get_width(), screen:get_height())
  sf:fill({r=80,g=80,b=80})
  -- THE BACKGROUND IS COPIED TO THE SCREEN AND THE SURFACE IS DESTROYED
  screen:copyfrom(sf)
  sf:destroy()

  -- LOOP THROUGH FLOOR TILES AND CALL DRAW FUNCTION 
 -- for k,v in pairs(floors) do 
  -- draw_tile(v, pos_change)
  --end
  --pos_change = pos_change + floor_speed
  
  TiledMap_DrawNearCam(gCamX,gCamY)

  -- THE GAME CHARACTER IS COPIED TO THE SCREEN
  screen:copyfrom(character:get_surface(), nil,{x=player.x,y=player.y},true)
  
  gfx.update()

  --- Get a green screen but can't change the color
  --screen:clear({r=72,g=72,b=72})
  
  
end


function draw_tile(tile, pos_change)
  if tile_surface==nil then
    tile_surface = gfx.loadpng(imageDir.."floor.png") -- SET FLOOR TILE IMAGE
  end
  screen:copyfrom(tile_surface,nil,{x=tile.x - pos_change, y=tile.y, width=tile.width, height=tile.height})
  --screen:fill({r=255,g=0,b=0},{x=tile.x - pos_change, y=tile.y, width=tile.width, height=tile.height})
  --sf:destroy()  
end

function game_navigation(key, state)
  if key=="ok" and state== 'up' then
    if direction_flag == 0 then
      ToTop()
      --player.y = player.y - 10
      --if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
       -- player.y = player.y + 10
      --end
      direction_flag=1
    else
      ToBottom()
      --player.y = player.y + 10
      --if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
       -- player.y = player.y - 20
      --end
      direction_flag=0
    end
  elseif key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    stop_game()
    change_global_game_state(0)
    set_menu_state("pause_menu")
    start_menu()
  end
end 


