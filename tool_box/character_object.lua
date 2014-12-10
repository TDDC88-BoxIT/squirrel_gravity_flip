----------------------------
-- character_object class --
----------------------------

--[[
IN ORDER TO USE THE CHARACTER OBJECT YOU FIRST NEED TO CREATE AND SAVE A NEW INSTANCE OF THE OBJECT.
THIS IS DONE BY CALLING: 
	
	character_object_variable = character_object(width,height,character_image_path)

IN ORDER TO DRAW THE CHARACTER ON THE SCREEN, THE OBJECT SURFACE FIRST HAS TO BE RETRIEVED.
THIS IS DONE BY CALLING:

	character_image_surface = character_object_variable:get_surface()

THE CHARACTER OBJECT HAS A SET OF CONFIGURATION FUNCTIONS WHICH CAN BE USED, THESE ARE:
	
	character_object:set_size()
	character_object:get_size()
	character_object:add_image()
	character_object:get_images()
	character_object:clear_images()

IF YOU HAVE ADDED MULTIPLE IMAGES TO THE CHARACTER OBJECT, YOU NEED TO RUN THE UPDATE THE OBJECT IN ORDER
FOR IT TO ANIMATE THE SHIFTING OF IMAGES.
THIS IS DONE BY CALLING:
	
	character_object_variable:update()

MAKE SURE TO USE THE DESTROY COMMAND WHEN THE OBJECT HAS BEEN DRAWN ON SCREEN IN ORDER TO SAVE RAM!
THIS WILL DESTROY THE OBJECTS SURFACE.
THIS IS DONE BY CALLING:

	character_object:destroy()

IF THE CHARACTER OBJECT IS PART OF AN ITTERATION AND IS SUPPOSED TO BE DRAWN ON SCREEN MULTIPLE TIMES,
THEN AN 	

	character_object:update() 

JUST BEFORE THE 	

	screen:copyfrom(character_object:get_surface()...)

WILL CREATE A NEW SURFACE FOR THE CHARACTER OBJECT.
--]]

require("class")
-- THE MENU CONSTRUCTOR SETS START VALUES FOR THE MENU
character_object = class(function (self, character_width, character_height, character_img)

	self.width = character_width or 50
	self.height = character_height or 50
	self.character_images={
		boost={},
		invulnerable={},
		slow={},
		normal={}
	}
	self.character_state="normal" 		-- THE CHARACTER CAN BE IN SEVERAL STATES DEPENDING ON WHAT POWERUP IS BEING USED
	self.character_flipped_images={
		boost={},
		invulnerable={},
		slow={},
		normal={}
	}
	self.current_character_image=1	-- DETERMINES WHICH CHARACTER IMAGE WILL BE DISPLAYED CURRENTLY
	self.character_surface=nil
	self.show_flipped_images = false -- DETERMINES WHICH SET OF CHARACTER IMAGES THAT WILL BE SHOWN
	if character_img ~= nil then
		self:add_image(character_img,"normal") 
	end
	self:update()
end)

-- SETS MENU SIZE
function character_object:set_size(character_width, character_height)
	self.width=character_width or self.width
	self.height=character_height or self.height
end

-- RETURNS MENU SIZE
function character_object:get_size()
	local size={width=self.width, height=self.height}
	return size
end

-- ADDS NEW MENU ITEMS
function character_object:add_image(img_Path,state)
  local img_data = gfx.loadpng(img_Path)
  img_data:premultiply()
	if state ~= nil then
		table.insert(self.character_images[state], #self.character_images[state]+1, img_data)
	else
		table.insert(self.character_images["normal"], #self.character_images["normal"]+1, img_data)
	end
end

-- ADDS NEW FLIPPED MENU ITEMS
function character_object:add_flipped_image(img_Path,state)
  local img_data = gfx.loadpng(img_Path)
  img_data:premultiply()
	table.insert(self.character_flipped_images[state], #self.character_flipped_images[state]+1, img_data)
end

-- RETURNS THE MENU ITEM CURRENTLY INDEXED
function character_object:get_current_image()
	if self.show_flipped_images==true then
  		if self.character_state == "boost" then
  			return self.character_flipped_images.boost[self.current_character_image]
		elseif self.character_state == "invulnerable" then
			return self.character_flipped_images.invulnerable[self.current_character_image]
		elseif self.character_state == "slow" then
			return self.character_flipped_images.slow[self.current_character_image]
		else
			return self.character_flipped_images.normal[self.current_character_image]
		end
  	else
  		if self.character_state == "boost" then
  			return self.character_images.boost[self.current_character_image]
		elseif self.character_state == "invulnerable" then
			return self.character_images.invulnerable[self.current_character_image]
		elseif self.character_state == "slow" then
			return self.character_images.slow[self.current_character_image]
		else
			return self.character_images.normal[self.current_character_image]
		end
  	end
end 

-- CLEARS ALL ADDED MENU ITEMS
function character_object:clear_images()
  	self.character_images={
  		boost={},
		invulnerable={},
		slow={},
		normal={}
  	}
  	self.character_flipped_images={
  		boost={},
		invulnerable={},
		slow={},
		normal={}
  	}
end

-- CHANGES THE BOOLEAN DETERMINING WHICH SET OM CHARACTER IMAGES THAT ARE TO BE DISPLAYED
function character_object:flip()
	if self.show_flipped_images==true then
		self.show_flipped_images=false
	else
		self.show_flipped_images=true
	end
end

-- RESETS THE CHARACTER TO START SETTINGS
function character_object:reset()
	self.show_flipped_images=false
	self.current_character_image=1
end

function character_object:get_state()
	return self.character_state
end

function character_object:set_state(state)
	self.character_state = state
end


-- CHANGES THE IMAGE INDEX IN ORDER TO CREATE AN ANIMATION OF THE CHARACTER IMAGES
local function animate(self)
	if self.show_flipped_images==true then
		if self.current_character_image<#self.character_flipped_images[self.character_state] then
			self.current_character_image=self.current_character_image+1
		else
			self.current_character_image=1
		end
	else
		if self.current_character_image<#self.character_images[self.character_state] then
			self.current_character_image=self.current_character_image+1
		else
			self.current_character_image=1
		end
	end
end

-- SETS THE IMAGE CURRENTLY INDEXED TO THE CHARACTER SURFACE
local function set_image(self)
	self.character_surface:copyfrom(self:get_current_image(),nil,{x=0,y=0,width=self.width,height=self.height},true)
end	

-- ASSEMBLES ALL MENU PARTS INTO A MENU
function character_object:update()
	if self.character_surface == nil then
		self.character_surface=gfx.new_surface(self.width, self.height)
	end
  self.character_surface:clear()
	animate(self)
  set_image(self)
end

-- RETURNS THE MENU SURFACE
function character_object:get_surface()
  	return self.character_surface
end

function character_object:destroy()
  for i=1, #self.character_images[self.character_state], 1 do
    self.character_images[self.character_state][i]:destroy();
    self.character_images[self.character_state][i]=nil
  end
end