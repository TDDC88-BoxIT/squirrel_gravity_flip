--Menu object
local menu = {}
menu.x = 0
menu.y = 0
menu.width= nil   --Is being set when initiating the menu
menu.height= nil  --Is being set when initiating the menu
menu.tile_x= nil  --Is being set when initiating the menu
menu.tile_y= nil  --Is being set when initiating the menu
menu.tile_width = nil --Is being set when initiating the menu (depends on menu width)
menu.tile_height = 40
menu.items={}
menu.item_names={"Start","High Score","Settings","Exit"}
menu.number_of_items = 4
menu.background_color={r=0,g=255,b=255}
menu.tiles_color={r=0,g=0,b=255}
menu.selected_tile_color={r=255,g=0,b=0}

local menuSurface = nil
local tile_surface_set = {}

--Item currently indexed in menu
local navItem=1
local menuItem=1

if timer then
   timer:stop()
   timer = nil
end

function onStart()
  
  --Sets the selection value to 1. 
  --This is meant to represent what option on the menu that the user is choosing
  --With the value 1, it will represent the first option on the menu, i.g "Start Game"
  selection = 1
  --Loads the background image 
  load_background()
  --Loads menu tiles
  load_menu_buttons() -- IF THIS IS COMMENTED OUT THE BACKGROUND IS SHOWN, IF NOT THE TILE IS SHOWN
  --UNCEARTAIN IF THIS FUNCTION IS NEEDED
  draw_menu()
 end 

function load_background()
   
   --Saves the path of the background image in a local variable
   local menu_pic = "images/menu.png"
   --Loads the chosen image file and loads via the API
   gfx.loadpng(menu_pic)
   
  menuSurface=create_menu_background()
  screen:copyfrom(menuSurface, nil)
   
end

--Creates a new menu background surface
function create_menu_background()
  -- Set menu size
  menu.width = screen:get_width()*0.1 --10% of screen width
  menu.height=screen:get_height() -- Screen height
  
  -- Create menu background surface
  local sf = gfx.new_surface(menu.width, menu.height)
  --Set color and location of menu surface
  sf:fill(menu.background_color)
  
  return sf
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
    
    -- Create tile surface
    local sf= gfx.new_surface(menu.tile_width, menu.tile_height)
    
    -- Set tile surface color
    sf:fill(menu.tiles_color,nil)
    
    -- Add attributes to tile object
    tile.surface=sf
    tile.width= menu.width*0.9-- 90% of menu width
    tile.height= menu.tile_height
    tile.x= (menu.width-tile.width)/2 -- Centering menu tiles in menu background on the x-axis
    tile.y= (menu.y+10)+(tile.height*(i-1)+i*10)
    
    -- Add tile to tile set
    tile_set[i]=tile
  end
  return tile_set
end

--UNCEARTAIN IF THIS FUNCTION IS NEEDED
function draw_menu()
   
  --Put tiles on menu background
  for k,v in pairs(tile_surface_set) do
    menuSurface:copyfrom(v.surface,nil,{x=v.x,y=v.y,width=v.width,height=v.height})
  end
  
  -- Put menu background on screen
  screen:copyfrom(menuSurface,nil)
  
  gfx.update()
  --TODO: DRAW EVERYTHING ON THE MENU

end

--SUPPOSED TO UPDATE THE MENU TO SHOW WHAT MENU TILE IS CURRENTLY SELECTED
function update_menu()
 
  draw_menu()
end

function navigate_menu()
  
    
  -- TODO: CREATE NAVIGATION AND FEEDBACK FOR NAVIGATING THE MENU
  -- FOR EACH NAVIGATION ON THE MENU, SELECTION SHOULD DECREMENT OR INCREMENT
  -- LIKE +1 for going down to "Exit Game"
end

function menu_button_pressed(button_pressed)
  
  --Check if the buttons pressed on the remote is "Ok"
  --If it's pressed, it will check the value of selection
  --and then call the approrite function for that value
  if(button_pressed == " ") then
    if(selection == 1) then
      --START GAME?
    elseif(selection == 2) then
      --EXIT GAME?
  --TODO: Add more options for more menu buttons, if added
  end
  
end

end

