require("../tool_box/menu_object")
require("game/level_config")
require("game/menu/text_input_handler")

local menu_width= screen:get_width()*0.2 -- MAKES THE MENU 20% OF TOTAL SCREEN WIDTH
local menu_x = (screen:get_width()-menu_width)/2 -- CENTERS THE MENU ON SCREEN ON THE X-AXIS
local menu_y = screen:get_height()/4 -- MAKES THE MENU START 1/4 DOWN FROM THE TOP OF THE SCREEN
local level_menu_y = screen:get_height()/100
local level_menu_x = screen:get_width()/100
local name_menu1_x = 400
local name_menu1_y = 200
local name_menu2_x = 550
local name_menu2_y = 200
local name_menu3_x = 700
local name_menu3_y = 200
local menuState = "start_menu" -- CAN BE "start_menu" OR "pause_menu" OR "levelwin_menu" OR "gameover_menu"
local menu = nil  -- THE MENU SURFACE VARIABLE
local imageDir = "images/"
local thunder_acorn_path = imageDir.."thunderAcorn.png"
local thunderAcorn = {}
--local squirrelImg1 = imageDir.."character/bigSquirrel1.png" 
--local squirrelImg2 = imageDir.."character/bigSquirrel2.png"
local backgroundImage = nil
local dash = nil
local green_dash = nil
local backdrop = nil
local addBling = true -- THIS WILL ADD A BACKGROUND IMAGE AND SOME THUNDER ACORNS IF TRUE
local current_character = 1
local player_name = ""
text_button_pressed = {0,0,0,0,0,0,0,0,0}
nr_buttons_pressed = 0
local current_page = 1 -- CORRESPONDS TO THE CURRENT PAGE OF A MENU IF THERE ARE MUTIPLE PAGES FOR IT. FOR EXAMPLE IN THE CASE OF LEVEL MENU
local was_pressed_from_menu = false



--local squirrel1 = nil
--local squirrel2 = nil



function start_menu(state)
  menuState=state

  unlocked_level = read_unlocked_level()
  if menuState == "new_name_menu" then
    menu = menu_object(128,92)
    menu2 = menu_object(128,92)
    menu3 = menu_object(128,92)
    menu2:set_background(imageDir.."menuImg/menuBackground.png")
    menu3:set_background(imageDir.."menuImg/menuBackground.png")
    menu:set_indexed_item(nil) --REMOVES THE ITEM INDICATOR ON THE MENU BUTTONS
    menu2:set_indexed_item(nil)
    menu3:set_indexed_item(nil)
  else
    menu = menu_object(menu_width,menu_height) -- CREATES A NEW MENU OBJECT. ATTRIBUTES= {X,Y,WIDTH,HEIGHT}
  end
  was_pressed_from_menu = false -- This dumps the last keypress event so you can't get instantly transferred from gameover to main menu.
  add_menu_items()
  configure_menu_height()
  menu:set_background(imageDir.."menuImg/menuBackground.png")
  draw_menu()
end 

function stop_menu()
  if backgroundImage ~= nil then
    backgroundImage:destroy()
    backgroundImage = nil
  end
  screen:clear() 
 end

-- ADDS THE MENU ITEMS
function add_menu_items()
  if menuState == "start_menu" then
    menu:add_button("start_new",imageDir.."menuImg/start.png")
    menu:add_button("select_level", imageDir.."menuImg/select_level.png")
    menu:add_button("high_score",imageDir.."menuImg/highScore.png")
    menu:add_button("settings",imageDir.."menuImg/settings.png")
    menu:add_button("tutorial",imageDir.."menuImg/tutorial.png")
    menu:add_button("exit",imageDir.."menuImg/exit.png") 
  elseif menuState == "pause_menu" then
    menu:add_button("resume",imageDir.."menuImg/resume.png")
    menu:add_button("restart", imageDir.."menuImg/restart.png")
    menu:add_button("main_menu", imageDir.."menuImg/mainMenu.png")
  elseif menuState == "levelwin_menu" then
    menu:add_button("continue", imageDir.."menuImg/continue.png")
    menu:add_button("restart", imageDir.."menuImg/restart.png")
    menu:add_button("main_menu", imageDir.."menuImg/mainMenu.png")
  elseif menuState == "gameover_menu" then
    menu:add_button("restart", imageDir.."menuImg/restart.png")
    menu:add_button("main_menu", imageDir.."menuImg/mainMenu.png")
  elseif menuState == "new_name_menu" then
    menu:add_button("name_1", imageDir.."font/1but.png")
    menu:add_button("name_4", imageDir.."font/4but.png")
    menu:add_button("name_7", imageDir.."font/7but.png")
    menu2:add_button("name_2", imageDir.."font/2but.png")
    menu2:add_button("name_5", imageDir.."font/5but.png")
    menu2:add_button("name_8", imageDir.."font/8but.png")
    menu3:add_button("name_3", imageDir.."font/3but.png")
    menu3:add_button("name_6", imageDir.."font/6but.png")
    menu3:add_button("name_9", imageDir.."font/9but.png")
  
  elseif menuState == "levelwin_menu" or menuState == "gameover_menu" then
    menu:add_button("continue", imageDir.."menuImg/continue.png")
    menu:add_button("main_menu", imageDir.."menuImg/mainMenu.png")
  elseif menuState == "level_menu" or menuState== "highscore_menu" then
    add_level_menu_buttons()
  end
end

-- ADDS A PAGE WITH LEVEL MENU BUTTONS. NUMBER OF LEVELS DISPLAYED PER PAGE AS WELL AS THE MAXIMUM NUMBER OF LEVEL MENU ITEMS CAN BE CONFIGURED
function add_level_menu_buttons()
  local levels_per_page = 7 
  local no_level_menu_items = 10
  local start_page_level = levels_per_page * (current_page - 1) + 1
  local end_page_level = nil
  local dir = imageDir .. "menuImg/level_menu/"
  local level_lable = nil
  unlocked_level = read_unlocked_level()

  end_page_level = math.min((start_page_level + levels_per_page - 1), no_level_menu_items)

  if (current_page > 1) then
    menu:add_button("previouspage", dir.."previouspage.png")
  end

  for level_number = start_page_level, end_page_level do
    if menuState == "level_menu" then  
      level_lable = "level" .. level_number
    else
      level_lable = "highscore" .. level_number
    end
    if (level_number > unlocked_level) then
      level_lable = level_lable .. "locked"
    end

    if menuState == "level_menu" then  
      menu:add_button(level_lable, dir .. level_lable .. ".png")
    else
      menu:add_button(level_lable, dir .. "level" .. level_number .. ".png")
    end
  end

  if(end_page_level ~= no_level_menu_items) then
    menu:add_button("nextpage", dir .. "nextpage.png")
  end
  if current_level ~= nil then
    menu:add_button("continue", imageDir .. "menuImg/continue.png")
  end
end

function configure_menu_height()
  menuState = get_menu_state()
  if menuState == "level_menu" and menuState == "highscore_menu" then
    local box_height = (screen:get_height()-2*screen:get_height()/100-20*menu:get_item_amount())/menu:get_item_amount()
    menu:set_button_size(nil, box_height)
  end
  
  local menuHeight= 60+(menu:get_button_size().height+15)*(menu:get_item_amount()) 
  menu:set_size(nil,menuHeight)
  if menuState == "new_name_menu" then
    menu:set_button_size(nil, 92)
    menu2:set_button_size(nil, 92)
    menu3:set_button_size(nil, 92)
    menu:set_size(nil,384)
    menu2:set_size(nil,384)
    menu3:set_size(nil,384)
  end
end

-- ADDS "BLING" FEATURES TO SCREEN THAT AREN'T MENU NECESSARY
function add_menu_bling()
  -- SETS A BACKGROUND IMAGE ON SCREEN
  if menuState == "start_menu" or menuState == "pause_menu" or menuState == "level_menu" or menuState == "highscore_menu" and backgroundImage == nil then -- SETS DIFFERENT BACKGROUND IMAGES FOR THE DIFFERENT MENUS
    backgroundImage = gfx.loadjpeg(imageDir.."/menuImg/gravityFlip.jpg")
  elseif menuState == "levelwin_menu" and backgroundImage == nil then
    backgroundImage = gfx.loadjpeg(imageDir.."menuImg/levelwin.jpg")
  elseif menuState == "new_name_menu" and backgroundImage == nil then
    backgroundImage = gfx.loadjpeg(imageDir.."/menuImg/gravityFlip.jpg")
    dash = gfx.loadpng(imageDir.."font/dash.png")
    green_dash = gfx.loadpng(imageDir.."font/green_dash.png")
  elseif menuState == "gameover_menu" then
    backgroundImage = gfx.loadpng(imageDir.."/menuImg/gameover.png")
  end

  screen:copyfrom(backgroundImage, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()})

  -- CREATES, AND SETS FOUR THUNDER ACORNS ON SCREEN
  thunderAcorn.img = gfx.loadpng(thunder_acorn_path)
  thunderAcorn.img:premultiply()
  thunderAcorn.height=139
  thunderAcorn.width=101
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=0,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=0,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  screen:copyfrom(thunderAcorn.img, nil,{x=screen:get_width()-thunderAcorn.width,y=screen:get_height()-thunderAcorn.height,width=thunderAcorn.width,height=thunderAcorn.height},true)
  
  -- DESTROYS UNNCESSEARY SURFACES TO SAVE RAM
  thunderAcorn.img:destroy()

end

function get_menu_state()
  return menuState
end

function draw_menu()
  screen:clear()
  if addBling==true then
      add_menu_bling() -- ADDS BLING BLING TO SCREEN (BACKGROUND, THUNDER ACORNS AND RUNNING SQUIRRELS)
  end

  if menuState == "level_menu" then
    screen:copyfrom(menu:get_surface(), nil,{x=name_menu1_x,y=level_menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  elseif menuState == "highscore_menu" then
    screen:copyfrom(menu:get_surface(), nil,{x=level_menu_x,y=level_menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  elseif menuState == "new_name_menu" then
    screen:copyfrom(menu:get_surface(), nil,{x=name_menu1_x,y=name_menu1_y,width=menu:get_size().width,height=menu:get_size().height},true)
    screen:copyfrom(menu2:get_surface(), nil,{x=name_menu2_x,y=name_menu2_y,width=menu:get_size().width,height=menu:get_size().height},true)
    screen:copyfrom(menu3:get_surface(), nil,{x=name_menu3_x,y=name_menu3_y,width=menu:get_size().width,height=menu:get_size().height},true)
  
    draw_score("Your name ", 300,600)
    -- the loading of the pictures should probaably not be done here for RAM effectiveness
    backButton = gfx.loadpng(imageDir.."menuImg/backButton.png")
    okButton = gfx.loadpng(imageDir.."menuImg/okButton.png")
    eraseButton = gfx.loadpng(imageDir.."menuImg/eraseButton.png")
    nextButton = gfx.loadpng(imageDir.."menuImg/nextButton.png")
    instructions = gfx.loadpng(imageDir.."menuImg/HighscoreInputInstruction.png")
    screen:copyfrom(backButton, nil,{x=1040,y=300,width=120,height=80})
    screen:copyfrom(okButton, nil,{x=1040,y=400,width=120,height=80})
    screen:copyfrom(eraseButton, nil,{x=900,y=400,width=120,height=80})
    screen:copyfrom(nextButton, nil,{x=900,y=300,width=120,height=80})
    screen:copyfrom(instructions, nil,{x=220,y=680,width=759,height=43})
    backButton:destroy()
    okButton:destroy()
    eraseButton:destroy()
    nextButton:destroy()
    instructions:destroy()
    if nr_buttons_pressed> 0 and nr_buttons_pressed<= 3 then 
      for i=1,nr_buttons_pressed do
        screen:copyfrom(green_dash, nil,{x=600+i*30,y=656,width=30,height=6},true)
      end
    end
    for i=nr_buttons_pressed,2 do
      screen:copyfrom(dash, nil,{x=600+(i+1)*30,y=656,width=30,height=6},true)
    end

    menu:destroy()
    menu2:destroy()
    menu3:destroy()
    gfx.update()
  elseif menuState == "levelwin_menu" --[[or menuState == "gameover_menu"]] then
    --draw_level() --STILL TO BE IMPLEMENTED
    if menuState == "levelwin_menu" then
      call_draw_score() --DRAWS BOTH SCORE AND LEVEL NUMBER
    end
    screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  else
    screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
    menu:destroy()
    gfx.update()
  end
end

function update_menu()
  draw_menu()
end


--HANDLES MENU NAVIGATION AND COMMANDS 
function menu_navigation(key, state)
  if menuState == "new_name_menu" then
    player_name = menu_navigation_new_name(key, state)
  else
    if key=="down" and state=='down' then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
      menu:increase_index()-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU 
      update_menu()   
    elseif key=="up" and state=='down' then
        menu:decrease_index()
        update_menu()
    elseif key=="ok" and state=='up' and was_pressed_from_menu == true then
      -- ACTIONS WHEN menu BUTTONS ARE PRESSED
      if menu:get_indexed_item().id=="start_new" then
        stop_menu()
        change_global_game_state(1)
        start_game(1,"story",0)
      elseif menu:get_indexed_item().id=="select_level" then
        stop_menu()
        start_menu("level_menu")  
      elseif menu:get_indexed_item().id=="resume" then -- RESUMES THE GAME
        stop_menu()
        change_global_game_state(1)
        resume_game()
      elseif menu:get_indexed_item().id=="tutorial" then
        stop_menu()
        change_global_game_state(1)
        start_game(1,"tutorial",0)
      elseif menu:get_indexed_item().id=="high_score" then
        -- COMMAND TO VIEW HIGH SCORE
        stop_menu()
        start_menu("highscore_menu")
      elseif menu:get_indexed_item().id=="settings" then
        -- COMMAND TO VIEW SETTINGS
        stop_menu()
        start_menu("new_name_menu")
      elseif menu:get_indexed_item().id=="exit" then
        sys.stop() -- COMMAND TO EXIT
      elseif menu:get_indexed_item().id=="continue" then
        stop_menu()
        change_global_game_state(1)
        start_game("next","current",0)
      elseif menu:get_indexed_item().id=="restart" then
        stop_menu()
        change_global_game_state(1)
        start_game("restart","current",0)
      elseif menu:get_indexed_item().id=="main_menu" then
        start_menu("start_menu")
      elseif menu:get_indexed_item().id=="previouspage" then
        current_page = current_page - 1
        stop_menu()
        if menuState == "level_menu" then
          start_menu("level_menu")
        elseif menuState == "highscore_menu" then
          start_menu("highscore_menu")
        end
      elseif menu:get_indexed_item().id=="nextpage" then
        current_page = current_page + 1
        stop_menu()
        if menuState == "level_menu" then
          start_menu("level_menu")
        elseif menuState == "highscore_menu" then
          start_menu("highscore_menu")
        end

      elseif (string.sub(menu:get_indexed_item().id, 1, 5) == "level") then
        if (string.find(menu:get_indexed_item().id, "locked") == nil) then
          local level = string.sub(menu:get_indexed_item().id, 6, 6)
          stop_menu()
          change_global_game_state(1)
          start_game(level,"story",0)
        end  
      elseif menuState == "highscore_menu" then 
        unlocked_level = read_unlocked_level()
        print(unlocked_level)
        for i=1,unlocked_level do
          if menu:get_indexed_item().id == "highscore" .. i then 
            draw_highscore(i,350)
          end
        end
      end
    elseif key=="ok" and state=="down" and was_pressed_from_menu == false then
      was_pressed_from_menu = true
    end
  end
end


function get_player_name()
  return player_name
end
