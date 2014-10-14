-- We'll be using Love and the TiledMapLoader for early development, then adapt the
-- loader to Zenterio's API once we get control of it. This should allow us to basically
-- port the game from Love2D to ZenterioOS.

-- small demo for TiledMap loader
love.filesystem.load("tiledmap.lua")()

gKeyPressed = {}
gCamX,gCamY = 100,100

function love.load()
	TiledMap_Load("map/prototypeLevel.tmx")
end

function love.keyreleased( key )
	gKeyPressed[key] = nil
end

function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true 
	if (key == "escape") then os.exit(0) end
	if (key == " ") then -- space = next mal
		gMapNum = (gMapNum or 1) + 1
		if (gMapNum > 10) then gMapNum = 1 end
		TiledMap_Load(string.format("map/map%02d.tmx",gMapNum))
		gCamX,gCamY = 100,100
	end
end

function love.update( dt )
	local s = 500*dt
	if (gKeyPressed.up) then gCamY = gCamY - s end
	if (gKeyPressed.down) then gCamY = gCamY + s end
	if (gKeyPressed.left) then gCamX = gCamX - s end
	if (gKeyPressed.right) then gCamX = gCamX + s end
end

function love.draw()
    love.graphics.print('arrow-keys=scroll, space=next map', 50, 50)
	love.graphics.setBackgroundColor(0x80,0x80,0x80)
	TiledMap_DrawNearCam(gCamX,gCamY)
end