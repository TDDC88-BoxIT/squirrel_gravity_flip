require("../tool_box/menu_object")
require("../tool_box/character_object")
local menu_width= screen:get_width()*0.2 -- MAKES THE MENU 20% OF TOTAL SCREEN WIDTH
local menu_height= 300
local menu_x = (screen:get_width()-menu_width)/2 -- CENTERS THE MENU ON SCREEN ON THE X-AXIS
local menu_y = screen:get_height()/4 -- MAKES THE MENU START 1/4 DOWN FROM THE TOP OF THE SCREEN
local menuState = "start_menu" -- CAN BE "start_menu" OR "pause_menu"
local menu = nil  -- THE MENU SURFACE VARIABLE

local thunder_acorn_path = "game/images/menuImg/thunderAcorn.png"
local thunderAcorn = {}
local background_image_path = "game/images/menuImg/gravityFlip.jpg"
local backgroundImage = nil
local backdrop = nil
local addBling = true -- THIS WILL ADD A BACKGROUND IMAGE AND SOME THUNDER ACORNS IF TRUE
local current_character = 1

local squirrel = nil

function start_menu()
  menu = menu_object(menu_width,menu_height) -- CREATES A NEW MENU OBJECT. ATTRIBUTES= {X,Y,WIDTH,HEIGHT}
  add_items()
  menu:set_background("game/images/menuImg/menuBackground.png")
  timer = sys.new_timer(100, "update_menu")
  draw_menu()
end 

function stop_menu()
  screen:clear()
  timer:stop()
  timer = nil 
 end

-- ADDS THE MENU ITEMS
function add_items()
  menu:add_item("start_new","game/images/menuImg/start.png")

  if menuState == "start_menu" then -- THE START MENU HAS THE HIGH SCORE BUTTON
    menu:add_item("high_score","game/images/menuImg/highScore.png")
  elseif menuState == "pause_menu" then -- THE PAUSE MENU HAS THE RESUME BUTTON
    menu:add_item("resume","game/images/menuImg/resume.png")
  end

  menu:add_item("settings","game/images/menuImg/settings.png")
  menu:add_item("exit","game/images/menuImg/exit.png")    
end

-- ADDS "BLING" FEATURES TO SCREEN THAT AREN'T MENU NECESSARY
function add_menu_bling()
  -- SETS A BACKGROUND IMAGE ON SCREEN
  backgroundImage = gfx.loadpng(background_image_path)
  screen:copyfrom(backgroundImage, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()})

  -- SETS A BLACK SEMI-TRANSPARENT BACKGROUND ON SCREEN
  backdrop = gfx.new_surface(screen:get_width(),screen:get_height())
  backdrop:fill({r=0,g=0,b=0,a=200})
  screen:copyfrom(backdrop, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()},true)

  -- SETS FOUR THUNDER ACORNS ON SCREEN
  thunderAcorn.img = gfx.loadpng(thunder_acorn_path)
  thunderAcorn.height=139
  thunderAcorn.width=101
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  
  -- ADD A RUNNING SQUIRREL
  if squirrel==nil then
    squirrel=character_object(117,140,"game/images/menuImg/squirrel1.png")
    squirrel:add_image("game/images/menuImg/squirrel2.png") 
  end
  squirrel:update()
  screen:copyfrom(squirrel:get_surface(), nil,{x=200,y=250,width=squirrel:get_size().width,height=squirrel:get_size().height},true)
  screen:copyfrom(squirrel:get_surface(), nil,{x=(screen:get_width()-(squirrel:get_size().width+200)),y=250,width=squirrel:get_size().width,height=squirrel:get_size().height},true)

  -- DESTROYS UNNCESSEARY SURFACES TO SAVE RAM
  backgroundImage:destroy()
  thunderAcorn.img:destroy()
  backdrop:destroy()
  squirrel:get_surface():destroy()

end

-- SETS A MENU STATE WHICH DETERMINES WHICH MENU WILL BE SHOWN. POSSIBLE STATES ARE: "pause_menu" AND "start_menu"
function set_menu_state(state)
  if menuState~=state then
    if state=="start_menu" or state=="pause_menu" then
      menuState=state
    else 
      menuState="start_menu"
    end
    menu:clear_items() -- CLEARS OUT ALL THE MENU ITEMS FORM THE MENU
    add_items() -- CREATES NEW MENU ITEMS 
  end
end

function get_menu_state()
  return menuState
end

function draw_menu()
  screen:clear()
  if addBling==true then
    add_menu_bling() -- ADDS BLING BLING TO SCREEN (BACKGROUND, THUNDER ACORNS AND RUNNING SQUIRREL)
  end
  menu:update()
  screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  menu:get_surface():destroy()
end

function update_menu()
  draw_menu()
end

--HANDLES MENU NAVIGATION AND COMMANDS 
function menu_key_down(key, state)
 
  if key=="down" and state=='up' then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
      menu:increase_index()-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU    
  elseif key=="up" and state=='up' then
      menu:decrease_index()
  elseif key=="ok" and state=='up' then
    -- ACTIONS WHEN menu BUTTONS ARE PRESSED
    if menu:get_indexed_item().id=="start_new" then
      -- COMMAND TO START GAME
      stop_menu()
      start_game()
      global_game_state = 1
    elseif menu:get_indexed_item().id=="resume" then  -- RIGHT NOW THIS SWAPS TO PAUSE MENU
      set_menu_state("start_menu")
      menu:clear_items()
      add_items()
      -- COMMAND TO VIEW RESUME
    elseif menu:get_indexed_item().id=="high_score" then -- RIGHT NOW THIS SWAPS TO START MENU
      set_menu_state("pause_menu")
      menu:clear_items()
      add_items()
      -- COMMAND TO VIEW HIGH SCORE
    elseif menu:get_indexed_item().id=="settings" then
      -- COMMAND TO VIEW SETTINGS
    elseif menu:get_indexed_item().id=="exit" then
      sys.stop() -- COMMAND TO EXIT
    end
  elseif key=="escape" and state=='up' then
     print("Memory usage: " .. string.format("%.0f",gfx.get_memory_use()) .. " of " .. string.format("%.0f",gfx.get_memory_limit()) .. " bytes or " .. string.format("%.2f", gfx.get_memory_use() * 100 / gfx.get_memory_limit()) .. " %") 
  end
end


