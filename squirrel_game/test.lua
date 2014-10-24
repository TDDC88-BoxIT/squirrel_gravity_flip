function onStart()
  --timer = sys.new_timer(20, "update_cb")

   draw_screen()
end

function draw_screen()
  --- Get a green screen but can't change the color
  screen:clear({0,80,50})   
  screen:fill({0,0,200}, {59,60,200,500})
  
  gfx.update()
end


function load_background()
   
   --Saves the path of the background image in a local variable
   local menu_pic = "images/menu.png"
   --Loads the chosen image file and loads via the API
   gfx.loadpng(menu_pic)
   
end