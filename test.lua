
local squirrel1 = {}
squirrel1.path= "game/images/menuImg/squirrel1.png"
squirrel1.width=117
squirrel1.height=140

local squirrel2 = {}
squirrel2.path= "game/images/menuImg/squirrel2.png"
squirrel2.width=117
squirrel2.height=140

-- SETS A BACKGROUND IMAGE ON SCREEN
squirrel1.img = gfx.loadpng(squirrel1.path)
squirrel2.img = gfx.loadpng(squirrel2.path)

timer = sys.new_timer(100, "change_character")
current_character = 1
function change_character()
	screen:clear()
	if current_character==1 then
		screen:copyfrom(squirrel2.img, nil,{x=0,y=0,width=squirrel2.width,height=squirrel2.height},true)
		current_character=2
	else
		screen:copyfrom(squirrel1.img, nil,{x=0,y=0,width=squirrel1.width,height=squirrel1.height},true)
		current_character=1
	end
end

  

  -- DESTROYS UNNCESSEARY SURFACES TO SAVE RAM
 
--Create surface a
--local a = gfx.new_surface(30, 30)

--Fill surface a with color
--a:fill({r=255,g=0,b=0})

--Create surface b
--local b = gfx.new_surface(30, 30)

--Fill surface b with color
--b:fill({r=0,g=255,b=0})

--Add both surfaces to screen

--screen:copyfrom(a, nil,{x=300,y=200,width=30,height=30})
--screen:copyfrom(b, nil,{x=350,y=200,width=30,height=30})
--a:destroy()
--b:destroy()

--print("Memory Use: "..(gfx.get_memory_use()/10^6).." MB")
-- -- Create white background surface
--  local a = gfx.new_surface(300, 300) 
--  --Set color for a surface
--  a:fill({r=255,g=255,b=255,a=255})
  
--   -- Create red surface 
--  local b = gfx.new_surface(50, 50) 
--  --Set color for b surface
--  b:fill({r=255,g=0,b=0,a=255})
  
--   -- Create green opague surface 
--  local c = gfx.new_surface(50, 50) 
--  --Set color for c surface
--  c:fill({r=0,g=255,b=0,a=125})
  
---- put red surface on background
--  a:copyfrom(b,nil,{x=100,y=100,width=50,height=50})

---- put green surface on background
--  a:copyfrom(c,nil,{x=125,y=125,width=50,height=50},true) 

---- put background on screen
--  screen:copyfrom(a,nil,{x=0,y=0,width=300,height=300})