-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'

--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"

require "game/level_handler"
require "game/collision_handler"
require ("tool_box/character_object")
require ("game/score")
require ("game/power_up")


local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local ok_button_character=nil
local direction_flag="down" -- KEEPS TRACK OF WHAT WAY THE SQUIRREL I MOVING
local background
local gameCounter=0
local gameSpeed = 5
local image1 = nil
local image2 = nil

local current_game_type=nil
-- STARTS GAME LEVEL level_number IN EITHER tutorial OR story MODE
function start_game(level_number,game_type) 
  game_score = 10000
  gameCounter=0
  current_game_type=game_type
  Level.load_level(level_number,current_game_type)
  create_game_character()
  if current_game_type=="tutorial" then
    require("tutorial/tutorial_handler")
    create_tutorial_helper(level_number)
  end
  set_character_start_position()
  image1 = gfx.loadpng(imageDir.."floor1.png")
  timer = sys.new_timer(20, "update_cb")
  pos_change = 0
  lives = 10
end

function resume_game()   
  timer = sys.new_timer(20, "update_cb")
  change_character_timer = sys.new_timer(200, "update_game_character")
end

function stop_game()
  --screen:clear()
  if timer~=nil then
    timer:stop()
    timer = nil
  end
  if change_character_timer~=nil then
    change_character_timer:stop()
    change_character_timer=nil 
  end  
  -- character name is only 3 characters no
  score_page("pl1", game_score)
end

function create_game_character()
  if character==nil then
    character = character_object(32,32,imageDir.."character/squirrel1.png")
    character:add_image(imageDir.."character/squirrel2.png")
    character:add_flipped_image(imageDir.."character/squirrel1_flipped.png")
    character:add_flipped_image(imageDir.."character/squirrel2_flipped.png")
  else
    character:reset()
    direction_flag="down"
  end
  change_character_timer = sys.new_timer(200, "update_game_character")
end



function update_game_character()
  character:destroy() -- DESTROYS THE CHARACTER'S SURFACE SO THAT NEW UPDATES WON'T BE PLACED ONTOP OF IT
  character:update()  -- UPDATES THE CHARACTERS BY CREATING A NEW SURFACE WITH THE NEW IMAGE TO BE DISPLAYED
end

function set_character_start_position()
  player.start_xpos=200 -- WHERE WE WANT THE CHARACTER TO BE ON THE X-AXIS WHEN HE IS NOT PUSHED BACK
  player.start_ypos=0 -- WHARE WE WANT THE CHARACTER TO BE ON THE Y-AXIS WHEN HE STARTS
  player.cur_x = 50
  player.cur_y = player.start_ypos
  player.new_x = player.cur_x -- INITIALLY NEW X-POS IS THE SAME AS CURRENT POSITION
  player.new_y = player.cur_y -- INITIALLY NEW Y-POS IS THE SAME AS CURRENT POSITION
end

-- UPDATES THE TILE MOVEMENT BY MOVING THEM DEPENDING ON THE VALUE OF THE GAMECOUNTER
function update_cb() 
  -- if lives > 0 then
  -- if game_score > 0 then

  screen:clear()
  draw_screen()
 -- if game_score > 0 then
 --   game_score = game_score -10
 -- else
 --   print ("you lost!")
 --   end
  gameCounter=gameCounter+gameSpeed -- CHANGES GAME SPEED FOR NOW  
end

function update_score()
    game_score = game_score - 1
end


function move_character()
  -- MOVE CHARACTER ON THE X-AXIS
  -- LOOP OVER EACH PIXEL THAT THE CHARACTER IS ABOUT TO MOVE AND CHECK IF IT HIT HITS SOMETHING
    player.new_x=player.cur_x+1
    if hitTest(gameCounter, Level.tiles, player.new_x, player.cur_y, character.width, character.height)~=nil then
      player.cur_x = player.cur_x-gameSpeed -- MOVING THE CHARACTER BACKWARDS IF IT HITS SOMETHING
      if player.cur_x<-1 then
        trigger_squize_reaction() -- THIS FUNTION IS TRIGGERED WHEN THE CHARACTER HAS GOTTEN STUCK AND GET SQUEEZED BY THE TILES
        --break
      end
    elseif player.cur_x<player.start_xpos then
      player.cur_x = player.cur_x+0.5*gameSpeed -- RESETS THE CHARACTER TO player.start_xpos IF IS HAS BEEN PUSHED BACK AND DOESN'T HIT ANYTHING ANYMORE
    end

  -- MOVE CHARACTER ON THE Y-AXIS
    for i=0, gameSpeed, 1 do
      if direction_flag == "down" then 
        player.new_y=player.cur_y+i
      else
        player.new_y=player.cur_y-i
      end
      if hitTest(gameCounter, Level.tiles, player.cur_x, player.new_y, character.width, character.height)==nil then
        player.cur_y = player.new_y -- MOVE CHARACTER DOWNWARDS IF IT DOESN'T HIT ANYTHING
      else
        break
      end
    end  
end


--the function that draws the score in the top left score 
function draw_screen()
  --draw_background()
  draw_tiles()
  move_character()
  draw_character()
  draw_score(game_score)
  if current_game_type=="tutorial" then
    draw_tutorial_helper()
  end
  gfx.update()
end

function draw_background()
  background = gfx.loadpng("images/level_sky.png")
  screen:copyfrom(background,nil,nil)
  background:destroy()
end

--[[ 
LOOPS THROUGH TILES AND DRAWS THEM ON SCREEN
WHERE THE TILES ARE DRAWN DEPENDS ON THE gameCounter WHICH STARTS TO COUNT FROM 0 WHEN THE GAME STARTS
THE TILES ARE DRAWN ON THEIR ORIGINAL X-POSITION - gameCounter
]]  
function draw_tiles()
  local sf = nil
    for k,v in pairs(Level.tiles) do
      if v.x-gameCounter+v.width>0 then 
        screen:copyfrom(image1,nil,{x=v.x-gameCounter,y=v.y,width=v.width,height=v.height})
      end
    end
end

--[[
DRAWS THE GAME CHARACTER ON SCREEN
]]
function draw_character()
  screen:copyfrom(character:get_surface(), nil,{x=player.cur_x,y=player.cur_y},true)
end


function trigger_squize_reaction()
  stop_game()
  screen:copyfrom(character:get_surface(), nil,{x=player.cur_x,y=player.cur_y},true)
end

function levelwin() -- TO BE CALLED WHEN A LEVEL IS ENDED. CALLS THE LEVELWIN MENU
  set_menu_state(levelwin_menu)
  start_menu()
end

function game_navigation(key, state)
  if key=="ok" and state== 'up' then
    if direction_flag == "down" then
       if hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y+1, character.width, character.height) ~= nil then
        character:flip()
        direction_flag="up"
      end
    else
      if hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y-1, character.width, character.height) ~= nil then
        character:flip()
        direction_flag="down"
      end
    end
  elseif key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    stop_game()
    change_global_game_state(0)
    set_menu_state("pause_menu")
    start_menu()
  end

  if current_game_type=="tutorial" and state=='up' then
      update_tutorial_handler(key)
  end
end 



