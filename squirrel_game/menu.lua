--Menu object
local menu = {}
menu.x = 0
menu.y = 0
menu.width= nil   --Is being set when initiating the menu
menu.height= nil  --Is being set when initiating the menu
menu.tile_x= nil  --Is being set when initiating the menu
menu.tile_y= nil  --Is being set when initiating the menu
menu.tile_width = 100
menu.tile_height = 40
menu.items={}
menu.item_names={"Start","High Score","Settings","Exit"}
menu.number_of_items = 4
menu.background_color={r=255,g=0,b=0}
menu.tiles_color={r=0,g=255,b=0}
menu.selected_tile_color={r=255,g=0,b=0}

local menuSurface = nil
local tileSurface = nil

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
  menu.height=screen:get_height()
  
  -- Create menu surface
  local sf = gfx.new_surface(menu.width, menu.height)
  --Set color and location of menu surface
  sf:fill(menu.background_color)
  
  return sf
end

function load_menu_buttons()
  tileSurface=create_menu_tiles()
  screen:copyfrom(tileSurface, nil)
  
end

-- Create tile surface for the menu
function create_menu_tiles()
  -- Set tile location in menu
  menu.tile_x= (menu.width-menu.tile_width)/2 -- Centering menu tiles in menu on the x-axis
  menu.tile_y= menu.y+10
  
  -- Create tile surface
  local sf= gfx.new_surface(menu.width, menu.height)
   
  -- Create menu tile rectangles
  for i = 1, menu.number_of_items, 1 do
    sf:fill(menu.tiles_color,{x=menu.tile_x, y=menu.tile_y+menu.tile_height*(i-1)+i*5, width=menu.tile_width, height=menu.tile_height})
  end
  return sf
end

--UNCEARTAIN IF THIS FUNCTION IS NEEDED
function draw_menu()
  
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

