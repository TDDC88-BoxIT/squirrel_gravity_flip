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
require("game/tutorial/tutorial_handler")

local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local ok_button_character=nil
local direction_flag="down" -- KEEPS TRACK OF WHAT WAY THE SQUIRREL I MOVING
local gameCounter=0
local gameSpeed = 10 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local current_level
local gameBackground=nil
local number_image={}
local image1 = nil
local image2 = nil
local current_game_type=nil
local upper_bound_y = 700 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local lower_bound_y = 0 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local G=2;     --gravity
local Tcount=1

-- STARTS GAME LEVEL level IN EITHER tutorial OR story MODE
function start_game(level,game_type,life) 
  game_score = 10000
  gameCounter=0

  if game_type ~= "current" then
    current_game_type=game_type
  end

  if level=="first" then
    current_level = 1
  elseif level=="next" then
    current_level = current_level+1
  end
  
  Level.load_level(current_level,current_game_type)

  prepare_fail_success_handler()

  load_level_atttributes()
  load_image_if_needed()

  create_game_character()

  if current_game_type=="tutorial" then
    create_tutorial_helper(current_level)
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

function load_image_if_needed()
  if (gameBackground == nil) then
    gameBackground = gfx.loadpng("images/level_sky.png")
  end
  if life == nil then
    life = gfx.loadpng("images/Game-hearts-icon.png")
  end

  if number_image["0"] == nil then
    number_image["0"] = gfx.loadpng("images/font/0.png")
    number_image["1"] = gfx.loadpng("images/font/1.png")
    number_image["2"] = gfx.loadpng("images/font/2.png")
    number_image["3"] = gfx.loadpng("images/font/3.png")
    number_image["4"] = gfx.loadpng("images/font/4.png")
    number_image["5"] = gfx.loadpng("images/font/5.png")
    number_image["6"] = gfx.loadpng("images/font/6.png")
    number_image["7"] = gfx.loadpng("images/font/7.png")
    number_image["8"] = gfx.loadpng("images/font/8.png")
    number_image["9"] = gfx.loadpng("images/font/9.png")
    number_image["0"]:premultiply()
    number_image["1"]:premultiply()
    number_image["2"]:premultiply()
    number_image["3"]:premultiply()
    number_image["4"]:premultiply()
    number_image["5"]:premultiply()
    number_image["6"]:premultiply()
    number_image["7"]:premultiply()
    number_image["8"]:premultiply()
    number_image["9"]:premultiply()
  end
end

function destroy_image()
  if gameBackground ~= nil then
    gameBackground:destroy()
    gameBackground = nil
  end
  if life ~= nil then
    life:destroy()
    life = nil
  end
  -- Should destroy number_image here.
  -- But level_win -> draw_menu will use the varables.
end

function resume_game()
  load_image_if_needed()
  timer = sys.new_timer(20, "update_game")
  change_character_timer = sys.new_timer(200, "update_game_character")
end

function stop_game()
  if timer~=nil then
    timer:stop()
    timer = nil
  end
  if speed_timer ~= nil then
    reset_game_speed()
  end
  destroy_image()
  if change_character_timer~=nil then
    change_character_timer:stop()
    change_character_timer=nil 
  end  
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
  player.work_xpos= 200 -- WHERE WE WANT THE CHARACTER TO BE ON THE X-AXIS WHEN HE IS NOT PUSHED BACK
  player.cur_x = Level.character_start_pos_x 
  player.cur_y = Level.character_start_pos_y
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
    print("Death caused by score == 0")
    get_killed()
    return
  end
  gameCounter=gameCounter+gameSpeed -- CHANGES GAME SPEED FOR NOW  
end

function update_score()
    game_score = game_score - 1
end


function move_character()
  -- MOVE CHARACTER ON THE X-AXIS
  -- LOOP OVER EACH PIXEL THAT THE CHARACTER IS ABOUT TO MOVE AND CHECK IF IT HIT HITS SOMETHING
  local falling=0
    player.new_x=player.cur_x+1
    if hitTest(gameCounter, Level.tiles, player.new_x, player.cur_y, character.width, character.height)~=nil then  
      player.cur_x = player.cur_x-gameSpeed -- MOVING THE CHARACTER BACKWARDS IF IT HITS SOMETHING
      if player.cur_x<-1 then -- CHARACTER HAS GOTTEN STUCK AND GET SQUEEZED BY THE TILES
        print("Death caused by getting squeezed")
        get_killed()
        return
      end
    elseif player.cur_x<player.work_xpos then
      player.cur_x = player.cur_x+0.5*gameSpeed -- RESETS THE CHARACTER TO player.work_xpos IF IS HAS BEEN PUSHED BACK AND DOESN'T HIT ANYTHING ANYMORE
    end

  -- MOVE CHARACTER ON THE Y-AXIS
    for i=0, gameSpeed, 1 do
      if direction_flag == "down" then 
        player.new_y=player.cur_y+i
      else
        player.new_y=player.cur_y-i
      end
      if (player.new_y > upper_bound_y or player.new_y < lower_bound_y) then -- CHARACTER HAS GOTTEN OUT OF RANGE
        print("Death caused by falling off grid")
        get_killed()
        return;
      end
      if hitTest(gameCounter, Level.tiles, player.cur_x, player.new_y, character.width, character.height)==nil or falling==1 then
        player.cur_y = player.new_y -- MOVE CHARACTER DOWNWARDS IF IT DOESN'T HIT ANYTHING
      else
        break
      end
    end  
end


--[[
@desc: Activates a collidable object (power-up, power-down or obstacle) and lets the game react to it.
@params: pu_name - The name (as defined in level files) of the object to activate.
]]
function activate_power_up(pu_name)
  --[[
  This prevents additional powerup events from being fired if the game is over (if you die).
  Previously, hitting two or more obstacles at the same time (easily done on level4) would cause the game to try
  and destroy the surface twice, throwing a runtime exception.
  ]]
  player_name = get_player_name()
  print("playername == " .. player_name)
  if(pu_name=="powerup1") then -- Score tile
    game_score = game_score + 100
  elseif(pu_name=="powerup2") then -- Speed tile
    change_game_speed(15,1000)
  elseif(pu_name=="powerup3") then -- Freeze tile
    change_game_speed(1,1000)    
  elseif(pu_name=="powerup4") then -- Invulnerability tile
    activate_invulnerability(10000)
  elseif(pu_name == "win") then -- Win tile!
    -- the 1 represent the current level bein played, should be made generic as soon as possible
    if player_name == "" then
      player_name= "AAA"
    end
    score_page(player_name, game_score, 1)
    draw_highscore(1,620)
    levelwin()
  elseif((pu_name == "obstacle1" or pu_name == "obstacle2" or pu_name == "obstacle3" or pu_name == "obstacle4") and not get_invulnerability_state()) then -- Obstacles
    get_killed() -- This NEEDS to be changed to the actual fail screen when that has been implemented
  end
end


function move_character_V2()
  local falling=0
  -- MOVE CHARACTER ON THE X-AXIS
  -- LOOP OVER EACH PIXEL THAT THE CHARACTER IS ABOUT TO MOVE AND CHECK IF IT HIT HITS SOMETHING
  if hitTest(gameCounter, Level.tiles, player.cur_x+1, player.cur_y, character.width, character.height)~=nil then
    player.cur_x = player.cur_x-gameSpeed -- MOVING THE CHARACTER BACKWARDS IF IT HITS SOMETHING 
    --This part is checking if the hero hit the tail by right side 
    if (direction_flag == "down" and hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y+1, character.width, character.height)==nil) or 
    (direction_flag == "up" and hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y-1, character.width, character.height)==nil)then  
      falling=1
    end
    if player.cur_x<-1 then -- CHARACTER HAS GOTTEN STUCK AND GET SQUEEZED BY THE TILES
      print("Death caused by getting squeezed") 
      get_killed()
    end
  elseif player.cur_x<player.work_xpos then
      player.cur_x = player.cur_x+0.5*gameSpeed -- RESETS THE CHARACTER TO player.work_xpos IF IS HAS BEEN PUSHED BACK AND DOESN'T HIT ANYTHING ANYMORE
  end

  --[[ MOVE CHARACTER ON THE Y-AXIS
    S=(G*t^2)/2 
    There has a rule that, F(t)=t^2, F(t)-F(t-1)=2t-1 
    We can get S(t)-S(t-1)=(G*(2t-1))/2
    ]]
  if direction_flag == "down" then 
    player.new_y=player.cur_y+0.5*G*(Tcount+0.5+gameSpeed)--since 2t-1 is looks to slow at the beginning and too fast at the end, so use t-1 here
  else       
    player.new_y=player.cur_y-0.5*G*(Tcount+0.5+gameSpeed)
  end
  if (player.new_y > upper_bound_y or player.new_y < lower_bound_y) then -- CHARACTER HAS GOTTEN OUT OF RANGE
    print("Death caused by falling off grid")
    get_killed()   
  end
  local W,H,B_T,B_B=hitTest(gameCounter, Level.tiles, player.cur_x, player.new_y, character.width, character.height)
  if W==nil or falling==1 then
    Tcount=Tcount+1  
    player.cur_y = player.new_y -- MOVE CHARACTER DOWNWARDS IF IT DOESN'T HIT ANYTHING
  else
    if direction_flag == "down" then 
      player.cur_y=B_T-32
      Tcount=1
    else
      player.cur_y=B_B
      Tcount=1
    end
  end     
end


--the function that draws the score and the level

function call_draw_score()
  --DRAWS SCORE
  if global_game_state==0 and get_menu_state() == "gameover_menu" then -- Don't draw score on gameover menu
    return
  end
  if global_game_state == 1 then --game situation, place score in the upper left corner of the screen
    xplace = 10
    yplace = 10
  elseif global_game_state == 0 then --menu situation, place score in the center of the screen
    xplace = 200
    yplace = 10
  end
  draw_score(tostring(game_score), xplace,yplace)
  
  --DRAWS LEVEL
  if global_game_state == 1 then --game situation, place level in the upper right corner of the screen
    xplace = 1000
    yplace = 10
  elseif global_game_state == 0 then --menu situation, place level in the center of the screen
    xplace = 100
    yplace = 10
  end
  draw_score(tostring(current_level), xplace,yplace)
end



function draw_screen()
  -- Measure the game speed of each function in millisecond.
  -- Remove the -- to trace and optimize.
  move_character_V2()
  if timer~=nil then
    --local t = sys.time()
    draw_background()
    --print(string.format("gameBackground %d", ((sys.time() - t)) * 1000))
    draw_tiles()
    --print(string.format("Draw_tiles %d", ((sys.time() - t)) * 1000))
    --print(string.format("Move_character %d", ((sys.time() - t)) * 1000))
    draw_character()
    --print(string.format("Draw_character %d", ((sys.time() - t)) * 1000))
    call_draw_score()
    --print(string.format("Draw_score %d", ((sys.time() - t)) * 1000))
    draw_lives()
    --print(string.format("Draw_lives %d", ((sys.time() - t)) * 1000))
    
    if current_game_type=="tutorial" then
      draw_tutorial_helper()
      --print(string.format("Draw_tutorial_helper %d", ((sys.time() - t)) * 1000))
    end
  end
  gfx.update()
end

function draw_background()
  screen:copyfrom(gameBackground,nil,nil)
end

--[[ 
LOOPS THROUGH TILES AND DRAWS THEM ON SCREEN
WHERE THE TILES ARE DRAWN DEPENDS ON THE gameCounter WHICH STARTS TO COUNT FROM 0 WHEN THE GAME STARTS
THE TILES ARE DRAWN ON THEIR ORIGINAL X-POSITION - gameCounter
]]  
function draw_tiles()
  local sf = nil
    for k,v in pairs(Level.tiles) do
      -- This code can't run properly on the box because the difference 
      -- of screen:copyfrom function . Wait for further improvement
      if v.x-gameCounter+v.width>0 and v.visibility==true and v.x-gameCounter+v.width<screen:get_width() + v.width then
        if v.gid == 9 then
          move_cloud(v)
        elseif v.gid == 10 then
          move_flame(v)
        end
        if v.image == nil then
          print("super wrong")
          v.image = gfx.loadpng("images/font/Z.png")
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
  for i=0, lives-1, 1 do
    screen:copyfrom(life,nil,{x=200+30*i,y=20},true)
  end
end

function check_alive()
  if lives>1 then
  return true
else
  return false
end
end
function decrease_life()
  --print(lives)
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
    activate_power_up("win")
    levelwin()
  elseif key=="star" and state=="up" then -- Testing purposes (S on keyboard). Should probably be commented out at some point.
    game_score = game_score + 1000
  elseif key=="multi" and state=="up" then -- Testing purposes (A on keyboard). Should probably be commented out at some point.
    if game_score - 1000 >= 0 then
      game_score = game_score - 1000
    else
      game_score = 0
    end
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
