-- We'll be using Love and the TiledMapLoader for early development, then adapt the
-- loader to Zenterio's API once we get control of it. This should allow us to basically
-- port the game from Love2D to ZenterioOS.

--love.filesystem.load("tiledmap.lua")()
require ("game/physic")
require ("game/tiledmap")

gKeyPressed = {}
gCamX,gCamY = 100,100
local imageDir = "images/"
local mapDir = "map/"
local player = {}

function gravity_module_start()
	TiledMap_Load(mapDir.."prototypeLevel.tmx") 
  player.image = imageDir.."hero.png"
  player.x = 100
  player.y = 100 
  timer = sys.new_timer(100, gravity_module_load_update(0.01)) 

end

function gravity_module_stop()
  screen:clear()
  timer:stop()
  timer = nil 
 end

function gravity_module_load_update( dt )
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

function gravity_module_key_down(key, state)
 
  if key=="up" and state=='down' then 
    ToTop()
    player.y = player.y - s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.y = player.y + s
    end
  end
  if key=="down" and state=='down' then 
    ToBottom()
    player.y = player.y + s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.y = player.y - 2*s
    end
  end
  if key=="left" and state=='down' then 
    player.x = player.x - s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x + s
    end
  end
  if key=="right" and state=='down' then 
    player.x = player.x + s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x - s
    end
  end
  if key=="escape" and state=='down' then 
    sys.stop() -- COMMAND TO EXIT
  end
end

function gravity_draw()
  --love.graphics.print('dat squirrel thang (arrow keys to move, esc to close)', 50, 50)
	--love.graphics.setBackgroundColor(0x80,0x80,0x80)
	--TiledMap_DrawNearCam(gCamX,gCamY)
  --love.graphics.draw(player.image, player.x, player.y)
  sf = gfx.loadpng(player.image)
  screen:copyfrom(sf, nil,{x=player.x,y=player.y,width=32,height=32},true)
  sf:destroy()
  gfx.update()
end