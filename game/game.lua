-- version 1.0

-- require("squirrel_game.menu")
-- enter_menu()

-- dir = 'squirrel_game/'

--package.path = package.path .. arg[1] .. "\\game\\?.lua"
--package.path = package.path .. "C:\\TDDC88\\gameproject\\api_squirrel_game\\?.lua"

require ("game/level_handler")
require ("game/collision_handler")
require ("game/fail_and_success_handler")
require ("tool_box/character_object")
require ("game/score")
require ("game/power_up")

local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local ok_button_character=nil
local direction_flag="down" -- KEEPS TRACK OF WHAT WAY THE SQUIRREL I MOVING
local gameCounter=0
local gameSpeed = 10 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local current_level
local image1 = nil
local image2 = nil
local current_game_type=nil
local upper_bound_y = 700 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local lower_bound_y = 0 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE

-- STARTS GAME LEVEL level_number IN EITHER tutorial OR story MODE
function start_game(level_number,game_type,life) 
  game_score = 10000
  current_level = level_number --TO BE PLACED SOMEWHERE ELSE
  gameCounter=0
  current_game_type=game_type
  Level.load_level(level_number,current_game_type)
  load_level_atttributes()

  create_game_character()

  if current_game_type=="tutorial" then
    require("game/tutorial/tutorial_handler")
    create_tutorial_helper(level_number)
  end
  
  set_character_start_position()
  timer = sys.new_timer(20, "update_game")
  pos_change = 0
  lives = life
  player.invulnerable = false


end
 
-- LOADS THE LEVEL ATTRIBUTES IF THERE ARE ANY SPECIFIED IN THE LEVEL INPUT FILE
function load_level_atttributes()
  if (Level.attributes ~= nil) then
    gameSpeed = Level.attributes.speed
    upper_bound_y = Level.attributes.upper_bound_y
    lower_bound_y = Level.attributes.lower_bound_y
  end
end

function resume_game()   
  timer = sys.new_timer(20, "update_game")
  change_character_timer = sys.new_timer(200, "update_game_character")
end

function restart_game()
  gameCounter=0
  set_character_start_position()
  change_character_timer = sys.new_timer(200, "update_game_character")
  pos_change = 0
  end

function stop_game()
  if timer~=nil then
    timer:stop()
    timer = nil
  end
  if change_character_timer~=nil then
    change_character_timer:stop()
    change_character_timer=nil 
  end  
  -- the 1 represent the current level bein played, should be made generic as soon as possible
  score_page("Squirrel killer", game_score, 4)
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
  player.start_ypos=40 -- WHARE WE WANT THE CHARACTER TO BE ON THE Y-AXIS WHEN HE STARTS
  player.cur_x = 50
  player.cur_y = player.start_ypos
  player.new_x = player.cur_x -- INITIALLY NEW X-POS IS THE SAME AS CURRENT POSITION
  player.new_y = player.cur_y -- INITIALLY NEW Y-POS IS THE SAME AS CURRENT POSITION
end

-- UPDATES THE TILE MOVEMENT BY MOVING THEM DEPENDING ON THE VALUE OF THE GAMECOUNTER
function update_game() 
  -- if lives > 0 then
  -- if game_score > 0 then

  screen:clear()
  draw_screen()
  if game_score > 0 then
    game_score = game_score -10
  else
    -- GAME IS LOST
    end
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
      if player.cur_x<-1 then -- CHARACTER HAS GOTTEN STUCK AND GET SQUEEZED BY THE TILES
        get_killed()
      end
      return
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
      if (player.new_y > upper_bound_y or player.new_y < lower_bound_y) then -- CHARACTER HAS GOTTEN OUT OF RANGE
        get_killed()
        break;
      end
      if hitTest(gameCounter, Level.tiles, player.cur_x, player.new_y, character.width, character.height)==nil then
        player.cur_y = player.new_y -- MOVE CHARACTER DOWNWARDS IF IT DOESN'T HIT ANYTHING
      else
        break
      end
    end  
end

--the function that draws the score and the level
function draw_score()
  --DRAWS SCORE
  if global_game_state == 1 then --game situation, place score in the upper left corner of the screen
    xplace = 10
    yplace = 10
  elseif global_game_state == 0 then --menu situation, place score in the center of the screen
    xplace = 550
    yplace = 370
  end
  local string_score = tostring(game_score)
  position = 1 -- Position of the digit (position 1 = 1, 2 = 10,3 = 100, ...)
  -- loops through the score that is stored as a string
  while position <= string.len(string_score) do
    -- calls on the print function for the digit, sends the number as a string
    draw_number(string.sub(string_score,position,position),position, xplace, yplace)
    position = position + 1
  end
  
  --DRAWS LEVEL
  if global_game_state == 1 then --game situation, place level in the upper right corner of the screen
    xplace = 1000
    yplace = 10
  elseif global_game_state == 0 then --menu situation, place level in the center of the screen
    xplace = 550
    yplace = 300
  end
  local string_levelCounter = tostring(current_level)
  position = 1 -- Position of the digit (position 1 = 1, 2 = 10,3 = 100, ...)
  -- loops through the levelCounter that is stored as a string
  while position <= string.len(string_levelCounter) do
    -- calls on the print function for the digit, sends the number as a string
    draw_number(string.sub(string_levelCounter,position,position),position, xplace, yplace)
    position = position + 1
  end
  
end

--isn't this a copy of the function in score.lua?
function draw_number(number, position, xplace, yplace)
-- loads the picture corresponding to the correct digit
  if number == "0"  then score = gfx.loadpng("images/numbers/zero.png")
  elseif number == "1" then 
    score = gfx.loadpng("images/numbers/one.png")
  elseif number == "2" then 
    score = gfx.loadpng("images/numbers/two.png")
  elseif number == "3" then 
    score = gfx.loadpng("images/numbers/three.png")
  elseif number == "4" then 
    score = gfx.loadpng("images/numbers/four.png")
  elseif number == "5" then 
    score = gfx.loadpng("images/numbers/five.png")
  elseif number == "6" then 
    score = gfx.loadpng("images/numbers/six.png")
  elseif number == "7" then 
    score = gfx.loadpng("images/numbers/seven.png")
  elseif number == "8" then 
    score = gfx.loadpng("images/numbers/eight.png") 
  elseif number == "9" then 
    score = gfx.loadpng("images/numbers/nine.png")
  end
  -- prints the loaded picture
  screen:copyfrom(score,nil ,{x=xplace+position*30, y = yplace, height = 50, width = 30}, true)
  score:destroy()

end

function draw_screen()
 --draw_background()
  draw_tiles()
  move_character()
  draw_character()
  draw_score(game_score)
  draw_lives()
  if current_game_type=="tutorial" then
    draw_tutorial_helper()
  end
  gfx.update()
end

function draw_background()
  --background = gfx.loadpng("images/level_sky.png")
  screen:copyfrom(background,nil,nil)
  --background:destroy()
end

--[[ 
LOOPS THROUGH TILES AND DRAWS THEM ON SCREEN
WHERE THE TILES ARE DRAWN DEPENDS ON THE gameCounter WHICH STARTS TO COUNT FROM 0 WHEN THE GAME STARTS
THE TILES ARE DRAWN ON THEIR ORIGINAL X-POSITION - gameCounter
]]  
function draw_tiles()
  local sf = nil
    for k,v in pairs(Level.tiles) do
      if v.x-gameCounter+v.width>0 and v.visibility==true then
        if v.gid == 9 then
          move_cloud(v)
        elseif v.gid == 10 then
          move_flame(v)
        end
        screen:copyfrom(v.image,nil,{x=v.x-gameCounter,y=v.y,width=v.width,height=v.height},true)
      end
    end
end

--[[
@desc: Handles the movement of a singular cloud up and down the screen (no collision detection used). Should be called at some point before or during draw_tiles.
@params: cloud - a tile object identified as a cloud
]]
function move_cloud(cloud)
  if(cloud.directionTimer == nil) then
    cloud.directionTimer = 0
  end
  cloud.directionTimer = cloud.directionTimer + 1
  if(cloud.directionTimer >= 20) then
    cloud.up = not cloud.up
    cloud.directionTimer = 0
  end
  if(cloud.up == true) then
    cloud.y = cloud.y + 8
  else
    cloud.y = cloud.y - 8
  end
end

--[[
@desc: Handles the movement of a singular fireball from the right side of the screen towards the character.
@params: flame - A tile object identified as a flame.
]]
function move_flame(flame)
  local distanceToRightEdge = 1080 --1280 (screen width) minus player's relative screen position.
  local distanceToLeftEdge = 232 --200 (character position) minus tile pixel size
  if(flame.x - gameCounter < player.cur_x + distanceToRightEdge and flame.x - gameCounter > player.cur_x - distanceToLeftEdge) then -- Checks if the flame object is currently on-screen.
    flame.x = flame.x - gameSpeed*2.5    
  end
end

--[[
DRAWS THE GAME CHARACTER ON SCREEN
]]
function draw_character()
  screen:copyfrom(character:get_surface(), nil,{x=player.cur_x,y=player.cur_y},true)
end


function draw_lives()
  life = gfx.loadpng("images/Game-hearts-icon.png")
  for i=0, lives-1, 1 do
  screen:copyfrom(life,nil,{x=200+30*i,y=20},true)
  end
  life:destroy()
end

function check_alive()
  if lives>1 then
  return true
else
  return false
end
end
function decrease_life()
  print(lives)
  lives = lives-1
end

function get_lives()
  return lives  
end


function game_navigation(key, state)
  if key=="ok" and state== 'down' then
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
    start_menu("pause_menu")
  elseif key=="green" and state=='up' then --TO BE REMOVED - FORCES THE LEVELWIN MENU TO APPEAR BY CLICKING "W" ON THE COMPUTER OR "GREEN" ON THE REMOTE
    levelwin()
  end

  if current_game_type=="tutorial" and state=='up' then
      update_tutorial_handler(key)
  end
end 

function change_game_speed(new_speed, time)
  gameSpeed = new_speed
  speed_timer = sys.new_timer(time, "reset_game_speed")
end

--[[
@desc: Makes the player character invulnerable (i.e. unable to die from touching obstacles).
@params: time - Time (in milliseconds) to apply invulnerability.
]]
function activate_invulnerability(time)
  if(player.invulnerable) then
    return
  else
    player.invulnerable = true
    invul_timer = sys.new_timer(time, "end_invulnerability")
  end
end

--[[
@desc: Public getter for player local attribute "invulnerable".
@return: (bool) Whether or not the character is currently invulnerable.
]]
function get_invulnerability_state()
  return player.invulnerable
end

--[[
@desc: Ends invulnerability by setting the player.invulnerable flag to false. Called by system timer, which is stopped.
]]
function end_invulnerability()
  player.invulnerable = false
  invul_timer:stop()
end

function reset_game_speed()
  gameSpeed = 10
  speed_timer:stop()
  end
