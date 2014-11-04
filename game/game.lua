-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'


--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"
require "game/level"
require ("game/physic")
require ("game/level_module")
require ("tool_box/character_object")

gKeyPressed = {}
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
local gameCounter=0
local image1 = nil
local image2 = nil
function start_game() 

 --TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  Level.load_level(1)
  if character==nil then
    character = character_object(character_width,character_height,imageDir.."character/squirrel1.png")
    character:add_image(imageDir.."character/squirrel2.png")
    character:add_flipped_image(imageDir.."character/squirrel1_flipped.png")
    character:add_flipped_image(imageDir.."character/squirrel2_flipped.png")
  else
    character:reset()
    ToBottom()
    direction_flag="down"
  end
  player.cur_x = 330
  player.cur_y = 450 
  image1 = gfx.loadpng(imageDir.."floor1.png")
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(100, "update_game_character")
  pos_change = 0
  lives = 10

end

function resume_game()   
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


-- UPDATES THE TILE MOVEMENT BY MOVING THEM DEPENDING ON THE VALUE OF THE GAMECOUNTER
function update_cb() 
  screen:clear()
  local sf = nil
    for k,v in pairs(Level.tiles) do     
        if((v.x-gameCounter)+v.width>=0) then          
          screen:copyfrom(image1,nil,{x=v.x-gameCounter,y=v.y,width=v.width,height=v.height})
          gfx.update()
        end
    end
  gameCounter=gameCounter+5  
  
end

function draw_screen()
  screen:clear()
  background = gfx.loadpng("images/level_sky.png")
  screen:copyfrom(background,nil,nil)
  background:destroy()
  
  draw_tiles(player.new_x,player.new_y)

  -- THE GAME CHARACTER IS COPIED TO THE SCREEN
  screen:copyfrom(character:get_surface(), nil,{x=player.new_x,y=player.new_y},true)
  
  gfx.update()

end


function game_navigation(key, state)
  if key=="ok" and state== 'up' then
    if direction_flag == "down" then
       if hitTest(player.cur_x, player.cur_y+1, character_width, character_height) ~= nil then
        character:flip()
        ToTop()
        direction_flag="up"
      end
    else
      if hitTest(player.cur_x, player.cur_y-1, character_width, character_height) ~= nil then
        character:flip()
        ToBottom()
        direction_flag="down"
      end
    end
  elseif key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    stop_game()
    change_global_game_state(0)
    set_menu_state("pause_menu")
    start_menu()
  end
end 



