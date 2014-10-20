require("menu.menu_object")

local menuState = "start_menu" -- CAN BE "start_menu" OR "pause_menu"
local menu = nil

function start_menu()
  local menu_width= screen:get_width()*0.2 -- MAKES THE MENU 20% OF TOTAL SCREEN WIDTH
  local menu_height= 300
  local menu_x = (screen:get_width()-menu_width)/2 -- CENTERS THE MENU ON SCREEN ON THE X-AXIS
  local menu_y = screen:get_height()/4 -- MAKES THE MENU START 1/4 DOWN FROM THE TOP OF THE SCREEN

  menu = menu_object(menu_x,menu_y,menu_width,menu_height) -- CREATES A NEW MENU OBJECT. ATTRIBUTES= {X,Y,WIDTH,HEIGHT}
  add_menu_items()
  menu:set_menu_background("game/images/menuImg/menuBackground.png")
  menu:assemble()
  timer = sys.new_timer(100, "update_menu")
  draw_menu()
end 

function stop_menu()
  screen:clear()
  timer:stop()
  timer = nil 
 end

-- ADDS THE MENU ITEMS
function add_menu_items()
  menu:add_menu_item("start_new","game/images/menuImg/start.png")

  if menuState == "start_menu" then -- THE START MENU HAS THE HIGH SCORE BUTTON
    menu:add_menu_item("highScore","game/images/menuImg/highScore.png")
  elseif menuState == "pause_menu" then -- THE PAUSE MENU HAS THE RESUME BUTTON
    menu:add_menu_item("resume","game/images/menuImg/resume.png")
  end

  menu:add_menu_item("settings","game/images/menuImg/settings.png")
  menu:add_menu_item("exit","game/images/menuImg/exit.png")    
end


-- SETS A MENU STATE WHICH DETERMINES WHICH MENU WILL BE SHOWN. POSSIBLE STATES ARE: "pause_menu" AND "start_menu"
function set_menu_state(state)
  if menuState~=state then
    if state=="start_menu" or state=="pause_menu" then
      menuState=state
    else 
      menuState="start_menu"
    end
    menu:clear_menu_items() -- CLEARS OUT ALL THE MENU ITEMS FORM THE MENU
    add_menu_items() -- CREATES NEW MENU ITEMS 
  end
end

function get_menu_state()
  return menuState
end

function draw_menu()
  screen:copyfrom(menu:get_menu_surface(), nil,{x=menu:get_location().x,y=menu:get_location().y,width=menu:get_size().width,height=menu:get_size().height})
  menu:get_menu_surface():destroy()
end

function update_menu()
  menu:update()
  draw_menu()
end

--HANDLES MENU NAVIGATION AND COMMANDS 
function menu_key_down(key, state)
 
  if key=="down" and state=='up' then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
      menu:increase_menu_index()-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU    
  elseif key=="up" and state=='up' then
      menu:decrease_menu_index()
  elseif key=="ok" and state=='up' then
    -- ACTIONS WHEN menu BUTTONS ARE PRESSED
    if menu:get_indexed_menu_item().id=="start_new" then
      -- COMMAND TO START GAME
      stop_menu()
      start_game()
      global_game_state = 1
    elseif menu:get_indexed_menu_item().id=="resume" then
      -- COMMAND TO VIEW HIGH SCORE    
    elseif menu:get_indexed_menu_item().id=="high_score" then
      -- COMMAND TO VIEW HIGH SCORE
    elseif menu:get_indexed_menu_item().id=="settings" then
      -- COMMAND TO VIEW SETTINGS
    elseif menu:get_indexed_menu_item().id=="exit" then
      sys.stop() -- COMMAND TO EXIT
    end
  end
end


