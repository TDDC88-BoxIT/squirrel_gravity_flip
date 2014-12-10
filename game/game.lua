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
require("game/power_up")

local imageDir = "images/"
local mapDir = "map/"
player = {}
character = nil
local ok_button_character=nil
local direction_flag="down" -- KEEPS TRACK OF WHAT WAY THE SQUIRREL I MOVING
local gameCounter=0
local gameSpeed = 10 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local current_level
local gameBackground=nil
local image1 = nil
local image2 = nil
local current_game_type=nil
local upper_bound_y = 700 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local lower_bound_y = 0 -- DEFAULT VALUE IF NOT SPECIFIED IN LEVEL INPUT FILE
local G=3;     --gravity
local Tcount=1
--local touchGround = false
local onscreen_buffer
local w0 = screen:get_width()
local h0 = screen:get_height()
pending_redraw={}

-- tileset_start and tileset_end mantain the current tiles that displayed to screen based on gameCounter.
tileset_start = 0
tileset_end = 0

number_image={}


-- STARTS GAME LEVEL level IN EITHER tutorial OR story MODE
function start_game(level,game_type,life) 
  key_disabled = true
  gameCounter=0
  game_score=10000

  if game_type ~= "current" then
    current_game_type=game_type
  end

  if level=="next" then
    current_level = current_level+1
  elseif level == "restart" then

  else
    current_level = level
  end

  if Level.load_level(current_level,current_game_type)== "level_loaded" then
    prepare_fail_success_handler()
    load_font_images()
    create_game_character()
    update_tile_index()
    set_up_buffer()

    if current_game_type=="tutorial" then
      create_tutorial_helper(current_level)
    end
    set_character_start_position()
    timer = sys.new_timer(40, "update_game")
    pos_change = 0
    lives = life
    player.invulnerable = false
    reset_game_speed()
    end_invulnerability()
  else
    stop_game()
    change_global_game_state(0)
    start_menu("start_menu")
  end
  key_disabled = false
end

function load_font_images()
  if (gameBackground == nil) then
    if tonumber(current_level) == 1 then
      gameBackground = gfx.loadpng("images/city_background1.png")
    elseif tonumber(current_level) == 2 then
      gameBackground = gfx.loadpng("images/city_background1.png")
    elseif tonumber(current_level) == 3 then
      gameBackground = gfx.loadpng("images/city_background2.png")
    elseif tonumber(current_level) == 4 then
      gameBackground = gfx.loadpng("images/city_background3.png")
    elseif tonumber(current_level) == 5 then
      gameBackground = gfx.loadpng("images/underground_background1.png")
    elseif tonumber(current_level) == 6 then
      gameBackground = gfx.loadpng("images/underground_background1.png")
    elseif tonumber(current_level) == 7 then
      gameBackground = gfx.loadpng("images/underground_background2.png")
    elseif tonumber(current_level) == 8 then
      gameBackground = gfx.loadpng("images/underground_background3.png")
    elseif tonumber(current_level) == 9 then
      gameBackground = gfx.loadpng("images/underground_background4.png")
    elseif tonumber(current_level) == 10 then
      gameBackground = gfx.loadpng("images/underground_background5.png")
    else
      gameBackground = gfx.loadpng("images/underground_background1.png")
    end
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
  load_font_images()
  timer = sys.new_timer(40, "update_game")
  change_character_timer = sys.new_timer(200, "update_game_character")
  if get_speed_timer()~=nil then
    if character:get_state() == "boost" then
      change_game_speed(15, 3000)
    else
      change_game_speed(1, 3000)
    end
  end
  if get_invul_timer()~=nil then
    activate_invulnerability(10000)
  end
end

function stop_game()
  key_disabled = true
  if timer~=nil then
    timer:stop()
    timer = nil
  end
  reset_game_speed()
  end_invulnerability()
  destroy_image()
  destroy_buffer()
  if change_character_timer~=nil then
    change_character_timer:stop()
    change_character_timer=nil 
  end  
  key_disabled = false
end

function pause_game()
  if timer~=nil then
    timer:stop()
    timer = nil
  end
  destroy_image()
  if change_character_timer~=nil then
    change_character_timer:stop()
    change_character_timer=nil 
  end 
  local st = get_speed_timer()
  local it = get_invul_timer() 
  if st~=nil then
    st:stop()
  end
  if it~=nil then
    it:stop()
  end
end

function create_game_character()
  if character==nil then
    character = character_object(32,32,imageDir.."character/squirrel1.png")
    add_character_images()
  else
    character:reset()
    direction_flag="down"
  end
  change_character_timer = sys.new_timer(200, "update_game_character")
end

function add_character_images()
  -- ADD IMAGES FOR NORMAL MODE
  character:add_image(imageDir.."character/squirrel2.png","normal")
  character:add_flipped_image(imageDir.."character/squirrel1_flipped.png","normal")
  character:add_flipped_image(imageDir.."character/squirrel2_flipped.png","normal")

  -- ADD IMAGES FOR BOOST MODE
  character:add_image(imageDir.."character/squirrel1_boost.png","boost")
  character:add_image(imageDir.."character/squirrel2_boost.png","boost")
  character:add_flipped_image(imageDir.."character/squirrel1_flipped_boost.png","boost")
  character:add_flipped_image(imageDir.."character/squirrel2_flipped_boost.png","boost")
  
  -- ADD IMAGES FOR INVULNERABLE MODE
  character:add_image(imageDir.."character/squirrel1_invulnerable.png","invulnerable")
  character:add_image(imageDir.."character/squirrel2_invulnerable.png","invulnerable")
  character:add_flipped_image(imageDir.."character/squirrel1_flipped_invulnerable.png","invulnerable")
  character:add_flipped_image(imageDir.."character/squirrel2_flipped_invulnerable.png","invulnerable")
  
  -- ADD IMAGES FOR SLOW MODE
  character:add_image(imageDir.."character/squirrel1_slow.png","slow")
  character:add_image(imageDir.."character/squirrel2_slow.png","slow")
  character:add_flipped_image(imageDir.."character/squirrel1_flipped_slow.png","slow")
  character:add_flipped_image(imageDir.."character/squirrel2_flipped_slow.png","slow")
end

function update_game_character()
  character:destroy() -- DESTROYS THE CHARACTER'S SURFACE SO THAT NEW UPDATES WON'T BE PLACED ONTOP OF IT
  character:update()  -- UPDATES THE CHARACTERS BY CREATING A NEW SURFACE WITH THE NEW IMAGE TO BE DISPLAYED
end

function set_character_start_position()
  player.work_xpos= 300 -- WHERE WE WANT THE CHARACTER TO BE ON THE X-AXIS WHEN HE IS NOT PUSHED BACK
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
  update_tile_index()
  draw_screen()
  if game_score > 0 then
    if current_game_type ~= "tutorial" then
      game_score = game_score -10
    end
  else
    print("Death caused by score == 0")
    get_killed()
    return
  end
  gameCounter=gameCounter+gameSpeed -- CHANGES GAME SPEED FOR NOW
end

-- Update tileset_start and tileset_end based on gameCounter.
function update_tile_index()
  local istart = math.floor(gameCounter / Level.raw_level.tilewidth) * Level.raw_level.height
  local iend = math.ceil((gameCounter + screen:get_width()) / Level.raw_level.tilewidth) * Level.raw_level.height
  for i = istart, iend, 1 do
    istart = i
    if Level.map_table[i] ~=nil then
      break
    end
  end
  for i = iend, istart, -1 do
    iend = i
    if Level.map_table[i] ~=nil then
      break
    end
  end
  tileset_start = Level.map_table[istart]
  tileset_end = Level.map_table[iend]
end

-- find first index and last index of Level.tiles from the give x column.
-- Input: column number.
-- Output: first and last index of tiles that belong to given column.
function find_col_from_index(first_x)
  -- istart is first set the last index.
  local istart = first_x * Level.raw_level.height+1
  local iend = istart + 3*Level.raw_level.height - 1
  print("find_col_from_index, istart="..istart..", iend="..iend)
  for i = istart, iend, 1 do
    istart = i
    if Level.map_table[i] ~=nil then
      break
    end
  end
  for i = iend, istart, -1 do
    iend = i
    if Level.map_table[i] ~=nil then
      break
    end
  end
  itileset_start = Level.map_table[istart]
  itileset_end = Level.map_table[iend]
  if itileset_start~=nil and itileset_end ~= nil and itileset_start<itileset_end then
    return {itileset_start, itileset_end}
  else
    return {2, 1}
  end
end

buffer_size = 0
buffer_width = 32*3
curindex = 1

-- set up the tile buffer. malloc memory for each surface.
function set_up_buffer()
  onscreen_buffer={}
  buffer_size= math.ceil(w0/buffer_width) + 1
  for i = 1, buffer_size, 1 do
    onscreen_buffer[i] = gfx.new_surface(buffer_width, h0)
    onscreen_buffer[i]:clear()
  end
  for k = 1, #(Level.tiles), 1 do
    v = Level.tiles[k]
    if v.x >= buffer_width * buffer_size then
      break
    end
    if v.gid ~= 9 and v.gid ~= 10 then
      local curindex = (math.floor(v.x / buffer_width)) % buffer_size + 1
      onscreen_buffer[curindex]:copyfrom(v.image, nil, {x=v.x % buffer_width, y=v.y, width=v.width, height=v.height}, true)
    end
  end
end

-- Destroy buffer when stop or pause game.
function destroy_buffer()
  for i = 1, buffer_size, 1 do
    if onscreen_buffer[i]~=nil then
      onscreen_buffer[i]:destroy()
      onscreen_buffer[i] = nil
    end
  end
end
-- update certain buffer.
-- Input: redraw_index, the index of buffers that need to be redraw.
-- Input: first_x, the column number in that index buffer, used to find the tiles that need to be drawn.
function update_buffer(redraw_index, first_x)
  -- load new buffer
  local col = find_col_from_index(first_x)
  onscreen_buffer[redraw_index]:clear()
  for i=col[1], col[2], 1 do
    -- copy new tiles to one buffer
    local v = Level.tiles[i]
    if v.gid ~= 9 and v.gid ~= 10 and v.visibility == true then
      onscreen_buffer[redraw_index]:copyfrom(v.image, nil, {x=v.x % buffer_width, y=v.y, width=v.width, height=v.height}, true)
    end
  end
end

function draw_tiles()
  -- Step 1. check if we need load new buffer.
  local newindex = math.floor(gameCounter / buffer_width) + 1
  if newindex ~= curindex then
    local first_x = math.floor((gameCounter - gameCounter%buffer_width + buffer_width*(buffer_size-1))/32)
    update_buffer((newindex+buffer_size-2)%buffer_size+1, first_x)
    curindex = newindex
  end


  local left_start_x = gameCounter%buffer_width
  local left_width = buffer_width - left_start_x
  local right_width = (gameCounter+w0)%buffer_width
  local right_start_x = w0 - right_width

  -- Step 2, redraw the buffer who have tiles that has changes its visibility.
  local redraw_list = {}
  local redraw_list_x = {}
  for i=1, #(pending_redraw), 1 do

    local reindex = (math.floor(pending_redraw[i] / buffer_width)  )% buffer_size +1
    local dup = false
    for k=1, #(redraw_list), 1 do
      if redraw_list[k] == reindex then
        dup = true
      end
    end
    if dup == false then
      table.insert(redraw_list, reindex)
      redraw_list_x[reindex] = math.floor(pending_redraw[i]/32) - math.floor((pending_redraw[i]%buffer_width)/32)
    end
  end
  pending_redraw={}

  for k=1, #(redraw_list), 1 do
    update_buffer(redraw_list[k], redraw_list_x[redraw_list[k]])
  end

  -- Step 3, draw tiles that not move by draw the buffers.
  -- left one. we draw part of this tile.
  screen:copyfrom(onscreen_buffer[(curindex-1)%buffer_size+1],
    {x=left_start_x, y=0, width=left_width, height=h0},
    {x=0, y=0, width=left_width, height = h0}, true)

  local last_buffer = curindex - 2 + buffer_size
  local not_show_threshold = left_width + buffer_width*(buffer_size-2)
  if not_show_threshold > w0 then
    last_buffer = last_buffer - 1
  end

  -- middle ones. we draw the entire buffer
  for i=curindex +1, last_buffer, 1 do
    screen:copyfrom(onscreen_buffer[(i-1)%buffer_size + 1],
      nil,
      {x=(i-curindex -1)*buffer_width + left_width, y=0, width=buffer_width, height = h0}, true)
  end

  --right one. we draw part of this tile.
  if right_width > 0 then
    screen:copyfrom(onscreen_buffer[(last_buffer)%buffer_size+1],
      {x=0, y=0, width=right_width, height=h0},
      {x=right_start_x, y=0, width=right_width, height = h0}, true)
  end

  -- Step 4, draw other tiles individually
  draw_tiles_for_movable()
end


function update_score()
    game_score = game_score - 1
end

function move_character()
  local falling=0
  -- MOVE CHARACTER ON THE X-AXIS
  -- LOOP OVER EACH PIXEL THAT THE CHARACTER IS ABOUT TO MOVE AND CHECK IF IT HIT HITS SOMETHING
  local B_L, B_R, B_T, B_B = hitTest(gameCounter, Level.tiles, player.cur_x+1, player.cur_y, character.width, character.height)
  if B_L~=nil then
    if islevelWon() then
      return
    end
    player.cur_x =B_L-32
    --player.cur_x = player.cur_x-gameSpeed -- MOVING THE CHARACTER BACKWARDS IF IT HITS SOMETHING 
    --This part is checking if the hero hit the tail by right side 
    if (direction_flag == "down" and hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y+1, character.width, character.height)==nil) or 
    (direction_flag == "up" and hitTest(gameCounter, Level.tiles, player.cur_x, player.cur_y-1, character.width, character.height)==nil)then  
      falling=1
    end
    if (player.cur_x<-1) or (player.new_y > upper_bound_y or player.new_y < lower_bound_y) then -- CHARACTER HAS GOTTEN STUCK AND GET SQUEEZED BY THE TILES
      print("Death caused by getting squeezed") 
      get_killed()
      return
    end
  elseif player.cur_x<player.work_xpos then
      player.cur_x = player.cur_x+0.5*gameSpeed -- RESETS THE CHARACTER TO player.work_xpos IF IS HAS BEEN PUSHED BACK AND DOESN'T HIT ANYTHING ANYMORE
  end
  -- MOVE CHARACTER ON THE Y-AXIS
  if Tcount==1 or Tcount==4 then
    for k=Tcount,Tcount+2, 1 do
      player.new_y=Y_position()
      if (player.cur_y > upper_bound_y or player.cur_y < lower_bound_y) then -- CHARACTER HAS GOTTEN OUT OF RANGE
        print("Death caused by falling off grid")
        get_killed()
        return
      end
      Y_check(falling)
      if Tcount==1 then
        break
      end
    end
  else
    player.new_y=Y_position()
    if (player.cur_y > upper_bound_y or player.cur_y < lower_bound_y) then -- CHARACTER HAS GOTTEN OUT OF RANGE
      print("Death caused by falling off grid")
      get_killed()
      return
    end
      Y_check(falling)
  end
end

function Y_check(falling)
  --Check if the hero has collision with the tiles or not, and if there will be a collision, adjust the y_position to fit the object.
  local W,H,B_T,B_B=hitTest(gameCounter, Level.tiles, player.cur_x, player.new_y, character.width, character.height)
  if islevelWon() then
      return
  else
    if W==nil or (falling==1 and W==nil) then
      Tcount=Tcount+1
      player.cur_y = player.new_y -- MOVE CHARACTER DOWNWARDS IF IT DOESN'T HIT ANYTHING
      --touchGround = false
    else
      if direction_flag == "down" then
        player.cur_y=B_T-32
        Tcount=1
      else
        player.cur_y=B_B
        Tcount=1
      end
      --touchGround = true
    end
  end
end
--[[Gravity equation
    S=(G*t^2)/2 
    There has a rule that, F(t)=t^2, F(t)-F(t-1)=2t-1 
    We can get S(t)-S(t-1)=(G*(2t-1))/2]]
function Y_position() 
  if direction_flag == "down" then 
    player.new_y=player.cur_y+0.5*G*(Tcount-1+5)--since the curve is too sharp, use t-1 instead of 2t-1, and it need a start position 5
    if math.abs(player.new_y-player.cur_y)>32 then
      player.new_y=player.cur_y+32
    end
    return player.new_y
    
  else       
    player.new_y=player.cur_y-0.5*G*(Tcount-1+5)
    if math.abs(player.new_y-player.cur_y)>32 then
      player.new_y=player.cur_y-32
    end
    return player.new_y
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
  draw_score(current_level, xplace,yplace)
end



function draw_screen()
  -- Measure the game speed of each function in millisecond.
  -- Remove the -- to trace and optimize.
  move_character()
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
    if current_game_type=="tutorial" and tutorial_goal_is_fulfilled()==false then
      draw_tutorial_helper()
      --print(string.format("Draw_tutorial_helper %d", ((sys.time() - t)) * 1000))
    end
  end
  gfx.update()
end

function draw_background()
  screen:copyfrom(gameBackground,nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()})
end

--[[
LOOPS THROUGH TILES AND DRAWS THEM ON SCREEN
WHERE THE TILES ARE DRAWN DEPENDS ON THE gameCounter WHICH STARTS TO COUNT FROM 0 WHEN THE GAME STARTS
THE TILES ARE DRAWN ON THEIR ORIGINAL X-POSITION - gameCounter

The old draw_tiles have been removed, we add buffer surface to improve the performance.
]]

-- draw the movable tiles, ie, flame and cloud.
function draw_tiles_for_movable()
  local sf = nil
  for k = tileset_start, tileset_end, 1 do
    v = Level.tiles[k]
    if v.name == "obstacle3" then
      move_cloud(v)
    elseif v.name == "obstacle4" then
      move_flame(v)
    end
    if v.image == nil then
      print("The tile the want to draw == nil")
      v.image = gfx.loadpng("images/font/Z.png")
    end
    if v.gid ==9 or v. gid == 10 then
      if v.x-gameCounter<0 and v.x-gameCounter+v.width>0 and v.visibility==true then
        local x1 = (gameCounter - v.x)
        local w1 = (v.x+v.width-gameCounter)
        screen:copyfrom(v.image, {x=x1, y=0, width=w1, height=v.height}, {x=0, y=v.y, width=w1, height=v.height},true)
      elseif v.x+v.width > w0+gameCounter and v.visibility==true then
          screen:copyfrom(v.image,{x=0, y=0, width=w0+gameCounter-v.x, height=v.height}
          ,{x=v.x - gameCounter, y=v.y, width=w0+gameCounter-v.x, height=v.height},true)
      elseif v.x-gameCounter+v.width > 0 and v.visibility == true then
        screen:copyfrom(v.image,nil,{x=v.x-gameCounter,y=v.y,width=v.width,height=v.height},true)
      end
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
  if(cloud.directionTimer >= 54) then
    cloud.up = not cloud.up
    cloud.directionTimer = 0
  end
  if(cloud.up == true) then
    cloud.y = cloud.y + 3
  else
    cloud.y = cloud.y - 3
  end
end

--[[
@desc: Handles the movement of a singular fireball from the right side of the screen towards the character.
@params: flame - A tile object identified as a flame.
]]
function move_flame(flame)
  local distanceToRightEdge = 1180 --1280 (screen width) minus player's relative screen position.
  local distanceToLeftEdge = 332 --200 (character position) minus tile pixel size
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

function get_global_game_state() 
  return global_game_state
end 

function get_game_speed()
  return gameSpeed
end

function set_game_speed(speed)
  gameSpeed = speed
end

function get_game_type()
  return current_game_type
end

function set_game_boudries(upper_bound, lower_bound)
  upper_bound_y = upper_bound
  lower_bound_y = lower_bound
end

function game_navigation(key, state)
  if key=="ok" and state== 'down' then
    if direction_flag == "down" then
      --if touchGround == true  then
      if buttonTest(gameCounter, Level.tiles, player.cur_x, player.cur_y+1, character.width, character.height) ~= nil then
      --if buttonTest1(gameCounter, Level.tiles, player.cur_x, player.cur_y+1, character.width, character.height,direction_flag) ~= nil then 
        character:flip()
        direction_flag="up"
      end
      --touchGround = false
    else
      --if touchGround == true then
      if buttonTest(gameCounter, Level.tiles, player.cur_x, player.cur_y-1, character.width, character.height) ~= nil then
      --if buttonTest1(gameCounter, Level.tiles, player.cur_x, player.cur_y-1, character.width, character.height,direction_flag) ~= nil then
        character:flip()
        direction_flag="down"
      end
      --touchGround = false
    end
  elseif key=="red" and state=='up' then --PAUSE GAME BY CLICKING "Q" ON THE COMPUTER OR "RED" ON THE REMOTE
    pause_game()    
    change_global_game_state(0)
    start_menu("pause_menu")
  --[[
  elseif key=="green" and state=='up' then --TO BE REMOVED - FORCES THE LEVELWIN MENU TO APPEAR BY CLICKING "W" ON THE COMPUTER OR "GREEN" ON THE REMOTE
    levelwin()
  elseif key=="star" and state=="up" then -- Testing purposes (S on keyboard). Should probably be commented out at some point.
    game_score = game_score + 1000
  elseif key=="multi" and state=="up" then -- Testing purposes (A on keyboard). Should probably be commented out at some point.
    if game_score - 1000 >= 0 then
      game_score = game_score - 1000
    else
      game_score = 0
    end
    ]]
  end

  if current_game_type=="tutorial" and state=='up' then
      update_tutorial_handler(key)
  end
end 
