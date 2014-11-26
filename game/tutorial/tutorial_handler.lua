local tutorial_goal_fulfilled
local tutorial_helper=nil
local tutorial_helper_timer=nil
local tutorial_level=nil
local ok_pressed_times=0
local imageDir = "images/"


-- CREATES A SPACE BAR CHARACTER WHICH WILL HELP THE GAMER IN THE TUTORIAL
function create_tutorial_helper(level_number)
	tutorial_level= level_number
	tutorial_goal_fulfilled=false
  	if tutorial_helper==nil and tutorial_level==1 then
    	tutorial_helper = character_object(236,219,imageDir.."tutorialImg/okButtonDown.png")
    	tutorial_helper:add_image(imageDir.."tutorialImg/okButtonUp.png")
    	tutorial_helper_timer = sys.new_timer(500, "update_tutorial_helper")
  	end
end

function update_tutorial_helper()
  	tutorial_helper:destroy() -- DESTROYS THE CHARACTER'S SURFACE SO THAT NEW UPDATES WON'T BE PLACED ONTOP OF IT
  	tutorial_helper:update()  -- UPDATES THE CHARACTERS BY CREATING A NEW SURFACE WITH THE NEW IMAGE TO BE DISPLAYED
end

function stop_tutorial_helper()
	tutorial_goal_fulfilled=true
    tutorial_helper_timer:stop()
    tutorial_helper_timer=nil
    tutorial_helper:destroy()
end

--[[
DRAWS TUTORIAL SPACE BAR ON SCREEN
]]
function draw_tutorial_helper()
	if tutorial_goal_fulfilled == false and tutorial_level==1  then
		screen:copyfrom(tutorial_helper:get_surface(), nil,{x=(screen:get_width()/2)-150,y=400},true)
	end
end

function update_tutorial_handler(key)
	if key=='ok' then
		ok_pressed_times=ok_pressed_times+1
		if tutorial_level==1 then
			if ok_pressed_times==1 then
				tutorial_goal_fulfilled=true
			end
		else
			tutorial_goal_fulfilled=true
		end
	end
	if tutorial_goal_fulfilled==true and tutorial_helper_timer~=nil then
		stop_tutorial_helper()
	end
end

function tutorial_goal_is_fulfilled()
	return tutorial_goal_fulfilled
end