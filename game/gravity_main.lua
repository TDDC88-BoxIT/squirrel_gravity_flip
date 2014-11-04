-- We'll be using Love and the TiledMapLoader for early development, then adapt the
-- loader to Zenterio's API once we get control of it. This should allow us to basically
-- port the game from Love2D to ZenterioOS.

--love.filesystem.load("tiledmap.lua")()
--require ("game/physic")
--require ("game/level_module")
--require("tool_box/character_object")

gKeyPressed = {}
gCamX,gCamY = 100,100
local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
local direction_flag=0 -- 0 MEANS DOWN AND 1 MEANS UP
local character_size = 32

function gravity_module_start()
	TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  character = character_object(character_size,character_size,imageDir.."menuImg/squirrel1.png")
  character:add_image(imageDir.."menuImg/squirrel2.png")
  player.x = 100
  player.y = 100 
  timer = sys.new_timer(20, "gravity_module_load_update")
  change_character_timer = sys.new_timer(100, "update_character")
end

function gravity_module_stop()
  screen:clear()
  timer:stop()
  timer = nil
  change_character_timer:stop()
  change_character_timer=nil 
 end

function gravity_module_load_update()
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

  gravity_draw()
end

function update_character()
  character:destroy() -- DESTROYS THE CHARACTER'S SURFACE SO THAT NEW UPDATES WON'T BE PLACED ONTOP OF IT
  character:update()  -- UPDATES THE CHARACTERS BY CREATING A NEW SURFACE WITH THE NEW IMAGE TO BE DISPLAYED
end



function gravity_module_navigation(key, state)
 
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
  end
 
  if key=="red" and state=='down' then 
    sys.stop() -- COMMAND TO EXIT
  end
end

function gravity_draw()
  screen:clear()
  
  -- CREATES A NEW SURFACE FOR THE GAME BACKGOUND AND GIVES IT A GRAY COLOR
  sf = gfx.new_surface(screen:get_width(), screen:get_height())
  sf:fill({r=80,g=80,b=80})
  -- THE BACKGROUND IS COPIED TO THE SCREEN AND THE SURFACE IS DESTROYED
  screen:copyfrom(sf)
  sf:destroy()

	TiledMap_DrawNearCam(gCamX,gCamY)

  -- THE GAME CHARACTER IS COPIED TO THE SCREEN
  screen:copyfrom(character:get_surface(), nil,{x=player.x,y=player.y},true)
  
  gfx.update()
end