require("../tool_box/menu_object")
require("../tool_box/character_object")
local menu_width= screen:get_width()*0.2 -- MAKES THE MENU 20% OF TOTAL SCREEN WIDTH
local menu_x = (screen:get_width()-menu_width)/2 -- CENTERS THE MENU ON SCREEN ON THE X-AXIS
local menu_y = screen:get_height()/4 -- MAKES THE MENU START 1/4 DOWN FROM THE TOP OF THE SCREEN
local name_menu1_x = 400
local name_menu1_y = 200
local name_menu2_x = 550
local name_menu2_y = 200
local name_menu3_x = 700
local name_menu3_y = 200
local level_menu_y = screen:get_height()/100
local menuState = "start_menu" -- CAN BE "start_menu" OR "pause_menu" OR "levelwin_menu" OR "gameover_menu"
local menu = nil  -- THE MENU SURFACE VARIABLE
local imageDir = "images/"
local thunder_acorn_path = imageDir.."thunderAcorn.png"
local thunderAcorn = {}
local squirrelImg1 = imageDir.."character/squirrel1.png" 
local squirrelImg2 = imageDir.."character/squirrel2.png"
local backgroundImage = nil
local dash = nil
local green_dash = nil
local backdrop = nil
local addBling = true -- THIS WILL ADD A BACKGROUND IMAGE AND SOME THUNDER ACORNS IF TRUE
local current_character = 1
local player_name = ""
text_button_pressed = {0,0,0,0,0,0,0,0,0}
nr_buttons_pressed = 0

local squirrel1 = nil
local squirrel2 = nil

function start_menu(state)
  menuState=state
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
    if(menu==nil) then
      menu = menu_object(menu_width,menu_height) -- CREATES A NEW MENU OBJECT. ATTRIBUTES= {X,Y,WIDTH,HEIGHT}
    else 
      menu:reset()
    end
  end
  print("menu should here")
  print(menu)
  add_menu_items()
  configure_menu_height()
  menu:set_background(imageDir.."menuImg/menuBackground.png")
  draw_menu()
end 

function stop_menu()
  screen:clear() 
 end

-- ADDS THE MENU ITEMS
function add_menu_items()
  if menuState == "start_menu" or menuState == "pause_menu" then
    menu:add_button("start_new",imageDir.."menuImg/start.png")
    menu:add_button("select_level", imageDir.."menuImg/select_level.png")
    if menuState == "start_menu" then -- THE START MENU HAS THE HIGH SCORE BUTTON
      menu:add_button("high_score",imageDir.."menuImg/highScore.png")
      menu:add_button("tutorial",imageDir.."menuImg/tutorial.png")
    elseif menuState == "pause_menu" then -- THE PAUSE MENU HAS THE RESUME BUTTON
      menu:add_button("resume",imageDir.."menuImg/resume.png")
    end
    menu:add_button("settings",imageDir.."menuImg/settings.png")
    menu:add_button("exit",imageDir.."menuImg/exit.png") 
    
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
  elseif menuState == "level_menu" then
    menu:add_button("zero",imageDir.."font/0.png")
    menu:add_button("one",imageDir.."font/1.png")
    menu:add_button("two",imageDir.."font/2.png")
    menu:add_button("three",imageDir.."font/3.png")
    menu:add_button("four",imageDir.."font/4.png")
    menu:add_button("five",imageDir.."font/5.png")
    menu:add_button("six",imageDir.."font/6.png")
    menu:add_button("seven",imageDir.."font/7.png")
    menu:add_button("eight",imageDir.."font/8.png")
    menu:add_button("nine",imageDir.."font/9.png")
    menu:add_button("ten",imageDir.."font/0.png")
    menu:add_button("eleven",imageDir.."font/1.png")
    menu:add_button("twelve",imageDir.."font/2.png")
    menu:add_button("thirteen",imageDir.."font/3.png")
    menu:add_button("fourteen",imageDir.."font/4.png") 
  end
end

function configure_menu_height()
  menuState = get_menu_state()
  if menuState == "level_menu" then
    local box_height = (screen:get_height()-2*screen:get_height()/100-20*menu:get_item_amount())/menu:get_item_amount()
    menu:set_button_size(nil, box_height)
  end
  
  local menuHeight= 20+(menu:get_button_size().height+15)*(menu:get_item_amount()) 
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
  if menuState == "start_menu" or menuState == "pause_menu" or menuState == "level_menu" then -- SETS DIFFERENT BACKGROUND IMAGES FOR THE DIFFERENT MENUS
    backgroundImage = gfx.loadpng(imageDir.."/menuImg/gravityFlip.jpg")
  elseif menuState == "levelwin_menu" then
    backgroundImage = gfx.loadpng(imageDir.."/menuImg/levelwin.jpg")
  elseif menuState == "new_name_menu" then
    backgroundImage = gfx.loadpng(imageDir.."/menuImg/gravityFlip.jpg")
    dash = gfx.loadpng(imageDir.."font/dash.png")
    green_dash = gfx.loadpng(imageDir.."font/green_dash.png")
  elseif menuState == "gameover_menu" then
    backgroundImage = gfx.loadpng(imageDir.."/menuImg/gameover.png")
  end

  screen:copyfrom(backgroundImage, nil,{x=0,y=0,width=screen:get_width(),height=screen:get_height()})
  
  -- SETS A BLACK SEMI-TRANSPARENT BACKGROUND ON SCREEN OVER THE BACKGROUND IMAGE
  backdrop = gfx.new_surface(screen:get_width(),screen:get_height())
  if menuState == "start_menu" or menuState == "pause_menu" or menuState == "level_menu" then
    backdrop:fill({r=0,g=0,b=0,a=200})
  elseif menuState == "levelwin_menu" or menuState == "gameover_menu" then
    backdrop:fill({r=0,g=0,b=0,a=100})
  end
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

function get_menu_state()
  return menuState
end

function draw_menu()
  screen:clear()
  if addBling==true then
      add_menu_bling() -- ADDS BLING BLING TO SCREEN (BACKGROUND, THUNDER ACORNS AND RUNNING SQUIRRELS)
  end

  if menuState == "level_menu" then
    screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=levelmenu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  elseif menuState == "new_name_menu" then
    screen:copyfrom(menu:get_surface(), nil,{x=name_menu1_x,y=name_menu1_y,width=menu:get_size().width,height=menu:get_size().height},true)
    screen:copyfrom(menu2:get_surface(), nil,{x=name_menu2_x,y=name_menu2_y,width=menu:get_size().width,height=menu:get_size().height},true)
    screen:copyfrom(menu3:get_surface(), nil,{x=name_menu3_x,y=name_menu3_y,width=menu:get_size().width,height=menu:get_size().height},true)
  
    draw_score("Your name ", 300,600)
    if nr_buttons_pressed> 0 and nr_buttons_pressed<= 3 then 
      for i=1,nr_buttons_pressed do
        screen:copyfrom(green_dash, nil,{x=600+i*30,y=656,width=30,height=6},true)
      end
    end
    for i=nr_buttons_pressed,2 do
      screen:copyfrom(dash, nil,{x=600+(i+1)*30,y=656,width=30,height=6},true)
    end
  elseif menuState == "levelwin_menu" --[[or menuState == "gameover_menu"]] then
    --draw_level() --STILL TO BE IMPLEMENTED
    
    if menuState == "levelwin_menu" then
      call_draw_score() --DRAWS BOTH SCORE AND LEVEL NUMBER
    end
    screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  else
    screen:copyfrom(menu:get_surface(), nil,{x=menu_x,y=menu_y,width=menu:get_size().width,height=menu:get_size().height},true)
  end
  if menuState == "new_name_menu" then 
    menu:destroy()
    menu2:destroy()
    menu3:destroy()
  else
    menu:destroy()
  end
  gfx.update()
end

function update_menu()
  draw_menu()
end


--HANDLES MENU NAVIGATION AND COMMANDS 
function menu_navigation(key, state)
  if key=="down" and state=='down' then -- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF START MENU
    if menuState ~= "new_name_menu" then
      menu:increase_index()-- ALLOW USER TO NAVIGATE DOWN IF CURRENT ITEMS IS NOT LAST OF PAUSE MENU 
      update_menu()   
    end
  elseif key=="up" and state=='down' then
    if menuState ~= "new_name_menu" then
      menu:decrease_index()
      update_menu()
    end
  elseif key=="1"  and state=="down" and nr_buttons_pressed<3 then 

    if text_button_pressed[1] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "A"
      else
        player_name = "A"
      end
      text_button_pressed[1] = text_button_pressed[1]+1
    elseif text_button_pressed[1] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "B"
      else
      player_name = "B"
      end
      text_button_pressed[1] = text_button_pressed[1]+1
    elseif text_button_pressed[1] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "C"
      else
        player_name = "C"
      end
      text_button_pressed[1] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="2"  and state=="down" and nr_buttons_pressed<3 then 
    if text_button_pressed[2] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "D"
      else
        player_name = "D"
      end
      text_button_pressed[2] = text_button_pressed[2]+1
    elseif text_button_pressed[2] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "E"
      else
        player_name = "E"
      end
      text_button_pressed[2] = text_button_pressed[2]+1
    elseif text_button_pressed[2] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "F"
      else
        player_name = "F"
      end
      text_button_pressed[2] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="3" and state=="down" and nr_buttons_pressed<3 then 
    if text_button_pressed[3] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "G"
      else
        player_name = "G"
      end
      text_button_pressed[3] = text_button_pressed[3]+1
    elseif text_button_pressed[3] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "H"
      else
        player_name = "H"
      end
      text_button_pressed[3] = text_button_pressed[3]+1
    elseif text_button_pressed[3] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "I"
      else
        player_name = "I"
      end
      text_button_pressed[3] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="4" and state=="down" and nr_buttons_pressed<3 then   
    if text_button_pressed[4] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "J"
      else
        player_name = "J"
      end
      text_button_pressed[4] = text_button_pressed[4]+1
    elseif text_button_pressed[4] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "K"
      else
        player_name = "K"
      end
      text_button_pressed[4] = text_button_pressed[4]+1
    elseif text_button_pressed[4] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "L"
      else
        player_name = "L"
      end
      text_button_pressed[4] = 0
    end
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="5" and state=="down" and nr_buttons_pressed<3 then 
    if text_button_pressed[5] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "M"
      else
        player_name = "M"
      end
      text_button_pressed[5] = text_button_pressed[5]+1
    elseif text_button_pressed[5] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "N"
      else
        player_name = "N"
      end
      text_button_pressed[5] = text_button_pressed[5]+1
    elseif text_button_pressed[5] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "O"
      else
        player_name = "O"
      end
      text_button_pressed[5] = 0
    end
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="6" and state=="down" and nr_buttons_pressed<3 then
    if text_button_pressed[6] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "P"
      else
        player_name = "P"
      end
      text_button_pressed[6] = text_button_pressed[6]+1
    elseif text_button_pressed[6] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "Q"
      else
        player_name = "Q"
      end
      text_button_pressed[6] = text_button_pressed[6]+1
    elseif text_button_pressed[6] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "R"
      else
        player_name = "R"
      end
      text_button_pressed[6] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="7" and state=="down" and nr_buttons_pressed<3 then
    if text_button_pressed[7] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "S"
      else
        player_name = "S"
      end
      text_button_pressed[7] = text_button_pressed[7]+1
    elseif text_button_pressed[7] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "T"
      else
        player_name = "T"
      end
      text_button_pressed[7] = text_button_pressed[7]+1
    elseif text_button_pressed[7] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "U"
      else
        player_name = "U"
      end
      text_button_pressed[7] = 0
    end
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="8" and state=="down" and nr_buttons_pressed<3 then
    if text_button_pressed[8] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "V"
      else
        player_name = "V"
      end
      text_button_pressed[8] = text_button_pressed[8]+1
    elseif text_button_pressed[8] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "W"
      else
        player_name = "W"
      end
      text_button_pressed[8] = text_button_pressed[8]+1
    elseif text_button_pressed[8] == 2 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "X"
      else
        player_name = "X"
      end
      text_button_pressed[8] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="9" and state=="down" and nr_buttons_pressed<3 then  
    if text_button_pressed[9] == 0 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "Y"
      else
        player_name = "Y"
      end
      text_button_pressed[9] = text_button_pressed[9]+1
    elseif text_button_pressed[9] == 1 then
      if nr_buttons_pressed >= 1 then
        player_name = string.sub(player_name, 1,nr_buttons_pressed) .. "Z"
      else
        player_name = "Z"
      end
      text_button_pressed[9] = 0
    end 
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="green" and state=="down" and nr_buttons_pressed<3 then 
  --Accepts a letter, allows you to write the next one 
    text_button_pressed = {0,0,0,0,0,0,0,0,0}
    nr_buttons_pressed = nr_buttons_pressed +1
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="yellow" and state=="down" then  
  --The button backspace, removes a letter
    player_name =""
    nr_buttons_pressed = 0
    update_menu()
    draw_score(player_name, 600,600)
  elseif key=="red" and state=="down" then  
  -- let's you go back to the start menu
    stop_menu()
    start_menu("start_menu")
  elseif key=="ok" and state=='up' then
    --print("ITEMS: "..menu:get_item_amount())
    -- ACTIONS WHEN menu BUTTONS ARE PRESSED
      if menu:get_indexed_item().id=="start_new" then
        stop_menu()
        change_global_game_state(1)
        start_game(16,"story",0)
      elseif menu:get_indexed_item().id=="select_level" then --STARTS THE LEVEL SELECTION MENU
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
        stop_menu()
--        change_global_game_state(1)
        draw_highscore(1)
        -- COMMAND TO VIEW HIGH SCORE
      elseif menu:get_indexed_item().id=="settings" then
        -- COMMAND TO VIEW SETTINGS
        stop_menu()
        start_menu("new_name_menu")
      elseif menu:get_indexed_item().id=="exit" then
        sys.stop() -- COMMAND TO EXIT
      elseif menu:get_indexed_item().id=="continue" then
        stop_menu()
        start_menu("start_menu")
      end
    
  end
end

function get_player_name()
  return player_name
end