 --Create surface a
local a = gfx.new_surface(30, 30)

--Fill surface a with color
a:fill({r=255,g=0,b=0})

--Create surface b
local b = gfx.new_surface(30, 30)

--Fill surface b with color
b:fill({r=0,g=255,b=0})

--Add both surfaces to screen

screen:copyfrom(a, nil,{x=300,y=200,width=30,height=30})
screen:copyfrom(b, nil,{x=350,y=200,width=30,height=30})
a:destroy()
b:destroy()

print("Memory Use: "..(gfx.get_memory_use()/10^6).." MB")
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