local alphabet = {{"A","B","C"},{"D", "E","F"},{"G","H","I"},{"J","K","L"},{"M","N","O"},{"P","Q","R"},{"S","T","U"},{"V","W","X"}}


function menu_navigation_new_name(key,state)
  if key=="green" or key=="ok" and state=="down" then 
    if nr_buttons_pressed<3 and nr_buttons_pressed<string.len(player_name)  then 
      --Accepts a letter, allows you to write the next one 
      text_button_pressed = {0,0,0,0,0,0,0,0,0}
      nr_buttons_pressed = nr_buttons_pressed +1
      update_menu()
      draw_score(player_name, 600,600)
      gfx.update()
    elseif nr_buttons_pressed== 3 then
        -- let's you go back to the start menu
        nr_buttons_pressed = 0
        stop_menu()
        start_menu("start_menu")
    end
  elseif key=="yellow" and state=="down" then  
  --The button backspace, removes a letter
    player_name =""
    nr_buttons_pressed = 0
    update_menu()
    draw_score(player_name, 600,600)
    gfx.update()
  elseif key=="red" and state=="down" then  
  -- let's you go back to the start menu
    nr_buttons_pressed= 0
    stop_menu()
    start_menu("start_menu")
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
    gfx.update()
  end

  for number=1,8 do
    if key==tostring(number)  and state=="down" and nr_buttons_pressed<3 then 

      if text_button_pressed[number] == 0 then
        if nr_buttons_pressed >= 1 then
          player_name = string.sub(player_name, 1,nr_buttons_pressed) .. alphabet[number][1]
        else
          player_name = alphabet[number][1]
        end
        text_button_pressed[number] = text_button_pressed[number]+1
      elseif text_button_pressed[number] == 1 then
        if nr_buttons_pressed >= 1 then
          player_name = string.sub(player_name, 1,nr_buttons_pressed) .. alphabet[number][2]
        else
        player_name = alphabet[number][2]
        end
        text_button_pressed[number] = text_button_pressed[number]+1
      elseif text_button_pressed[number] == 2 then
        if nr_buttons_pressed >= 1 then
          player_name = string.sub(player_name, 1,nr_buttons_pressed) .. alphabet[number][3]
        else
          player_name = alphabet[number][3]
        end
        text_button_pressed[number] = 0
      end 
      update_menu()
      draw_score(player_name, 600,600)
      gfx.update()
      break
    end
  end
  return player_name
end

