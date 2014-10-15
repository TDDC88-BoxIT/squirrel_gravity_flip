--Menu object
local menu = {}
menu.x = (screen:get_width()-(screen:get_width()*0.2))/2
menu.y = screen:get_height()/4
menu.width= nil       --Is being set when initiating the menu
menu.height= nil      --Is being set when initiating the menu
menu.tile_x= nil      --Is being set when initiating the menu
menu.tile_y= nil      --Is being set when initiating the menu
menu.tile_width = nil --Is being set when initiating the menu (depends on menu width)
menu.tile_height = 60
menu.items={  
  [1]={id="start",img="squirrel_game/images/menuImg/start.png"},
  [2]={id="highScore",img="squirrel_game/images/menuImg/highScore.png"},
  [3]={id="settings",img="squirrel_game/images/menuImg/settings.png"},
  [4]={id="exit",img="squirrel_game/images/menuImg/exit.png"}
  }
menu.number_of_items = table.getn(menu.items) 
menu.background_color={r=136,g=138,b=116}
menu.indicator_color={r=255,g=0,b=0}
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

function onStart()
  load_backdrop()
  --Loads the background image 
  load_background()
  --Loads menu tiles
  load_menu_buttons() -- IF THIS IS COMMENTED OUT THE BACKGROUND IS SHOWN, IF NOT THE TILE IS SHOWN
  --UNCEARTAIN IF THIS FUNCTION IS NEEDED
  --Loads menu item indicator
  load_menu_indicator()
  timer = sys.new_timer(100, "update_menu")
  draw_menu()
 end 

function load_backdrop()
  backdrop = create_backdrop()
end

--Creates semi-transparent backdrop to cover game screen  
function create_backdrop()
  -- Create menu background surface
  local sf = gfx.new_surface(screen:get_width(),screen:get_height())
  --Set color and location of menu surface
  sf:fill({r=0,g=0,b=0,a=200})
  
  return sf
end

function load_background()
  menuSurface, menuBackgroundSurface=create_menu_background()
end

--Creates a new menu background surface
function create_menu_background()
  
  -- Set menu size
  menu.width = screen:get_width()*0.2 --10% of screen width
  menu.height= 310-- Screen height
 
  -- Create menu background surface
  local sf = gfx.new_surface(menu.width, menu.height)
  --Set color and location of menu surface
  --sf:fill(menu.background_color)
  
  -- Set menu background image
  local img_surface=nil
  img_surface = gfx.loadpng("squirrel_game/images/menuImg/menuBackground.png")
  sf:copyfrom(img_surface,nil,{x=0,y=0,width=menu.width,height=menu.height})
  
  
  --Loads the background image
  local sf_png = gfx.loadpng("images/menu.png")
  
  --returns both surfaces
  return sf, sf_png
end

function load_menu_buttons()
  tile_surface_set=create_menu_tiles()
end

-- Create a set of tile surfaces for the menu (All the buttons)
function create_menu_tiles()
  
  local tile_set={}
   
  -- Create menu tile rectangles    CREATE AN ARRAY WITH ALL TILES AND LOOP THROUGH IT WHEN DRAWING TO AVOID BLACK AREAS
  for i = 1, menu.number_of_items, 1 do
   
    -- Create tile object
    local tile={}
    
    -- Set tile size 
    tile.width= menu.width*0.9-- 90% of menu width
    tile.height= menu.tile_height
    
    -- Create tile surface
    local sf= gfx.new_surface(tile.width, tile.height)
    
    -- Set button image
    local img_surface=nil
    img_surface = gfx.loadpng(menu.items[i].img)
    sf:copyfrom(img_surface,nil,{x=0,y=0,width=tile.width,height=tile.height})
    
    -- Add attributes to tile object
    tile.surface=sf
    tile.x= (menu.width-tile.width)/2 -- Centering menu tiles in menu background on the x-axis
    tile.y= 10+(tile.height*(i-1)+i*10)
    
    -- Add tile to tile set
    tile_set[i]=tile
  end
  return tile_set
end

function load_menu_indicator()
  indicator_object=create_menu_item_indicator()
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
  
  --Put the menu-png in the background
  screen:copyfrom(menuBackgroundSurface,nil)
  
  --Put semi-transparent backdrop over backgroun image
  screen:copyfrom(backdrop,nil,nil,true)
  
  --Put tiles on menu background
  for k,v in pairs(tile_surface_set) do
    if indexed_menu_item==k then
      v.surface:copyfrom(indicator_object.surface,nil,{x=indicator_object.x,y=indicator_object.y,width=indicator_object.width,height=indicator_object.height})
    end
    menuSurface:copyfrom(v.surface,nil,{x=v.x,y=v.y,width=v.width,height=v.height},true)
  end
  
  -- Put menu background on screen
  screen:copyfrom(menuSurface,nil,{x=menu.x,y=menu.y,width=menu.width,height=menu.height},true)
  
  gfx.update()

end

--SUPPOSED TO UPDATE THE MENU TO SHOW WHAT MENU TILE IS CURRENTLY SELECTED
function update_menu()
  menuSurface, menuBackgroundSurface=create_menu_background()
  tile_surface_set=create_menu_tiles()
  draw_menu()
end


--HANDLES NAVIGATION AND COMMANDS 
function onKey(key, state)
  if key=="down" and state=='up' and indexed_menu_item<menu.number_of_items then
    indexed_menu_item=indexed_menu_item+1
  elseif key=="up" and state=='up' and indexed_menu_item>1 then
    indexed_menu_item=indexed_menu_item-1
  elseif key=="ok" and state=='up' then
      
      -- ACTIONS WHEN MENU BUTTONS ARE PRESSED
      if menu.items[indexed_menu_item].id=="start" then
        -- COMMAND TO START GAME
      end
      if menu.items[indexed_menu_item].id=="high_score" then
        -- COMMAND TO VIEW HIGH SCORE
      end
      if menu.items[indexed_menu_item].id=="settings" then
        -- COMMAND TO VIEW SETTINGS
      end
      if menu.items[indexed_menu_item].id=="exit" then
        -- COMMAND TO EXIT
        sys.stop()
      end
  end 
end


