-- We'll be using Love and the TiledMapLoader for early development, then adapt the
-- loader to Zenterio's API once we get control of it. This should allow us to basically
-- port the game from Love2D to ZenterioOS.

--love.filesystem.load("tiledmap.lua")()
require ("game/physic")
require ("game/tiledmap")
require("tool_box/character_object")

gKeyPressed = {}
gCamX,gCamY = 100,100
local imageDir = "images/"
local mapDir = "map/"
local player = {}
local character = nil
function gravity_module_start()
	TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  character = character_object(32,32,imageDir.."menuImg/squirrel1.png")
  character:add_image(imageDir.."menuImg/squirrel2.png")
  character:update()

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
  local s = 700*dt
  hitTest(gCamX, gCamY, player.x, player.y, 32)
  -- gravity
  gsetGravity(10)
  local gy = CurveY(dt)
  player.y = player.y + gy
  if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
    player.y = player.y - 2*gy
  end

   -- go ahead
  player.x = player.x + 100*dt
  if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
    player.x = player.x - 100*dt
  end
  
  gCamX = player.x
  gCamY = player.y

  gravity_draw()
end

function update_character()
  character:update()
end

function gravity_module_key_down(key, state)
 
  if key=="up" and (state=='repeat' or state== 'down') then
    ToTop()
    player.y = player.y - 10
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.y = player.y + 10
    end
  end
  if key=="down" and (state=='repeat' or state== 'down') then 
    ToBottom()
    player.y = player.y + 10
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.y = player.y - 20
    end
  end
  if key=="left" and (state=='repeat' or state== 'down') then 
    player.x = player.x - 10
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x + 10
    end
  end
  if key=="right" and (state=='repeat' or state== 'down') then 
    player.x = player.x + 10
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x - 10
    end
  end
  if key=="escape" and state=='down' then 
    sys.stop() -- COMMAND TO EXIT
  end
end

function gravity_draw()
  screen:clear()
  --love.graphics.print('dat squirrel thang (arrow keys to move, esc to close)', 50, 50)
  sf = gfx.new_surface(screen:get_width(), screen:get_height())
  sf:fill({r=80,g=80,b=80})
  screen:copyfrom(sf)
	TiledMap_DrawNearCam(gCamX,gCamY)
  --love.graphics.draw(player.image, player.x, player.y)
  --sf = gfx.loadpng(player.image)
  screen:copyfrom(character:get_surface(), nil,{x=player.x,y=player.y},true)
  --sf:destroy()
  gfx.update()
end