-- version 1.0

require("squirrel_game.menu")

dir = 'squirrel_game/'

function onStart()
  --timer = sys.new_timer(20, "update_cb")
   draw_screen()
end

function draw_screen()
  --- Get a green screen but can't change the color
  screen:clear({0,80,50})   
  --screen:fill({0,0,200}, {59,60,200,500})
  
  gfx.update()
end

--Taken directly from Zenterio's game since I think we will need this or is this for a later user story?
function update_cb(timer)
--  print("update_cb")
--  now = sys.time()
--  last_time = last_time or 0
--  update_state(now - last_time)
--  last_time = now
--  if lives > 0 then
--    draw_screen()
--  else
--    game_over()
--  end
end

