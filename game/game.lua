-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'


--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"
require "game/level"
require ("game/physic")
require ("game/level_module")
--require ("game/tiledmap")
require ("tool_box/character_object")

gKeyPressed = {}
gCamX,gCamY = 100,100
local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local direction_flag="down" -- KEEPS TRACK OF WHAT WAY THE SQUIRREL I MOVING
local character_width = 32
local character_height = 32
local tile_surface=nil
local floor_speed = 10
local background


-- CERATES A TILE SURFACE
function create_tile(tile_index) 
  return gfx.loadpng(imageDir .. "floor" .. tile_index .. ".png") 
end

local tile_surface = create_tile(1)

player = {}
--player.image = "game/images/hero.png"
function start_game() 

  TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  character = character_object(character_width,character_height,imageDir.."character/squirrel1.png")
  character:add_image(imageDir.."character/squirrel2.png")
  character:add_flipped_image(imageDir.."character/squirrel1_flipped.png")
  character:add_flipped_image(imageDir.."character/squirrel2_flipped.png")
  player.x = 320
  player.y = 450 
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(100, "update_game_character")

  pos_change = 0
  lives = 10

end

function resume_game()   
  lives = 10
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(100, "update_game_character")
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
  if lives > 0 then
    dt=0.01
    hitTest(gCamX, gCamY, player.x, player.y, character_width, character_height)
    -- gravity
    gsetGravity(10)
    local gy = CurveY(dt)
    player.y = player.y + gy
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, character_width, character_height) then
      player.y = player.y - gy --THIS MAKES THE CHARACTED STOP FALLING OR RISING IF IT HITS SOMETHING
    end

     -- go ahead
    player.x = player.x + 100*dt
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, character_width, character_height) then
      player.x = player.x  - 100*dt --THIS MAKES THE SQUIRREL STOP MOVING FORWARD IF IT RUNS INTO SOMEHTING
    end
    
    gCamX = player.x
    gCamY = player.y
  
    draw_screen()
  else
   -- game_over()
    --print ("YOU LOST!!")
  end
end

function draw_screen()
  screen:clear()
  background = gfx.loadpng("images/level_sky.png")
  screen:copyfrom(background,nil,nil)
  background:destroy()

  -- LOOP THROUGH FLOOR TILES AND CALL DRAW FUNCTION 
  --for k,v in pairs(floors) do 
    --draw_tile(v, pos_change)
  --end
  --pos_change = pos_change + floor_speed
  
  draw_tiles(gCamX,gCamY)

  -- THE GAME CHARACTER IS COPIED TO THE SCREEN
  screen:copyfrom(character:get_surface(), nil,{x=player.x,y=player.y},true)
  
  gfx.update()

  --- Get a green screen but can't change the color
  --screen:clear({r=72,g=72,b=72})

end

function draw_tile(tile, pos_change) 
  screen:copyfrom(tile_surface, nil, {x=tile.x - pos_change, y=tile.y, width=tile.width, height=tile.height})
end

function game_navigation(key, state)
  if key=="ok" and state== 'up' then
    character:flip()
    if direction_flag == "down" then
      ToTop()
      --player.y = player.y - 10
      --if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
       -- player.y = player.y + 10
      --end
      direction_flag="up"
    else
      ToBottom()
      --player.y = player.y + 10
      --if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
       -- player.y = player.y - 20
      --end
      direction_flag="down"
    end
  elseif key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    stop_game()
    change_global_game_state(0)
    set_menu_state("pause_menu")
    start_menu()
  end
end 



