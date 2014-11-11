require("../tool_box/menu_object")
require("../tool_box/character_object")
require("../tool_box/timelog")
local menu_width= screen:get_width()*0.2 -- MAKES THE MENU 20% OF TOTAL SCREEN WIDTH
local menu_height= 400
local menu_x = (screen:get_width()-menu_width)/2 -- CENTERS THE MENU ON SCREEN ON THE X-AXIS
local menu_y = screen:get_height()/4 -- MAKES THE MENU START 1/4 DOWN FROM THE TOP OF THE SCREEN
local menuState = "start_menu" -- CAN BE "start_menu" OR "pause_menu" OR "levelwin_menu"
local menu = nil  -- THE MENU SURFACE VARIABLE

local imageDir = "images/"
local thunder_acorn_path = imageDir.."thunderAcorn.png"
local thunderAcorn = {}
local background_image_path = imageDir.."/menuImg/gravityFlip.jpg"
local background_image2_path = imageDir.."/menuImg/levelwin.jpg" -- TO BE CHANGED TO OTHER PICTURE! THIS IS THE BACKGROUND IMAGE FOR THE LEVELWIN MENU
local squirrelImg1 = imageDir.."character/squirrel1.png" 
local squirrelImg2 = imageDir.."character/squirrel2.png"
local backgroundImage = nil
local backdrop = nil
local addBling = true -- THIS WILL ADD A BACKGROUND IMAGE AND SOME THUNDER ACORNS IF TRUE
local current_character = 1

local squirrel1 = nil
local squirrel2 = nil

function start_menu()
  logstartover()
  logprint("start menu")
  menu = menu_object(menu_width,menu_height) -- CREATES A NEW MENU OBJECT. ATTRIBUTES= {X,Y,WIDTH,HEIGHT}
  add_menu_items()
  menu:set_background(imageDir.."menuImg/menuBackground.png")
  draw_menu()
end 

function stop_menu()
  screen:clear() 
 end

-- ADDS THE MENU ITEMS
function add_menu_items()
  menu:add_button("start_new",imageDir.."menuImg/start.png")

  if menuState == "start_menu" or menuState == "levelwin_menu" then -- THE START MENU AND THE LEVELWIN MENU HAS THE HIGH SCORE BUTTON
    menu:add_button("high_score",imageDir.."menuImg/highScore.png")
    menu:add_button("tutorial",imageDir.."menuImg/tutorial.png")
  elseif menuState == "pause_menu" then -- THE PAUSE MENU HAS THE RESUME BUTTON
    menu:add_button("resume",imageDir.."menuImg/resume.png")
  end

  menu:add_button("settings",imageDir.."menuImg/settings.png")
  menu:add_button("exit",imageDir.."menuImg/exit.png")    
end

-- ADDS "BLING" FEATURES TO SCREEN THAT AREN'T MENU NECESSARY
function add_menu_bling()
  -- SETS A BACKGROUND IMAGE ON SCREEN
  if menuState == "start_menu" or menuState == "pause_menu" then -- SETS DIFFERENT BACKGROUND IMAGES FOR THE DIFFERENT MENUS
    backgroundImage = gfx.loadpng(background_image_path)
  elseif menuState == "levelwin_menu" then
    backgroundImage = gfx.loadpng(background_image2_path)
  end

  screen:copyfrom(backgroundImage, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()})

  -- SETS A BLACK SEMI-TRANSPARENT BACKGROUND ON SCREEN OVER THE BACKGROUND IMAGE
  backdrop = gfx.new_surface(screen:get_width(),screen:get_height())
  backdrop:fill({r=0,g=0,b=0,a=200})
  screen:copyfrom(backdrop, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()},true)

  -- CREATES, AND SETS FOUR THUNDER ACORNS ON SCREEN
  thunderAcorn.img = gfx.loadpng(thunder_acorn_path)
  thunderAcorn.height=139
  thunderAcorn.width=101
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  
  -- ADD TWO A RUNNING SQUIRRELS
  if squirrel1 == nil and squirrel2 == nil then
    squirrel1=character_object(117,140,squirrelImg2)
    squirrel2=character_object(117,140,squirrelImg1)
  end
  squirrel1:update()
  squirrel2:update()
  screen:copyfrom(squirrel1:get_surface(), nil,{x=200,y=250,width=squirrel1:get_size().width,height=squirrel1:get_size().height},true)
  screen:copyfrom(squirrel2:get_surface(), nil,{x=(screen:get_width()-(squirrel2:get_size().width+200)),y=250,width=squirrel2:get_size().width,height=squirrel2:get_size().height},true)
  
  -- DESTROYS UNNCESSEARY SURFACES TO SAVE RAM
  backgroundImage:destroy()
  thunderAcorn.img:destroy()
  backdrop:destroy()
  squirrel1:destroy()
  squirrel2:destroy()
end

-- SETS A MENU STATE WHICH DETERMINES WHICH MENU WILL BE SHOWN. POSSIBLE STATES ARE: "pause_menu" AND "start_menu" AND "levelwin_menu"
function set_menu_state(state)
  if menuState~=state then
    if state=="start_menu" or state=="pause_menu" or state=="levelwin_menu" then
      menuState=state
    else 
      menuState="start_menu"
    end
    menu:clear_buttons() -- CLEARS OUT ALL THE MENU ITEMS FORM THE MENU
    add_menu_items() -- CREATES NEW MENU ITEMS 
  end
end

function get_menu_state()
  return menuState
end

function draw_menu()
  logprint("draw menu start")
  screen:clear()
  if addBling==true then
    add_menu_bling() -- ADDS BLING BLING TO SCREEN (BACKGROUND, THUNDER ACORNS AND RUNNING SQUIRRELS)
  end
  --logprint("3 end")
  screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  --logprint("4 end")
  menu:destroy()
  --logprint("5 end")
  gfx.update()
  logprint("draw menu end")
end

function update_menu()
  draw_menu()
end

--HANDLES MENU NAVIGATION AND COMMANDS 
function menu_navigation(key, state)
  logstartover()
  if key=="down" and state=='up' then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
      menu:increase_index()-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU 
      update_menu()   
  elseif key=="up" and state=='up' then
      menu:decrease_index()
      update_menu()
  elseif key=="ok" and state=='up' then
    -- ACTIONS WHEN menu BUTTONS ARE PRESSED
    if menu:get_indexed_item().id=="start_new" then
      -- COMMAND TO START GAME
      stop_menu()
      change_global_game_state(1)
      start_game(1,"story")
    elseif menu:get_indexed_item().id=="resume" then -- RESUMES THE GAME
      stop_menu()
      change_global_game_state(1)
      resume_game()
    elseif menu:get_indexed_item().id=="tutorial" then
      stop_menu()
      change_global_game_state(1)
      start_game(1,"tutorial")
    elseif menu:get_indexed_item().id=="high_score" then
      -- COMMAND TO VIEW HIGH SCORE
    elseif menu:get_indexed_item().id=="settings" then
      -- COMMAND TO VIEW SETTINGS
    elseif menu:get_indexed_item().id=="exit" then
      sys.stop() -- COMMAND TO EXIT
    end
  end
end


