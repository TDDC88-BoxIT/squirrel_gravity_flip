--mainmenu = { }

function enter_menu()
  
  --Sets the selection value to 1. 
  --This is meant to represent what option on the menu that the user is choosing
  --With the value 1, it will represent the first option on the menu, i.g "Start Game"
  selection = 1
  --Loads the background image 
  load_background()
  --A table to hold menu buttons
  menu_buttons = {}
  --Call function to load menu buttons and store them in the table
  menu_buttons = load_menu_buttons()
  --UNCEARTAIN IF THIS FUNCTION IS NEEDED
  draw_menu()
 end 

function load_background()
   
   --Saves the path of the background image in a local variable
   local menu_pic = "images/menu.png"
   --Loads the chosen image file and loads via the API
   gfx.loadpng(menu_pic)
   
end

function load_menu_buttons()
  --TODO: LOAD AVAILABLE MENU BUTTONS 
  
  --LOCAL TABEL TO HOLD MENU BUTTONS
  local menu_buttons = {}
  
  --TODO: STORE BUTTONS IN TABLE
  
  return menu_buttons;
  
end

--UNCEARTAIN IF THIS FUNCTION IS NEEDED
function draw_menu()
  
   gfx.update()
  --TODO: DRAW EVERYTHING ON THE MENU

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

