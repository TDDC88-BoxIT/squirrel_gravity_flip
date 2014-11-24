
--@desc: creates a player name depending on the numbers you press, old text messaging system
--@params: key pressed and the key state
--@return: player_name
--@author: Amanda Persson
function menu_navigation_new_name(key,state)

  if key=="1"  and state=="down" and nr_buttons_pressed<3 then 

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
  elseif key=="green" and state=="down" then 
    if nr_buttons_pressed<3 then 
      --Accepts a letter, allows you to write the next one 
      text_button_pressed = {0,0,0,0,0,0,0,0,0}
      nr_buttons_pressed = nr_buttons_pressed +1
      update_menu()
      draw_score(player_name, 600,600)
    elseif nr_buttons_pressed== 3 then
        -- let's you go back to the start menu
        stop_menu()
        start_menu("start_menu")
    end
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

  elseif key=="ok" and state=="down" then 
        if nr_buttons_pressed<3 then 
          --Accepts a letter, allows you to write the next one 
          text_button_pressed = {0,0,0,0,0,0,0,0,0}
          nr_buttons_pressed = nr_buttons_pressed +1
          update_menu()
          draw_score(player_name, 600,600)
        elseif nr_buttons_pressed== 3 then
          -- let's you go back to the start menu
          stop_menu()
          start_menu("start_menu")
        end
  end
  return player_name
end

