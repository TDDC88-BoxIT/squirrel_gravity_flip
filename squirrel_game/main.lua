-- We'll be using Love and the TiledMapLoader for early development, then adapt the
-- loader to Zenterio's API once we get control of it. This should allow us to basically
-- port the game from Love2D to ZenterioOS.

love.filesystem.load("tiledmap.lua")()
require "physic"


gKeyPressed = {}
gCamX,gCamY = 100,100

function love.load()
	TiledMap_Load("map/prototypeLevel.tmx")
  
  player = {}
  player.image = love.graphics.newImage("images/hero.png")
  player.x = 100
  player.y = 100
  
  
end

function love.keyreleased( key )
	gKeyPressed[key] = nil
end

function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true 
	if (key == "escape") then os.exit(0) end
end

function love.update( dt )
  local s = 480*dt
  
  -- gravity
  gsetGravity(10)
  local gy = CurveY(dt)
  player.y = player.y + gy
  if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
    player.y = player.y - gy
  end
  
  -- go ahead
  player.x = player.x + 100*dt
  if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
    player.x = player.x - 100*dt
  end
	if (gKeyPressed.up) then
    player.y = player.y - s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.y = player.y + s
    end
  end
	if (gKeyPressed.down) then
    player.y = player.y + s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      print("hitTest before", hitTest(gCamX,gCamY, player.x, player.y, 32))
      player.y = player.y - s
      print("hitTest after", hitTest(gCamX,gCamY, player.x, player.y, 32))
    end
  end
	if (gKeyPressed.left) then
    player.x = player.x - s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x + s
    end
  end
	if (gKeyPressed.right) then
    player.x = player.x + s
    if nil ~= hitTest(gCamX,gCamY, player.x, player.y, 32) then
      player.x = player.x - s
    end
  end
  gCamX = player.x
  gCamY = player.y
end

function love.draw()
  love.graphics.print('dat squirrel thang (arrow keys to move, esc to close)', 50, 50)
	love.graphics.setBackgroundColor(0x80,0x80,0x80)
	TiledMap_DrawNearCam(gCamX,gCamY)
  love.graphics.draw(player.image, player.x, player.y)
end