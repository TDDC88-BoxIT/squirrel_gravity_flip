--Start Menu object
local menu = {}
menu.x = (screen:get_width()-(screen:get_width()*0.2))/2 -- Center on screen in x-axis
menu.y = screen:get_height()/4 
menu.width= nil       --Is being set when initiating the menu
menu.height= nil      --Is being set when initiating the menu
menu.tile_x= nil      --Is being set when initiating the menu
menu.tile_y= nil      --Is being set when initiating the menu
menu.tile_width = nil --Is being set when initiating the menu (depends on menu width)
menu.tile_height = 60
menu.start_menu_items={  
  [1]={id="start_new",img="squirrel_game/images/menuImg/start.png"},
  [2]={id="highScore",img="squirrel_game/images/menuImg/highScore.png"},
  [3]={id="settings",img="squirrel_game/images/menuImg/settings.png"},
  [4]={id="exit",img="squirrel_game/images/menuImg/exit.png"}
}
menu.pause_menu_items={  
  [1]={id="start_new",img="squirrel_game/images/menuImg/start.png"},
  [2]={id="resume",img="squirrel_game/images/menuImg/resume.png"},
  [3]={id="settings",img="squirrel_game/images/menuImg/settings.png"},
  [4]={id="exit",img="squirrel_game/images/menuImg/exit.png"}
}
menu.images={
  [1]={x=screen:get_width()/8,y=screen:get_height()/4,width=152,height=208,img="squirrel_game/images/menuImg/thunderAcorn.png"},
  [2]={x=0,y=0,width=screen:get_width(),height=screen:get_height(),img="squirrel_game/images/menuImg/gravityFlip.jpg"},
}
--menu.number_of_items = table.getn(menu.items) 
menu.indicator_color={r=255,g=0,b=0}

local menuState = "pause_menu" -- CAN BE "start_menu" OR "pause_menu"
local backdrop = nil
local menuSurface = nil
local tile_surface_set = {}
local indicator_object=nil

--Item currently indexed in menu
local indexed_menu_item=1  

if timer then
   timer:stop()
   timer = nil
end

local st_menu

function onStart()
  -- Creates all components for menu screen
  create_menu_components()
  
  -- Starts a timer which calls the update function every 100 milliseconds
  timer = sys.new_timer(100, "update_menu")
  draw_menu()
 end 

function create_menu_components()
  -- Create semi-transparent background
  backdrop, backgroundImageSurface, thunder_acorn= create_backdrop()
  
  -- Create menu background
  menuSurface = create_menu_background()
  
  -- Create menu buttons
  tile_surface_set=create_menu_tiles()
  
  -- Create menu indicator
  indicator_object=create_menu_item_indicator()
end

--Creates semi-transparent backdrop to cover game screen  
function create_backdrop()
  -- Create menu background surface
  local sf = gfx.new_surface(screen:get_width(),screen:get_height())
  --Set color and location of menu surface
  sf:fill({r=0,g=0,b=0,a=200})
  
  --Loads the background image
  local sf_png = gfx.loadjpeg(menu.images[2].img)
  
  --Load thunder acorns
  local t_a = gfx.loadpng(menu.images[1].img)
  
    --returns both surfaces
  return sf, sf_png, t_a
end

--Creates a new menu background surface based on menuState "gs"
function create_menu_background()
  local sf=nil
  local img_surface=nil
  
  -- Set menu size
  menu.width = screen:get_width()*0.2 --10% of screen width
  if menuState=="start_menu" then -- MENU HEIGHT VARIES DEPENDING ON MENY TYPE
    menu.height= 30 + ((menu.tile_height+10)*table.getn(menu.start_menu_items))
  elseif menuState=="pause_menu" then
    menu.height= 30 + ((menu.tile_height+10)*table.getn(menu.pause_menu_items))
  end
 
  -- Create menu background surface
  sf= gfx.new_surface(menu.width, menu.height)  -- HOW TO DESTROY THIS SURFACE?
   
  -- Set menu background image
  img_surface = gfx.loadpng("squirrel_game/images/menuImg/menuBackground.png")
  sf:copyfrom(img_surface,nil,{x=0,y=0,width=menu.width,height=menu.height})
  img_surface:destroy()
  return sf
end

-- Create a set of tile surfaces for the menu (All the buttons)
function create_menu_tiles()
  
  local tile_set={}

  local nbr_of_tiles=nil
  if menuState=="start_menu" then
    nbr_of_tiles=table.getn(menu.start_menu_items)
  elseif menuState=="pause_menu" then
    nbr_of_tiles=table.getn(menu.pause_menu_items)
  end
  
  -- Create menu tile rectangles    CREATE AN ARRAY WITH ALL TILES AND LOOP THROUGH IT WHEN DRAWING TO AVOID BLACK AREAS
  for i = 1, nbr_of_tiles, 1 do
    -- Create tile object
    local tile={}
    -- Set tile size 
    tile.width= menu.width*0.9 -- 90% of menu width
    tile.height= menu.tile_height
    
    -- Create tile surface
    local sf= gfx.new_surface(tile.width, tile.height)
    
    -- Set button image
    local img_surface=nil
    if menuState=="start_menu" then 
      img_surface = gfx.loadpng(menu.start_menu_items[i].img) -- GET IMAGES FOR START MENU
    elseif menuState=="pause_menu" then 
      img_surface = gfx.loadpng(menu.pause_menu_items[i].img) -- GET IMAGES FROM PAUSE MENU
    end
    sf:copyfrom(img_surface,nil,{x=0,y=0,width=tile.width,height=tile.height})
    img_surface:destroy()
    -- Add attributes to tile object
    tile.surface=sf
    tile.x= (menu.width-tile.width)/2 -- Centering menu tiles in menu background on the x-axis
    tile.y= 10+(tile.height*(i-1)+i*10)
    
    -- Add tile to tile set
    tile_set[i]=tile
  end
  return tile_set
end

function create_menu_item_indicator()
   -- Create indicator object
  local indicator={}
  
  -- Set indicator size
  indicator.width = 10
  indicator.height= menu.tile_height -- Indicator is as high as the tile which it incicates
 
 -- Create indicator surface
  local sf = gfx.new_surface(indicator.width, indicator.height)
  
  --Set color for indicator surface
  sf:fill(menu.indicator_color)
  
  --Add attributes to indicator object
  indicator.surface=sf
  indicator.x=0
  indicator.y=0
  
  return indicator
end


function draw_menu()
  
  --Put the background image in the background (THIS WILL NOT BE NECESSARY WHEN THERE IS A GAME)
  screen:copyfrom(backgroundImageSurface,nil,{x=menu.images[2].x,y=menu.images[2].y,width=menu.images[2].width,height=menu.images[2].height})

  --Put semi-transparent backdrop over backgroun image
  screen:copyfrom(backdrop,nil,nil,true)
 
  --Put thunder acorns on backdrop
  screen:copyfrom(thunder_acorn,nil,{x=menu.images[1].x,y=menu.images[1].y,width=menu.images[1].width,height=menu.images[1].height},true)
  screen:copyfrom(thunder_acorn,nil,{x=5.9*menu.images[1].x,y=menu.images[1].y,width=menu.images[1].width,height=menu.images[1].height},true)

  --Put tiles on menu background
  for k,v in pairs(tile_surface_set) do
    if indexed_menu_item==k then
      v.surface:copyfrom(indicator_object.surface,nil,{x=indicator_object.x,y=indicator_object.y,width=indicator_object.width,height=indicator_object.height})  
    end
    menuSurface:copyfrom(v.surface,nil,{x=v.x,y=v.y,width=v.width,height=v.height},true)
    v.surface:destroy()
  end
  
  -- Put menu background on screen
  screen:copyfrom(menuSurface,nil,{x=menu.x,y=menu.y,width=menu.width,height=menu.height},true)
  destroy_unnecessary_surfaces()
  gfx.update()

end

function destroy_unnecessary_surfaces()
  -- THE CONTENT OF THE FOLLOWING SURFACES HAVE BEEN COPIED TO SCREEN AND CAN THEREFOR BE REMOVED IN ORDER TO SAVE RAM
  backgroundImageSurface:destroy()
  backdrop:destroy()
  thunder_acorn:destroy()
  indicator_object.surface:destroy()
  menuSurface:destroy()
end

-- UPDATES THE menu TO SHOW WHAT MENU TILE IS CURRENTLY SELECTED
function update_menu()
  backdrop, backgroundImageSurface, thunder_acorn= create_backdrop()
  menuSurface = create_menu_background()
  tile_surface_set=create_menu_tiles()
  indicator_object=create_menu_item_indicator()
  draw_menu()
end

-- SETS A MENU STATE WHICH DETERMINES WHICH MENU WILL BE SHOWN. POSSIBLE STATES ARE: "pause_menu" AND "start_menu"
function set_menu_state(state)
  if state=="start_menu" or state=="pause_menu" then
    menuState=state
  else 
    menuState="start_menu"
  end
end

function get_menu_state()
  return menuState
end

--HANDLES NAVIGATION AND COMMANDS 
function onKey(key, state)
  if key=="down" and state=='up' then
    if menuState=="start_menu" and indexed_menu_item<table.getn(menu.start_menu_items) then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
      indexed_menu_item=indexed_menu_item+1
    elseif menuState=="pause_menu" and indexed_menu_item<table.getn(menu.pause_menu_items) then-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU
      indexed_menu_item=indexed_menu_item+1
    end
    print("Memory Use: "..(gfx.get_memory_use()/10^3).." kB")
  elseif key=="up" and state=='up' and indexed_menu_item>1 then
    indexed_menu_item=indexed_menu_item-1
    print("Memory Use: "..(gfx.get_memory_use()/10^3).." kB")
  elseif key=="ok" and state=='up' then
      if menuState=="start_menu" then
        -- ACTIONS WHEN menu BUTTONS ARE PRESSED
        if menu.start_menu_items[indexed_menu_item].id=="start_new" then
          -- COMMAND TO START GAME
        end
        
        if menu.start_menu_items[indexed_menu_item].id=="high_score" then
          -- COMMAND TO VIEW HIGH SCORE
        end
        if menu.start_menu_items[indexed_menu_item].id=="settings" then
          -- COMMAND TO VIEW SETTINGS
        end
        if menu.start_menu_items[indexed_menu_item].id=="exit" then
          sys.stop() -- COMMAND TO EXIT
        end
      elseif menuState=="pause_menu" then
         -- ACTIONS WHEN menu BUTTONS ARE PRESSED
        if menu.pause_menu_items[indexed_menu_item].id=="start_new" then
          -- COMMAND TO START GAME
        end
        if menu.pause_menu_items[indexed_menu_item].id=="resume" then
          -- COMMAND TO VIEW HIGH SCORE
        end
        if menu.pause_menu_items[indexed_menu_item].id=="settings" then
          -- COMMAND TO VIEW SETTINGS
        end
        if menu.pause_menu_items[indexed_menu_item].id=="exit" then
          sys.stop() -- COMMAND TO EXIT
        end
      end
  end 
end


